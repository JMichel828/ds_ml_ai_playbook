# Conditional Aggregation

## Definition
**Conditional Aggregation** is the SQL pattern of applying aggregate functions (SUM, COUNT, AVG, MAX, etc.) to *subsets* of rows **based on boolean conditions inside the aggregate**.  
Instead of filtering with `WHERE`, conditions are placed **inside the aggregation** using `CASE WHEN ... THEN ... END`.

It’s used to pivot data, compute multiple metrics in one scan, or generate KPIs without writing multiple queries.

---

## When It Appears in Interviews

- Computing multi-metric summaries by group  
  (e.g., number of active vs inactive users)
- Pivot-style summaries without using `PIVOT`
- Time-window metrics (e.g., revenue in Q1 vs Q2)
- Categorizing values into buckets and aggregating them
- Calculating conditional counts (e.g., failures vs successes)
- Nearly universal: appears in **easy, medium, and hard** SQL interviews

---

## Core Template

The classic form looks like this:

```sql
SELECT
    group_col,
    SUM(CASE WHEN condition_1 THEN value ELSE 0 END) AS metric_1,
    SUM(CASE WHEN condition_2 THEN value ELSE 0 END) AS metric_2,
    COUNT(CASE WHEN condition_3 THEN 1 END) AS count_condition_3
FROM table_name
GROUP BY group_col;
```

### Key idea:
`CASE` controls *which rows* count toward an aggregate **without** removing other rows from the result.

---

## Variants

### 1. **Boolean Counts**
```sql
COUNT(CASE WHEN status = 'active' THEN 1 END) AS active_users
```

### 2. **Boolean Sums**
```sql
SUM(CASE WHEN country = 'US' THEN revenue ELSE 0 END) AS us_revenue
```

### 3. **Pivot Simulation**
Turns rows into columns without a `PIVOT` keyword:

```sql
SUM(CASE WHEN color = 'red' THEN 1 END) AS red_count,
SUM(CASE WHEN color = 'blue' THEN 1 END) AS blue_count
```

### 4. **Bucketed Aggregation**
```sql
SUM(CASE WHEN spend < 100 THEN 1 END) AS low_spend_users,
SUM(CASE WHEN spend BETWEEN 100 AND 500 THEN 1 END) AS medium_spend_users
```

### 5. **Time-Based Metrics**
```sql
SUM(CASE WHEN EXTRACT(MONTH FROM order_date) = 1 THEN amount ELSE 0 END) AS january_sales
```

---

## Pitfalls

- **Forgetting ELSE 0**  
  SUM() or AVG() returns NULL instead of 0 when all conditions fail.
- **Mixing WHERE with conditional logic**  
  `WHERE` filters out rows *before* aggregation — often a logic bug.
- **Using COUNT(*) incorrectly**  
  `COUNT(*)` counts rows regardless of `CASE`; use `COUNT(CASE WHEN ...)`.
- **Non-mutually-exclusive conditions**  
  Rows may count in *multiple* buckets if conditions overlap.
- **Performance**  
  Too many `CASE` expressions can slow queries; indexes may help.

---

## Mini Example

Suppose you have:

```sql
user_id | status     | spend
--------+-----------+-------
1       | active     | 120
2       | inactive   | 50
3       | active     | 300
4       | pending    | 0
5       | active     | 40
```

### Query

```sql
SELECT
    COUNT(*) AS total_users,
    COUNT(CASE WHEN status = 'active' THEN 1 END) AS active_users,
    SUM(CASE WHEN spend >= 100 THEN spend ELSE 0 END) AS high_value_spend,
    SUM(CASE WHEN spend < 100 THEN spend ELSE 0 END) AS low_value_spend
FROM users;
```

### Result

| total_users | active_users | high_value_spend | low_value_spend |
|-------------|--------------|------------------|------------------|
| 5           | 3            | 420              | 90               |

---

