# Assignment 2 — Measuring Service Complaints with an LLM

**Released** Week 4 (Sep 16) · **Due** Week 6 (Sep 30), start of class

**Weight:** 10% of the first-half grade

---

## The point of this assignment

You are going to build a measurement instrument out of a language model, find out how
good it is, and then find out what happens when you use it anyway.

The construct is the **locus of complaint**: when a reviewer is dissatisfied, are they
faulting how they were treated or what they were served?

The deliverable is not a classifier. It is an honest account of a classifier's error and
what that error does to a regression coefficient. If you finish this assignment believing
your measure is good, you have probably not validated it hard enough.

---

## The construct

For each review, we want a binary label:

> **1:** the review contains a complaint about **service**, the interaction or
> environment rather than the product: staff behaviour, wait, order accuracy,
> cleanliness of the premises, noise or crowding, facilities, or billing and policy
> friction.
>
> **0:** everything else. This includes reviews that complain about the **food** and
> reviews that complain about **nothing at all**.

Three things to be clear about.

**Every review gets a label.** There is no "not applicable" category. A purely positive
review is a 0, and so is a review whose only complaint is about the food. This matters
more than it looks: if the label decided which rows entered your regression, you would
have selection on the outcome, and none of the Week 5 corrections would repair it. They
assume the sample is fixed and only the labels are noisy.

**The hard boundary is not service versus food.** That distinction is reasonably crisp.
The hard part is deciding **when a mention becomes a complaint.** Reviews routinely note
a wait, a price, or a cramped room without treating any of it as a fault. "Come early
because the line gets long" is advice to the reader; "we waited an hour and nobody
acknowledged us" is a grievance. Both mention a wait. You will have to decide where the
line is, write your decision down, and live with it. That decision *is* the instrument.

**Do not use the star rating to decide the label, and do not put it in your coding
sheet.** It is tempting, since a one-star review probably contains a complaint. But star
rating is a control in your regression. If it informs your labels, you have built a
correlation between your outcome and a regressor, and that correlation will look exactly
like a finding.

Telling yourself not to look at a column printed next to the text is not a control. **Build
the coding sheet with `review_id` and `review_text` only, and rejoin the rating by
`review_id` after coding.** The same applies to anything else that ends up on the right
hand side of your regression. This costs one line in your sampling script and removes a
whole class of doubt about what your labels mean.

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

Very short reviews are excluded because "Great!" carries no complaint either way and
would inflate your accuracy for free.

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
- inclusion criteria: what counts as a service complaint
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

- prompt stored in `prompts/`, version-controlled, with model name and date
- **structured output** (JSON schema) so parsing does not silently fail
- store the **raw response**, not just the parsed label
- handle refusals and malformed output loudly, never by dropping the row

On sampling parameters: current frontier models no longer accept `temperature`, and
sending it returns an error. Do not set it. Determinism was never guaranteed by
`temperature = 0` anyway; what makes your run reproducible is versioning the prompt and
storing the raw responses.

Annotate **5,000 reviews** for the analysis sample, plus the 150 you labeled by hand.

**Budget.** With a mid-tier model this costs roughly **$12 through the standard API, or
$6 through the Batch API**. Use the Batch API: it is half price, nothing here is
latency-sensitive, and it avoids the rate-limit pileup when twenty of you fire several
thousand calls in the same week. On a frontier model the same run costs about five times
as much, which is not a good use of departmental funds for a classification task.

Test your prompt on 20 reviews before spending anything.

Two things that will surprise you. **Cost scales with the length of your coding
instructions**, because they are re-sent on every call. Adding six edge cases can double
your bill; measure your per-call token count after you finish writing them, not before.
And **prompt caching will not help you here** unless your instructions run past ~1,000
tokens, which is the minimum cacheable prefix on most mid-tier models. Below it, caching
fails silently: no error, and `cache_creation_input_tokens` stays 0.

### Part 4 — Validate

Against your 150 hand labels, report:

- the **confusion matrix** (not just accuracy)
- accuracy, precision, recall, F1
- **your human–human kappa** alongside the model–human kappa, so the ceiling is visible

Then answer, in prose: **on what kinds of reviews does the model get it wrong?** Read at
least fifteen of its errors. This is the most important paragraph in the assignment.
Vague answers here indicate you did not actually look.

**And the critical question:** is the error correlated with anything in your analysis?
Not "is it random", check. Compute the error rate separately by star rating and by elite
status. If the model is worse on 1-star reviews than 5-star, and rating is in your
regression, you have a problem that no amount of accuracy fixes.

Report how many validation cases sit in each cell when you do this. If one group has ten
reviews in it, an error rate of 0/10 tells you almost nothing: the upper end of its
confidence interval is around 30%. A test that cannot reject a difference is not evidence
that there is none, and the correction in Part 5 assumes there is none.

### Part 5 — Use it, twice

Estimate this:

```
service_complaint_i = β · elite_i + controls + ε_i
```

where `elite` = 1 if the reviewer holds Yelp Elite status. Include star-rating controls,
and cluster by business, think about where the variation is.

**On business fixed effects.** Do not include them, and be able to say why. Your 5,000
reviews are drawn from three million, so most businesses in your sample appear exactly
once. Check how many of your businesses have both an elite and a non-elite reviewer:
that is the only variation a within-business estimator can use. Report the number. A
specification that is nominally estimated but substantively empty is worth recognising
on sight.

**For context**, elite reviewers are 17.3% of the analysis population. Yelp awards the
status partly on review volume and quality, so it is assigned on the basis of writing
behaviour, plausibly including how people express dissatisfaction. That is an
identification problem, not a nuisance: say what it means for what you can claim.

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
