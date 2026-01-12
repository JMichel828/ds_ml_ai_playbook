# Subquery Aggregation

## Definition
Subquery aggregation is a SQL pattern where an aggregate calculation is performed in a subquery
and then joined or referenced by an outer query. It is used when aggregations must occur
before additional joins, filters, or calculations.

This pattern is especially useful when:
- Aggregation changes row granularity
- You need aggregated values alongside non-aggregated columns
- Multiple aggregation levels are required

---

## When It Typically Appears
- Calculating per-user metrics before joining to dimensional data
- Comparing row-level values to group-level aggregates
- Finding rows above/below an average or threshold
- Multi-step metric derivations
- 
---

## Core Template
Aggregate first, then join or filter:

```sql
WITH agg AS (
    SELECT
        group_col,
        SUM(metric) AS total_metric
    FROM table_name
    GROUP BY group_col
)
SELECT
    t.*,
    a.total_metric
FROM table_name t
JOIN agg a
    ON t.group_col = a.group_col;
```

The subquery establishes the correct level of aggregation before rejoining.

---

## Variants

1. Scalar Subquery
Used when the aggregate returns a single value.

```sql
SELECT
    *,
    (SELECT AVG(metric) FROM table_name) AS avg_metric
FROM table_name;
```

2. Correlated Subquery
The subquery depends on the outer query row.

```sql
SELECT
    t.*
FROM table_name t
WHERE t.metric >
    (SELECT AVG(metric)
     FROM table_name
     WHERE group_col = t.group_col);
```

3. Subquery in SELECT Clause
Used to enrich rows with aggregated context.

```sql
SELECT
    user_id,
    spend,
    (SELECT SUM(spend)
     FROM orders o2
     WHERE o2.user_id = o1.user_id) AS total_spend
FROM orders o1;
```

---

## Pitfalls
- Correlated subqueries can be slow on large datasets
- Forgetting GROUP BY causes invalid or incorrect aggregates
- Subqueries may be rewritten as joins for better performance
- Nested subqueries reduce readability if overused

---

## Mini Example

```sql
WITH user_totals AS (
    SELECT
        user_id,
        SUM(amount) AS total_spend
    FROM orders
    GROUP BY user_id
)
SELECT
    o.user_id,
    o.order_id,
    o.amount,
    u.total_spend
FROM orders o
JOIN user_totals u
    ON o.user_id = u.user_id
ORDER BY o.user_id, o.order_id;
```

Result:

user_id | order_id | amount | total_spend
--------|----------|--------|-------------
1       | 101      | 50     | 120
1       | 102      | 70     | 120
2       | 201      | 30     | 30
