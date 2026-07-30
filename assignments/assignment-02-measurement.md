# Assignment 2 — Measuring Authenticity with an LLM

**Released** Week 4 (Sep 16) · **Due** Week 6 (Sep 30), start of class

**Weight:** 10% of the first-half grade

---

## The point of this assignment

You are going to build a measurement instrument out of a language model, find out how
good it is, and then find out what happens when you use it anyway.

The construct is **experiential authenticity**: does this review read like it was
written by someone who actually went there?

The deliverable is not a classifier. It is an honest account of a classifier's error and
what that error does to a regression coefficient. If you finish this assignment believing
your measure is good, you have probably not validated it hard enough.

---

## The construct

For each review, we want a binary label:

> **Authentic (1):** the review contains concrete, verifiable specifics that indicate
> first-hand experience, named dishes, prices, staff, timing, spatial detail, sensory
> description tied to a particular visit, or a narrative of what happened.
>
> **Generic (0):** the review expresses evaluation without first-hand specifics. Praise
> or complaint that could apply to any business in the category, with no detail that
> anchors it to an actual visit.

Two things to be clear about.

**This is not a fake-review detector.** You are measuring textual specificity, not
deception. A genuine customer can write "Great food, will come back!" and a paid shill
can invent convincing detail. Do not claim in your write-up that you are detecting fraud.
Referees will destroy you for it, and they will be right.

**The boundary is genuinely contested.** Is "the carnitas were dry" authentic? It names a
dish. Is "best sushi in LA" generic? It makes a specific claim about a category. You will
have to decide, write your decision down, and live with it. That decision *is* the
instrument.

---

## The data

```
host:     <given in class>
database: mkt615
user:     <given in class>
```

Restrict to reviews between 2015-01-01 and 2019-12-31 with `CHAR_LENGTH(review_text)`
between 200 and 2000, at businesses in California. That is **3,083,906 reviews**, you
will use a small fraction.

Very short reviews are excluded because "Great!" is trivially generic and would inflate
your accuracy for free.

On the California restriction: check what `state` actually contains in this table before
you assume you know what it means. If you were in the Week 2 lab you already know why.

---

## What to do

### Part 1 — Write the coding instructions (before you touch a model)

**Coding instructions** are what you would hand a research assistant: they state
the construct, what counts, what does not, how the hard cases resolve, and the exact
format for an answer. It is what makes two coders agree, and it is what your reliability
statistic is computed against. Your prompt will be coding instructions, write it as one.

Write `coding-instructions.md` containing:

- the construct definition, in your own words
- inclusion criteria: what makes a review authentic
- exclusion criteria: what does not count
- **at least six worked edge cases** with your ruling and your reasoning

Do this first. If you write the coding instructions after seeing model output, you will
unconsciously write it to match the model, and your validation will be circular.

### Part 2 — Label by hand

**You** label **150 reviews**, drawn at random from your analysis population. Not a
convenience sample, not the first 150 rows.

Then get a **second human** (a classmate, a labmate, anyone who will read your coding
instructions) to independently label **75** of the same reviews.

Compute **Cohen's kappa** between the two of you, `irr::kappa2()` in R, or
`DescTools::CohenKappa()` if you want a confidence interval with it.

> **If your human–human kappa is below about 0.6, stop and fix the coding instructions.** Your
> construct is ill-defined, and no model can beat a ceiling that does not exist. This is a
> result, not a failure, and reporting it honestly is worth more than papering over it.

### Part 3 — Build the LLM measure

Annotate with an LLM. Requirements:

- **temperature = 0**
- prompt stored in `prompts/`, version-controlled, with model name and date
- **structured output** (JSON) so parsing does not silently fail
- store the **raw response**, not just the parsed label
- handle refusals and malformed output loudly, never by dropping the row

Annotate **5,000 reviews** for the analysis sample, plus the 150 you labeled by hand.

Budget: this should cost a few dollars with a mid-tier model. Batch your requests, and
test your prompt on 20 reviews before spending anything.

### Part 4 — Validate

Against your 150 hand labels, report:

- the **confusion matrix** (not just accuracy)
- accuracy, precision, recall, F1
- **your human–human kappa** alongside the model–human kappa, so the ceiling is visible

