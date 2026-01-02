# Regularization (Combined Reference)

## Purpose

This document is a **single-source reference** for regularization in machine learning.
It combines **intuition, mathematical grounding, practical techniques, code examples,
failure modes, and interview framing** into one markdown file.

Designed for:
- Manager / Senior Manager interviews
- Reviewing and stabilizing production models
- Long-term ML reference
- RAG ingestion (markdown-first corpus)

---

## Why Regularization Matters

Regularization exists to control **model complexity** and **generalization**.

> Regularization trades a small amount of bias for a large reduction in variance.

In practice, it is one of the **most powerful levers** for improving out-of-sample performance.

---

## Core Idea (Intuition)

Regularization:
- Penalizes overly complex models
- Shrinks parameters toward simpler solutions
- Reduces sensitivity to noise

This is especially important when:
- Data is limited
- Features are correlated
- Models are flexible

---

## Mathematical View (High Level)

For linear models:

\[
\min_\beta \; \mathcal{L}(y, X\beta) + \lambda \cdot \Omega(\beta)
\]

- \(\mathcal{L}\): loss function
- \(\lambda\): regularization strength
- \(\Omega(\beta)\): penalty term

---

## L2 Regularization (Ridge)

### What It Does
- Penalizes squared magnitude of coefficients
- Shrinks coefficients smoothly toward zero
- Rarely sets coefficients exactly to zero

```python
from sklearn.linear_model import Ridge
import numpy as np

X = np.random.randn(200, 10)
y = X[:,0] * 3 + np.random.randn(200)

ridge = Ridge(alpha=1.0)
ridge.fit(X, y)
ridge.coef_
```

### When to Use
- Many correlated features
- You want stability over sparsity

---

## L1 Regularization (Lasso)

### What It Does
- Penalizes absolute magnitude of coefficients
- Drives some coefficients exactly to zero
- Performs implicit feature selection

```python
from sklearn.linear_model import Lasso

lasso = Lasso(alpha=0.1)
lasso.fit(X, y)
lasso.coef_
```

### Risks
- Unstable feature selection
- Sensitive to correlated features

---

## Elastic Net

Combines L1 and L2 penalties.

```python
from sklearn.linear_model import ElasticNet

enet = ElasticNet(alpha=0.1, l1_ratio=0.5)
enet.fit(X, y)
enet.coef_
```

**Why It’s Popular**
- Balances sparsity and stability
- Common default in production

---

## Regularization Beyond Linear Models

### Trees
- Max depth
- Min samples per leaf
- Min samples split

```python
from sklearn.tree import DecisionTreeRegressor

tree = DecisionTreeRegressor(max_depth=5, min_samples_leaf=10)
tree.fit(X, y)
```

### Boosting
- Learning rate
- Number of estimators
- Subsampling

```python
from sklearn.ensemble import GradientBoostingRegressor

gb = GradientBoostingRegressor(
    learning_rate=0.05,
    n_estimators=300,
    max_depth=3
)
gb.fit(X, y)
```

---

## Regularization vs Feature Engineering

| Scenario | Better Lever |
|------|--------------|
| High variance | Regularization |
| Missing signal | Feature engineering |
| Multicollinearity | Regularization |
| Interpretability | Feature selection |

---

## Choosing Regularization Strength

### Cross-Validation

```python
from sklearn.linear_model import RidgeCV

alphas = [0.01, 0.1, 1.0, 10.0]
ridge_cv = RidgeCV(alphas=alphas, cv=5)
ridge_cv.fit(X, y)
ridge_cv.alpha_
```

### Manager Insight
- Small changes in lambda can have big effects
- Always inspect stability across folds

---

## Common Failure Modes

- Over-regularizing and killing signal
- Under-regularizing complex models
- Treating regularization as a tuning afterthought
- Forgetting to scale features before L1/L2
- Assuming trees don’t need regularization

---

## Manager-Level Decision Framing

Managers should ask:
- Is the model stable across retrains?
- Are coefficients interpretable and reasonable?
- Does regularization reduce operational risk?
- How sensitive is performance to lambda?

---

## Interview Section

### Common Questions
- “Why does regularization help generalization?”
- “L1 vs L2 — when would you choose each?”
- “How does regularization relate to bias–variance?”

### Strong Answer Pattern

> “Regularization intentionally introduces bias to reduce variance,
> improving out-of-sample performance and model stability.”

---

## When Combined Files Make Sense

Regularization works extremely well as a combined file because:
- Theory and practice are tightly coupled
- Code is illustrative, not exploratory
- Interview questions emphasize intuition

---

## Summary Checklist

- [ ] I understand L1 vs L2
- [ ] I know when to use Elastic Net
- [ ] I can tune regularization safely
- [ ] I understand tree and boosting regularization
- [ ] I can explain regularization in interviews
