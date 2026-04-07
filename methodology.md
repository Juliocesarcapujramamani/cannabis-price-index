# Cannabis Price Index — Methodology

## What the Index Measures

The Cannabis Price Index (CPI) tracks weekly price movements across the U.S. online cannabis accessories and CBD market. It provides a standardized measure of average pricing, discount activity, and category-level trends over time.

The index is designed to answer: **How are cannabis product prices changing week over week, and where?**

## Data Collection

Product data is collected weekly from online retailers across the United States. Each weekly snapshot captures:

- Product name and category
- Regular (list) price
- Sale price (if discounted)
- Effective price (the price a consumer would actually pay)

Products are categorized into main categories (e.g., Flower, Edibles, Concentrates, Accessories, CBD) and subcategories (e.g., Pre-Rolls, Gummies, Cartridges).

## Baseline Definition

The index uses a **fixed baseline week of December 8, 2025**. All index values are expressed relative to this baseline:

- A value of **100** means prices are at the baseline level
- A value of **105** means prices are 5% above baseline
- A value of **95** means prices are 5% below baseline

The baseline was selected as the first week with full coverage across all tracked categories after methodology stabilization.

## Index Formula

For each (category, subcategory) pair:

```
index_value = (current_week_avg_price / baseline_week_avg_price) × 100
```

Where:
- `current_week_avg_price` = average effective price for that subcategory in the current week
- `baseline_week_avg_price` = average effective price for that subcategory in the baseline week (2025-12-08)

## Aggregation Approach

Weekly aggregation is computed at the **(main_category, subcategory)** grain. For each group, the following metrics are calculated:

| Metric | Definition |
|--------|-----------|
| `product_count` | Number of products in the group |
| `avg_price` | Mean effective price |
| `avg_regular_price` | Mean list/regular price |
| `avg_sale_price` | Mean sale price (discounted products only) |
| `discount_rate` | Fraction of products currently on sale (0.0–1.0) |
| `discount_depth` | Average discount percentage among discounted products |

## Inclusion / Exclusion Rules

**Included:**
- Products with a valid effective price > $0
- Products with a resolved category and subcategory

**Excluded:**
- Hemp category (outside core market scope)
- Wellness category (outside core market scope)
- Products with missing or zero pricing
- Uncategorized products

These exclusions ensure the index reflects the core cannabis market without noise from adjacent or poorly classified segments.

## Limitations

- **Online-only coverage.** The index tracks online retail pricing and does not include dispensary walk-in prices or wholesale markets.
- **Price ≠ transaction.** Average prices reflect listed/effective prices, not actual transaction volumes or revenue.
- **Category granularity.** Subcategory definitions may evolve as the market introduces new product types.
- **Geographic scope.** Data is collected from U.S.-based online retailers. State-level breakdowns are not currently available.
- **Survivorship.** Products that are delisted between snapshots are not retroactively removed from prior weeks.

## Reproducibility

The SQL logic for computing the index from a products snapshot table is provided in [`sql/compute_index.sql`](sql/compute_index.sql). A sample dataset is available in [`sample_data/sample_week.csv`](sample_data/sample_week.csv) for testing and validation.
