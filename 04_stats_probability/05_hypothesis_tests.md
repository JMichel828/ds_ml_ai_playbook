# Hypothesis Testing

## Core Concept & Intuition

Hypothesis testing is a framework for **making decisions under uncertainty**.
For managers and senior managers, it answers a practical question:

> *Is this observed difference likely real, or could it be noise?*

Hypothesis tests do **not** prove truth.
They quantify how surprising data would be **if nothing had changed**.

---

## The Mental Model (Manager-Friendly)

Every hypothesis test has:
- a **null hypothesis (H₀)**: “nothing interesting happened”
- an **alternative hypothesis (H₁)**: “something changed”
- a **test statistic**: how far reality deviates from H₀
- a **p-value**: how surprising that deviation is under H₀

Key idea:
> A small p-value means the data is unlikely *if H₀ were true*.

---

## Step-by-Step Testing Framework

1. Define the metric and population
2. State H₀ and H₁ clearly
3. Choose an appropriate test
4. Compute test statistic
5. Interpret results *in context*

---

## Worked Example 1: A/B Test on Conversion (Binary Outcome)

**Question:**  
Did a new checkout flow increase conversion?

H₀: conversion_treatment = conversion_control  
H₁: conversion_treatment > conversion_control  

```python
import numpy as np
from scipy import stats

np.random.seed(0)

n = 20_000
control = np.random.binomial(1, 0.10, n)
treatment = np.random.binomial(1, 0.11, n)

stat, p_value = stats.ttest_ind(treatment, control, equal_var=False)
p_value
```

**Manager takeaway:**
- Statistical significance ≠ business significance
- Always compare effect size and confidence

---

## Worked Example 2: Non-Normal Metric (Revenue)

Revenue is heavy-tailed → t-test assumptions often break.

```python
control_rev = np.random.lognormal(mean=1.0, sigma=1.5, size=10_000)
treatment_rev = np.random.lognormal(mean=1.05, sigma=1.5, size=10_000)

stat, p_value = stats.mannwhitneyu(treatment_rev, control_rev)
p_value
```

**Insight:**
- Use non-parametric tests when distributions are skewed
- Choice of test reflects understanding, not rigor theater

---

## Worked Example 3: Paired Test (Before / After)

Paired tests reduce variance when observations are linked.

```python
before = np.random.normal(50, 10, 5_000)
after = before + np.random.normal(1.0, 5, 5_000)

stat, p_value = stats.ttest_rel(after, before)
p_value
```

**Manager takeaway:**
- Paired designs are more powerful
- Missed pairing wastes data

---

## Type I and Type II Errors

- **Type I (false positive):** shipping a bad change
- **Type II (false negative):** missing a good change

Managers choose which risk matters more.

---

## p-Values in Practice (Critical Section)

A p-value is **not**:
- probability H₀ is true
- probability the result will repeat

Correct interpretation:
> *If there were truly no effect, this result would be rare.*

---

## Confidence Intervals vs p-Values

```python
mean_diff = np.mean(treatment) - np.mean(control)
std_err = np.sqrt(
    np.var(control)/len(control) + np.var(treatment)/len(treatment)
)

ci_low = mean_diff - 1.96 * std_err
ci_high = mean_diff + 1.96 * std_err

mean_diff, (ci_low, ci_high)
```

Managers should prefer:
- intervals over binary “significant / not”

---

## Practical Decision Implications

For managers:
- Demand effect sizes and intervals
- Match test to data shape
- Avoid “p-hacking”
- Require pre-specified metrics

---

## System-Level Considerations

At scale:
- Multiple testing inflates false positives
- Experiment velocity pressures teams to over-test
- Dashboards hide uncertainty
- Automated testing pipelines need guardrails

---

## Common Pitfalls

- Blindly using t-tests
- Ignoring distribution shape
- Over-interpreting marginal p-values
- Testing after peeking
- Treating non-significance as “no effect”

---

## Interview Guidance

### How Interviewers Test This
- “How would you test this change?”
- “What test would you use and why?”
- “What assumptions are you making?”

### Strong Interview Framing

> “I start by understanding the metric and its distribution,  
> then choose the simplest test whose assumptions are reasonable.”

---

## Summary Checklist

- [ ] I can explain hypothesis testing intuitively
- [ ] I know when t-tests fail
- [ ] I understand paired vs unpaired tests
- [ ] I focus on effect size, not just p-values
- [ ] I connect test choice to business decisions
