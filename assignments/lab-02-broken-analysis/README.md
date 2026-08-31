# Lecture 2 Lab — Find the Bugs

**In-class, Week 2. Work individually.**

---

## The situation

A research assistant was asked the following question:

> **Do higher-priced restaurants in Los Angeles receive systematically more
> favorable reviews, and has that relationship changed over time?**

They had access to the Yelp LA County database. They used an AI coding assistant. They
produced `analysis.R`, which is in this directory.

The script **runs without error**. It produces a clean regression table. The RA sent it
to you with the message "results attached, the price effect is significant."

---

## Your job

Find what is wrong with it.

There are **at least six** distinct errors. Some change the estimate a little. At least
two change it enough to reverse the interpretation. One of them means the analysis is
answering a different question than the one that was asked.

---

## Rules

**Do not open this with an AI assistant and type "find the bugs."** You will get a list,
some of it wrong, and you will learn nothing. That is not the exercise, and I will be
walking around.

You may use an AI assistant to *explain what a line does* if you do not recognize the
syntax. That is a legitimate use and I encourage it.

---

## How to work through it

Use the order from lecture. It is the order of how badly things go wrong:

1. **Sample size.** Print `nrow()` after every single step. Where does it change, and by
   how much? Does any change surprise you?
2. **Merges.** For each join: what is the key? Is it unique on both sides? Did rows
   multiply or disappear?
3. **Specification.** Does the regression estimate what the question asked for? Are the
   variables what their names claim?
4. **Standard errors.** At what level does treatment vary? Is that where clustering
   happens?

Work in that order. Do not skip ahead to the regression because it looks interesting: by
the time you get to the specification, the damage is usually already done.

---

## Setting up

```bash
cp .Renviron.example .Renviron
# fill in host, user, and password (given in class)
```

```r
renv::restore()
source("analysis.R")
```

The script pulls from MySQL directly. It takes about a minute.

---

## What to have by the debrief

We go through the script together at the end of class. Have notes, in whatever form
helps you talk through it:

**For each bug you found:**
- the line number
- what is wrong
- which failure mode from lecture it is
- **which direction it biases the estimate**, and how you know

That last item is the one that matters. "The join is wrong" is an observation.
"The join duplicates reviews for multi-category businesses, which over-weights
restaurants that are also bars, and those skew expensive. So the price coefficient is
biased upward" is a finding.

**Then, the part that matters most:**

Rewrite the script's first thirty lines with assertions that would have caught these
errors automatically. Not comments describing the problems, but running code that stops
execution when the data is not what you assumed.

The assertions matter more than the bug list. Anyone can find a bug once it is pointed
out. Writing the check that finds it next time is the skill, and it is exactly what
Assignment 1 grades.

---

## A note before you start

This script is not a strawman. I did not write bad code on purpose to make a point.

The failure modes in it are the ones I actually see in submitted papers, in replication
packages, and in my own work when I am not careful. Two of them I have personally
shipped in a draft that went to coauthors.

The reason this is doable in an hour is that you have been told there are bugs. Nobody
tells you that in real life.
