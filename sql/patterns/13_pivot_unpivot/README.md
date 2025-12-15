# Pivot & Unpivot

Definition
Pivot and unpivot are SQL patterns used to reshape data between long (row-based) and wide (column-based) formats.

- Pivot turns rows into columns (categorical values become columns).
- Unpivot turns columns into rows (columns become categorical values).

These patterns are common in reporting, analytics, and feature engineering.

---

When It Appears in Interviews
- Transforming event-level data into summary tables
- Converting category rows into KPI columns
- Preparing data for dashboards or reports
- Reversing pivoted data back into long format
- Medium SQL interview questions, often combined with CASE WHEN

---

Pivot (Rows → Columns)

### Core Template (CASE WHEN Pivot)
Most portable approach across SQL dialects.

```sql
SELECT
    user_id,
    SUM(CASE WHEN category = 'A' THEN amount ELSE 0 END) AS category_a,
    SUM(CASE WHEN category = 'B' THEN amount ELSE 0 END) AS category_b,
    SUM(CASE WHEN category = 'C' THEN amount ELSE 0 END) AS category_c
FROM table_name
GROUP BY user_id;
```

This uses conditional aggregation to simulate a pivot.

---

Pivot (Using PIVOT Keyword)
Supported in some databases (e.g., SQL Server, Oracle).

```sql
SELECT *
FROM table_name
PIVOT (
    SUM(amount)
    FOR category IN ('A', 'B', 'C')
);
```

---

Unpivot (Columns → Rows)

### Core Template (UNION ALL)
Most portable unpivot approach.

```sql
SELECT user_id, 'A' AS category, category_a AS amount FROM pivoted_table
UNION ALL
SELECT user_id, 'B' AS category, category_b AS amount FROM pivoted_table
UNION ALL
SELECT user_id, 'C' AS category, category_c AS amount FROM pivoted_table;
```

---

Unpivot (Using UNPIVOT Keyword)
Supported in some databases.

```sql
SELECT user_id, category, amount
FROM pivoted_table
UNPIVOT (
    amount FOR category IN (category_a, category_b, category_c)
);
```

---

Variants

1. Pivot with Counts Instead of Sums
```sql
COUNT(CASE WHEN status = 'active' THEN 1 END)
```

2. Dynamic Pivot
Requires dynamic SQL when categories are unknown.

3. Sparse Pivot
Use MAX instead of SUM when values are mutually exclusive.

---

Pitfalls
- Hardcoding categories reduces flexibility
- NULL handling can affect aggregates
- PIVOT / UNPIVOT syntax is not portable across all SQL engines
- Dynamic pivots add complexity and are rarely expected in interviews

---

Mini Example

Input Table:

user_id | category | amount
--------|----------|-------
1       | A        | 10
1       | B        | 20
2       | A        | 5
2       | C        | 15

Pivot Result:

user_id | category_a | category_b | category_c
--------|------------|------------|-----------
1       | 10         | 20         | 0
2       | 5          | 0          | 15
