# Evaluation Metrics

## Definition

Evaluation metrics quantify how well a model performs relative to the problem being solved.
Choosing the *right* metric is often more important than choosing the model itself.

Different metrics emphasize different types of errors, tradeoffs, and business costs.

---

## Why Metrics Matter

- Models can look good under one metric and fail under another
- Imbalanced data makes naive metrics misleading
- Metrics encode business priorities implicitly

> A good metric answers: *“What does success actually mean?”*

---

## Common Classification Metrics

### Accuracy
Fraction of correct predictions.

- Simple and intuitive
- Often misleading with class imbalance

Use when:
- Classes are balanced
- Costs of false positives and false negatives are similar

---

### Precision
Of predicted positives, how many were correct?

High precision means:
- Few false positives

Use when:
- False positives are costly
- Example: fraud flags, spam detection

---

### Recall (Sensitivity)
Of actual positives, how many did we catch?

High recall means:
- Few false negatives

Use when:
- Missing positives is costly
- Example: disease detection, risk screening

---

### F1 Score
Harmonic mean of precision and recall.

Use when:
- You need a single metric
- Precision and recall are both important

---

## Threshold-Dependent vs Threshold-Free Metrics

- Accuracy, precision, recall → depend on classification threshold
- ROC AUC → evaluates ranking across all thresholds

---

## ROC AUC

Measures how well the model ranks positives above negatives.

- Threshold-independent
- Insensitive to class imbalance
- Does **not** measure calibration

High ROC AUC ≠ good probability estimates

---

## Confusion Matrix

The foundation for most classification metrics.

|              | Predicted 0 | Predicted 1 |
|--------------|-------------|-------------|
| Actual 0     | TN          | FP          |
| Actual 1     | FN          | TP          |

---

## Common Pitfalls

- Using accuracy on imbalanced data
- Optimizing metrics without business context
- Comparing metrics across different data distributions
- Ignoring calibration when probabilities matter

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Why is accuracy a bad metric here?”
- “Would you optimize precision or recall?”
- “Why choose ROC AUC over F1?”

They are testing:
- Metric intuition
- Cost-sensitive thinking
- Business alignment

---

## Strong Interview Framing

> “I start by understanding the business cost of different errors.
> That guides whether I care more about false positives, false negatives,
> or ranking quality rather than a fixed threshold metric.”

---

## Company Context Examples

- **Instacart**: ranking models → ROC AUC / NDCG
- **Affirm**: risk models → recall vs default risk
- **Federato**: insurance risk → precision vs stability

---

## Interview Checklist

- [ ] I can explain precision vs recall tradeoffs
- [ ] I know when accuracy fails
- [ ] I can justify ROC AUC vs thresholded metrics
- [ ] I can tie metric choice to business impact
