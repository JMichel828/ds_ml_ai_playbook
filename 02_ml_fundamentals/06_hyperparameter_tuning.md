# Hyperparameter Tuning (Combined Reference)

## Purpose

This document is a **single-source reference** for hyperparameter tuning.
It combines **intuition, practical strategies, code examples, failure modes,
and interview framing** into one markdown file.

Designed for:
- Manager / Senior Manager interviews
- Designing reliable model training workflows
- Long-term ML reference
- RAG ingestion (markdown-first corpus)

---

## Why Hyperparameter Tuning Matters

Hyperparameters control **how models learn**, not **what they learn**.

Poor tuning can:
- Mask true model performance
- Cause overfitting or underfitting
- Waste massive compute budgets

> Tuning is an optimization problem under uncertainty and cost constraints.

---

## Parameters vs Hyperparameters

- **Parameters**: learned from data (weights, splits)
- **Hyperparameters**: set before training (depth, lambda, learning rate)

Examples:
- Regularization strength
- Tree depth
- Learning rate
- Number of estimators

---

## Bias–Variance Lens

| Hyperparameter Effect |
|----------------------|
| Increase regularization → ↑ bias, ↓ variance |
| Increase model complexity → ↓ bias, ↑ variance |
| Increase data per leaf → ↑ bias, ↓ variance |
| Increase estimators → ↓ variance (up to a point) |

Understanding this is more important than any algorithm.

---

## Grid Search

### What It Is
Exhaustive search over predefined parameter grid.

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier

param_grid = {
    "max_depth": [3, 5, None],
    "min_samples_leaf": [1, 5, 10]
}

gs = GridSearchCV(
    RandomForestClassifier(n_estimators=200, random_state=42),
    param_grid,
    cv=5,
    scoring="roc_auc"
)

gs.fit(X, y)
gs.best_params_
```

### Pros / Cons
- ✅ Simple, deterministic
- ❌ Expensive, scales poorly

---

## Random Search

Samples randomly from parameter distributions.

```python
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint

param_dist = {
    "max_depth": randint(3, 20),
    "min_samples_leaf": randint(1, 20)
}

rs = RandomizedSearchCV(
    RandomForestClassifier(n_estimators=200, random_state=42),
    param_dist,
    n_iter=30,
    cv=5,
    scoring="roc_auc",
    random_state=42
)

rs.fit(X, y)
rs.best_params_
```

### Why It Works
- Explores more unique configurations
- Finds good regions faster

---

## Bayesian Optimization (Conceptual)

Uses prior results to guide future searches.

Common tools:
- Optuna
- Hyperopt
- Ax / BoTorch

```python
# Conceptual example (Optuna-style)
def objective(trial):
    depth = trial.suggest_int("max_depth", 3, 20)
    lr = trial.suggest_float("learning_rate", 0.01, 0.3)

    model = GradientBoostingClassifier(
        max_depth=depth,
        learning_rate=lr
    )
    return cross_val_score(model, X, y, cv=3).mean()
```

### Manager Insight
Bayesian tuning trades **compute for intelligence**.

---

## Cross-Validation Strategy

### k-Fold CV
- Good default
- Assumes i.i.d. data

### Time-Based CV
- Required for temporal data
- Prevents leakage

```python
from sklearn.model_selection import TimeSeriesSplit

tscv = TimeSeriesSplit(n_splits=5)
```

---

## Early Stopping

Prevents overfitting and saves compute.

```python
from sklearn.ensemble import GradientBoostingClassifier

gb = GradientBoostingClassifier(
    n_estimators=500,
    learning_rate=0.05,
    n_iter_no_change=10
)
```

---

## Nested Cross-Validation

Used when tuning and evaluating simultaneously.

```python
# Conceptual pattern
# Outer loop: evaluation
# Inner loop: hyperparameter tuning
```

**Interview Insight**
Avoids optimistic bias in reported metrics.

---

## Common Failure Modes

- Tuning on test set
- Overfitting validation data
- Ignoring metric variance
- Using default CV for time series
- Optimizing proxy metrics

---

## Manager-Level Decision Framing

Managers should ask:
- What metric are we optimizing?
- How stable are results across folds?
- What is the compute cost vs expected gain?
- Are gains statistically meaningful?

---

## Interview Section

### Common Questions
- “Grid vs random search — why?”
- “How do you avoid overfitting during tuning?”
- “What is nested cross-validation?”

### Strong Answer Pattern

> “I treat tuning as a bias–variance and cost optimization problem,
> using cross-validation and early stopping to avoid overfitting.”

---

## When Combined Files Make Sense

Hyperparameter tuning benefits from combined format because:
- Concepts + code reinforce each other
- Interview framing relies on intuition
- RAG systems need full context

---

## Summary Checklist

- [ ] I understand tuning strategies
- [ ] I can choose CV correctly
- [ ] I avoid tuning leakage
- [ ] I can explain tuning decisions clearly
- [ ] I account for compute constraints
