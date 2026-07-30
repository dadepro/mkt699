# ---------------------------------------------------------------
# Do higher-priced LA restaurants get better reviews?
# Has that relationship changed over time?
#
# RA draft. Produced with AI assistance.
# ---------------------------------------------------------------

library(DBI)
library(RMySQL)
library(dplyr)
library(lubridate)
library(fixest)
library(modelsummary)

con <- dbConnect(
  MySQL(),
  host     = Sys.getenv("MKT615_HOST"),
  dbname   = "mkt615",
  user     = Sys.getenv("MKT615_USER"),
  password = Sys.getenv("MKT615_PWD")
)

# ---------------------------------------------------------------
# 1. Pull the data
# ---------------------------------------------------------------

# Restaurants in LA
businesses <- dbGetQuery(con, "
  SELECT business_id, business_name, city, state, price_range,
         star_rating, review_count, categories, latitude, longitude
  FROM yelp_lacounty_businesses
  WHERE state = 'LA'
")

cat("businesses:", nrow(businesses), "\n")

# Reviews for those businesses, 2015 onward
reviews <- dbGetQuery(con, "
  SELECT review_id, business_id, user_id, review_date,
         review_rating, useful_votes
  FROM yelp_lacounty_reviews
  WHERE review_date >= '2015-01-01'
")

cat("reviews:", nrow(reviews), "\n")

dbDisconnect(con)

# ---------------------------------------------------------------
# 2. Clean
# ---------------------------------------------------------------

# Price: convert to a numeric scale
businesses <- businesses %>%
  mutate(
    price_num = case_when(
      price_range == "$"    ~ 1,
      price_range == "$$"   ~ 2,
      price_range == "$$$"  ~ 3,
      price_range == "$$$$" ~ 4
    ),
    lat = as.numeric(latitude),
    lon = as.numeric(longitude)
  )

# Keep restaurants only
businesses <- businesses %>%
  filter(grepl("Restaurants|Food", categories))

# Split categories out so we can control for cuisine type
cats <- businesses %>%
  tidyr::separate_rows(categories, sep = ", ") %>%
  select(business_id, category = categories)

# ---------------------------------------------------------------
# 3. Merge
# ---------------------------------------------------------------

df <- reviews %>%
  inner_join(businesses, by = "business_id") %>%
  left_join(cats, by = "business_id")

cat("merged:", nrow(df), "\n")

df <- df %>%
  mutate(
    year   = year(review_date),
    rating = as.numeric(review_rating),
    post   = ifelse(year >= 2018, 1, 0)
  )

df <- na.omit(df)

# ---------------------------------------------------------------
# 4. Analysis
# ---------------------------------------------------------------

# Does price predict rating, and did that change after 2018?
m1 <- feols(rating ~ price_num, data = df)
m2 <- feols(rating ~ price_num + post, data = df)
m3 <- feols(rating ~ price_num * post | city, data = df)

modelsummary(
  list("(1)" = m1, "(2)" = m2, "(3)" = m3),
  stars  = TRUE,
  output = "output/price_ratings.tex"
)

cat("\nDone. N =", nobs(m3), "\n")
