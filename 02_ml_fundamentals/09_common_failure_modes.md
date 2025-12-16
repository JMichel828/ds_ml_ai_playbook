# Common Machine Learning Failure Modes

## Purpose

This document catalogs **frequently encountered ML failure modes** across the full
modeling lifecycle. It is designed as both:
- A long-term reference
- An interview reasoning guide

This file is intentionally **Markdown-only** — judgment and diagnosis matter more than code here.

---

## 1. Problem Framing Failures

### Symptoms
- Strong offline metrics, weak business impact
- Model optimizes the wrong objective
- Stakeholders dissatisfied despite “good performance”

### Root Causes
- Misaligned target variable
- Proxy metrics poorly correlated with business outcomes
- Ignoring constraints (latency, interpretability, risk)

### Fixes
- Revisit problem statement
- Align metrics with decision-making
- Validate assumptions with stakeholders

---

## 2. Data Failures

### Symptoms
- Model performance unstable
- Large train–test gap
- Sudden production degradation

### Root Causes
- Data leakage
- Label noise
- Distribution shift
- Missing or biased data

### Fixes
- Strict train/test separation
- Time-based splits where appropriate
- Data validation and monitoring

---

## 3. Feature Engineering Failures

### Symptoms
- High training performance, poor generalization
- Model overly sensitive to certain features

### Root Causes
- Leakage via future information
- Over-engineered features
- Redundant or highly correlated features

### Fixes
- Feature audits
- Remove leaky features
- Simpler representations

---

## 4. Modeling Failures

### Symptoms
- Overfitting or underfitting
- High variance across runs

### Root Causes
- Model too complex or too simple
- Poor regularization
- Inadequate hyperparameter tuning

### Fixes
- Adjust complexity
- Add regularization
- Tune hyperparameters properly

---

## 5. Evaluation Failures

### Symptoms
- Inflated metrics
- Surprising real-world behavior

### Root Causes
- Wrong metrics
- Test set contamination
- Ignoring class imbalance

### Fixes
- Choose cost-aware metrics
- Lock test sets
- Use stratified or time-based evaluation

---

## 6. Deployment & Monitoring Failures

### Symptoms
- Model degrades silently
- Predictions become unstable

### Root Causes
- No monitoring
- Data drift
- Concept drift

### Fixes
- Drift detection
- Retraining strategies
- Monitoring dashboards

---

# Interview-Focused Guidance

## How Interviewers Test This

- “What could go wrong with this model?”
- “Why did this model fail in production?”
- “How would you debug this?”

They are testing **experience, judgment, and systems thinking**.

---

## Strong Interview Framing

> “I debug ML systems by checking problem framing first,
> then data, then features, then modeling and evaluation.
> Most failures happen before modeling.”

---

## Company Context Examples

- **Instacart**: feature leakage in demand forecasting
- **Affirm**: stability and fairness failures in risk models
- **Federato**: distribution shift in rare-event prediction

---

## Interview Checklist

- [ ] I can identify failure modes by lifecycle stage
- [ ] I prioritize fixes from highest leverage to lowest
- [ ] I focus on data and framing before models
- [ ] I communicate tradeoffs clearly
