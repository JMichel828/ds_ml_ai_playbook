# Experimentation Interview Scenarios

## Purpose

This file contains **realistic experimentation interview scenarios**
designed to test:
- experimental judgment
- statistical reasoning
- business tradeoffs
- communication clarity

These scenarios mirror how **senior and manager-level interviews** are actually run.

---

## Scenario 1: Feature Improves Conversion but Hurts Revenue

### Situation
You run an A/B test on a new checkout flow.

Results:
- Conversion rate ↑ 3%
- Average order value ↓ 5%
- Revenue per user ↓ 2%

### How to Think

Key questions:
- Is this a metric tradeoff or a bug?
- Is the revenue loss short-term or structural?
- Does this affect all segments equally?

### Analysis Sketch

```python
# Compare revenue per user by segment
df.groupby(["variant", "segment"]).revenue.mean()
```

### Strong Interview Answer

> “I would not ship immediately.
> I’d segment by basket size and user tenure to understand
> whether we’re shifting behavior or cannibalizing value.”

---

## Scenario 2: Experiment Is Not Statistically Significant

### Situation
You run a two-week experiment.
p-value = 0.12

### How to Think

- Was the experiment powered?
- What is the confidence interval?
- What is the minimum detectable effect?

### Analysis Sketch

```python
# Compute confidence interval
mean_diff ± 1.96 * standard_error
```

### Strong Interview Answer

> “A non-significant result is inconclusive.
> I’d check power and confidence intervals before making a decision.”

---

## Scenario 3: Sample Ratio Mismatch Detected

### Situation
Traffic split expected: 50/50
Observed: 55/45

### How to Think

- Randomization failure
- Logging bug
- Eligibility mismatch

### Analysis Sketch

```python
from scipy.stats import chisquare
chisquare([5500, 4500], [5000, 5000])
```

### Strong Interview Answer

> “I’d invalidate the experiment.
> SRM breaks randomization, so effect estimates can’t be trusted.”

---

## Scenario 4: Metric Improves but Users Complain

### Situation
Primary metric improves significantly.
Support tickets increase.

### How to Think

- Metric blind spots
- Missing guardrails
- Long-term vs short-term impact

### Analysis Sketch

```python
# Add guardrail metrics
df.groupby("variant")[["primary_metric", "support_tickets"]].mean()
```

### Strong Interview Answer

> “I’d pause rollout and add guardrails.
> Metrics must reflect user experience, not just optimization targets.”

---

## Scenario 5: Marketplace Experiment Causes Supply Collapse

### Situation
Demand-side experiment increases orders.
Supply-side availability drops.

### How to Think

- Interference
- Network effects
- Capacity constraints

### Analysis Sketch

```python
# Supply-demand imbalance
df.groupby("variant")[["orders", "active_supply"]].mean()
```

### Strong Interview Answer

> “This indicates interference.
> I’d redesign the experiment using cluster or saturation-based randomization.”

---

## Scenario 6: Regional Rollout Without Randomization

### Situation
Feature launched in one region only.

### How to Think

- Difference-in-differences
- Parallel trends validation
- Spillover risk

### Analysis Sketch

```python
# DiD regression
y ~ treated * post + region + time
```

### Strong Interview Answer

> “I’d use DiD cautiously and validate parallel trends
> before making causal claims.”

---

## Common Interview Follow-Ups

- “Would you ship this?”
- “What additional data do you need?”
- “How confident are you?”
- “What are the risks?”

---

## Interview Meta-Advice

Interviewers are evaluating:
- judgment under uncertainty
- metric intuition
- causal thinking
- communication clarity

Correct math with bad judgment still fails interviews.

---

## Final Interview Checklist

- [ ] I clarify the decision goal
- [ ] I check power and assumptions
- [ ] I segment results
- [ ] I identify failure modes
- [ ] I communicate tradeoffs clearly
