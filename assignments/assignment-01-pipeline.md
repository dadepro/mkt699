# Assignment 1 — A Reproducible Data Pipeline

**Released** Week 2 (Sep 2) · **Due** Week 4 (Sep 16), start of class

**Weight:** 10% of the first-half grade

---

## The point of this assignment

You are going to pull real data out of a database, clean it, and produce a small set of
descriptive results. That part is easy, and a model will do most of it for you.

The part being graded is whether someone else can **run what you built and get the same
numbers**. That is the actual skill, and it is the one that will still matter to you in
five years.

A submission that produces beautiful results but cannot be re-run is worth less than a
submission with modest results that runs perfectly from a clean clone.

---

## The data

MySQL on the course server:

```
host:     <given in class>
database: mkt615
tables:   yelp_lacounty_reviews      (~6.6M rows)
          yelp_lacounty_businesses   (~23.7k rows)
```

Credentials will be distributed in class. **They do not go in your repository**, see
the section on secrets below.

`yelp_lacounty_reviews` is one row per review: `review_id`, `business_id`, `user_id`,
`review_date`, `review_text`, `review_rating`, `useful_votes`, `funny_votes`,
`cool_votes`, `check_in`.

`yelp_lacounty_businesses` is one row per business: `business_id`, `business_name`,
`address`, `city`, `state`, `zip`, `latitude`, `longitude`, `price_range`,
`star_rating`, `review_count`, `categories`, `open`, `business_url`.

Reviews span roughly 2004 to mid-2020.

---

## What to do

### 1. Extract

Pull a working sample from MySQL. You do **not** need all 6.6 million reviews, decide
on a sample, and **state the rule you used**. "Reviews from restaurants in Los Angeles
with at least 20 reviews, 2015–2019" is a rule. "About 100k reviews" is not.

Write the raw pull to disk once. Do not re-query the database every time you run your
analysis.

### 2. Clean

Merge reviews to businesses and build an analysis dataset. Along the way you will hit
real problems. Some of what is in this data:

- `price_range` is encoded in **two incompatible schemes** in the same column
- `latitude`, `longitude`, and `price_range` are stored as text, not numbers
- `categories` is a delimited blob, not a normalized table
- the `city` and `state` fields contain values that will surprise you

I am not going to tell you what the surprises are. Finding them is the assignment.

### 3. Describe

Produce **three** exhibits, any mix of tables and figures, that describe something
substantive about this data. Not summary statistics for their own sake: pick a question
and show me something about it.

Each exhibit needs one or two sentences interpreting what it shows.

### 4. Make it reproducible

This is the graded part.

---

## Requirements

Your repository must satisfy all of the following.

**Structure.** Use the layout from Lecture 1:

```
├── README.md
├── data/
│   ├── raw/        # written once, never edited
│   └── clean/      # generated, disposable
├── code/
│   ├── 01-extract.R
│   ├── 02-clean.R
│   └── 03-describe.R
├── output/
│   ├── figures/
│   └── tables/
└── ai-log.md
```

**A master script.** One file that runs everything in order. I should be able to clone
your repo and run a single command.

**Deletability.** I will delete `data/clean/` and `output/` entirely and re-run. Both
must rebuild. If anything you submit depends on a step you performed by hand and did not
script, you will find out this way.

**Assertions.** Every join and every filter must be checked. At minimum:

```r
stopifnot(nrow(merged) == nrow(reviews))       # no row multiplication
stopifnot(!any(duplicated(merged$review_id)))  # key is unique
stopifnot(nrow(analysis) == expected_n)        # sample is what you think
```

Report how many rows each filter removed. A filter that silently drops 400,000
observations is the most common way this assignment goes wrong.

**No secrets in the repository.** Database credentials go in `.Renviron` or an
environment file, which goes in `.gitignore`. If I find a password in your commit
history, that is an automatic fail on this assignment, not because I am strict, but
because this is the single most consequential habit in the course.

**Environment.** Commit a lockfile: `renv.lock` for R, `uv.lock` for Python.

**A README** that states: what the project does, how to run it, what the sample
restriction is, and where the data came from. Assume the reader is a referee, not a
classmate.

**An AI-use log** (`ai-log.md`) recording what tools you used, for what, and, this part
matters, anything an AI tool got wrong that you caught. Reporting a caught error helps
your grade. It is evidence you were checking.

---

## Grading

| | Points |
|:--|--:|
| Runs from a clean clone, rebuilds after deletion | 30 |
| Assertions present and meaningful | 20 |
| Sample rule stated and correctly implemented | 15 |
| Data problems identified and handled sensibly | 15 |
| Three exhibits, interpreted | 10 |
| README and provenance documentation | 5 |
| AI-use log | 5 |

**Note the weighting.** Half the grade is reproducibility and assertions.

---

## How to submit

Push to your own GitHub repository, add `dadepro` as a collaborator, and send me the
URL.

Before you submit, do this:

```bash
cd /tmp
git clone <your repo url> test-clone
cd test-clone
# now run it
```

If it fails, it fails for me too. Most submissions that lose points on this assignment
lose them here, and every one of those failures was findable in five minutes.

---

## A warning about how to use AI on this

Use it. That is the point of the course. But this assignment is specifically designed so
that the parts a model is good at (writing the SQL, writing the `ggplot` call) are
worth 10 points, and the parts it is bad at are worth 65.

A model will not tell you that your merge multiplied rows. It will not notice that your
sample rule and your `filter()` call disagree. It will not know that `state = 'LA'` in
this data does not mean what you assume.

That is your job. That is the whole assignment.
