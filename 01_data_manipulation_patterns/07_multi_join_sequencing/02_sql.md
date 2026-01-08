
# Multi-Join Sequencing

## Definition
Multi-Join Sequencing is a SQL pattern used to join the same or multiple tables in a specific temporal or logical order.
It is commonly used when events, statuses, or records must be matched to the *correct* prior or next row based on time, rank, or condition.

---

## When It Typically Appears
- Matching events to the most recent prior record (e.g., last subscription before purchase)
- Sequencing user actions across multiple tables
- Attribution problems (which campaign, session, or state applied at the time?)
- Slowly changing attributes without full SCD tables
- Medium to hard SQL interview questions

---

## Core Template
The most common approach uses window functions with filtered joins:

```sql
WITH ranked AS (
    SELECT
        a.*,
        b.attribute,
        ROW_NUMBER() OVER (
            PARTITION BY a.id
            ORDER BY b.event_time DESC
        ) AS rn
    FROM table_a a
    JOIN table_b b
        ON a.id = b.id
       AND b.event_time <= a.event_time
)
SELECT *
FROM ranked
WHERE rn = 1;
```

This pattern ensures each row in `table_a` is matched to the *most relevant* row in `table_b`.

---

## Variants
1. Forward-looking sequencing (next event):
```sql
ROW_NUMBER() OVER (
    PARTITION BY a.id
    ORDER BY b.event_time ASC
)
```

2. Multi-step sequencing:
Join multiple CTEs, each resolving one step in the sequence.

3. Using LAG / LEAD instead of joins when data is in a single table.

---

## Pitfalls
- Missing join filters can cause row explosion
- Incorrect ORDER BY leads to wrong attribution
- Ties in timestamps require deterministic sorting
- LEFT vs INNER JOIN choice affects data loss

---

## Mini Example

WITH purchases AS (
    SELECT * FROM (VALUES
        (1, TIMESTAMP '2023-01-05'),
        (2, TIMESTAMP '2023-01-10')
    ) AS t(user_id, purchase_time)
),
subscriptions AS (
    SELECT * FROM (VALUES
        (1, TIMESTAMP '2023-01-01', 'Basic'),
        (1, TIMESTAMP '2023-01-04', 'Pro'),
        (2, TIMESTAMP '2023-01-02', 'Basic')
    ) AS t(user_id, start_time, plan)
),
joined AS (
    SELECT
        p.user_id,
        p.purchase_time,
        s.plan,
        ROW_NUMBER() OVER (
            PARTITION BY p.user_id, p.purchase_time
            ORDER BY s.start_time DESC
        ) AS rn
    FROM purchases p
    JOIN subscriptions s
        ON p.user_id = s.user_id
       AND s.start_time <= p.purchase_time
)
SELECT user_id, purchase_time, plan
FROM joined
WHERE rn = 1;

Result:

user_id | purchase_time        | plan
--------|----------------------|------
1       | 2023-01-05 00:00:00  | Pro
2       | 2023-01-10 00:00:00  | Basic
