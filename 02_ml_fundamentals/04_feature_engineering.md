# Feature Engineering (Combined Reference)

## Purpose

This document is a **single-source reference** for feature engineering.
It combines **intuition, practical techniques, code examples, failure modes,
and interview framing** into one markdown file.

Designed for:
- Manager / Senior Manager interviews
- Reviewing and improving real production models
- Long-term ML reference
- RAG ingestion (markdown-first corpus)

---

## Why Feature Engineering Matters

Feature engineering often contributes **more performance gain than model choice**.

A simple model with strong features usually beats a complex model with weak features.

> Models learn patterns. Features define what patterns are even possible.

---

## Feature Engineering Taxonomy

### 1. Transformations
- Scaling
- Log / Box-Cox
- Normalization

### 2. Encodings
- One-hot
- Target / mean encoding
- Frequency encoding

### 3. Aggregations
- Rolling metrics
- Group-level statistics

### 4. Interactions
- Crossed features
- Polynomial terms

### 5. Temporal Features
- Lags
- Trends
- Seasonality

---

## Numerical Feature Transformations

### Scaling

```python
from sklearn.preprocessing import StandardScaler
import numpy as np

X = np.array([[1.0],[10.0],[100.0]])
scaler = StandardScaler()
scaler.fit_transform(X)
```

**When it matters**
- Distance-based models
- Gradient-based optimization

**When it doesn’t**
- Tree-based models

---

### Log Transforms

```python
X = np.array([1, 10, 100, 1000])
np.log1p(X)
```

**Use when**
- Data is heavy-tailed
- Variance grows with magnitude

---

## Categorical Encodings

### One-Hot Encoding

```python
from sklearn.preprocessing import OneHotEncoder

cats = [["red"], ["blue"], ["green"]]
enc = OneHotEncoder(sparse=False)
enc.fit_transform(cats)
```

**Pitfall**
High-cardinality categories explode dimensionality.

---

### Target Encoding

```python
import pandas as pd

df = pd.DataFrame({
    "city": ["A","A","B","B","C"],
    "y": [1,0,1,1,0]
})

means = df.groupby("city")["y"].mean()
df["city_te"] = df["city"].map(means)
df
```

**Risk**
Data leakage if computed on full dataset.

---

## Aggregation Features

```python
df = pd.DataFrame({
    "user": ["u1","u1","u2","u2"],
    "amount": [10,20,5,15]
})

df["user_mean"] = df.groupby("user")["amount"].transform("mean")
df
```

**Common Uses**
- User-level behavior
- Account-level risk
- Historical baselines

---

## Interaction Features

```python
import numpy as np

x1 = np.array([1,2,3])
x2 = np.array([2,3,4])

interaction = x1 * x2
interaction
```

**Note**
Tree-based models learn interactions automatically;
linear models do not.

---

## Temporal Features

### Lag Features

```python
df = pd.DataFrame({
    "date": pd.date_range("2023-01-01", periods=5),
    "value": [10,12,11,14,13]
})

df["lag_1"] = df["value"].shift(1)
df
```

### Rolling Features

```python
df["rolling_mean_3"] = df["value"].rolling(3).mean()
df
```

**Critical Rule**
Never compute rolling features using future data.

---

## Feature Engineering vs Model Choice

| Situation | Best Lever |
|--------|-----------|
| Weak signal | Feature engineering |
| High variance | Regularization |
| Non-linearity | Feature crosses or trees |
| Interpretability needed | Careful feature design |

---

## Feature Selection

```python
from sklearn.feature_selection import SelectKBest, f_regression

selector = SelectKBest(score_func=f_regression, k=2)
selector.fit_transform(X, y)
```

**Goal**
Reduce noise, not maximize CV score.

---

## Common Failure Modes

- Leakage from future data
- Aggregating at wrong level
- Overfitting with target encoding
- Hard-coding categories
- Building brittle features

---

## Manager-Level Decision Framing

Managers should ask:
- Are features stable over time?
- Can features be recomputed reliably?
- Do features encode business logic?
- What breaks if data distribution shifts?

---

## Interview Section

### Common Questions
- “What features matter most in this problem?”
- “How do you avoid leakage?”
- “How do trees reduce need for feature engineering?”

### Strong Answer Pattern

> “I focus first on leakage-safe aggregates and
> domain-informed features before increasing model complexity.”

---

## When Combined Files Make Sense

Feature engineering is ideal for combined format because:
- Code is illustrative
- Explanation is critical
- Interview framing relies on examples

---

## Summary Checklist

- [ ] I understand feature types
- [ ] I know leakage risks
- [ ] I can engineer temporal features safely
- [ ] I can explain feature choices in interviews
- [ ] I consider operational stability
