# A/B Testing

## Definition

A/B testing is a controlled experimentation framework used to **estimate the causal
impact of a change** by randomly assigning units (users, sessions, accounts, regions)
to a control or treatment group.

It is the backbone of trustworthy product, growth, and ML-driven decision-making.

---

## Why A/B Testing Matters

- Separates correlation from causation
- Reduces risk in decision-making
- Enables iterative improvement
- Creates organizational learning loops

Rule of thumb:
> If you cannot randomize, you cannot make strong causal claims.

---

## Core Components of an A/B Test

### Unit of Randomization
- Users
- Sessions
- Accounts
- Geographies

Choose the unit that minimizes interference and aligns with the decision.

---

### Control vs Treatment
- Control: current experience
- Treatment: proposed change

All else must remain equal.

---

### Metrics
- **Primary metric**: decision driver
- **Guardrails**: safety and regression checks
- **Secondary metrics**: diagnostics and interpretation

Metric choice determines experiment validity.

---

## Key Assumptions

- Valid randomization
- Stable Unit Treatment Value Assumption (SUTVA)
- No cross-unit interference
- Consistent measurement

Violations invalidate results.

---

## Worked Example: Continuous Metric Experiment

### Setup

```python
import numpy as np
import pandas as pd
from scipy import stats

np.random.seed(42)
```

---

### Simulated Data

```python
n_control = 500
n_treatment = 500

control = np.random.normal(0.0, 1.0, n_control)
treatment = np.random.normal(0.2, 1.0, n_treatment)

df = pd.DataFrame({
    "group": ["control"] * n_control + ["treatment"] * n_treatment,
    "metric": np.concatenate([control, treatment])
})

df.head()
```

---

### Difference in Means

```python
df.groupby("group")["metric"].mean()
```

---

### Welch’s t-Test

```python
stats.ttest_ind(treatment, control, equal_var=False)
```

---

## Worked Example: Binary Metric (Conversion Rate)

Binary outcomes are extremely common in product experiments.

```python
from statsmodels.stats.proportion import proportions_ztest

successes = np.array([120, 150])
trials = np.array([1000, 1000])

proportions_ztest(successes, trials)
```

Interpretation:
- Tests difference in conversion rates
- More appropriate than t-test for binary metrics

---

## Sample Ratio Mismatch (SRM) Check

SRM invalidates experiments and must be checked.

```python
from scipy.stats import chisquare

observed = np.array([950, 1050])
expected = np.array([1000, 1000])

chisquare(observed, expected)
```

Low p-value ⇒ randomization failure.

---

## Effect Size vs Statistical Significance

Always compute magnitude.

```python
treatment.mean() - control.mean()
```

Statistical significance does not imply business significance.

---

## Common Pitfalls

- P-hacking and repeated peeking
- Ignoring SRM
- Choosing metrics post-hoc
- Overinterpreting noisy results
- Shipping based solely on p-values

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Design an A/B test for feature X”
- “What assumptions does this rely on?”
- “What could invalidate the results?”
- “What would you do if results are inconclusive?”

---

## Strong Interview Framing

> “I start by defining the decision, then the metric and unit of randomization,
> validate assumptions like SRM, and only then interpret statistical results
> in terms of business impact.”

---

## Company Context Examples

- **Instacart**: checkout and search experiments
- **Affirm**: approval flow experiments balancing conversion and risk
- **Federato**: underwriting rule experiments with small samples

---

## Interview Checklist

- [ ] I can design an experiment end-to-end
- [ ] I understand assumptions and failure modes
- [ ] I know when to trust or distrust results
- [ ] I can connect statistics to decisions
