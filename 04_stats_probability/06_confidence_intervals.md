# Confidence Intervals

## Core Concept & Intuition

A confidence interval (CI) quantifies **uncertainty around an estimate**.
For managers and senior managers, CIs answer the practical question:

> *What range of values is consistent with the data we observed?*

Unlike p-values, confidence intervals communicate **magnitude, direction, and uncertainty**—all of which are critical for decision-making.

---

## What a Confidence Interval Is (and Is Not)

A 95% confidence interval means:
> If we repeated this experiment many times, **95% of such intervals would contain the true value**.

It does **not** mean:
- There is a 95% probability the true value lies in this specific interval
- The result will repeat with 95% certainty

---

## Why Managers Should Prefer Confidence Intervals

Confidence intervals:
- show **effect size**
- show **uncertainty**
- discourage binary thinking (“significant / not”)
- support risk-aware decisions

They are far more informative than a single p-value.

---

## Worked Example 1: Conversion Rate Confidence Interval

**Question:**  
What is the uncertainty around a conversion rate estimate?

```python
import numpy as np

np.random.seed(0)

n = 10_000
conversion = np.random.binomial(1, 0.12, n)

p_hat = np.mean(conversion)
std_err = np.sqrt(p_hat * (1 - p_hat) / n)

ci_low = p_hat - 1.96 * std_err
ci_high = p_hat + 1.96 * std_err

p_hat, (ci_low, ci_high)
```

**Manager takeaway:**
- Larger samples shrink uncertainty
- Small deltas inside the CI are not actionable

---

## Worked Example 2: Difference in Conversion Rates

**Question:**  
What is the uncertainty around the lift between control and treatment?

```python
control = np.random.binomial(1, 0.10, 15_000)
treatment = np.random.binomial(1, 0.105, 15_000)

diff = np.mean(treatment) - np.mean(control)

std_err = np.sqrt(
    np.var(control) / len(control) +
    np.var(treatment) / len(treatment)
)

ci = (diff - 1.96 * std_err, diff + 1.96 * std_err)
diff, ci
```

**Interpretation:**
- If CI includes zero, evidence is weak
- If CI is narrow but small, business impact may still be negligible

---

## Worked Example 3: Non-Normal Metric (Revenue)

Revenue is heavy-tailed, so normal assumptions can fail.

```python
revenue = np.random.lognormal(mean=1.0, sigma=1.5, size=10_000)

mean_rev = np.mean(revenue)
std_err = np.std(revenue) / np.sqrt(len(revenue))

(mean_rev - 1.96 * std_err, mean_rev + 1.96 * std_err)
```

**Caution:**
- CI may be misleading for skewed data
- Bootstrap methods are often safer

---

## Worked Example 4: Bootstrap Confidence Interval

```python
boot_means = []

for _ in range(2000):
    sample = np.random.choice(revenue, size=len(revenue), replace=True)
    boot_means.append(np.mean(sample))

np.percentile(boot_means, [2.5, 97.5])
```

**Manager takeaway:**
- Bootstrap avoids strong distributional assumptions
- Especially useful for revenue and latency metrics

---

## Interpreting Overlapping Confidence Intervals

Overlapping CIs:
- do not necessarily imply no difference
- require direct CI on the difference

Avoid visual misinterpretation.

---

## Practical Decision Implications

For managers:
- Require CIs in experiment readouts
- Focus on width as much as location
- Compare CIs to business thresholds, not zero
- Use bootstrap when assumptions are questionable

---

## System-Level Considerations

At scale:
- Dashboards often omit uncertainty entirely
- Automated alerts trigger on point estimates
- Teams chase noise due to narrow interpretation

Robust systems surface **ranges**, not just numbers.

---

## Common Pitfalls

- Treating CI bounds as guarantees
- Ignoring distribution shape
- Using CIs mechanically without context
- Focusing only on statistical significance
- Forgetting practical impact

---

## Interview Guidance

### How Interviewers Test This
- “How confident are you in this lift?”
- “Would you ship this change?”
- “How would you explain uncertainty to leadership?”

### Strong Interview Framing

> “I look at the confidence interval first,
> compare it to the business threshold,
> and then decide whether the uncertainty is acceptable.”

---

## Summary Checklist

- [ ] I understand what confidence intervals represent
- [ ] I can compute and interpret them
- [ ] I know when normal assumptions fail
- [ ] I use bootstrap when appropriate
- [ ] I communicate uncertainty clearly
