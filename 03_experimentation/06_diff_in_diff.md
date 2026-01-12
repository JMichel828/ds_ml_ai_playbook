# Difference-in-Differences (DiD)

## Definition

Difference-in-Differences (DiD) is a **quasi-experimental causal inference method**
used to estimate treatment effects when randomization is not possible.

It compares **changes over time** between a treated group and a control group.

Core idea:
> If the control group represents the counterfactual trend,
> the difference in trends isolates the treatment effect.

---

## When DiD Is Used

- Policy changes
- Feature rollouts without randomization
- Geo-based launches
- Regulatory or pricing shifts
- Historical interventions

---

## Core Assumption: Parallel Trends

The key assumption:
> In the absence of treatment, treated and control groups would have followed **parallel trends**.

If this assumption fails, DiD is biased.

---

## DiD Estimator

Two-period DiD:

Effect =
(Post_Treat − Pre_Treat) − (Post_Control − Pre_Control)

---

## Panel Data Simulation (Python)

### Setup

```python
import numpy as np
import pandas as pd
import statsmodels.formula.api as smf

np.random.seed(42)
```

---

### Generate Panel Data

```python
n_units = 200
n_periods = 10

units = np.arange(n_units)
time = np.arange(n_periods)

df = pd.MultiIndex.from_product(
    [units, time], names=["unit", "time"]
).to_frame(index=False)

# Treatment assignment
df["treated"] = (df.unit < n_units / 2).astype(int)
df["post"] = (df.time >= 5).astype(int)

# Baseline trends
df["trend"] = 0.3 * df.time

# Treatment effect
true_effect = 2.0

# Outcome
df["y"] = (
    5
    + df.trend
    + true_effect * df.treated * df.post
    + np.random.normal(0, 1, len(df))
)

df.head()
```

---

## Visual Check: Parallel Trends (Pre-Treatment)

```python
pre = df[df.post == 0]
pre.groupby(["treated", "time"]).y.mean().unstack(0)
```

---

## DiD via Regression

```python
model = smf.ols(
    "y ~ treated + post + treated:post",
    data=df
).fit()

model.summary().tables[1]
```

---

## Fixed Effects Version

```python
fe_model = smf.ols(
    "y ~ treated:post + C(unit) + C(time)",
    data=df
).fit()

fe_model.params["treated:post"]
```

---

## Failure Modes

- Non-parallel trends
- Spillovers
- Time-varying confounders
- Anticipation effects

