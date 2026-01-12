# Expectation & Variance

## Core Concept & Intuition

Expectation and variance describe **what you should expect on average** and **how much uncertainty surrounds that expectation**.

For managers and senior managers, these concepts show up constantly when:
- interpreting experiment results
- comparing metrics across cohorts
- evaluating model performance
- deciding whether a change is meaningful or noise

At higher levels, misunderstanding variance leads to **false confidence, overreaction, and bad decisions**.

---

## Expectation (Mean)

Expectation answers:

> If I repeated this process many times, what value would I expect *on average*?

Mathematically:
E[X] = Σ x · P(X = x)

But practically:
> Expectation is a **long-run average**, not a guaranteed outcome.

---

## Worked Example 1: Average Conversion Rate

```python
import numpy as np

np.random.seed(0)

n = 100_000
conversion = np.random.binomial(1, 0.10, n)

np.mean(conversion)
```

Even with a true conversion rate of 10%, short samples fluctuate.

---

## Why Averages Lie

Managers often hear:
> “The average improved.”

But the average hides:
- skew
- heavy tails
- outliers
- unequal exposure

---

## Worked Example 2: Revenue Per User (Skewed Data)

```python
revenue = np.random.lognormal(mean=1.0, sigma=1.5, size=100_000)

np.mean(revenue), np.median(revenue)
```

**Manager takeaway:**
- The mean is pulled by a small number of high spenders
- Median often better reflects typical user experience

---

## Variance (Uncertainty Around the Mean)

Variance measures how spread out outcomes are.

High variance means:
- more uncertainty
- slower learning
- larger samples needed

---

## Worked Example 3: Same Mean, Different Variance

```python
a = np.random.normal(50, 5, 100_000)
b = np.random.normal(50, 20, 100_000)

np.var(a), np.var(b)
```

Same expectation, very different reliability.

---

## Expectation vs Variance in Experiments

Two experiments can have:
- identical lift
- wildly different confidence

---

## Worked Example 4: A/B Test Noise

```python
control = np.random.binomial(1, 0.10, 10_000)
treatment = np.random.binomial(1, 0.105, 10_000)

np.mean(treatment) - np.mean(control)
```

Small lifts can be drowned by variance.

---

## Law of Large Numbers (Preview)

As sample size increases:
- variance of the mean decreases
- estimates stabilize

But **this does not remove variance** — it averages it.

---

## Expectation in ML Context

In ML:
- Loss functions optimize expected error
- Models minimize average outcomes, not worst cases
- High-variance segments can be under-optimized

---

## Practical Decision Implications

For managers:
- Do not trust small deltas without variance context
- Ask for confidence intervals, not just point estimates
- Segment variance matters more than overall averages
- Large variance implies slower iteration speed

---

## System-Level Considerations (Principal-Relevant Depth)

At scale:
- Variance differs across markets and cohorts
- Aggregates mask instability
- Alerting systems often ignore variance
- Teams optimize means while ignoring tail risk

Common failure:
> A metric improves on average but degrades for critical users.

---

## Common Pitfalls

- Treating averages as guarantees
- Ignoring distribution shape
- Comparing means without uncertainty
- Overreacting to short-term fluctuations
- Using point estimates for decisions

