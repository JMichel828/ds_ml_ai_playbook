# Evaluation Metrics (Combined Reference)

---

## Why Evaluation Metrics Matter

Evaluation metrics answer three different questions:

1. *Is the model good?* (statistical performance)
2. *Is the model useful?* (business impact)
3. *Is the model safe to ship?* (failure modes)

---

## Metric Taxonomy

### Regression
- MAE
- MSE / RMSE
- R²
- MAPE (with caveats)

### Classification
- Accuracy
- Precision / Recall
- F1
- ROC-AUC
- PR-AUC
- Log Loss

### Ranking / Scoring
- Precision@K
- Recall@K
- NDCG
- Lift

---

## Regression Metrics

### Mean Absolute Error (MAE)

**Definition**
Average absolute difference between predictions and truth.

**Why it’s useful**
- Interpretable in original units
- Robust to outliers compared to MSE

```python
import numpy as np

y_true = np.array([100, 120, 130, 150])
y_pred = np.array([110, 115, 140, 145])

mae = np.mean(np.abs(y_true - y_pred))
mae
```

**Pitfall**
- Not differentiable at zero (rarely matters in practice)

---

### Mean Squared Error (MSE) / RMSE

**Why squared error exists**
- Penalizes large errors more heavily
- Aligns with Gaussian noise assumptions

```python
mse = np.mean((y_true - y_pred) ** 2)
rmse = np.sqrt(mse)
rmse
```

**Manager insight**
RMSE is sensitive to tail risk — great for catching catastrophic failures.

---

### R² (Coefficient of Determination)

**What it measures**
Fraction of variance explained relative to baseline mean model.

```python
ss_res = np.sum((y_true - y_pred) ** 2)
ss_tot = np.sum((y_true - np.mean(y_true)) ** 2)
r2 = 1 - ss_res / ss_tot
r2
```

**Interview pitfall**
Negative R² is possible and meaningful.

---

## Classification Metrics

### Accuracy

**Definition**
Correct predictions / total predictions.

**Why it’s dangerous**
Breaks under class imbalance.

```python
y_true = np.array([1,0,0,0,0])
y_pred = np.array([0,0,0,0,0])
accuracy = np.mean(y_true == y_pred)
accuracy
```

95% accuracy, zero usefulness.

---

### Precision & Recall

- **Precision**: Of predicted positives, how many are correct?
- **Recall**: Of actual positives, how many did we find?

```python
tp, fp, fn = 8, 2, 5
precision = tp / (tp + fp)
recall = tp / (tp + fn)
precision, recall
```

**Tradeoff**
You usually optimize one at the expense of the other.

---

### F1 Score

Harmonic mean of precision and recall.

```python
f1 = 2 * precision * recall / (precision + recall)
f1
```

**Additional note**
Only meaningful when precision and recall are both important.

---

### ROC-AUC

**What it measures**
Ranking ability across all thresholds.

```python
from sklearn.metrics import roc_auc_score

y_true = [0, 0, 1, 1]
y_scores = [0.1, 0.4, 0.35, 0.8]

roc_auc_score(y_true, y_scores)
```

**Pitfall**
Insensitive to class imbalance severity.

---

### PR-AUC

Better metric when positives are rare.

```python
from sklearn.metrics import average_precision_score

average_precision_score(y_true, y_scores)
```

---

### Log Loss

Measures probabilistic calibration.

```python
from sklearn.metrics import log_loss

log_loss(y_true, y_scores)
```

**Takeaway**
Log loss punishes overconfident wrong predictions.

---

## Ranking Metrics

### Precision@K

```python
import numpy as np

y_true = np.array([1, 0, 1, 0, 1])
y_scores = np.array([0.9, 0.8, 0.7, 0.4, 0.2])

top_k = np.argsort(y_scores)[-3:]
precision_at_k = y_true[top_k].mean()
precision_at_k
```

---

### NDCG (Conceptual)

- Rewards correct ordering
- Discounted by rank position

Used heavily in search & recommendation.

---

## Choosing the Right Metric (Framework)

Ask:
1. What decision is this model supporting?
2. What is the cost of false positives vs false negatives?
3. Is ranking more important than absolute correctness?
4. Is calibration important?
5. Who consumes the output?

---

## Model Comparison Pitfalls

- Comparing metrics across different datasets
- Optimizing proxy metrics
- Ignoring variance / confidence intervals
- Overfitting on validation metrics


