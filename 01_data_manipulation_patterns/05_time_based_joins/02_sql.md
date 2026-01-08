
# Time-Based Joins (SQL Pattern)

## Overview
Time-based joins are used when you want to join two tables based on timestamps rather than strict equality, such as joining an event to the "effective record" valid at that time.

---

## When It Typically Appears
- Slowly changing dimensions (SCD Type 2 lookups)
- Matching events to nearest timestamp
- Joining sessions to activity logs
- Valid-from / valid-to ranges
- IoT / clickstream / log-level time merges

---

## Core Patterns

### 1. **Range-Based Join (Valid-From / Valid-To)**
```sql
SELECT
    f.event_id,
    d.dimension_value
FROM fact_events f
LEFT JOIN dim_history d
    ON f.event_ts >= d.valid_from
   AND f.event_ts <  d.valid_to;
```

### 2. **Join on Nearest Timestamp (LAST BEFORE)**
```sql
SELECT f.*, d.value
FROM fact_events f
LEFT JOIN LATERAL (
    SELECT *
    FROM dim_values d
    WHERE d.ts <= f.ts
    ORDER BY d.ts DESC
    LIMIT 1
) d ON TRUE;
```

### 3. **Join on Nearest Timestamp (FIRST AFTER)**
```sql
SELECT f.*, d.value
FROM fact_events f
LEFT JOIN LATERAL (
    SELECT *
    FROM dim_values d
    WHERE d.ts >= f.ts
    ORDER BY d.ts ASC
    LIMIT 1
) d ON TRUE;
```

### 4. **Find Overlapping Time Windows**
```sql
SELECT *
FROM sessions s
JOIN pageviews p
  ON p.ts BETWEEN s.session_start AND s.session_end;
```

---

## Common Pitfalls
- Not indexing timestamps → slow queries
- Overlapping dimension records → duplicated join results
- Time zone inconsistencies
- Null `valid_to` values → use a sentinel (e.g., `'9999-12-31'`)

---

## Best Practices
- Normalize timestamps to UTC
- Ensure ranges never overlap
- Always sanity-check with `COUNT(*)` before and after
- Add indexes on timestamp columns
