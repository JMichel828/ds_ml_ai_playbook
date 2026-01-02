# Interview Brain Teasers (Stats & Probability)

## Purpose

This file is a **practice bank** of high-frequency probability and statistics brain teasers.
It is designed for manager / senior manager interviews, with added depth where useful.

How to use:
1. Try to solve each problem without reading the solution.
2. Write your reasoning in 3–6 bullet points (like you would in an interview).
3. Check the solution and refine your explanation.
4. Repeat with variations and edge cases.

---

## 1) Monty Hall Problem

### Prompt
You choose one of 3 doors. One has a car, two have goats.
The host opens one goat door and offers you the chance to switch.
Should you switch? Why?

### Correct Answer
Yes — switching gives a 2/3 chance of winning.

### Explanation (Interview Version)
- Initially you have 1/3 chance of car, 2/3 chance you picked a goat.
- Host action is not random; it reveals information.
- Switching wins whenever your first choice was a goat (2/3 of the time).

### Simulation
```python
import numpy as np

def monty_hall(n=100000):
    wins_switch = 0
    wins_stay = 0

    for _ in range(n):
        car = np.random.randint(3)
        choice = np.random.randint(3)

        # host opens a goat door != choice
        possible = [d for d in range(3) if d != choice and d != car]
        host = np.random.choice(possible)

        # switch to remaining unopened door
        remaining = [d for d in range(3) if d not in (choice, host)][0]

        wins_stay += (choice == car)
        wins_switch += (remaining == car)

    return wins_stay/n, wins_switch/n

monty_hall()
```

---

## 2) The Two-Child Problem (Conditioning Trap)

### Prompt
A family has two children. You learn one is a boy.
What is the probability both are boys?

### Correct Answer
1/3 (under standard assumptions).

### Explanation
Possible equally likely pairs: {BB, BG, GB, GG}
Given “at least one boy”, eliminate GG → remaining {BB, BG, GB}
Only BB satisfies both boys → 1/3.

### Common Pitfall
If statement was: “the older child is a boy”, answer becomes 1/2.

---

## 3) Birthday Problem

### Prompt
How many people are needed so that the probability of at least two sharing a birthday is > 50%?

### Correct Answer
23.

### Explanation (Key Steps)
- Compute P(no shared birthday) and subtract from 1.
- Approximation: exp(-k(k-1)/(2*365)).

### Simulation
```python
def birthday_prob(n_people, trials=20000):
    matches = 0
    for _ in range(trials):
        days = np.random.randint(0, 365, n_people)
        if len(days) != len(set(days)):
            matches += 1
    return matches / trials

birthday_prob(23)
```

---

## 4) Expected Tosses Until First Heads

### Prompt
Fair coin. Expected number of flips until first heads?

### Correct Answer
2.

### Explanation
Geometric distribution with p=0.5: E = 1/p = 2.

### Simulation
```python
def expected_flips_until_heads(trials=100000):
    counts = []
    for _ in range(trials):
        c = 0
        while True:
            c += 1
            if np.random.rand() < 0.5:
                break
        counts.append(c)
    return np.mean(counts)

expected_flips_until_heads()
```

---

## 5) Two Dice: Conditional Probability

### Prompt
You roll two fair dice. You are told the sum is 8.
What is the probability one die is 6?

### Correct Answer
2/5.

### Explanation
Sum=8 combinations: (2,6),(3,5),(4,4),(5,3),(6,2)
Two include a 6 → 2/5.

---

## 6) The Counterintuitive Mean (Heavy Tails)

### Prompt
A startup’s revenue per customer is extremely skewed.
Why is mean misleading, and what would you report instead?

### “Correct” Answer (Manager Version)
- Mean dominated by outliers, unstable.
- Report median, percentiles (p75/p90/p99), trimmed mean, and distribution plots.
- Use bootstrap CIs for mean if needed.

### Deeper System Note
- Heavy tails affect alerting, forecasting, and resource planning.
- “Average user” is not meaningful.

---

## 7) A/B Test Peeking Problem

### Prompt
You check your experiment results every day and stop when p < 0.05.
What happens to your false positive rate?

### Correct Answer
It inflates above 5%.

### Explanation
Repeated testing increases the probability of observing an extreme result by chance.
Fix with:
- pre-registered stopping rule
- alpha spending (e.g., O’Brien–Fleming)
- sequential testing methods

---

## 8) Base Rate Fallacy (Fraud)

### Prompt
Fraud rate = 0.5%. Model has 95% sensitivity and 98% specificity.
If flagged, what is probability of fraud?

### Key Insight
Even strong models can produce mostly false positives when the base rate is tiny.

### Simulation
```python
def fraud_posterior(n=1000000, base=0.005, sens=0.95, fpr=0.02):
    fraud = np.random.binomial(1, base, n)
    flagged = fraud * np.random.binomial(1, sens, n) + (1-fraud) * np.random.binomial(1, fpr, n)
    return np.mean(fraud[flagged==1])

fraud_posterior()
```

---

## 9) The “Three Lights” Puzzle (Switching / Logic)

### Prompt
You have 3 switches outside a room and 3 bulbs inside.
You can enter the room only once.
How do you determine which switch corresponds to which bulb?

### Correct Answer
- Turn on switch 1 for a while, then turn it off.
- Turn on switch 2 and leave it on.
- Enter room:
  - bulb on → switch 2
  - bulb off but warm → switch 1
  - bulb off and cold → switch 3

### Why It Matters
Tests your ability to use **state + memory** (not just probability).

---

## 10) Expected Value: Coupon Collector (Manager-Friendly Version)

### Prompt
You collect random coupons. There are N unique types.
How many draws expected to collect them all?

### Correct Answer
N * H_N ≈ N (log N + γ)

### Interview Explanation
Later coupons take much longer to collect.
This shows “long-tail completion time” behavior.

---

## 11) Confidence Interval Interpretation Trap

### Prompt
A 95% CI for lift is (0.1%, 1.2%).
What does that mean? Would you ship?

### Strong Answer
- The interval is one realization; repeated intervals contain true lift 95% of the time.
- Shipping depends on business threshold:
  - if minimum viable lift is 0.5%, risk is that lift could be below threshold.
- Consider opportunity cost, rollout strategy, and monitoring.

---

## 12) Correlation vs Causation (Selection Bias)

### Prompt
You observe that users who watch more videos churn less.
Can you conclude videos reduce churn?

### Strong Answer
No — selection bias: engaged users may both watch more and churn less.
Fix with:
- experiment (recommend videos to random users)
- causal adjustment (propensity scores, diff-in-diff, IV if valid)

---

# Interview Guidance

## How to Answer Brain Teasers Well

**Structure:**
1) Clarify assumptions
2) Define sample space / conditioning
3) Solve cleanly
4) Sanity-check (limits or simulation)
5) Explain in plain language

**What to avoid:**
- jumping into algebra without defining events
- overconfident answers without assumptions
- missing conditioning traps

---

## Practice Plan (High ROI)

- Do 2–3 per day for 1 week
- Explain aloud in 60–120 seconds each
- Add variations (change numbers, add constraints)
- Build speed and clarity

---

## Notes for Senior Manager / Principal Interviews

At higher levels, interviewers often care less about the final number and more about:
- how you clarify assumptions
- how you structure reasoning
- whether you recognize traps and failure modes
- whether you can explain results to non-technical stakeholders

