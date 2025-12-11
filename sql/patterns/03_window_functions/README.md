# Window Functions

Definition
Window functions perform calculations across a set of rows that are related to the current row — without collapsing them into a single aggregated result. They allow ranking, running totals, moving averages, time-based comparisons, and more.

---

When It Appears in Interviews
- Ranking customers, products, or events
- Finding previous/next values using LAG/LEAD
- Calculating running totals or moving averages
- Deduplicating rows with ROW_NUMBER()
- Computing percentiles or distributions
- Intermediate/advanced SQL interviews almost always include at least one window function question

---

Core Template

```sql
SELECT
    column,
    window_function(...) OVER (
        PARTITION BY partition_column
        ORDER BY order_column
        ROWS BETWEEN ... -- optional frame
    )
FROM table_name;
```

Key Components:
- **PARTITION BY**: Splits rows into groups
- **ORDER BY**: Specifies ordering within each group
- **Frame clause**: Controls range of rows included (e.g., running totals)

---

Most Common Window Functions

### 1. ROW_NUMBER(), RANK(), DENSE_RANK()
Used for ranking or deduplication.

```sql
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time)
```

### 2. LAG() and LEAD()
Access previous/next row values.

```sql
LAG(value, 1) OVER (PARTITION BY user_id ORDER BY event_time)
```

### 3. SUM(), COUNT(), AVG() OVER()
Running totals, moving averages, rolling stats.

```sql
SUM(sales) OVER (ORDER BY date) AS running_sales
```

---

Variants
- **Frame definitions**: ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
- **Value-based windows**: RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
- **Percentile functions**: PERCENT_RANK(), NTILE()
- **First/last value**: FIRST_VALUE(), LAST_VALUE()

---

Pitfalls
- Forgetting ORDER BY results in meaningless window calculations
- ROW_NUMBER vs RANK differences causing unexpected gaps
- Frame clauses producing surprising results if not specified
- LAG/LEAD returning NULL when no previous/next row exists
- Performance issues on large partitions without indexing

---

Mini Example

```sql
WITH sales AS (
    SELECT * FROM (VALUES
        (1, DATE '2023-01-01', 10),
        (1, DATE '2023-01-02', 15),
        (1, DATE '2023-01-03', 7),
        (2, DATE '2023-01-01', 20),
        (2, DATE '2023-01-03', 5)
    ) AS t(user_id, date, amount)
)
SELECT
    user_id,
    date,
    amount,
    SUM(amount) OVER (PARTITION BY user_id ORDER BY date)
        AS running_total,
    LAG(amount) OVER (PARTITION BY user_id ORDER BY date)
        AS previous_amount
FROM sales
ORDER BY user_id, date;
```

Result:

user_id | date       | amount | running_total | previous_amount
--------|------------|--------|----------------|-------------------
1       | 2023-01-01 | 10     | 10             | NULL
1       | 2023-01-02 | 15     | 25             | 10
1       | 2023-01-03 | 7      | 32             | 15
2       | 2023-01-01 | 20     | 20             | NULL
2       | 2023-01-03 | 5      | 25             | 20
