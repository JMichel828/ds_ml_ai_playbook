# Gaps & Islands

Definition
The Gaps & Islands pattern is used to identify consecutive sequences of rows ("islands") and the gaps between them.
It’s commonly applied to detect streaks, missing dates, sessionization, or periods of uninterrupted activity.

---

When It Appears in Interviews
- Finding daily login streaks or activity periods
- Detecting missing dates in a series
- Sessionizing user activity or events
- Identifying continuous usage or subscription periods
- Frequently appears in medium to hard SQL interview questions

---

Core Template
The most common approach uses ROW_NUMBER() differences:

```sql
WITH numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY date_column)
         - ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date_column) AS grp
    FROM table_name
)
SELECT user_id, MIN(date_column) AS start_date, MAX(date_column) AS end_date
FROM numbered
GROUP BY user_id, grp;

The grp column helps to identify consecutive sequences.
ROW_NUMBER() differences produce a constant value for each island.
```

---

Variants
1. LAG-based session detection:

CASE 
    WHEN date_column = LAG(date_column) OVER (PARTITION BY user_id ORDER BY date_column) + INTERVAL '1 day'
    THEN 0 
    ELSE 1
END AS new_session;

2. Numeric sequences – For strictly increasing sequences of numbers
3. Calculating session durations – Use LAG() and LEAD() to measure time between events

---

Pitfalls
- Off-by-one errors on date boundaries
- Duplicate dates break the calculation
- Timestamps may need truncation to dates
- ORDER BY must be deterministic to avoid inconsistent results

---

Mini Example

WITH events AS (
    SELECT * FROM (VALUES
        (1, DATE '2023-01-01'),
        (1, DATE '2023-01-02'),
        (1, DATE '2023-01-04'),
        (2, DATE '2023-02-01'),
        (2, DATE '2023-02-02')
    ) AS t(user_id, date_column)
),
tagged AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY date_column)
         - ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date_column) AS grp
    FROM events
)
SELECT user_id, MIN(date_column) AS start_date, MAX(date_column) AS end_date
FROM tagged
GROUP BY user_id, grp
ORDER BY user_id, start_date;

Result:

user_id | start_date  | end_date
--------|------------|------------
1       | 2023-01-01 | 2023-01-02
1       | 2023-01-04 | 2023-01-04
2       | 2023-02-01 | 2023-02-02
