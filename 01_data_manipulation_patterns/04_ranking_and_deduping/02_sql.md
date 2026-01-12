# Ranking Window Functions

## Definition
Ranking window functions assign an order or position to each row within a partition.
They are used to identify top-N, ties, ordering within groups, and comparative positions.

Functions include:
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `NTILE(n)`

---

## When It Typically Appears
- Finding the top performer per group
- Identifying the 2nd/3rd highest metric
- Breaking ties or preserving them depending on function
- Detecting duplicates
- Comparing current row to earlier rows

---

## Core Template

```sql
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY group_col ORDER BY sort_col DESC) AS rn,
    RANK() OVER (PARTITION BY group_col ORDER BY sort_col DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY group_col ORDER BY sort_col DESC) AS dense_rnk,
    NTILE(4) OVER (ORDER BY sort_col) AS quartile
FROM table_name;
```

---

## Differences Between Ranking Functions

- **ROW_NUMBER()**  
  Always increments by 1. No ties.  
  1, 2, 3, 4…

- **RANK()**  
  Ties get the same rank, but gaps appear afterward.  
  1, 1, 3, 4…

- **DENSE_RANK()**  
  Ties get the same rank, but no gaps.  
  1, 1, 2, 3…

- **NTILE(n)**  
  Splits rows into buckets (e.g., quartiles).

---

## Pitfalls
- Missing `ORDER BY` inside `OVER()` → incorrect or random ranking
- Ties due to insufficient ordering columns
- Large datasets require careful indexing
- `NTILE()` buckets can be uneven if rows don’t divide cleanly

---

## Mini Example

```sql
SELECT
    employee,
    department,
    sales,
    RANK() OVER (PARTITION BY department ORDER BY sales DESC) AS dept_rank
FROM sales_table;
```

Result:

employee | department | sales | dept_rank
-------- | ---------- | ----- | ---------
Alice    | A          | 100   | 1
Bob      | A          | 100   | 1
Carol    | A          | 80    | 3
Dave     | B          | 70    | 1
Eve      | B          | 50    | 2


# Deduplication Using Window Functions

## Definition
Deduplication removes duplicate rows based on key columns while keeping only the “best” row per group.
The most common technique uses `ROW_NUMBER()`.

---

## Core Template (ROW_NUMBER)

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY event_timestamp DESC
           ) AS rn
    FROM events
)
SELECT *
FROM ranked
WHERE rn = 1;
```

This keeps only the most recent event per `user_id`.

---

## Alternative Approaches

### DISTINCT ON (PostgreSQL)
```sql
SELECT DISTINCT ON (user_id) *
FROM events
ORDER BY user_id, event_timestamp DESC;
```

### GROUP BY + JOIN

---

## Pitfalls
- Missing or nondeterministic `ORDER BY` → wrong row kept
- Multiple “top” rows if using `RANK()` instead of `ROW_NUMBER()`
- Performance issues without indexing

---

## Mini Example

Input:

user_id | ts
--------|-----------
1       | 2023-01-01
1       | 2023-01-03
1       | 2023-01-02

Output:

user_id | ts
--------|-----------
1       | 2023-01-03


