# Bias–Variance Tradeoff (Combined Reference)

## Core Idea (Executive Summary)

The bias–variance tradeoff describes **why models fail**.

> Error comes from being **too simple**, **too complex**, or **trained on insufficient signal**.

Every modeling decision moves you somewhere along this tradeoff.

---

## Formal Decomposition

For a regression problem:

\[
\mathbb{E}[(y - \hat{f}(x))^2] =
\text{Bias}^2 + \text{Variance} + \text{Irreducible Noise}
\]

- **Bias**: Error from incorrect assumptions
- **Variance**: Error from sensitivity to data
- **Noise**: Inherent randomness

You can reduce bias or variance — rarely both.

---

## Bias

### What Bias Looks Like

- Model consistently wrong in the same direction
- Underfits the data
- Misses important structure

### Common Causes
- Linear model for non-linear data
- Over-regularization
- Missing key features

```python
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

np.random.seed(0)

X = np.linspace(-3, 3, 100).reshape(-1, 1)
y = X.flatten()**2 + np.random.normal(0, 1, 100)

model = LinearRegression().fit(X, y)
preds = model.predict(X)

mean_squared_error(y, preds)
```

---

## Variance

### What Variance Looks Like

- Model performance swings wildly between datasets
- Overfits training data
- Learns noise instead of signal

### Common Causes
- Too many parameters
- Small datasets
- High model flexibility

```python
from sklearn.tree import DecisionTreeRegressor

tree = DecisionTreeRegressor(max_depth=None)
tree.fit(X, y)
preds_tree = tree.predict(X)

mean_squared_error(y, preds_tree)
```

---

## Bias vs Variance Intuition

| Model | Bias | Variance |
|----|----|----|
| Linear Regression | High | Low |
| k-NN (k large) | High | Low |
| k-NN (k small) | Low | High |
| Decision Tree (deep) | Low | High |
| Random Forest | Medium | Lower |
| Gradient Boosting | Lower | Medium |

---

## Visual Intuition (Conceptual)

- Bias → misses the target consistently
- Variance → hits all around the target inconsistently
- Good model → clustered around the target

---

## Diagnosing Bias vs Variance

### Training vs Validation Error

| Pattern | Interpretation |
|------|----|
| High train, high val | High bias |
| Low train, high val | High variance |
| Low train, low val | Good fit |
| High train, low val | Rare / leakage |

---

## Practical Levers

### Reduce Bias
- Add features
- Use more expressive models
- Reduce regularization

### Reduce Variance
- More data
- Stronger regularization
- Ensembling
- Feature selection

```python
from sklearn.ensemble import RandomForestRegressor

rf = RandomForestRegressor(n_estimators=200, random_state=42)
rf.fit(X, y)
mean_squared_error(y, rf.predict(X))
```

---

## Bias–Variance in Cross-Validation

```python
from sklearn.model_selection import cross_val_score

scores = cross_val_score(rf, X, y, scoring="neg_mean_squared_error", cv=5)
np.mean(-scores), np.std(scores)
```

- Mean error → expected performance
- Std dev → variance across splits

---

## When the Tradeoff Breaks

Bias–variance intuition weakens when:
- Data is non-i.i.d.
- Concept drift exists
- Labels are noisy or delayed
- Metrics are misaligned with objectives

---

## Common Failure Modes

- Blindly increasing model complexity
- Treating CV score improvements as guaranteed gains
- Ignoring segment-level variance
- Optimizing bias/variance without business context


