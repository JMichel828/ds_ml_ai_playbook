# Power Analysis

## Definition

Power analysis is the process of determining **how likely an experiment is to detect a real effect**,
given a sample size, variance, effect size, and significance level.

Power answers the question:
> “If a real effect exists, how likely are we to detect it?”

---

## Why Power Analysis Matters

- Prevents underpowered experiments
- Avoids false negatives
- Informs sample size planning
- Enables realistic expectations

Rule of thumb:
> If you don’t plan power, you’re guessing.

---

## Core Concepts

### Statistical Power
Power = P(reject H₀ | H₁ true)

Typically targeted at:
- 80%
- 90%

---

### Effect Size
Minimum detectable effect (MDE) worth acting on.

Smaller effects require:
- More samples
- Lower variance

---

### Significance Level (α)
Probability of Type I error (false positive).

Common values:
- 0.05
- 0.01

---

### Variance
Higher variance → lower power.

Variance reduction techniques increase power.

---

## Analytical Power Calculation (Continuous Metric)

```python
from statsmodels.stats.power import TTestIndPower

analysis = TTestIndPower()

effect_size = 0.2   # Cohen's d
alpha = 0.05
power = 0.8

sample_size = analysis.solve_power(
    effect_size=effect_size,
    alpha=alpha,
    power=power
)

sample_size
```

---

## Simulation-Based Power Analysis

Simulation provides intuition when assumptions are unclear.

### Setup

```python
import numpy as np
from scipy import stats

np.random.seed(42)
```

---

### Simulate Experiments

```python
def run_experiment(n, effect):
    control = np.random.normal(0, 1, n)
    treatment = np.random.normal(effect, 1, n)
    _, p = stats.ttest_ind(treatment, control, equal_var=False)
    return p < 0.05
```

---

### Estimate Power

```python
def estimate_power(n, effect, sims=1000):
    return sum(run_experiment(n, effect) for _ in range(sims)) / sims

estimate_power(500, 0.2)
```

---

## Power Curve

```python
effects = [0.05, 0.1, 0.2, 0.3]
powers = [estimate_power(500, e) for e in effects]

list(zip(effects, powers))
```

---

## Binary Metric Power (Conversion Rate)

```python
from statsmodels.stats.power import NormalIndPower

analysis = NormalIndPower()

effect_size = 0.02  # 2 percentage points
sample_size = analysis.solve_power(
    effect_size=effect_size,
    alpha=0.05,
    power=0.8
)

sample_size
```

---

## Relationship Between Power and Errors

- Low power → high Type II error
- Significant but low-powered results overestimate effect size
- Many null results are inconclusive, not negative

---

## Common Pitfalls

- Choosing unrealistically large effect sizes
- Ignoring variance estimates
- Planning power after data collection
- Treating non-significant results as “no effect”
- Forgetting multiple testing adjustments

