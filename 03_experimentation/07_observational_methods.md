# Observational Methods (When You Cannot Randomize)

## Definition

Observational methods are **causal inference techniques** used when randomized experiments
(A/B tests) are infeasible, unethical, or unavailable.

They attempt to approximate the counterfactual:
> “What would have happened to this unit if it had not been treated?”

---

## When Observational Methods Are Needed

- Product launches without randomization
- Policy or pricing changes
- Risk / underwriting decisions
- User self-selection into treatment
- Retrospective analysis of past changes

---

## Core Challenge: Confounding

Treatment assignment is **not random**.

This creates bias because:
- Treated and control groups differ systematically
- Differences may drive outcomes independently of treatment

---

## Key Observational Techniques

1. Regression Adjustment
2. Matching (Exact / Propensity Score)
3. Weighting (IPW)
4. Instrumental Variables
5. Synthetic Control (advanced)

This file focuses on **commonly interviewed methods**.

---

## 1. Regression Adjustment

### Idea

Model outcome as a function of:
- Treatment
- Observed covariates

```python
import pandas as pd
import numpy as np
import statsmodels.formula.api as smf

np.random.seed(42)
```

---

### Simulated Data

```python
n = 3000

age = np.random.normal(35, 10, n)
income = np.random.normal(70000, 15000, n)

# Treatment depends on covariates (confounding)
treatment = (age + income/10000 + np.random.normal(0, 2, n) > 10).astype(int)

true_effect = 5

y = (
    50
    + 0.3 * age
    + 0.0002 * income
    + true_effect * treatment
    + np.random.normal(0, 5, n)
)

df = pd.DataFrame({
    "y": y,
    "treatment": treatment,
    "age": age,
    "income": income
})
```

---

### Regression Estimate

```python
model = smf.ols("y ~ treatment + age + income", data=df).fit()
model.params["treatment"]
```

Regression adjustment works **only if all confounders are observed**.

---

## 2. Matching (Propensity Score Matching)

### Step 1: Estimate Propensity Scores

```python
from sklearn.linear_model import LogisticRegression

X = df[["age", "income"]]
ps_model = LogisticRegression().fit(X, df.treatment)

df["propensity"] = ps_model.predict_proba(X)[:,1]
```

---

### Step 2: Nearest Neighbor Matching

```python
treated = df[df.treatment == 1]
control = df[df.treatment == 0]

control_matched = control.iloc[
    np.abs(control.propensity.values[:,None] - treated.propensity.values).argmin(axis=0)
]

matched_effect = treated.y.mean() - control_matched.y.mean()
matched_effect
```

Matching improves balance but:
- Discards data
- Does not fix unobserved confounding

---

## 3. Inverse Probability Weighting (IPW)

### Idea

Weight observations by inverse probability of receiving their treatment.

```python
df["weight"] = (
    df.treatment / df.propensity
    + (1 - df.treatment) / (1 - df.propensity)
)

weighted_effect = (
    df[df.treatment==1].y.mul(df[df.treatment==1].weight).sum()
    / df[df.treatment==1].weight.sum()
    -
    df[df.treatment==0].y.mul(df[df.treatment==0].weight).sum()
    / df[df.treatment==0].weight.sum()
)

weighted_effect
```

IPW is sensitive to:
- Extreme propensities
- Model misspecification

---

## 4. Instrumental Variables (IV)

### Idea

Use a variable Z that:
- Affects treatment
- Does NOT affect outcome except through treatment

Common in economics, rare in product analytics.

```python
# Conceptual example only
```

Examples:
- Policy eligibility thresholds
- Random assignment encouragements

---

## Comparison of Methods

| Method | Handles Observed Confounding | Handles Unobserved |
|-----|-----------------------------|--------------------|
| Regression | Yes | No |
| Matching | Yes | No |
| IPW | Yes | No |
| IV | Partial | Yes (if valid) |

---

## Common Failure Modes

- Unobserved confounders
- Poor overlap (positivity violations)
- Overfitting propensity models
- Post-treatment covariates
- Interpreting correlation as causation

---

# Interview-Focused Guidance

## How Interviewers Test This

- “What if you can’t run an A/B test?”
- “How would you adjust for confounding?”
- “What assumptions are required?”

---

## Strong Interview Framing

> “Observational methods rely on strong assumptions.
> I prefer randomized experiments, but when unavailable,
> I use matching or regression while explicitly stating limitations.”

---

## Company Context Examples

- **Instacart**: pricing experiments without randomization
- **Affirm**: policy changes with selection bias

---

## Interview Checklist

- [ ] I understand confounding
- [ ] I can explain regression vs matching vs IPW
- [ ] I know when results are biased
- [ ] I can clearly state assumptions
