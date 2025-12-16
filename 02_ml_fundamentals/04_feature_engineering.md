# Feature Engineering

## Definition

Feature engineering is the process of transforming raw data into meaningful inputs
that improve model performance. In many real-world problems, **feature quality matters
more than model choice**.

Strong feature engineering reduces bias, controls variance, and improves interpretability.

---

## Why Feature Engineering Matters

- Models learn patterns only from provided features
- Good features simplify the learning task
- Poor features create noise, leakage, and instability

Rule of thumb:
> Better features often beat better algorithms.

---

## Common Feature Engineering Categories

### Numeric Transformations
Examples:
- Scaling (standardization, normalization)
- Log transforms
- Winsorization / clipping

Use when:
- Distributions are skewed
- Models are scale-sensitive

---

### Categorical Encoding
Examples:
- One-hot encoding
- Target encoding
- Ordinal encoding

Use when:
- Features are categorical
- Cardinality varies

Pitfall:
- Target leakage with target encoding

---

### Interaction Features
Examples:
- Ratios
- Differences
- Crossed features

Use when:
- Relationships are conditional
- Linear models underfit

---

### Time-Based Features
Examples:
- Day of week
- Seasonality flags
- Rolling aggregates

Use when:
- Data is temporal
- Behavior changes over time

---

### Aggregations
Examples:
- User-level stats
- Rolling means
- Historical counts

Use when:
- Past behavior predicts future outcomes

---

## Feature Engineering and Bias–Variance

- Adding features → ↓ bias, ↑ variance
- Removing noisy features → ↑ bias, ↓ variance
- Leakage → artificially low bias & variance (dangerous)

Feature engineering is bias–variance management in practice.

---

## Leakage (Critical)

Leakage occurs when features use information unavailable at prediction time.

Common leakage sources:
- Future timestamps
- Target-derived aggregates
- Improper train/test splits

Leakage produces unrealistically strong validation results.

---

## Feature Selection vs Feature Creation

- Creation: add signal
- Selection: remove noise

Both aim to improve generalization.

---

## Common Pitfalls

- Creating features before defining prediction time
- Using target information implicitly
- Over-engineering without validation
- Ignoring feature stability

---

# Interview-Focused Guidance

## How Interviewers Test This

- “What features would you add?”
- “How would you debug poor model performance?”
- “How do you avoid leakage?”

They are testing:
- Practical intuition
- Data understanding
- Modeling judgment

---

## Strong Interview Framing

> “I start by defining prediction time.
> Then I add features that reflect available information.
> I validate every feature to ensure it improves generalization.”

---

## Company Context Examples

- **Instacart**: user & item aggregates, seasonality
- **Affirm**: financial ratios, historical behavior
- **Federato**: temporal risk features, stability constraints

---

## Interview Checklist

- [ ] I can propose relevant features quickly
- [ ] I know how to detect leakage
- [ ] I can explain feature tradeoffs
- [ ] I validate features rigorously
