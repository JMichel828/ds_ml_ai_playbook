# Class Imbalance (Combined Reference)

## Purpose

This document is a **single-source reference** for handling class imbalance in machine learning.
It combines **intuition, statistical grounding, practical techniques, code examples,
and failure modes** into one markdown file.

Designed for:

- Production model evaluation and risk mitigation
- Long-term ML reference
- RAG ingestion (markdown-first corpus)

---

## Why Class Imbalance Matters

Class imbalance occurs when one class is far rarer than others.
In real-world systems (fraud, churn, abuse, medical diagnosis), imbalance is the norm — not the exception.

> A model can achieve high accuracy and be completely useless.

Ignoring imbalance leads to:
- misleading metrics
- poor decision thresholds
- operational overload (false positives)
- missed rare but critical events

---

## Accuracy Trap (Intuition)

```python
import numpy as np

y_true = np.array([1] + [0]*99)   # 1% positive
y_pred = np.zeros_like(y_true)    # predict all negatives

accuracy = np.mean(y_true == y_pred)
accuracy
```

**Result:** 99% accuracy, zero business value.

---

## Proper Metrics for Imbalanced Data

### Preferred Metrics
- Precision
- Recall
- F1
- PR-AUC
- Cost-weighted loss

### Avoid Blindly Using
- Accuracy
- ROC-AUC alone (can be misleading)

---

## Confusion Matrix Framing

```python
tp, fp, fn, tn = 10, 90, 5, 895

precision = tp / (tp + fp)
recall = tp / (tp + fn)
precision, recall
```

**Manager insight**
Precision controls operational load; recall controls risk exposure.

---

## Threshold Tuning

Models output scores — decisions come from thresholds.

```python
import numpy as np

scores = np.random.rand(1000)
threshold = 0.9
preds = (scores > threshold).astype(int)

np.mean(preds)
```

**Key idea**
Threshold choice is a business decision, not a modeling one.

---

## Resampling Techniques

### Undersampling

```python
from sklearn.utils import resample

majority = np.zeros(900)
minority = np.ones(100)

undersampled = resample(majority, n_samples=100, replace=False)
len(undersampled)
```

**Risk**
Throws away data.

---

### Oversampling

```python
oversampled = resample(minority, n_samples=900, replace=True)
len(oversampled)
```

**Risk**
Overfitting duplicated examples.

---

### SMOTE (Conceptual)

Synthetic examples interpolated between minority samples.
Useful but dangerous if data has complex structure.

---

## Class Weighting

```python
from sklearn.linear_model import LogisticRegression

clf = LogisticRegression(class_weight="balanced")
clf.fit(np.random.randn(100,5), np.random.randint(0,2,100))
```

**Why It Works**
Shifts loss to penalize minority errors more heavily.

---

## Cost-Sensitive Learning

Frame errors in terms of business cost.

```python
false_negative_cost = 100
false_positive_cost = 1
```

**Manager insight**
The “best” model depends on cost assumptions, not metrics alone.

---

## Calibration & Imbalance

Imbalanced data often leads to poorly calibrated probabilities.

```python
from sklearn.calibration import CalibratedClassifierCV
```
Calibration matters when outputs drive downstream automation.

---

## When to Fix Imbalance vs Fix the Problem

Ask:
- Is imbalance inherent or data collection artifact?
- Can we change product flows to generate more positives?
- Can we delay decision to collect more signal?

---

## Common Failure Modes

- Optimizing accuracy
- Using ROC-AUC without PR curves
- Ignoring base rates
- Setting thresholds without ops input
- Oversampling before train-test split (leakage)

---

## Manager-Level Decision Framing

Managers should ask:
- What happens operationally at this threshold?
- How many false positives can we handle?
- What’s the cost of a miss?
- How stable is performance across segments?

