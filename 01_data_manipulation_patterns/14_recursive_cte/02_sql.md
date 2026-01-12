# Recursive CTEs

## Definition
A Recursive Common Table Expression (CTE) is a SQL pattern used to repeatedly execute a query
until a condition is met. It is most often used to traverse hierarchical data, generate sequences,
or solve problems that require iterative logic.

Recursive CTEs consist of:
- An anchor query (base case)
- A recursive query that references the CTE itself
- A termination condition that stops recursion

---

## When It Typically Appears
- Working with hierarchical data (org charts, category trees)
- Parent-child relationships
- Generating sequences of numbers or dates
- Graph traversal problems

---

## Core Template

```sql
WITH RECURSIVE cte_name AS (
    -- Anchor member
    SELECT
        id,
        parent_id,
        value
    FROM table_name
    WHERE parent_id IS NULL

    UNION ALL

    -- Recursive member
    SELECT
        t.id,
        t.parent_id,
        t.value
    FROM table_name t
    JOIN cte_name c
        ON t.parent_id = c.id
)
SELECT *
FROM cte_name;
```

The anchor initializes the recursion.
The recursive member runs repeatedly until no new rows are returned.

---

## Variants

1. Generating a Number Sequence
```sql
WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM nums
    WHERE n < 10
)
SELECT * FROM nums;
```

2. Generating a Date Series
```sql
WITH RECURSIVE dates AS (
    SELECT DATE '2023-01-01' AS dt
    UNION ALL
    SELECT dt + INTERVAL '1 day'
    FROM dates
    WHERE dt < DATE '2023-01-07'
)
SELECT * FROM dates;
```

3. Hierarchy Depth Tracking
```sql
WITH RECURSIVE hierarchy AS (
    SELECT id, parent_id, 1 AS level
    FROM nodes
    WHERE parent_id IS NULL

    UNION ALL

    SELECT n.id, n.parent_id, h.level + 1
    FROM nodes n
    JOIN hierarchy h
        ON n.parent_id = h.id
)
SELECT * FROM hierarchy;
```

---

## Pitfalls
- Forgetting a termination condition causes infinite recursion
- UNION ALL is almost always required (UNION may remove rows)
- Recursive queries can be slow on large hierarchies
- Some databases require explicit recursion limits
- Cycles in data can break recursion unless guarded against

---

## Mini Example

```sql
WITH RECURSIVE org AS (
    SELECT
        employee_id,
        manager_id,
        employee_name
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.manager_id,
        e.employee_name
    FROM employees e
    JOIN org o
        ON e.manager_id = o.employee_id
)
SELECT *
FROM org;
```

Result:

employee_id | manager_id | employee_name
------------|------------|---------------
1           | NULL       | CEO
2           | 1          | VP
3           | 2          | Manager
4           | 3          | Engineer
