# Assignments — MKT 699, first half

| | Released | Due | Weight |
|:--|:--|:--|--:|
| [Lab 2, Find the bugs](lab-02-broken-analysis/) |, | in class, Week 2 (Sep 2) | ungraded, participation |
| [Assignment 1, Reproducible data pipeline](assignment-01-pipeline.md) | Week 2 (Sep 2) | Week 4 (Sep 16) | 10% |
| [Assignment 2, Measuring service complaints with an LLM](assignment-02-measurement.md) | Week 4 (Sep 16) | Week 6 (Sep 30) | 10% |

Each assignment is released after the lecture covering the material it needs, and you get
two weeks.

The semester project runs in parallel with its own weekly milestones, see the
[syllabus](../syllabus/).

## Data

All assignments use the Yelp LA County data on the course server:

```
host:     <given in class>   (USC network or VPN required)
database: mkt615
user:     <given in class>

yelp_lacounty_reviews      6,633,241 rows   2004-10-18 to 2020-07-09
yelp_lacounty_businesses      23,747 rows
airbnb_sample                200,000 rows   US listings, 26 cols, ~35MB
airbnb_rooms               2,940,771 rows   full scrape, 150 cols, ~20GB
zip_market                    11,398 rows   zip-level lookup (numeric key)
```

`airbnb_sample` is the teaching extract used in the Lecture 2 examples, small enough to
pull into memory on a laptop. `airbnb_rooms` is the full raw scrape; query it with a
`WHERE` clause and a column list, never `SELECT *`.

Reviews join to businesses on `business_id` with no orphans. `latitude`, `longitude`,
and `price_range` are stored as text; `categories` is a delimited blob; and `state`
does not mean what you would guess.

**Never commit the password.** Use `.Renviron` or an environment file, and put it in
`.gitignore`.

## API costs

Assignment 2 requires paid API access. Budget a few dollars with a mid-tier model if you
batch sensibly and test your prompt on a handful of reviews first. Talk to me before you
spend anything if the cost is a constraint, there are departmental funds.
