# JSON Array Extraction

## Definition
JSON array extraction is a SQL pattern used to read, expand, and analyze array-type fields stored in JSON or semi-structured columns.
It allows you to extract individual elements, unnest arrays into rows, and access nested attributes for analytics and reporting.

This pattern is common in event logs, API payloads, product analytics, and modern data warehouses.

---

## When It Typically Appears
- Working with event payloads stored as JSON
- Exploding arrays into rows (one-to-many expansion)
- Extracting nested attributes for filtering or aggregation
- Analytics on semi-structured data

---

## Core Template (Extract Scalar Value)

```sql
SELECT
    json_column ->> 'key' AS value
FROM table_name;
```

Use `->` to return JSON and `->>` to return text (PostgreSQL syntax).

---

Core Template (Explode / Unnest JSON Array)
Turn a JSON array into one row per element.

```sql
SELECT
    t.id,
    elem ->> 'item_id' AS item_id,
    elem ->> 'price' AS price
FROM table_name t
CROSS JOIN LATERAL jsonb_array_elements(t.json_array_column) AS elem;
```

This creates one output row per array element.

---

## Variants

1. Extract by Array Index
```sql
json_array_column -> 0 ->> 'field'
```

2. Filter While Exploding
```sql
CROSS JOIN LATERAL jsonb_array_elements(json_array_column) AS elem
WHERE elem ->> 'type' = 'purchase';
```

3. Nested Arrays
```sql
jsonb_array_elements(elem -> 'sub_array')
```

4. Snowflake / BigQuery Syntax
```sql
-- Snowflake
SELECT value:item_id
FROM table_name, LATERAL FLATTEN(input => json_column);

-- BigQuery
SELECT item.item_id
FROM table_name,
UNNEST(json_array_column) AS item;
```

---

## Pitfalls
- Forgetting to unnest arrays leads to incorrect aggregations
- JSON extraction functions vary by SQL engine
- Type casting is often required for numeric operations
- Exploding large arrays can drastically increase row counts
- Performance issues without proper filtering

---

## Mini Example

Input Table:

id | items
---|---------------------------------------------------------
1  | [{"item":"A","qty":2},{"item":"B","qty":1}]
2  | [{"item":"C","qty":3}]

Query:

```sql
SELECT
    t.id,
    elem ->> 'item' AS item,
    (elem ->> 'qty')::int AS qty
FROM orders t
CROSS JOIN LATERAL jsonb_array_elements(t.items) AS elem;
```

Result:

id | item | qty
---|------|----
1  | A    | 2
1  | B    | 1
2  | C    | 3
