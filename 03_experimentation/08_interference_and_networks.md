# Interference and Network Effects

## Definition

Interference occurs when **one unit’s treatment affects another unit’s outcome**.
This violates the standard A/B testing assumption known as SUTVA
(Stable Unit Treatment Value Assumption).

In networked systems, users are not independent.

---

## Why Interference Matters

Ignoring interference can:
- Bias treatment effect estimates
- Inflate false positives
- Hide real negative externalities
- Cause harmful launches

Interference is common in:
- Marketplaces
- Social networks
- Messaging systems
- Pricing / incentives
- Fraud & risk systems

---

## Types of Interference

### 1. Direct Network Effects
A user’s outcome depends on others being treated.

Examples:
- Messaging features
- Social feeds
- Referral programs

---

### 2. Spillover Effects
Treatment leaks to control users.

Examples:
- Promotions shared between users
- Geographic spillovers
- Word-of-mouth effects

---

### 3. Saturation Effects
Treatment effect changes as adoption increases.

Examples:
- Driver incentives
- Supply-side interventions
- Capacity constraints

---

## Core Problem with Naïve A/B Tests

Standard A/B tests assume:

Outcome_i ⟂ Treatment_j for i ≠ j

This fails in networks.

---

## Simulation: Interference in a Simple Network

### Setup

```python
import numpy as np
import pandas as pd

np.random.seed(42)
```

---

### Create Network

```python
n = 1000

# Random connections
connections = np.random.binomial(1, 0.01, size=(n, n))

# Treatment assignment
treatment = np.random.binomial(1, 0.5, size=n)

# Spillover exposure
spillover = connections.dot(treatment) > 0
```

---

### Generate Outcomes

```python
true_direct = 1.0
spillover_effect = 0.5

y = (
    5
    + true_direct * treatment
    + spillover_effect * spillover
    + np.random.normal(0, 1, n)
)

df = pd.DataFrame({
    "treatment": treatment,
    "spillover": spillover.astype(int),
    "y": y
})
```

---

### Naïve A/B Estimate (Biased)

```python
naive_effect = df[df.treatment==1].y.mean() - df[df.treatment==0].y.mean()
naive_effect
```

This conflates direct and spillover effects.

---

## Diagnosing Interference

### Exposure Mapping

Define exposure levels:
- Treated & exposed
- Treated & unexposed
- Control & exposed
- Control & unexposed

```python
df["exposure"] = (
    df.treatment.astype(str)
    + "_"
    + df.spillover.astype(str)
)

df.groupby("exposure").y.mean()
```

---

## Cluster-Based Randomization

### Idea

Randomize **clusters**, not individuals.

Examples:
- Geography
- Social graph components
- Teams or cohorts

---

### Cluster Simulation

```python
clusters = np.random.randint(0, 50, size=n)
cluster_treatment = np.random.binomial(1, 0.5, size=50)

df["cluster"] = clusters
df["cluster_treatment"] = cluster_treatment[clusters]

y_cluster = (
    5
    + true_direct * df.cluster_treatment
    + np.random.normal(0, 1, n)
)

df["y_cluster"] = y_cluster
```

---

## Two-Stage Randomization (Saturation Experiments)

### Idea

1. Randomize clusters to different treatment intensities
2. Randomize users within clusters

Used to measure:
- Spillovers
- Saturation curves

---

## Common Failure Modes

- Ignoring network structure
- Underpowered cluster experiments
- Misdefining exposure
- Post-treatment conditioning
- Treating spillovers as noise


