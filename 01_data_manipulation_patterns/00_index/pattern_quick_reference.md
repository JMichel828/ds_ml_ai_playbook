# SQL & Pandas Pattern Quick Reference

This file is a **high-level pattern index** designed for fast triage during coding work.
Use it to quickly identify *which pattern* applies before diving into the detailed folders.

---

## 1. Gaps & Islands
**Use when:** You need to detect consecutive sequences or breaks in ordered data.  
**Common signals:** streaks, sessions, missing dates, continuous activity.  
**Typical tools:** ROW_NUMBER diffs (SQL), shift + cumsum (pandas).  
**Common pitfalls:** forgetting to sort data, duplicate dates breaking streak logic, off-by-one errors in date math.

---

## 2. Conditional Aggregation
**Use when:** You need multiple metrics from the same table with different conditions.  
**Common signals:** counts by category, conditional sums, pivot-style outputs.  
**Typical tools:** CASE WHEN inside aggregates, boolean masks in pandas.  
**Common pitfalls:** missing ELSE clauses, double-counting rows, mixing aggregation levels.

---

## 3. CASE WHEN Logic
**Use when:** You need branching logic or feature creation.  
**Common signals:** bucketing, flags, business rules, scoring logic.  
**Typical tools:** CASE WHEN (SQL), np.where / Series.where (pandas).  
**Common pitfalls:** incorrect condition order, missing ELSE returning NULL, overlapping conditions.

---

## 4. Subquery Aggregation
**Use when:** You must aggregate at one level before computing a higher-level metric.  
**Common signals:** “average of averages”, pre-aggregation, normalization.  
**Typical tools:** CTEs / subqueries, groupby → merge in pandas.  
**Common pitfalls:** aggregating at the wrong level, unnecessary nested subqueries, performance issues.

---

## 5. Set Logic
**Use when:** Comparing or combining datasets based on membership.  
**Common signals:** inclusion/exclusion, overlap, differences between tables.  
**Typical tools:** UNION / INTERSECT / EXCEPT, concat + drop_duplicates, merges.  
**Common pitfalls:** confusing UNION vs UNION ALL, mishandling NULLs, unintended duplicates.

---

## 6. Pivot & Unpivot
**Use when:** Reshaping data between long and wide formats.  
**Common signals:** categories becoming columns, KPI tables, reporting outputs.  
**Typical tools:** conditional aggregation, pivot_table / melt.  
**Common pitfalls:** hardcoding categories, sparse data creating NULLs, non-portable SQL syntax.

---

## 7. Recursive Logic
**Use when:** Data is hierarchical or iterative.  
**Common signals:** org charts, category trees, graph traversal, sequences.  
**Typical tools:** recursive CTEs, loops or iterative expansion in pandas.  
**Common pitfalls:** missing termination conditions, cycles in data, poor performance on large hierarchies.

---

## 8. Window Functions (General)
**Use when:** You need row-aware calculations without collapsing rows.  
**Common signals:** rankings, running metrics, comparisons to previous rows.  
**Typical tools:** OVER() clauses, groupby + transform.  
**Common pitfalls:** missing PARTITION BY, incorrect ORDER BY, misunderstanding ROWS vs RANGE.

---

## 9. Ranking & Deduplication
**Use when:** Selecting top-N or removing duplicates with rules.  
**Common signals:** latest record per user, highest score per group.  
**Typical tools:** ROW_NUMBER / RANK, sort_values + drop_duplicates.  
**Common pitfalls:** using DISTINCT incorrectly, ties handled improperly, unstable ordering.

---

## 10. Running Totals
**Use when:** Metrics should accumulate over time.  
**Common signals:** cumulative revenue, total usage, growth curves.  
**Typical tools:** SUM OVER, cumsum.  
**Common pitfalls:** forgetting ORDER BY, resetting totals unintentionally, mixing running and grouped metrics.

---

## 11. Sliding Windows
**Use when:** Metrics should apply over a moving window.  
**Common signals:** rolling averages, rolling sums, trend smoothing.  
**Typical tools:** ROWS BETWEEN, rolling().  
**Common pitfalls:** confusing ROWS with time-based windows, missing dates, window size off-by-one errors.

---

## 12. Nested Windows
**Use when:** A window function depends on the output of another window.  
**Common signals:** rank-of-rank, percentile-of-rank problems.  
**Typical tools:** window functions inside subqueries, multi-step transforms.  
**Common pitfalls:** attempting nested windows in a single SELECT, readability issues, performance overhead.

---

## 13. Percentiles & Quantiles
**Use when:** Distribution-based metrics matter.  
**Common signals:** medians, p90/p95, outlier detection.  
**Typical tools:** PERCENTILE_CONT / DISC, quantile().  
**Common pitfalls:** confusing percentile definitions, interpolation differences across engines, small-sample instability.

---

## 14. Time-Based Joins
**Use when:** Records must align by time rather than exact keys.  
**Common signals:** as-of joins, effective dating, validity windows.  
**Typical tools:** BETWEEN joins, merge_asof.  
**Common pitfalls:** overlapping time ranges, timezone mismatches, incorrect join conditions.

---

## 15. Multi-Join Sequencing
**Use when:** Multiple joins must happen in a specific logical order.  
**Common signals:** funnel analysis, event sequencing, step-based metrics.  
**Typical tools:** ordered joins, cumulative conditions, staged merges.  
**Common pitfalls:** joining too early, losing rows between steps, incorrect join types.

---

## 16. JSON Array Extraction
**Use when:** Data is stored in semi-structured arrays.  
**Common signals:** event payloads, nested attributes, one-to-many explosion.  
**Typical tools:** json functions, UNNEST / FLATTEN, explode().  
**Common pitfalls:** forgetting to unnest before aggregating, type casting errors, exploding large arrays unintentionally.

---

## How to Use This File
1. Match the **signal language** to a pattern above.
2. Check the **common pitfalls** to avoid mistakes.
3. Jump into the corresponding pattern folder.
4. Start with 1_notes.md, then 2_sql.md or 4_pandas.md.

This file is your **pattern decision map**.