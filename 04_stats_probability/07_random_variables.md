# Random Variables

## Core Concept & Intuition

A **random variable** is a function that maps outcomes of a random process to numbers.

For managers and senior managers, random variables matter because:
- metrics *are* random variables
- experiments compare random variables
- models predict random variables
- uncertainty comes from variability in random variables

If you misunderstand random variables, everything downstream (tests, CIs, models) becomes fragile.

---

## Discrete vs Continuous Random Variables

### Discrete Random Variables
- Take on **countable values**
- Examples:
  - conversion (0/1)
  - number of purchases
  - number of errors

### Continuous Random Variables
- Take on values in a **continuous range**
- Examples:
  - revenue
  - latency
  - time spent

Understanding which you are dealing with determines:
- which distributions apply
- which tests are valid
- how uncertainty behaves

---

## Worked Example 1: Discrete Random Variable (Conversion)

```python
import numpy as np

np.random.seed(0)

conversion = np.random.binomial(1, 0.1, 100_000)

np.unique(conversion, return_counts=True)
```

Here:
- X ∈ {0, 1}
- P(X=1) = 0.1
- P(X=0) = 0.9

**Manager takeaway:**
Most product metrics begin life as discrete random variables.

---

## Expectation of a Random Variable

Expectation answers:
> *What value do I expect on average over many realizations?*

```python
np.mean(conversion)
```

This connects directly to:
- conversion rate estimates
- average revenue
- expected loss

---

## Variance of a Random Variable

Variance measures:
> *How much does the random variable fluctuate around its expectation?*

```python
np.var(conversion)
```

Low variance → stable decisions  
High variance → more noise and risk

---

## Worked Example 2: Continuous Random Variable (Revenue)

```python
revenue = np.random.lognormal(mean=1.0, sigma=1.4, size=100_000)

np.mean(revenue), np.median(revenue), np.var(revenue)
```

**Key insight:**
- Mean ≠ typical value
- Variance is extremely large
- Outliers dominate outcomes

---

## Transformations of Random Variables

If X is a random variable, then:
- f(X) is also a random variable

Examples:
- log(revenue)
- revenue per user
- binary flags from continuous signals

```python
log_revenue = np.log(revenue)

np.mean(log_revenue), np.var(log_revenue)
```

Transformations often:
- reduce variance
- stabilize metrics
- enable simpler modeling

---

## Sums and Averages of Random Variables

Many metrics are **aggregates of random variables**.

```python
samples = np.random.normal(50, 10, size=(1000, 100))
means = samples.mean(axis=1)

np.var(samples.flatten()), np.var(means)
```

Averages reduce variance — but do not remove uncertainty.

---

## Random Variables in Experiments

In A/B tests:
- each user outcome is a random variable
- group means are random variables
- lift is a random variable

This explains:
- noisy results
- false positives
- need for large samples

---

## Random Variables in ML

In ML:
- labels are random variables
- predictions are random variables
- errors are random variables

Loss functions minimize **expected error**, not worst-case error.

---

## Practical Decision Implications

For managers:
- Always ask what random variable a metric represents
- Know whether it is discrete or continuous
- Expect noise even when nothing changes
- Segment-level random variables behave differently

---

## System-Level Considerations

At scale:
- Random variables drift as products evolve
- Aggregation hides volatility
- Alerting systems mistake noise for signal
- Feedback loops amplify variance

Understanding RVs prevents overreaction.

---

## Common Pitfalls

- Treating metrics as fixed numbers
- Ignoring variance and distribution
- Applying the wrong test to the wrong RV type
- Over-trusting point estimates
- Forgetting transformations change interpretation

---

## Interview Guidance

### How Interviewers Test This
- “What kind of variable is this metric?”
- “Why is this result noisy?”
- “What assumptions does this test make?”

### Strong Interview Framing

> “I always start by identifying the random variable,
> its distribution, and its variance before reasoning further.”

---

## Summary Checklist

- [ ] I understand what a random variable represents
- [ ] I know the difference between discrete and continuous
- [ ] I connect RVs to experiments and ML
- [ ] I understand aggregation effects
- [ ] I can explain this clearly to stakeholders
