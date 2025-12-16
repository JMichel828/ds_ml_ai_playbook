# Model Families

## Definition

Model families are groups of algorithms that share similar assumptions, strengths,
weaknesses, and failure modes. Understanding model families helps you reason about
*why* a model works, not just *how* to use it.

In interviews, model families are used to test judgment, tradeoff reasoning,
and debugging intuition.
 
---

## Major Model Families (High Level)

### Linear Models
Examples:
- Linear Regression
- Logistic Regression

Characteristics:
- High bias, low variance
- Interpretable
- Fast to train
- Strong baseline for tabular data

Common failure modes:
- Cannot capture nonlinear relationships
- Sensitive to feature scaling and leakage

---

### Tree-Based Models
Examples:
- Decision Trees
- Random Forests
- Gradient Boosting (XGBoost, LightGBM)

Characteristics:
- Capture nonlinearities and interactions
- Handle mixed feature types well
- Strong performance on tabular data

Common failure modes:
- Overfitting (especially single trees)
- Less interpretable as complexity increases

---

### Distance-Based Models
Examples:
- k-Nearest Neighbors

Characteristics:
- Non-parametric
- Intuitive behavior
- Sensitive to feature scaling

Common failure modes:
- Poor scalability
- Sensitive to noise and irrelevant features

---

### Probabilistic Models
Examples:
- Naive Bayes
- Gaussian Mixture Models

Characteristics:
- Explicit probability modeling
- Fast and simple
- Strong assumptions

Common failure modes:
- Independence assumptions often violated
- Poor performance when assumptions fail

---

### Neural Networks
Examples:
- MLPs
- Deep Neural Networks

Characteristics:
- Highly expressive
- Flexible representations
- Data-hungry

Common failure modes:
- Overfitting on small data
- Hard to debug and interpret

---

## Choosing a Model Family

Key considerations:
- Dataset size
- Feature types
- Interpretability requirements
- Latency constraints
- Business risk

Rule of thumb:
> Start simple. Add complexity only when justified by data and validation.

---

## Bias–Variance Perspective

- Linear models → high bias, low variance
- Trees / ensembles → lower bias, higher variance
- Neural nets → lowest bias, highest variance

Model selection is often bias–variance management in disguise.

---

## Common Pitfalls

- Jumping to complex models too early
- Ignoring interpretability requirements
- Over-optimizing metrics without understanding failure modes
- Treating models as interchangeable

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Why did you choose this model?”
- “What would you try next if performance is poor?”
- “Why not use XGBoost here?”

They are testing:
- Modeling judgment
- Tradeoff awareness
- Debugging strategy

---

## Strong Interview Framing

> “I usually start with a simple, interpretable baseline.
> If it underfits, I move to models that can capture nonlinearities.
> I choose complexity only when validation shows it’s justified.”

---

## Company Context Examples

- **Instacart**: tree-based models for demand & ranking
- **Affirm**: interpretable models for risk + compliance
- **Federato**: balance stability and flexibility in risk models

---

## Interview Checklist

- [ ] I can explain why a model family fits the problem
- [ ] I know the failure modes of each family
- [ ] I can suggest next steps if performance degrades
- [ ] I can defend simpler models when appropriate
