# Class Imbalance

## Definition

Class imbalance occurs when one class is significantly more frequent than another.
This is common in real-world problems such as fraud detection, risk modeling, and
rare event prediction.

Class imbalance fundamentally affects **metric choice, model training, and evaluation**.

---

## Why Class Imbalance Matters

- Accuracy becomes misleading
- Models may learn to ignore minority classes
- Small changes in predictions can have large business impact

Rule of thumb:
> If the positive class is rare, accuracy is almost never the right metric.

---

## Common Examples

- Fraud detection (fraud ≪ non-fraud)
- Credit default (default ≪ non-default)
- Insurance claims
- Anomaly detection
- Medical diagnosis

---

## Metrics Under Class Imbalance

### Metrics That Fail
- Accuracy

### Metrics That Matter
- Precision
- Recall
- F1 score
- ROC AUC
- Precision–Recall AUC

Metric choice should reflect **business cost asymmetry**.

---

## Modeling Strategies

### Resampling Techniques
- Undersampling majority class
- Oversampling minority class
- SMOTE (synthetic samples)

Tradeoff:
- Bias vs variance
- Information loss vs noise

---

### Class Weighting
- Assign higher loss to minority class
- Supported by many algorithms

Advantages:
- Simple
- No data duplication

---

### Threshold Tuning
- Adjust decision threshold
- Trade precision vs recall intentionally

---

## Class Imbalance and Bias–Variance

- Minority class variance is high
- Oversampling reduces bias but increases variance
- Undersampling reduces variance but increases bias

Imbalance handling is bias–variance management under constraints.

---

## Common Pitfalls

- Reporting accuracy as primary metric
- Ignoring base rates
- Training on balanced data but evaluating on imbalanced data incorrectly
- Overfitting synthetic samples

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Accuracy is 99%. Is this good?”
- “Would you optimize precision or recall?”
- “How do you handle imbalance in training?”

They are testing:
- Metric intuition
- Cost-sensitive thinking
- Practical ML judgment

---

## Strong Interview Framing

> “I first quantify the base rate and business cost of errors.
> That determines the metric, sampling strategy, and threshold choice.”

---

## Company Context Examples

- **Instacart**: rare churn or fraud events
- **Affirm**: default prediction (recall vs risk)
- **Federato**: rare but costly risk outcomes

---

## Interview Checklist

- [ ] I avoid accuracy traps
- [ ] I can choose precision vs recall intentionally
- [ ] I know multiple imbalance handling techniques
- [ ] I align metrics with business cost
