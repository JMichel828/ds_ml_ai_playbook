# Set Logic (Set Operations)

## Definition
Set logic refers to SQL operations that treat query results as mathematical sets.
These operations combine, compare, or subtract result sets rather than joining rows.
The most common set operators are UNION, UNION ALL, INTERSECT, and EXCEPT (or MINUS).

---

## When It Typically Appears
- Comparing two datasets to find overlap or differences
- Identifying users who did one action but not another
- Merging datasets with the same schema
- Data reconciliation and QA checks

---

## Core Template

```sql
-- UNION removes duplicates
SELECT col1, col2
FROM table_a
UNION
SELECT col1, col2
FROM table_b;

-- UNION ALL keeps duplicates
SELECT col1, col2
FROM table_a
UNION ALL
SELECT col1, col2
FROM table_b;
```

All SELECT statements must:
- Have the same number of columns
- Have compatible data types
- Use the same column order

---

## Core Set Operators

1. UNION  
Combines two result sets and removes duplicates.

2. UNION ALL  
Combines two result sets and keeps duplicates (faster than UNION).

3. INTERSECT  
Returns only rows that appear in both result sets.

```sql
SELECT user_id FROM table_a
INTERSECT
SELECT user_id FROM table_b;
```

4. EXCEPT (or MINUS)  
Returns rows in the first result set that do NOT appear in the second.

```sql
SELECT user_id FROM table_a
EXCEPT
SELECT user_id FROM table_b;
```

---

Variants

1. Anti-Join via Set Logic
```sql
SELECT user_id FROM table_a
EXCEPT
SELECT user_id FROM table_b;
```

2. Deduplication via UNION
```sql
SELECT * FROM table_a
UNION
SELECT * FROM table_a;
```

3. Data Validation
```sql
SELECT * FROM prod_table
EXCEPT
SELECT * FROM staging_table;
```

---

## Pitfalls
- UNION performs a DISTINCT under the hood (can be slow)
- Column order matters more than column names
- NULL handling can differ across databases
- EXCEPT removes duplicates by default
- INTERSECT not supported in some older systems

---

## Mini Example

Table A (logins):

user_id
-------
1
2
3
4

Table B (purchases):

user_id
-------
3
4
5

Queries and Results:

Users in either table:
```sql
SELECT user_id FROM logins
UNION
SELECT user_id FROM purchases;
```

Result:
1, 2, 3, 4, 5

Users in both tables:
```sql
SELECT user_id FROM logins
INTERSECT
SELECT user_id FROM purchases;
```

Result:
3, 4

Users who logged in but never purchased:
```sql
SELECT user_id FROM logins
EXCEPT
SELECT user_id FROM purchases;
```

Result:
1, 2
