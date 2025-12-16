# Regularization

## Definition

Regularization is a set of techniques used to **control model complexity** by penalizing
large or unstable parameter values. Its primary purpose is to **reduce variance and
improve generalization**.

Regularization is one of the most important tools for managing the bias–variance tradeoff.

---

## Why Regularization Matters

- Complex models can overfit noise
- Small datasets amplify variance
- Regularization stabilizes learning

Rule of thumb:
> If a model fits the training data too well, regularization should be your first lever.

---

## Common Types of Regularization

### L2 Regularization (Ridge)

Penalty:
- Sum of squared coefficients

Effects:
- Shrinks coefficients smoothly
- Reduces variance
- Keeps all features

Use when:
- Many correlated features
- You want stability over sparsity

---

### L1 Regularization (Lasso)

Penalty:
- Sum of absolute coefficients

Effects:
- Drives some coefficients to zero
- Performs implicit feature selection

Use when:
- You suspect many irrelevant features
- Interpretability matters

---

### Elastic Net

Combination of L1 and L2 penalties.

Effects:
- Balances sparsity and stability
- Works well with correlated features

Use when:
- You want both feature selection and robustness

---

## Regularization and Bias–Variance

- Increasing regularization → ↑ bias, ↓ variance
- Decreasing regularization → ↓ bias, ↑ variance

Regularization is a controlled way to trade variance for bias.

---

## Regularization vs Data

- More data can reduce variance naturally
- Regularization compensates when data is limited
- Both are often used together

---

## Regularization in Practice

Regularization affects:
- Coefficient magnitude
- Feature importance
- Model stability across samples

Hyperparameters controlling regularization must be tuned carefully.

---

## Common Pitfalls

- Over-regularizing and underfitting
- Forgetting to scale features (critical for L1/L2)
- Treating regularization strength as universal
- Ignoring domain constraints

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Why add regularization here?”
- “L1 vs L2 — when would you choose each?”
- “Why did your coefficients shrink?”

They are testing:
- Understanding of overfitting
- Tradeoff reasoning
- Practical modeling judgment

---

## Strong Interview Framing

> “When I see a gap between train and validation performance,
> I reach for regularization to stabilize the model before increasing data or complexity.”

---

## Company Context Examples

- **Instacart**: stabilize demand models with many correlated signals
- **Affirm**: control risk model volatility for regulatory consistency
- **Federato**: prevent overfitting on sparse risk features

---

## Interview Checklist

- [ ] I can explain L1 vs L2 clearly
- [ ] I understand how regularization affects coefficients
- [ ] I know how it relates to bias–variance
- [ ] I tune regularization rather than hardcoding it
