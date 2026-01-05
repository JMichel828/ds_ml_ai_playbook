# Metrics Design

## Definition

Metrics design is the process of defining **what to measure**, **how to measure it**, and
**how that measurement maps to a real business decision**. In experimentation, metrics
are the lens through which impact is evaluated.

Poor metrics lead to confident but wrong decisions.

---

## Why Metrics Design Matters

- Metrics determine experiment outcomes
- Misaligned metrics cause local optimization
- Good metrics make tradeoffs explicit
- Guardrails prevent silent regressions

Rule of thumb:
> If you cannot explain *why* a metric matters, you should not optimize it.

---

## Types of Metrics

### Primary Metric
- Directly tied to the decision
- Single source of truth
- Optimized explicitly

Examples:
- Conversion rate
- Revenue per user
- Loss rate

---

### Guardrail Metrics
- Ensure safety and stability
- Must not regress meaningfully

Examples:
- Latency
- Error rate
- Cancellation rate

---

### Secondary / Diagnostic Metrics
- Explain *why* the primary moved
- Aid interpretation

Examples:
- Funnel step conversion
- Engagement depth

---

## Good Metric Properties

A strong metric should be:

- **Directional** (up is good, down is bad)
- **Sensitive** to change
- **Stable** under noise
- **Hard to game**
- **Aligned** with long-term value

---

## Common Metric Traps

- Proxy metrics with weak correlation to value
- Composite metrics that hide tradeoffs
- Metrics that saturate too early
- Metrics that lag too far behind decisions

---

## Worked Example: Funnel Metrics

### Scenario
You are testing a checkout change.

```python
import pandas as pd

data = {
    "user_id": range(1, 11),
    "viewed_checkout": [1,1,1,1,1,1,1,1,0,0],
    "started_payment": [1,1,1,1,0,0,1,1,0,0],
    "completed_purchase": [1,1,1,0,0,0,1,0,0,0]
}

df = pd.DataFrame(data)
df
```

---

### Funnel Conversion Rates

```python
conversion = {
    "checkout_view_rate": df["viewed_checkout"].mean(),
    "payment_start_rate": df["started_payment"].mean(),
    "purchase_rate": df["completed_purchase"].mean()
}

conversion
```

---

## Metric Decomposition

Decompose metrics to:
- Diagnose failures
- Attribute effects
- Guide iteration

Example:
> Purchase rate = view rate × payment start rate × completion rate

---

## Metric Sensitivity and Variance

Metrics with high variance require larger samples to detect changes.

```python
import numpy as np

np.random.seed(0)

metric_high_var = np.random.normal(100, 50, 1000)
metric_low_var = np.random.normal(100, 5, 1000)

metric_high_var.std(), metric_low_var.std()
```

---

## Ratio Metric Instability

Ratio metrics can be noisy and misleading.

```python
numerator = np.random.poisson(5, 1000)
denominator = np.random.poisson(1, 1000)

ratio = numerator / np.maximum(denominator, 1)
ratio.mean(), ratio.std()
```

---

## Metric Alignment Across Teams

Ensure:
- Product metrics align with ML metrics
- Short-term lifts don’t harm long-term value
- Teams share definitions

---

## Common Pitfalls

- Optimizing multiple primary metrics
- Changing metrics mid-experiment
- Ignoring variance and sensitivity
- Overfitting decisions to noisy metrics

---

# Interview-Focused Guidance

## How Interviewers Test This

- “What metric would you choose?”
- “Why not metric X?”
- “How would you know if this is a false positive?”

---

## Strong Interview Framing

> “I define the decision first, then work backwards to a metric
> that best captures long-term value while protecting guardrails.”

---

## Company Context Examples

- **Instacart**: order completion vs basket size
- **Affirm**: approval rate vs loss rate

---

## Interview Checklist

- [ ] I can articulate why a metric matters
- [ ] I can define guardrails
- [ ] I can decompose metrics
- [ ] I understand variance and sensitivity
