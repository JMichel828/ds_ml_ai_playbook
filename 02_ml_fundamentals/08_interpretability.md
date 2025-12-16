# Model Interpretability

## Definition

Model interpretability refers to our ability to **understand and explain why a model
makes a particular prediction**. Interpretability is critical for trust, debugging,
regulatory compliance, and stakeholder communication.

Interpretability requirements vary by use case, risk, and audience.

---

## Why Interpretability Matters

- Builds trust with stakeholders
- Enables debugging and model improvement
- Required in regulated domains
- Helps detect bias and leakage

Rule of thumb:
> The higher the business risk, the higher the interpretability requirement.

---

## Types of Interpretability

### Global Interpretability
Understanding overall model behavior.

Examples:
- Feature importance
- Partial dependence plots
- Coefficient magnitudes

Use when:
- Explaining model behavior at a high level
- Comparing models

---

### Local Interpretability
Explaining individual predictions.

Examples:
- SHAP values
- LIME explanations

Use when:
- Auditing specific decisions
- Handling customer or regulator inquiries

---

## Common Interpretability Techniques

### Linear Models
- Coefficients are directly interpretable
- Requires feature scaling awareness

Pros:
- Simple
- Transparent

Cons:
- Limited expressiveness

---

### Tree-Based Models
- Feature importance
- Decision paths

Pros:
- Intuitive splits
- Nonlinear interactions

Cons:
- Importance can be misleading
- Complex trees are hard to explain

---

### SHAP (Shapley Values)
- Consistent local explanations
- Aggregates to global importance

Pros:
- Theoretically grounded
- Model-agnostic

Cons:
- Computationally expensive
- Requires careful interpretation

---

## Interpretability vs Performance

- Increasing complexity often reduces interpretability
- Simpler models may be preferred even if slightly less accurate
- Interpretability is a business constraint, not a technical afterthought

---

## Common Pitfalls

- Treating feature importance as causal
- Ignoring correlated features
- Over-explaining low-impact models
- Using interpretability tools without context

---

# Interview-Focused Guidance

## How Interviewers Test This

- “How would you explain this model to a non-technical stakeholder?”
- “How do you debug a black-box model?”
- “When would you sacrifice performance for interpretability?”

They are testing:
- Judgment and communication
- Awareness of business risk
- Practical use of tools

---

## Strong Interview Framing

> “I choose interpretability techniques based on audience and risk.
> For high-stakes decisions, I prefer simpler models or robust explanation tools
> and validate explanations carefully.”

---

## Company Context Examples

- **Instacart**: explaining ranking drivers to ops teams
- **Affirm**: regulatory explanations for credit decisions
- **Federato**: transparent risk scoring

---

## Interview Checklist

- [ ] I can explain global vs local interpretability
- [ ] I know strengths and weaknesses of SHAP
- [ ] I can tie interpretability to business risk
- [ ] I avoid causal overclaims
