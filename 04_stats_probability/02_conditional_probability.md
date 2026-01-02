# Conditional Probability & Bayes

## Core Concept & Intuition

Conditional probability answers a simple but easily-misunderstood question:

> **Given that we know something happened, how should that change what we believe?**

Formally:

P(A | B) = P(A ∩ B) / P(B)

But for real-world data work, the key intuition is:

> **Conditioning changes the population you are reasoning about.**

Most mistakes in experimentation, metrics, and modeling come from forgetting this.

---

## Why Conditional Probability Matters for Managers

As a manager or senior manager, conditional probability shows up when you:
- interpret experiment results
- evaluate model performance
- compare metrics across segments
- explain results to PMs and leadership
- decide whether a signal is trustworthy

At higher levels, errors here scale into **bad roadmap decisions**.

---

## Worked Example 1: Product Funnel Conditioning

Question:
> What is the probability a user purchases *given that* they reached checkout?

This is **not** the same as overall conversion.

```python
import numpy as np

np.random.seed(42)

n = 100_000

reached_checkout = np.random.binomial(1, 0.3, n)
purchased = reached_checkout * np.random.binomial(1, 0.4, n)

p_purchase_given_checkout = np.mean(purchased[reached_checkout == 1])
p_overall_purchase = np.mean(purchased)

p_purchase_given_checkout, p_overall_purchase
```

**Manager takeaway:**
- Metrics change meaning when you condition
- Funnel metrics must be interpreted at the correct stage
- Comparing conditioned and unconditioned metrics is invalid

---

## Independence vs Conditional Dependence

Two events can be:
- independent overall
- dependent once you condition on a third variable

This is one of the most common sources of misinterpretation.

---

## Worked Example 2: Simpson’s Paradox (High-Impact Interview Topic)

```python
import pandas as pd

df = pd.DataFrame({
    "segment": ["A", "A", "B", "B"],
    "conversion_rate": [0.10, 0.30, 0.20, 0.40],
    "users": [1000, 100, 100, 1000]
})

df
```

Aggregated results can reverse once segmented.

**Manager takeaway:**
- Always ask: *what did we condition on?*
- Never trust a single aggregate metric
- Require segmented analysis for decisions

---

## Bayes’ Rule (Belief Updating)

Bayes’ Rule formalizes belief updating:

P(A | B) = P(B | A) × P(A) / P(B)

Intuitively:
> **Posterior belief = prior belief updated by evidence**

---

## Worked Example 3: Fraud Detection (Classic Real-World Bayes)

Assumptions:
- Fraud rate = 0.5%
- Model detects fraud 95% of the time
- False positive rate = 2%

```python
n = 1_000_000

fraud = np.random.binomial(1, 0.005, n)

flagged = (
    fraud * np.random.binomial(1, 0.95, n)
    + (1 - fraud) * np.random.binomial(1, 0.02, n)
)

np.mean(fraud[flagged == 1])
```

Despite a strong model, **most alerts are false positives**.

**Manager takeaway:**
- Accuracy alone is misleading
- Base rates dominate outcomes
- Operational cost must be considered alongside precision

---

## Worked Example 4: Medical Testing (Base Rate Fallacy)

This mirrors many product and risk problems.

Even highly accurate tests can produce misleading results when prevalence is low.

**Key lesson:**
> If you ignore base rates, you will overreact to noise.

---

## Conditional Probability in ML Systems

Most ML models output:

P(Y = 1 | X)

This is already a conditional probability.

Important implications:
- The prior P(Y) can drift over time
- Model outputs may change even if model quality is stable
- Calibration matters as much as ranking

---

## Practical Decision Implications

For managers and senior managers:
- Demand clarity on *what population* metrics describe
- Require segment-level reporting for decisions
- Push teams to explain conditioning explicitly
- Avoid comparing metrics across differently-conditioned cohorts

---

## System-Level Considerations (Principal-Relevant Depth)

At scale:
- Priors change as products evolve
- Traffic mix shifts break historical assumptions
- Feedback loops alter base rates
- Dashboards often hide conditioning

Common failure:
> Leadership believes a model degraded when the environment changed.

Correct framing:
> The conditional probability is stable; the prior is not.

---

## Common Pitfalls

- Confusing P(A | B) with P(B | A)
- Ignoring base rates
- Treating model scores as unconditional truth
- Mixing populations in comparisons
- Over-indexing on accuracy metrics

---

## Interview Guidance

### How Interviewers Test This
- “Explain Bayes to a PM”
- “Why are most fraud alerts false?”
- “Why did the aggregate metric change?”

### Strong Interview Framing

> “I always reason about the population first,  
> then explicitly state what I’m conditioning on,  
> and sanity-check with simulation when possible.”

---

## Summary Checklist

- [ ] I understand how conditioning changes interpretation
- [ ] I can explain Bayes without formulas
- [ ] I recognize base-rate fallacies
- [ ] I know how this impacts experiments and models
- [ ] I can communicate this clearly to stakeholders
