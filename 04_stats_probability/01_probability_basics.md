# Probability Basics

## Definition

Probability provides a **formal language for uncertainty**.
In data science interviews, it underpins:
- experimentation
- statistical inference
- ML intuition
- risk reasoning

This document focuses on **intuition + computation**, not abstract theory.

---

## Random Experiments and Sample Space

- **Experiment**: a process with uncertain outcomes
- **Sample space (Ω)**: all possible outcomes
- **Event**: a subset of the sample space

Example:
- Experiment: flip a coin
- Ω = {H, T}

---

## Probability Axioms

For any event A:
1. 0 ≤ P(A) ≤ 1
2. P(Ω) = 1
3. If A and B are disjoint:  
   P(A ∪ B) = P(A) + P(B)

Everything else follows from these.

---

## Computing Probability

### Classical Probability
Used when outcomes are equally likely.

P(A) = favorable outcomes / total outcomes

---

### Empirical Probability (Simulation)

```python
import numpy as np

np.random.seed(42)

flips = np.random.choice(["H", "T"], size=10000)
np.mean(flips == "H")
```

Simulation builds intuition and avoids algebra mistakes.

---

## Conditional Probability

P(A | B) = P(A ∩ B) / P(B)

Interpretation:
> Probability of A *given that* B has occurred.

---

### Example

```python
# Probability a randomly chosen number is even, given it's divisible by 4
nums = np.arange(1, 101)

A = nums % 2 == 0
B = nums % 4 == 0

np.mean(A & B) / np.mean(B)
```

---

## Independence

Events A and B are independent if:

P(A ∩ B) = P(A)P(B)

Equivalently:
P(A | B) = P(A)

---

### Common Pitfall

Correlation ≠ dependence ≠ causation

Many interview traps live here.

---

## Law of Total Probability

If B₁, B₂, … partition the space:

P(A) = Σ P(A | Bᵢ)P(Bᵢ)

---

### Example

```python
# Weighted average probability
p_A_given_B1 = 0.1
p_A_given_B2 = 0.4

p_B1 = 0.7
p_B2 = 0.3

p_A = p_A_given_B1 * p_B1 + p_A_given_B2 * p_B2
p_A
```

---

## Bayes’ Rule (Preview)

P(A | B) = P(B | A)P(A) / P(B)

Used when:
- updating beliefs
- reasoning under uncertainty
- fraud / risk / ML predictions

Bayes gets its own dedicated file next.

---

## Common Interview Traps

- Confusing P(A | B) with P(B | A)
- Assuming independence without justification
- Forgetting base rates
- Mixing conditional and marginal probabilities

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Explain probability to a PM”
- “Is this event independent?”
- “What’s the chance given partial information?”

---

## Strong Interview Framing

> “I reason explicitly about sample space, conditioning, and independence
> before doing any math.”

---

## Interview Checklist

- [ ] I can define probability clearly
- [ ] I understand conditional probability
- [ ] I know independence vs dependence
- [ ] I can simulate probabilities
- [ ] I avoid base rate fallacies
