# Hypothesis Testing

## Definition

Hypothesis testing is a statistical framework for making decisions under uncertainty.
It quantifies whether an observed effect is likely due to **random variation**
or represents a **true underlying signal**.

In experimentation, hypothesis tests support decisions — they do not make them automatically.

---

## Why Hypothesis Testing Matters

- Prevents overreacting to noise
- Provides a common decision framework
- Makes uncertainty explicit
- Enables disciplined experimentation at scale

Rule of thumb:
> Statistical significance is evidence, not a decision.

---

## Core Components

### Null Hypothesis (H₀)
Represents the default state (no effect).

Example:
> H₀: μ_treatment − μ_control = 0

---

### Alternative Hypothesis (H₁)
Represents the presence of an effect.

Example:
> H₁: μ_treatment − μ_control ≠ 0

---

### Significance Level (α)
Probability of a **Type I error** (false positive).  
Common values: 0.05, 0.01.

---

### Test Statistic
Quantifies how extreme the observed data is under H₀.

Examples:
- t-statistic
- z-score
- chi-square statistic

---

### P-value
Probability of observing data **at least as extreme as observed**, assuming H₀ is true.

Lower p-value ⇒ stronger evidence against H₀.

---

## Error Types

- **Type I error**: Rejecting a true null (false positive)
- **Type II error**: Failing to reject a false null (false negative)

Tradeoff controlled by α, power, and sample size.

---

## Statistical Power

Power = P(reject H₀ | H₁ true)

Increases with:
- Larger samples
- Larger effect sizes
- Lower variance

Low power leads to unstable conclusions.

---

## Common Hypothesis Tests

### 1. Two-Sample t-Test (Means)

Assumptions:
- Independent samples
- Approximately normal means
- Equal variances (optional)

```python
import numpy as np
from scipy import stats

np.random.seed(42)

control = np.random.normal(0.0, 1.0, 500)
treatment = np.random.normal(0.2, 1.0, 500)

t_stat, p_value = stats.ttest_ind(treatment, control, equal_var=False)
t_stat, p_value
```

---

### 2. One-Sample t-Test

Used when comparing to a fixed baseline.

```python
baseline = 0.0
stats.ttest_1samp(treatment, baseline)
```

---

### 3. Paired t-Test

Used when observations are naturally paired.

```python
before = np.random.normal(1.0, 0.5, 200)
after = before + np.random.normal(0.1, 0.3, 200)

stats.ttest_rel(after, before)
```

---

### 4. Proportion z-Test (Binary Metrics)

Used for conversion rates.

```python
from statsmodels.stats.proportion import proportions_ztest

successes = np.array([120, 150])
trials = np.array([1000, 1000])

proportions_ztest(successes, trials)
```

---

### 5. Chi-Square Test (Categorical)

Used for independence testing.

```python
from scipy.stats import chi2_contingency

table = [
    [200, 50],
    [180, 70]
]

chi2_contingency(table)
```

---

### 6. Nonparametric Test (Mann–Whitney U)

Used when distributions are skewed or heavy-tailed.

```python
stats.mannwhitneyu(treatment, control, alternative="two-sided")
```

---

## Assumption Checks

### Normality (Optional for Large n)

```python
stats.shapiro(control[:50])
```

---

### Variance Equality

```python
stats.levene(control, treatment)
```

---

## Effect Size (Beyond P-values)

Always report magnitude:

```python
effect_size = treatment.mean() - control.mean()
effect_size
```

P-values answer *whether* an effect exists.  
Effect sizes answer *how big* it is.

---

## Multiple Testing

Testing many hypotheses inflates false positives.

Common corrections:
- Bonferroni
- False Discovery Rate (Benjamini–Hochberg)

---

## Common Pitfalls

- Treating p-values as binary truth
- Ignoring assumptions blindly
- Testing after peeking at results
- Multiple testing without correction
- Overconfidence with small samples

---

# Interview-Focused Guidance

## How Interviewers Test This

- “What does a p-value actually mean?”
- “When would you not trust a t-test?”
- “What’s the difference between statistical and practical significance?”

---

## Strong Interview Framing

> “I use hypothesis tests to quantify uncertainty,
> but I always pair them with effect sizes,
> assumption checks, and business context.”

---

## Company Context Examples

- **Instacart**: noisy conversion experiments
- **Affirm**: credit risk model comparisons
- **Federato**: underwriting experiments with limited samples

---

## Interview Checklist

- [ ] I can explain p-values clearly
- [ ] I understand Type I vs Type II errors
- [ ] I know when assumptions break
- [ ] I can choose appropriate tests
- [ ] I can connect results to decisions
