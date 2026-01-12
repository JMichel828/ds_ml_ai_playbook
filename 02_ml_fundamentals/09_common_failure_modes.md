# Common Machine Learning Failure Modes (Combined Reference)

## Purpose

This document is a **single-source synthesis** of the most common machine learning failure modes.
It focuses on **how ML systems break in practice**, why they break, and how strong practitioners
anticipate and prevent these failures.

Designed for:
- Principal-level system thinking
- Reviewing and debugging production ML systems
- RAG ingestion (failure-pattern heavy, judgment-oriented)

---

## Why Failure Modes Matter

Most ML systems do not fail because of:
- incorrect algorithms
- insufficient compute
- lack of sophistication

They fail because of:
- incorrect assumptions
- silent data issues
- misaligned incentives
- organizational blind spots

Strong ML leaders think **in failure modes**, not models.

---

## 1. Data Leakage

### What It Is
Information from the future or target leaks into training.

### Examples
- Using post-outcome features
- Aggregating over full history instead of cutoff date
- Performing normalization before train-test split

### Why It’s Dangerous
- Inflated offline metrics
- Catastrophic production performance

### Detection
- Time-aware validation
- Feature audits
- Suspiciously strong performance

---

## 2. Training–Serving Skew

### What It Is
Mismatch between training data and production inputs.

### Examples
- Different preprocessing logic
- Feature definitions drift
- Missing values handled differently

### Prevention
- Shared feature pipelines
- End-to-end tests
- Feature store usage

---

## 3. Distribution Shift

### Types
- Covariate shift
- Label shift
- Concept drift

### Example
User behavior changes after product launch.

### Mitigation
- Monitoring input distributions
- Periodic retraining
- Robust feature design

---

## 4. Metric Misalignment

### What Happens
Optimizing a metric that doesn’t reflect business value.

### Examples
- Optimizing AUC instead of cost
- Ignoring false positive load
- Local metrics vs system metrics

### Fix
Tie metrics directly to decisions.

---

## 5. Overfitting to Validation

### What It Is
Repeated tuning to the same validation set.

### Symptoms
- Offline improvement, online stagnation
- High variance across retrains

### Prevention
- Holdout test sets
- Nested CV
- Limited tuning iterations

---

## 6. Feature Fragility

### Examples
- Features dependent on upstream services
- High-cardinality categorical features
- Rare-event features

### Risk
Silent failures or instability.

---

## 7. Spurious Correlations

### Example
Weather correlates with demand but isn’t causal.

### Danger
Models break when environment changes.

### Mitigation
- Domain review
- Causal reasoning
- Stress testing

---

## 8. Poor Thresholding

### What Happens
Correct model, wrong decision rule.

### Examples
- Static thresholds
- No ops alignment

### Fix
Threshold tuning with business input.

---

## 9. Ignoring Segment-Level Performance

### Risk
Overall metrics hide subgroup failures.

### Mitigation
- Slice metrics
- Fairness audits

---

## 10. Monitoring Blind Spots

### What’s Missed
- Data drift
- Latency spikes
- Feedback loops

### Fix
Multi-layer monitoring.

---

## 11. Feedback Loops

### Example
Model decisions affect future training data.

### Risk
Runaway bias or collapse.

---

## 12. Organizational Failure Modes

### Examples
- No model ownership
- Poor documentation
- Lack of rollback plans

ML systems fail socially before they fail technically.


