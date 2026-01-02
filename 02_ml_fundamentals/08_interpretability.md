# Model Interpretability & Explainability (Combined Reference)

## Purpose

This document is a **single-source reference** for model interpretability and explainability.
It combines **intuition, practical techniques, code examples, failure modes,
and interview framing** into one markdown file.

Designed for:
- Manager / Senior Manager interviews
- Reviewing and governing production ML systems
- Communicating model behavior to stakeholders
- RAG ingestion (markdown-first corpus)

---

## Why Interpretability Matters

Interpretability answers a different question than accuracy:

> “Why did the model make this decision?”

Interpretability is critical when:
- Models impact users financially or legally
- Decisions must be explained to regulators or executives
- Models fail and require debugging
- Trust is required for adoption

---

## Interpretability vs Explainability

- **Interpretability**: Model is inherently understandable (e.g., linear models)
- **Explainability**: Post-hoc methods to explain complex models

Both are useful — but not interchangeable.

---

## Inherently Interpretable Models

### Linear & Logistic Regression

```python
from sklearn.linear_model import LogisticRegression
import numpy as np

X = np.random.randn(200, 3)
y = (X[:,0] - X[:,1] > 0).astype(int)

model = LogisticRegression()
model.fit(X, y)
model.coef_
```

**Pros**
- Transparent coefficients
- Easy debugging
- Stable explanations

**Cons**
- High bias for complex relationships

---

### Decision Trees (Shallow)

```python
from sklearn.tree import DecisionTreeClassifier

tree = DecisionTreeClassifier(max_depth=3)
tree.fit(X, y)
```

**Note**
Shallow trees can be both interpretable and expressive.

---

## Global vs Local Explanations

- **Global**: How the model behaves overall
- **Local**: Why a specific prediction was made

Strong practitioners know when each is required.

---

## Permutation Importance (Global)

```python
from sklearn.inspection import permutation_importance

result = permutation_importance(model, X, y, n_repeats=10)
result.importances_mean
```

**Strength**
Model-agnostic

**Risk**
Breaks with correlated features

---

## Partial Dependence Plots (PDP)

Shows average marginal effect of a feature.

```python
from sklearn.inspection import PartialDependenceDisplay
```

**Pitfall**
Averages hide heterogeneous effects.

---

## SHAP Values (Local + Global)

```python
import shap

explainer = shap.Explainer(model, X)
shap_values = explainer(X)
```

**Why SHAP Is Popular**
- Local accuracy
- Consistency
- Model-agnostic

**Costs**
- Computationally expensive
- Can be misinterpreted

---

## LIME (Local)

Approximates model locally with simpler surrogate.

```python
# Conceptual — LIME usage pattern
```

**Risk**
Local approximations can be unstable.

---

## Interpretability vs Causality

Important distinction:
- Feature importance ≠ causal effect
- Explanations show *association*, not *intervention*

Interviewers often test this explicitly.

---

## Using Interpretability in Practice

Common use cases:
- Debugging unexpected predictions
- Detecting leakage
- Auditing bias
- Communicating risk drivers
- Supporting model governance

---

## Common Failure Modes

- Treating SHAP as causal
- Explaining unstable models
- Over-trusting local explanations
- Ignoring feature correlations
- Using explanations to justify bad decisions

---

## Manager-Level Decision Framing

Managers should ask:
- Who needs to understand this model?
- How stable are explanations across time?
- What decisions depend on explanations?
- What regulatory requirements exist?

---

## Interview Section

### Common Questions
- “How do you explain complex models?”
- “SHAP vs permutation importance?”
- “Can explanations be misleading?”

### Strong Answer Pattern

> “I choose interpretability methods based on audience and risk,
> and I’m careful not to confuse explanation with causality.”

---

## When Combined Files Make Sense

Interpretability is ideal for combined format because:
- Explanation without examples is useless
- Code without context is dangerous
- Interview questions emphasize judgment

---

## Summary Checklist

- [ ] I know global vs local explanations
- [ ] I understand SHAP and PDP tradeoffs
- [ ] I know explanation ≠ causation
- [ ] I can communicate model behavior clearly
- [ ] I recognize interpretability failure modes
