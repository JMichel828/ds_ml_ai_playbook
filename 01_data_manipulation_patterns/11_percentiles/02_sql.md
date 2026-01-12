# Percentiles & Quantiles

## Definition
Percentiles are statistical measures that describe the relative standing of a value within a distribution.
In SQL, percentiles are commonly used to understand distributions, outliers, medians, and thresholds.
Typical use cases include latency analysis, compensation bands, spend distribution, and performance metrics.

---

## When It Typically Appears
- Finding medians (50th percentile)
- Computing p90 / p95 / p99 latency metrics
- Identifying outliers or long tails
- Bucketing users into performance or spend tiers

---

## Core Template (Continuous Percentiles)
Most databases support ordered-set aggregates such as `PERCENTILE_CONT`.

```sql
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY value) AS median_value
FROM table_name;
```

Common percentiles:
- 0.5 → median
- 0.9 → p90
- 0.95 → p95
- 0.99 → p99

---

## Core Template (Grouped Percentiles)
Calculate percentiles per group.

```sql
SELECT
    category,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY metric) AS p90_metric
FROM table_name
GROUP BY category;
```

---

Window-Based Percentiles
Some systems support percentile window functions:

```sql
SELECT
    *,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY value)
        OVER (PARTITION BY category) AS median_per_category
FROM table_name;
```

---

## Variants

1. Discrete Percentiles
Returns an actual observed value.

```sql
PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY value)
```

2. NTILE Bucketing
Divide rows into equal-sized buckets.

```sql
NTILE(4) OVER (ORDER BY value) AS quartile
```

3. Percent Rank
Relative rank between 0 and 1.

```sql
PERCENT_RANK() OVER (ORDER BY value)
```

4. Approximate Percentiles
Used in large-scale systems (syntax varies).

```sql
APPROX_PERCENTILE(value, 0.95)
```

---

## Pitfalls
- Continuous percentiles may interpolate values
- Discrete percentiles may not represent true medians
- NTILE produces equal row counts, not equal value ranges
- Different SQL engines have different percentile syntax
- Approximate percentiles trade accuracy for speed

---

## Mini Example

```sql
WITH response_times AS (
    SELECT * FROM (VALUES
        (120),
        (200),
        (250),
        (300),
        (400),
        (1000)
    ) AS t(ms)
)
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ms) AS median_ms,
    PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY ms) AS p90_ms,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY ms) AS p95_ms
FROM response_times;
```

Result:

median_ms | p90_ms | p95_ms
----------|--------|--------
275       | 850    | 925
