# Course data

## `airbnb_parquet/`

A parquet export of `mkt615.airbnb_sample`, shipped in the repo so the DuckDB examples in
Lecture 3 run without a database connection.

```
listings_00.parquet   ~1.8 MB
listings_01.parquet   ~1.8 MB
listings_02.parquet   ~1.8 MB
listings_03.parquet   ~1.8 MB
                      ─────────
                        6.9 MB   200,000 rows, 26 columns
```

Four shards rather than one file so the `*.parquet` glob in the lecture is meaningful —
DuckDB reads them as a single table.

```r
library(duckdb)
con <- dbConnect(duckdb())

dbGetQuery(con, "
  SELECT state, room_type, COUNT(*) AS n, AVG(price) AS mean_price
  FROM 'data/airbnb_parquet/*.parquet'
  WHERE price > 0
  GROUP BY state, room_type
  ORDER BY n DESC
")
```

**Types are preserved**, which is the point of parquet over CSV. `zipcode` is `VARCHAR`,
so `05356` survives the round trip instead of becoming `5356`. The same data as CSV is
28.5 MB; as parquet it is 7.2 MB.

Regenerated from MySQL with:

```sql
SELECT listing_id, host_id, name, city, state, zipcode, country_code,
       lat, lng, room_type, property_type, bedrooms, bathrooms, beds,
       person_capacity, price, cleaning_fee_native, min_nights,
       reviews_count, star_rating, review_rating_cleanliness,
       review_rating_location, review_rating_value, instant_bookable,
       is_location_exact, requires_license
FROM airbnb_sample
```

then sharded on `listing_id % 4` and written with zstd compression. Text fields are
stripped of embedded tabs and newlines: the raw scrape has both, in `name`, `city`, and
`zipcode`.

Everything else lives in the `mkt615` database on the course server; see
[assignments/README.md](../assignments/README.md).
