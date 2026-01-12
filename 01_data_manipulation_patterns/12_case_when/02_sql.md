# CASE WHEN Logic

## Definition
CASE WHEN is a SQL conditional expression used to apply branching logic within a query.
It allows you to create derived columns, bucket values, apply conditional calculations,
and encode business rules directly in SQL.

CASE WHEN is foundational to many advanced SQL patterns, including conditional aggregation,
data categorization, scoring logic, and feature engineering.

---

## When It Typically Appears
- Creating categorical variables from numeric values
- Applying business rules or flags
- Conditional aggregation and pivots
- Data cleaning and standardization

---

## Core Template

```sql
CASE
    WHEN condition_1 THEN result_1
    WHEN condition_2 THEN result_2
    ELSE default_result
END
```

The CASE expression is evaluated top-down; the first matching condition is returned.

---

## Common Patterns

1. **Binary Flags**
```sql
CASE
    WHEN status = 'active' THEN 1
    ELSE 0
END AS is_active
```

2. **Bucketing / Binning**
```sql
CASE
    WHEN spend < 100 THEN 'low'
    WHEN spend BETWEEN 100 AND 500 THEN 'medium'
    ELSE 'high'
END AS spend_bucket
```

3. **Conditional Metrics**
```sql
CASE
    WHEN completed = TRUE THEN revenue
    ELSE 0
END
```

4. **NULL Handling**
```sql
CASE
    WHEN value IS NULL THEN 0
    ELSE value
END
```

---

## CASE WHEN Inside Aggregates
Used heavily for conditional aggregation.

```sql
SUM(
    CASE
        WHEN event_type = 'purchase' THEN amount
        ELSE 0
    END
) AS purchase_revenue
```

---

## Variants

1. Simple CASE
```sql
CASE column
    WHEN 'A' THEN 1
    WHEN 'B' THEN 2
    ELSE 0
END
```

2. Searched CASE (most common)
```sql
CASE
    WHEN column > 100 THEN 'large'
    ELSE 'small'
END
```

---

## Pitfalls
- Order matters: first matching condition wins
- Missing ELSE returns NULL
- Overlapping conditions cause unintended results
- Mixing data types across THEN clauses causes errors
- Deeply nested CASE expressions reduce readability

---

## Mini Example

```sql
WITH orders AS (
    SELECT * FROM (VALUES
        (1, 50),
        (2, 150),
        (3, 600)
    ) AS t(order_id, amount)
)
SELECT
    order_id,
    amount,
    CASE
        WHEN amount < 100 THEN 'low'
        WHEN amount BETWEEN 100 AND 500 THEN 'medium'
        ELSE 'high'
    END AS order_size
FROM orders;
```

Result:

order_id | amount | order_size
---------|--------|-----------
1        | 50     | low
2        | 150    | medium
3        | 600    | high
