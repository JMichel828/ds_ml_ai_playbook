# Central Limit Theorem (CLT) & Law of Large Numbers (LLN)

## Core Concept & Intuition

The **Law of Large Numbers (LLN)** and the **Central Limit Theorem (CLT)** explain *why statistics works at all*.

For managers and senior managers, these concepts matter because they answer:
- Why do experiments stabilize over time?
- Why does noise shrink with more data?
- Why do confidence intervals make sense?
- Why do things still go wrong at scale?

They are often confused — but they describe **different phenomena**.

---

## Law of Large Numbers (LLN)

### Intuition

The Law of Large Numbers states:

> As sample size increases, the **sample average converges to the true expectation**.

Key idea:
- Individual outcomes remain noisy
- The *average* becomes more stable

LLN is about **convergence**, not distribution shape.

---

## Worked Example 1: LLN with Conversion Rate

```python
import numpy as np

np.random.seed(0)

true_p = 0.12
samples = np.random.binomial(1, true_p, 100_000)

running_means = np.cumsum(samples) / np.arange(1, len(samples) + 1)

running_means[-1]
```

As sample size grows, the estimate stabilizes around the true rate.

**Manager takeaway:**
- Early experiment results are volatile
- Stability comes from volume, not luck

---

## What LLN Does *Not* Say

LLN does **not** guarantee:
- small variance in short samples
- normality
- absence of outliers

Noise still exists — it just averages out.

---

## Central Limit Theorem (CLT)

### Intuition

The CLT states:

> The distribution of the **sample mean** approaches a normal distribution as sample size increases,
> regardless of the original distribution (with mild conditions).

CLT is about **shape**, not convergence.

---

## Worked Example 2: CLT with Non-Normal Data

```python
# Highly skewed distribution
data = np.random.lognormal(mean=1.0, sigma=1.5, size=(5000, 50))

sample_means = data.mean(axis=1)

np.mean(sample_means), np.std(sample_means)
```

Despite skewed data, the distribution of means becomes approximately normal.

---

## Visualizing CLT Numerically

```python
np.percentile(sample_means, [2.5, 50, 97.5])
```

This underpins:
- confidence intervals
- hypothesis tests
- normal approximations

---

## CLT vs LLN (Critical Distinction)

| Concept | LLN | CLT |
|------|----|----|
| What converges? | Sample mean | Distribution of the mean |
| Convergence type | Value | Shape |
| Explains | Stability | Normality |
| Enables | Reliable averages | CIs and tests |

---

## When CLT Fails (Important)

CLT requires:
- finite variance
- weak dependence

It can fail when:
- distributions have infinite variance
- data is highly dependent
- sample sizes are small

---

## Worked Example 3: Heavy-Tailed Risk

```python
# Extremely heavy-tailed distribution
heavy_tail = np.random.pareto(a=1.5, size=(5000, 50))

means = heavy_tail.mean(axis=1)

np.var(means)
```

Variance of the mean can remain large.

**Manager takeaway:**
- More data does not always fix instability
- Tail risk matters

---

## Practical Experiment Implications

For managers:
- Expect early volatility
- Trust stabilization trends, not snapshots
- Use CIs to quantify remaining uncertainty
- Be skeptical of small-sample conclusions

---

## System-Level Considerations

At scale:
- Data dependence violates CLT assumptions
- Feedback loops distort averages
- Segment-level CLT may fail even if global CLT holds
- Automated testing assumes CLT silently

Failure mode:
> Teams trust normal approximations blindly and ship fragile changes.

---

## Common Pitfalls

- Confusing LLN with CLT
- Assuming normality too early
- Ignoring dependence between samples
- Believing more data always fixes noise
- Applying CLT to heavy-tailed metrics