Then answer, in prose: **on what kinds of reviews does the model get it wrong?** Read at
least fifteen of its errors. This is the most important paragraph in the assignment.
Vague answers here indicate you did not actually look.

**And the critical question:** is the error correlated with anything in your analysis?
Not "is it random", check. Compute the error rate separately by star rating and by
reviewer type. If the model is worse on 1-star reviews than 5-star, and rating is in your
regression, you have a problem that no amount of accuracy fixes.

### Part 5 — Use it, twice

Estimate this:

```
authentic_i = β · one_off_reviewer_i + controls + ε_i
```

where `one_off_reviewer` = 1 if the reviewer wrote exactly one review in the 2015–2019
window. Include business fixed effects and star-rating controls. Cluster appropriately
think about where the variation is.

**For context**, in the full data: one-off reviewers give 1- or 5-star ratings 78.6% of
the time versus 60.3% for repeat reviewers, despite nearly identical mean ratings (3.92
vs 3.93). Whether that extremeness comes with less first-hand detail is your question.

Report **two** sets of estimates:

1. **Naive**: LLM labels plugged straight in as the outcome.
2. **Corrected**: using your 150 gold-standard labels and one of the methods from Week 5
, design-based supervised learning (`dsl`) or prediction-powered inference (`ppi_py`).

Put them **side by side in one table**. Report both point estimates and both confidence
intervals.

Then write one paragraph: **how much did the correction move the estimate, and would your
substantive conclusion have changed?**

If the two are nearly identical, say so. That is a legitimate and interesting finding.
Do not manufacture a discrepancy.

---

## Deliverables

```
├── coding-instructions.md              # written FIRST
├── prompts/                 # versioned, with model + date
├── code/
│   ├── 01-sample.R          # incl. the RNG seed
│   ├── 02-annotate.R
│   ├── 03-validate.R
│   └── 04-estimate.R
├── data/
│   ├── gold/                # your 150 hand labels + second coder's 75
│   └── raw_responses/       # unparsed model output
├── output/
└── report.md                # 3-4 pages
```

`report.md` covers, in this order: the construct and why it is hard; the data and your
identification argument, including what would break it; the validation results with the
confusion matrix and both kappas; where the model fails and whether that failure is
correlated with your regressors; and naive vs. corrected estimates.

Plus the AI-use appendix, as always.

---

## Grading

| | Points |
|:--|--:|
| Coding instructions written first, with real edge cases | 10 |
| Hand labels + second coder + kappa reported | 20 |
| **Validation sampling scheme correct and documented** | 15 |
| Confusion matrix + error analysis you clearly performed | 20 |
| Naive and corrected estimates, side by side | 20 |
| Honest interpretation, including limits | 10 |
| Reproducibility and AI log | 5 |

Note what is worth the most: **validation and correction, 55 points.** The regression is
worth 20 and I do not much care what the coefficient is.

---

## How to submit

Same as Assignment 1: push to your own GitHub repository, add `dadepro` as a
collaborator, and send me the URL. It must run from a clean clone. Test that yourself
before you submit.

Do **not** commit your API key. Do not commit the raw model responses if they contain
anything you would not want public; keep them in `data/` and gitignore it, but keep them
locally, because I may ask.

---

## The sampling warning

Read this twice.

Every correction method in Week 5 requires that you **know and control the probability
with which each observation entered your gold-standard sample**.

If you label the first 150 rows, or the ones that looked interesting, or the ones the
model was uncertain about, the corrections **do not apply**, and there is no way to fix
it after the fact. You would have to relabel.

Draw your validation sample at random (or by a stratified scheme you design and
document), and **record the sampling probability as a column in your gold-standard
file**. Set a seed. Write down the seed.

This is the single most common way this assignment goes wrong, and it is unrecoverable in
Week 5 when you need it.

---

## A note on what you are likely to find

Most of you will get 80–90% accuracy and feel good about it.

Then you will run the correction and discover that the confidence interval is wider than
you expected, or the point estimate moves more than you are comfortable with, or that
your model's errors are concentrated exactly on the reviews that distinguish your
treatment group.

That discovery is the assignment. It is not a sign you did it wrong. It is the thing I
want you to have felt in your own data before you do this in a dissertation chapter.
