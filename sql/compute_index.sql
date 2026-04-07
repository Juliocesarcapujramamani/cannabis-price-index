-- =============================================================================
-- compute_index.sql
-- Cannabis Price Index: Weekly Subcategory Aggregation
-- =============================================================================
-- Purpose:  Compute weekly price index from a products snapshot table.
--           Aggregates effective_price, regular_price, and discount metrics
--           at (week, category, subcategory) grain.
--
-- Formula:  index_value = (current_week_avg_price / baseline_avg_price) * 100
--           Baseline week: 2025-12-08 (fixed reference point)
--
-- Exclusions:
--   - Hemp and Wellness categories (outside CPI scope)
--   - Products with null or zero effective_price
--   - Uncategorized products
-- =============================================================================

-- Step 1: Weekly subcategory aggregation
-- Replace `sample_products` with your products snapshot table.

CREATE TEMP TABLE weekly_agg AS
SELECT
  snapshot_week,
  main_category,
  subcategory,
  COUNT(*)                                                    AS product_count,
  AVG(effective_price)                                        AS avg_price,
  AVG(regular_price)                                          AS avg_regular_price,
  AVG(CASE WHEN discount_pct > 0 THEN sale_price END)         AS avg_sale_price,
  COUNTIF(discount_pct > 0) / COUNT(*)                        AS discount_rate,
  AVG(CASE WHEN discount_pct > 0 THEN discount_pct END)       AS discount_depth
FROM sample_products
WHERE LOWER(main_category) NOT IN ('hemp', 'wellness')
  AND main_category != ''
  AND subcategory NOT IN ('', 'uncategorized')
  AND effective_price > 0
GROUP BY snapshot_week, main_category, subcategory;


-- Step 2: Compute baseline averages (from fixed baseline week)

CREATE TEMP TABLE baseline AS
SELECT
  main_category,
  subcategory,
  avg_price AS baseline_avg_price
FROM weekly_agg
WHERE snapshot_week = '2025-12-08';


-- Step 3: Compute index values relative to baseline

SELECT
  w.snapshot_week,
  w.main_category,
  w.subcategory,
  w.product_count,
  w.avg_price,
  w.avg_regular_price,
  w.avg_sale_price,
  w.discount_rate,
  w.discount_depth,
  ROUND((w.avg_price / b.baseline_avg_price) * 100, 2)       AS index_value
FROM weekly_agg w
JOIN baseline b
  ON w.main_category = b.main_category
  AND w.subcategory = b.subcategory
ORDER BY w.snapshot_week, w.main_category, w.subcategory;
