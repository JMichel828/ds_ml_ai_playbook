# Variance Reduction (CUPED and Related Techniques)

## Definition

Variance reduction techniques reduce the **noise** in experiment metrics so that
we can detect smaller effects with the same sample size (or reduce sample size for the same effect).

In practice, variance reduction is one of the highest-leverage skills in experimentation.

---

## Why Variance Reduction Matters

- Detects smaller effects (lower MDE)
- Increases power without more traffic
- Reduces experiment duration
- Improves decision confidence

Rule of thumb:
> If your metric is noisy and you have a good pre-period covariate, CUPED is often worth it.

---

## Core Idea

We can reduce variance by accounting for predictable variation.

If we can predict part of the outcome using pre-treatment behavior, we subtract that predictable portion,
leaving a more stable residual metric.

---

## CUPED (Controlled Experiments Using Pre-Experiment Data)

### Intuition

CUPED adjusts the outcome metric using a pre-experiment covariate that is correlated with the outcome.

Adjusted metric:

Y_cuped = Y - θ(X - E[X])

Where:
- Y = post-period outcome
- X = pre-period covariate
- θ = Cov(Y, X) / Var(X)

---

## Worked Example: CUPED in Python

### Setup

```python
import numpy as np
import pandas as pd

np.random.seed(42)
```

---

### Simulate Pre and Post Data

```python
n = 5000

# Pre-period covariate (e.g., last week's spend)
X = np.random.gamma(shape=2.0, scale=10.0, size=n)

# True treatment effect
true_effect = 0.5

# Treatment assignment
treatment = np.random.binomial(1, 0.5, size=n)

# Post metric correlated with X
noise = np.random.normal(0, 5, size=n)
Y = 2.0 + 0.8 * X + true_effect * treatment + noise

df = pd.DataFrame({"X_pre": X, "Y_post": Y, "treatment": treatment})
df.head()
```

---

### Baseline Difference in Means

```python
baseline_effect = df[df.treatment==1].Y_post.mean() - df[df.treatment==0].Y_post.mean()
baseline_effect
```

---

### Compute CUPED Theta

```python
X_centered = df.X_pre - df.X_pre.mean()
theta = np.cov(df.Y_post, df.X_pre, ddof=1)[0,1] / np.var(df.X_pre, ddof=1)
theta
```

---

### Apply CUPED Adjustment

```python
df["Y_cuped"] = df.Y_post - theta * X_centered

cuped_effect = df[df.treatment==1].Y_cuped.mean() - df[df.treatment==0].Y_cuped.mean()
cuped_effect
```

---

### Compare Variance Reduction

```python
var_original = df.Y_post.var()
var_cuped = df.Y_cuped.var()

var_original, var_cuped, var_cuped / var_original
```

You should see variance drop when X is meaningfully correlated with Y.

---

## Why CUPED Increases Power

Lower variance → smaller standard errors → easier to detect effects.

Even if the mean difference is unchanged, confidence intervals tighten.

---

## Common Requirements for CUPED

A good covariate X must be:
- Measured pre-treatment
- Strongly correlated with Y
- Not affected by treatment
- Available for most users

---

## Other Variance Reduction Techniques

### 1. Stratification / Blocking
Randomize within segments (e.g., region, device, tenure).

### 2. Regression Adjustment
Model outcome as function of covariates and estimate treatment coefficient.

### 3. CUPAC
Use ML predictions as covariates (more flexible CUPED).

---

## Common Pitfalls

- Using a covariate influenced by treatment (bias!)
- Weakly correlated covariate → no benefit
- Mis-centering X
- Missing pre-period data creates selection issues
- Applying CUPED to ratios incorrectly without care

---

# Interview-Focused Guidance

## How Interviewers Test This

- “How would you reduce variance?”
- “What is CUPED and why does it help?”
- “When would CUPED be invalid?”

---

## Strong Interview Framing

> “If I have a stable pre-period covariate correlated with the outcome,
> I can use CUPED to reduce variance and increase power without more traffic,
> as long as the covariate is strictly pre-treatment.”

---

## Company Context Examples

- **Instacart**: adjust checkout metrics using prior spend
- **Affirm**: adjust approval / conversion using pre-period behavior

---

## Interview Checklist

- [ ] I can explain CUPED intuition and formula
- [ ] I can describe when CUPED is valid vs biased
- [ ] I can implement theta and adjustment
- [ ] I understand alternative variance reduction tools
