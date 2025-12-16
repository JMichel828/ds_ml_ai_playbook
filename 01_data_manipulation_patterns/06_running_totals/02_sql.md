# Running Totals

Definition  
Running totals (also called cumulative sums) compute a progressively increasing total over an ordered sequence of rows.
They are commonly used for revenue-to-date, balances, cumulative counts, and time-series KPIs.

---

When It Appears in Interviews
- Calculating cumulative revenue or spend
- Tracking running balances or inventory
- Generating cumulative user or event counts
- Time-series growth and trend analysis
- Common in easy to medium SQL interview questions

---

Core Template

```sql
SELECT
    date_column,
    value,
    SUM(value) OVER (
        ORDER BY date_column
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM table_name;
```

---

Partitioned Running Totals

```sql
SELECT
    user_id,
    date_column,
    value,
    SUM(value) OVER (
        PARTITION BY user_id
        ORDER BY date_column
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM table_name;
```

---

Variants

1. Running Count
```sql
COUNT(*) OVER (ORDER BY date_column)
```

2. Running Average
```sql
AVG(value) OVER (ORDER BY date_column)
```

3. Conditional Running Totals
```sql
SUM(CASE WHEN event_type = 'purchase' THEN amount ELSE 0 END)
OVER (ORDER BY event_time)
```

4. Excluding Current Row
```sql
SUM(value) OVER (
    ORDER BY date_column
    ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
)
```

---

Pitfalls
- Missing ORDER BY leads to incorrect cumulative results
- Duplicate timestamps cause nondeterministic ordering
- RANGE vs ROWS behaves differently with ties
- Large windows can impact performance without indexing

---

Mini Example

```sql
WITH sales AS (
    SELECT * FROM (VALUES
        (DATE '2023-01-01', 100),
        (DATE '2023-01-02', 50),
        (DATE '2023-01-05', 200)
    ) AS t(date_column, amount)
)
SELECT
    date_column,
    amount,
    SUM(amount) OVER (
        ORDER BY date_column
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales;
```

Result:

date_column | amount | running_total
------------|--------|---------------
2023-01-01  | 100    | 100
2023-01-02  | 50     | 150
2023-01-05  | 200    | 350
