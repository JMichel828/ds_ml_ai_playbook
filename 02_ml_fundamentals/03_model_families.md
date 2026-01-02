# Model Families (Combined Reference)

## Purpose

This document is a **single-source reference** for core machine learning model families.
It combines **intuition, mathematical grounding, practical tradeoffs, code examples,
and interview framing** into one markdown file.

Designed for:
- Manager / Senior Manager interviews
- Reviewing model choices in real systems
- Long-term ML reference
- RAG ingestion (markdown-first corpus)

---

## How to Think About Model Families

Model families differ along four primary axes:

1. **Assumptions** – what structure they impose on data
2. **Expressiveness** – what patterns they can represent
3. **Bias–Variance Profile** – underfitting vs overfitting tendencies
4. **Operational Cost** – training, inference, and maintenance complexity

Strong candidates frame model choice as **tradeoffs**, not “best models”.

---

## Linear Models

### Linear Regression

**Assumptions**
- Linear relationship between features and target
- Independent errors with constant variance

```python
from sklearn.linear_model import LinearRegression
import numpy as np

X = np.random.randn(200, 3)
y = 2*X[:,0] - X[:,1] + np.random.randn(200)

model = LinearRegression().fit(X, y)
model.coef_, model.intercept_
```

**Strengths**
- High interpretability
- Low variance
- Fast training & inference

**Weaknesses**
- High bias on non-linear problems
- Sensitive to outliers

---

### Logistic Regression

Used for **classification with calibrated probabilities**.

```python
from sklearn.linear_model import LogisticRegression

clf = LogisticRegression()
clf.fit(X, (y > y.mean()).astype(int))
```

**Manager insight**
Logistic regression is often the *baseline to beat* in production systems.

---

## Tree-Based Models

### Decision Trees

```python
from sklearn.tree import DecisionTreeClassifier

tree = DecisionTreeClassifier(max_depth=4)
tree.fit(X, (y > y.mean()).astype(int))
```

**Pros**
- Handles non-linear interactions
- Minimal feature preprocessing

**Cons**
- High variance
- Unstable splits

---

### Random Forests

Ensemble of decorrelated trees.

```python
from sklearn.ensemble import RandomForestClassifier

rf = RandomForestClassifier(n_estimators=200, random_state=42)
rf.fit(X, (y > y.mean()).astype(int))
```

**Bias–Variance Profile**
- Lower variance than trees
- Moderate bias

**Operational Note**
Harder to debug individual predictions.

---

### Gradient Boosting (GBM / XGBoost / LightGBM)

Sequentially corrects errors of weak learners.

```python
from sklearn.ensemble import GradientBoostingClassifier

gb = GradientBoostingClassifier()
gb.fit(X, (y > y.mean()).astype(int))
```

**Strengths**
- High accuracy on tabular data
- Captures complex interactions

**Risks**
- Overfitting if poorly tuned
- Slower training

---

## k-Nearest Neighbors (kNN)

```python
from sklearn.neighbors import KNeighborsClassifier

knn = KNeighborsClassifier(n_neighbors=5)
knn.fit(X, (y > y.mean()).astype(int))
```

**Intuition**
Prediction = average of nearby points.

**Tradeoffs**
- Low bias, high variance (small k)
- High bias, low variance (large k)

Rarely used in production but common in interviews.

---

## Support Vector Machines (SVM)

Maximizes margin between classes.

```python
from sklearn.svm import SVC

svm = SVC(kernel="rbf", probability=True)
svm.fit(X, (y > y.mean()).astype(int))
```

**Notes**
- Strong theoretical guarantees
- Poor scaling on large datasets

---

## Neural Networks (High-Level)

```python
from sklearn.neural_network import MLPClassifier

mlp = MLPClassifier(hidden_layer_sizes=(64, 32))
mlp.fit(X, (y > y.mean()).astype(int))
```

**When They Shine**
- Unstructured data (text, images)
- Very large datasets

**When They Don’t**
- Small tabular datasets
- Interpretability-heavy use cases

---

## Model Families vs Data Type

| Data Type | Recommended Families |
|--------|------------------|
| Small tabular | Linear, Tree |
| Large tabular | Boosted Trees |
| Text | Linear, Transformers |
| Images | CNNs |
| Time series | Trees, ARIMA, RNNs |

---

## Choosing the Right Model (Framework)

Ask:
1. How much data do we have?
2. How complex is the signal?
3. Is interpretability required?
4. What latency constraints exist?
5. How often will we retrain?

---

## Common Failure Modes

- Jumping to complex models prematurely
- Ignoring baselines
- Using deep learning where trees suffice
- Overfitting leaderboard metrics
- Underestimating maintenance cost

---

## Interview Section

### Common Questions
- “Why use gradient boosting over random forests?”
- “When would you choose logistic regression?”
- “How do model families differ in bias–variance?”

### Strong Answer Pattern

> “I start with simple, interpretable baselines,
> then move to more expressive models if the data
> and business problem justify the added complexity.”

---

## When Combined Files Make Sense

Combined format is ideal here because:
- Model choice is conceptual + practical
- Code examples are illustrative, not exploratory
- RAG systems benefit from unified context

---

## Summary Checklist

- [ ] I can explain core model families
- [ ] I know their tradeoffs
- [ ] I can justify model choice
- [ ] I can discuss operational implications
