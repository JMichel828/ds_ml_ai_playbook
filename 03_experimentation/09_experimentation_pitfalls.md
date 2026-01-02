# Experimentation Pitfalls (and How Experiments Fail in Practice)

## Definition

Experimentation pitfalls are **systematic failure modes** that cause experiments
to produce misleading or incorrect conclusions — even when statistical tests are applied correctly.

Most bad decisions from experiments come from **design and execution errors**, not math.

---

## Why This Matters

- Teams ship harmful features
- Real effects are missed or exaggerated
- Trust in experimentation erodes
- Interviewers care deeply about *judgment* here

Rule of thumb:
> If you can’t explain how experiments fail, you don’t understand experiments.

---

## Pitfall 1: Peeking (Early Stopping Bias)

### What Happens

Repeatedly checking results and stopping when p < 0.05 inflates false positives.

---

### Simulation Example

```python
import numpy as np
from scipy import stats

np.random.seed(42)

def run_peeking_experiment(n=1000, looks=10):
    control = np.random.normal(0, 1, n)
    treatment = np.random.normal(0, 1, n)
    
    for i in range(looks):
        _, p = stats.ttest_ind(treatment[: (i+1)*100], control[: (i+1)*100])
        if p < 0.05:
            return True
    return False

np.mean([run_peeking_experiment() for _ in range(1000)])
```

False positive rate is much higher than 5%.

---

## Pitfall 2: Sample Ratio Mismatch (SRM)

### What Happens

Assignment or logging bugs break randomization.

---

### Detection Example

```python
from scipy.stats import chisquare

observed = [520, 480]
expected = [500, 500]

chisquare(observed, expected)
```

SRM invalidates the experiment regardless of p-values.

---

## Pitfall 3: Metric Invariance Violations

### What Happens

The metric itself changes meaning due to treatment.

Examples:
- Conversion rate denominator changes
- Eligibility criteria shift
- Logging definitions change mid-test

---

### Example

```python
# Conversion rate increases but eligible users drop
```

Metric improvement ≠ business improvement.

---

## Pitfall 4: Simpson’s Paradox

### What Happens

Aggregated results reverse within segments.

---

### Example

```python
import pandas as pd

df = pd.DataFrame({
    "group": ["A","A","B","B"],
    "segment": ["X","Y","X","Y"],
    "success": [90, 1, 80, 19],
    "total": [100, 10, 100, 20]
})

df["rate"] = df.success / df.total
df
```

Always segment when results look “too good”.

---

## Pitfall 5: Interference Ignored

### What Happens

Treatment affects control users.

Examples:
- Network spillovers
- Market saturation
- Capacity constraints

Naïve A/B tests overestimate effects.

---

## Pitfall 6: Underpowered Experiments

### What Happens

Non-significant ≠ no effect.

```python
# Low power experiments often miss real effects
```

Always check power and confidence intervals.

---

## Pitfall 7: Multiple Testing

### What Happens

Testing many metrics inflates false discovery.

---

### Example

```python
import numpy as np

np.mean([np.random.rand(100).min() < 0.05 for _ in range(1000)])
```

Corrections or guardrails are required.

---

## Pitfall 8: Post-Treatment Conditioning

### What Happens

Filtering on outcomes affected by treatment biases estimates.

Examples:
- Only analyzing retained users
- Conditioning on engagement after launch

---

## Pitfall 9: Logging and Instrumentation Bugs

### What Happens

Data collection errors invalidate analysis.

Symptoms:
- Sudden metric jumps
- Asymmetric missing data
- Segment-specific anomalies

---

# Interview-Focused Guidance

## How Interviewers Test This

- “Why might an experiment be misleading?”
- “What would make you distrust results?”
- “What checks do you run before reading p-values?”

---

## Strong Interview Framing

> “I trust experiments only after validating assignment,
> instrumentation, power, and metric definitions.
> Statistics come last.”

---

## Company Context Examples

- **Instacart**: marketplace balance masking negative effects
- **Affirm**: policy changes altering eligibility
- **Federato**: selection bias in underwriting experiments

---

## Interview Checklist

- [ ] I can name common failure modes
- [ ] I know how to detect SRM
- [ ] I understand peeking bias
- [ ] I validate metrics before testing
- [ ] I distrust results appropriately
