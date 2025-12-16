# Sliding Windows (Moving Windows)

Definition
Sliding windows (also called moving windows) are SQL patterns that compute metrics over a moving
range of rows relative to the current row. Unlike running totals, which always start from the
beginning, sliding windows move forward as the row advances.

They are commonly used for rolling averages, rolling sums, and trend smoothing.

---

When It Appears in Interviews
- 7-day / 30-day rolling averages
- Moving sums for revenue or usage
- Trend detection and smoothing
- Time-series analytics
- Medium SQL interview questions involving window functions

---

Core Template

```sql
SELECT
    date_column,
    metric,
    AVG(metric) OVER (
        ORDER BY date_column
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg
FROM table_name;
```

This computes a rolling metric using a fixed number of rows.

---

Time-Based Sliding Windows
Use RANGE for time-based windows (supported in some databases).

```sql
SELECT
    date_column,
    metric,
    SUM(metric) OVER (
        ORDER BY date_column
        RANGE BETWEEN INTERVAL '6 days' PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_sum
FROM table_name;
```

---

Partitioned Sliding Windows
Calculate rolling metrics per entity.

```sql
SELECT
    user_id,
    date_column,
    metric,
    AVG(metric) OVER (
        PARTITION BY user_id
        ORDER BY date_column
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM events;
```

---

Variants

1. Rolling Sum
```sql
SUM(value) OVER (
    ORDER BY date_column
    ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
)
```

2. Centered Window
```sql
AVG(value) OVER (
    ORDER BY date_column
    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
)
```

3. Excluding Current Row
```sql
AVG(value) OVER (
    ORDER BY date_column
    ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING
)
```

---

Pitfalls
- ROWS counts physical rows, not time intervals
- RANGE behavior differs by SQL engine
- Missing dates can distort rolling metrics
- Large windows can be expensive without indexes
- ORDER BY must be deterministic

---

Mini Example

```sql
WITH daily_sales AS (
    SELECT * FROM (VALUES
        (DATE '2023-01-01', 10),
        (DATE '2023-01-02', 20),
        (DATE '2023-01-03', 30),
        (DATE '2023-01-04', 40)
    ) AS t(date_column, amount)
)
SELECT
    date_column,
    amount,
    AVG(amount) OVER (
        ORDER BY date_column
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS rolling_avg
FROM daily_sales;
```

Result:

date_column | amount | rolling_avg
------------|--------|------------
2023-01-01  | 10     | 10
2023-01-02  | 20     | 15
2023-01-03  | 30     | 25
2023-01-04  | 40     | 35
