# Hyperparameter Tuning

## Definition

Hyperparameters are configuration choices **set before training** that control model
behavior, complexity, and learning dynamics. Hyperparameter tuning is the process of
selecting values that optimize generalization performance.

Unlike parameters, hyperparameters are **not learned directly from data**.

---

## Why Hyperparameter Tuning Matters

- Poor hyperparameters can make good models fail
- Default values are rarely optimal
- Tuning controls the bias–variance tradeoff

Rule of thumb:
> Model performance is often limited more by hyperparameters than by model choice.

---

## Common Hyperparameters (By Model Family)

### Linear / Regularized Models
- Regularization strength (alpha, C)
- Penalty type (L1, L2, ElasticNet)

---

### Tree-Based Models
- max_depth
- min_samples_split
- min_samples_leaf
- n_estimators (ensembles)
- learning_rate (boosting)

---

### k-NN
- Number of neighbors (k)
- Distance metric

---

### Neural Networks
- Learning rate
- Number of layers / units
- Batch size
- Regularization terms

---

## Tuning Strategies

### Manual / Heuristic Tuning
- Fast
- Relies on intuition
- Limited scalability

---

### Grid Search
- Exhaustive search over a fixed grid
- Simple but expensive
- Scales poorly with many parameters

---

### Random Search
- Samples hyperparameters randomly
- More efficient than grid search
- Often finds good solutions faster

---

### Bayesian Optimization
- Models the objective function
- Chooses promising hyperparameters adaptively
- More sample-efficient

---

## Cross-Validation and Tuning

Hyperparameter tuning must be:
- Nested within cross-validation
- Performed only on training data

Never tune on the test set.

---

## Hyperparameters and Bias–Variance

- Increasing model complexity → ↓ bias, ↑ variance
- Regularization hyperparameters control this tradeoff
- Tuning is bias–variance management at scale

---

## Common Pitfalls

- Tuning on the test set
- Overfitting validation data
- Searching unnecessarily large spaces
- Ignoring training cost and latency

---

# Interview-Focused Guidance

## How Interviewers Test This

- “How would you tune this model?”
- “Grid vs random search?”
- “Why not tune everything?”

They are testing:
- Practical ML judgment
- Computational awareness
- Experimental discipline

---

## Strong Interview Framing

> “I start with reasonable defaults, then use random search with cross-validation
> to explore sensitive hyperparameters, balancing performance with cost.”

---

## Company Context Examples

- **Instacart**: tuning tree depth and learning rates
- **Affirm**: conservative tuning for stability and compliance
- **Federato**: balancing performance vs robustness on sparse data

---

## Interview Checklist

- [ ] I can explain grid vs random vs Bayesian search
- [ ] I know where cross-validation fits
- [ ] I avoid tuning on the test set
- [ ] I consider cost and latency
