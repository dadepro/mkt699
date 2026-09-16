# Assignments — MKT 699, first half

| | Released | Due | Weight |
|:--|:--|:--|--:|
| [Lab 2, Find the bugs](lab-02-broken-analysis/) | | in class, Week 2 (Sep 2) | ungraded, participation |
| [Assignment 1, Reproducible data pipeline](assignment-01-pipeline.md) | Week 2 (Sep 2) | Week 4 (Sep 16) | 10% |
| [Assignment 2, Present one of the Week 5 papers](assignment-02-paper-presentation.md) | Week 4 (Sep 16) | in class, Week 5 (Sep 23) | 10% |

Assignment 1 is released after the lecture covering the material it needs, with two weeks
to do it. Assignment 2 is a paper presentation the week after it is assigned.

The semester project runs in parallel with its own weekly milestones, see the
[syllabus](../syllabus/).

## Data

Assignment 1 and Lab 2 use the Yelp LA County data on the course server:

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

The project's measurement step requires paid API access. Budget a few dollars with a
mid-tier model if you batch sensibly and test your prompt on a handful of documents first.
Talk to me before you spend anything if the cost is a constraint, there are departmental
funds.
