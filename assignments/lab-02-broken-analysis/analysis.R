# ---------------------------------------------------------------
# Do higher-priced LA restaurants get better reviews?
# Has that relationship changed over time?
#
# RA draft. Produced with AI assistance.
# ---------------------------------------------------------------

library(DBI)
library(RMySQL)
library(data.table)
library(stargazer)

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
businesses <- setDT(dbGetQuery(con, "
  SELECT business_id, business_name, city, state, price_range,
         star_rating, review_count, categories, latitude, longitude
  FROM yelp_lacounty_businesses
  WHERE state = 'LA'
"))

cat("businesses:", nrow(businesses), "\n")

# Reviews for those businesses, 2015 onward
reviews <- setDT(dbGetQuery(con, "
  SELECT review_id, business_id, user_id, review_date,
         review_rating, useful_votes
  FROM yelp_lacounty_reviews
  WHERE review_date >= '2015-01-01'
"))

cat("reviews:", nrow(reviews), "\n")

dbDisconnect(con)

# ---------------------------------------------------------------
# 2. Clean
# ---------------------------------------------------------------

# Price: convert to a numeric scale
businesses[, price_num := fcase(
  price_range == "$",    1,
  price_range == "$$",   2,
  price_range == "$$$",  3,
  price_range == "$$$$", 4
)]
businesses[, `:=`(lat = as.numeric(latitude), lon = as.numeric(longitude))]

# Keep restaurants only: drop bars and nightlife
businesses <- businesses[!grepl("Bars", categories)]

# Split categories out so we can control for cuisine type
cats <- businesses[, .(category = unlist(strsplit(categories, ", ", fixed = TRUE))),
                   by = business_id]

# ---------------------------------------------------------------
# 3. Merge
# ---------------------------------------------------------------

df <- merge(reviews, businesses, by = "business_id")
# needed for the category join to run
df <- merge(df, cats, by = "business_id", all.x = TRUE, allow.cartesian = TRUE)

cat("merged:", nrow(df), "\n")

df[, year   := year(as.IDate(review_date))]
df[, rating := as.numeric(review_rating)]

df <- na.omit(df)

# ---------------------------------------------------------------
# 4. Analysis
# ---------------------------------------------------------------

# Does price predict rating, and has that changed over time?
m1 <- lm(rating ~ price_num, data = df)
m2 <- lm(rating ~ price_num + I(year - 2015), data = df)
m3 <- lm(rating ~ price_num * I(year - 2015) + factor(city), data = df)

stargazer(m1, m2, m3, type = "text", omit = "city")

cat("\nDone. N =", nobs(m3), "\n")
