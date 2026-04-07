# Cannabis Price Index

A weekly price index tracking U.S. online cannabis product pricing across categories and subcategories.

This repository contains the **methodology, reference SQL, and sample data** behind the Cannabis Price Index published at [CannabisDealsUS](https://cannabisdealsus.com/cannabis-price-index/).

## What's Included

| Asset | Description |
|-------|-------------|
| [`methodology.md`](methodology.md) | Full methodology: baseline definition, index formula, aggregation, inclusion/exclusion rules |
| [`sql/compute_index.sql`](sql/compute_index.sql) | SQL to compute weekly subcategory-level price index from a products snapshot |
| [`sample_data/sample_week.csv`](sample_data/sample_week.csv) | Two weeks of sample data (realistic, anonymized) for testing |

## What's NOT Included

- Full production dataset (available via the [live index](https://cannabisdealsus.com/cannabis-price-index/))
- Data ingestion pipeline
- Product classification / taxonomy system
- Publishing automation

## How It Works

1. **Collect** — Weekly product snapshots are taken from online cannabis retailers across the U.S.
2. **Aggregate** — Products are grouped by (category, subcategory) and averaged on effective price, discount rate, and discount depth.
3. **Index** — Each subcategory's average price is compared to a fixed baseline week (2025-12-08) to produce an index value.

An index value of **100** = baseline pricing. Above 100 = prices rising. Below 100 = prices falling.

## Example Output

| Week | Category | Subcategory | Avg Price | Index Value |
|------|----------|-------------|-----------|-------------|
| 2025-12-08 | Flower | Pre-Rolls | $18.45 | 100.00 |
| 2025-12-15 | Flower | Pre-Rolls | $18.20 | 98.64 |
| 2025-12-22 | Flower | Pre-Rolls | $17.85 | 96.75 |
| 2025-12-08 | Edibles | Gummies | $24.30 | 100.00 |
| 2025-12-15 | Edibles | Gummies | $23.90 | 98.35 |
| 2025-12-22 | Edibles | Gummies | $24.80 | 102.06 |

Visualized as a **line chart** with week on the x-axis and index value on the y-axis, each subcategory rendered as a separate series. This reveals divergent pricing trends across product types — for example, Flower trending down while Edibles hold steady or rise.

## Quick Start

1. Load `sample_data/sample_week.csv` into a SQL-compatible database
2. Adapt `sql/compute_index.sql` to your table name
3. Run the query to produce index values

The SQL is written for BigQuery but is easily portable to PostgreSQL, DuckDB, or any SQL engine with window function support.

## Used in Production

This methodology powers the Cannabis Price Index at **CannabisDealsUS**, tracking thousands of products weekly across the U.S. online cannabis market.

- **Live index:** [cannabisdealsus.com/cannabis-price-index](https://cannabisdealsus.com/cannabis-price-index/)
- **Full dataset:** Available via [Zenodo](https://zenodo.org/) (monthly releases)

## Citation

If you use this methodology or data in research, reporting, or analysis:

```
CannabisDealsUS Cannabis Price Index
https://cannabisdealsus.com/cannabis-price-index/
```

## License

[MIT](LICENSE) — methodology and code are freely available. The full production dataset is not included in this repository.
