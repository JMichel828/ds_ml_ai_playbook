# Nested Window Functions

## Definition
Nested window functions refer to SQL patterns where the output of one window function
is used as input to another calculation, typically by layering window functions
across subqueries or CTEs. Since most SQL dialects do not allow window functions
directly inside other window functions, nesting is achieved through query structure.

This pattern is essential for multi-step analytics such as ranking ranked results,
running totals of aggregates, or percent-of-total calculations.

---

## When It Typically Appears
- Ranking within ranked groups
- Percent-of-total or share-of-total calculations
- Running totals of daily aggregates
- Top-N per group with additional metrics

---

## Core Template
The pattern uses multiple query layers:

```sql
WITH base AS (
    SELECT
        group_col,
        metric,
        SUM(metric) OVER (PARTITION BY group_col) AS group_total
    FROM table_name
),
ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY group_total DESC) AS group_rank
    FROM base
)
SELECT *
FROM ranked;
```

Each layer applies a single window function, enabling complex logic step by step.

---

## Variants

1. Percent of Total
```sql
WITH totals AS (
    SELECT
        *,
        SUM(amount) OVER () AS total_amount
    FROM sales
)
SELECT
    *,
    amount * 1.0 / total_amount AS pct_of_total
FROM totals;
```

2. Running Total of Aggregates
```sql
WITH daily AS (
    SELECT
        date,
        SUM(amount) AS daily_total
    FROM sales
    GROUP BY date
)
SELECT
    date,
    daily_total,
    SUM(daily_total) OVER (ORDER BY date) AS running_total
FROM daily;
```

3. Rank After Filtering
```sql
WITH filtered AS (
    SELECT *
    FROM events
    WHERE event_type = 'purchase'
)
SELECT
    *,
    ROW_NUMBER() OVER (ORDER BY event_time) AS purchase_order
FROM filtered;
```

---

## Pitfalls
- Window functions cannot be nested directly in most SQL engines
- Forgetting to alias window outputs breaks later layers
- Ordering inconsistencies compound across layers
- Performance issues if intermediate results are very large
- Using ORDER BY inconsistently between layers

---

## Mini Example

```sql
WITH user_spend AS (
    SELECT
        user_id,
        SUM(amount) AS total_spend
    FROM orders
    GROUP BY user_id
),
ranked AS (
    SELECT
        *,
        RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
    FROM user_spend
)
SELECT *
FROM ranked;
```

Result:

user_id | total_spend | spend_rank
--------|-------------|------------
1       | 500         | 1
2       | 300         | 2
3       | 300         | 2
4       | 100         | 4
