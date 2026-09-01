# Lecture 2 -- follow-along code
#
# Every example from the deck, in slide order, runnable end to end.
# Comments give the number the slide shows, so you can check you got the
# same thing.
#
# Data: the script uses the course MySQL server when MKT615_* variables are
# set (see .Renviron; VPN required), and otherwise falls back to the parquet
# copies shipped in the repo, so it runs from a clean clone with no server.
#
# Run from anywhere:  Rscript lectures/02-ai-verification/02-examples.R

suppressPackageStartupMessages({
  library(data.table)
  library(DBI)
})

# ---- set the working directory to the repo root -----------------------------
# Works under Rscript, source(), and running line-by-line in RStudio/VS Code.
find_script <- function() {
  a <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(a)) return(sub("^--file=", "", a))               # Rscript
  for (f in rev(sys.frames())) {                              # source()
    if (!is.null(f$ofile)) return(f$ofile)
  }
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {                            # RStudio editor
    pth <- tryCatch(rstudioapi::getSourceEditorContext()$path,
                    error = function(e) "")
    if (nzchar(pth)) return(pth)
  }
  NULL
}
script <- find_script()
root <- if (!is.null(script)) {
  normalizePath(file.path(dirname(script), "..", ".."))
} else {
  # last resort: walk up from the current directory to the repo root
  d <- normalizePath(".")
  while (!dir.exists(file.path(d, "data", "airbnb_parquet")) &&
         d != dirname(d)) d <- dirname(d)
  d
}
if (!dir.exists(file.path(root, "data", "airbnb_parquet")))
  stop("cannot find the repo root -- run this from inside the mkt699 repo")
setwd(root)
cat("working directory:", getwd(), "\n")

# ---- Slide: Everything from here runs ---------------------------------------
use_mysql <- nzchar(Sys.getenv("MKT615_HOST")) && nzchar(Sys.getenv("MKT615_PWD"))
if (use_mysql) {
  ok <- tryCatch({
    Sys.setenv(MARIADB_TLS_DISABLE_PEER_VERIFICATION = 1)
    con <- dbConnect(RMySQL::MySQL(),
                     host     = Sys.getenv("MKT615_HOST"),
                     dbname   = "mkt615",
                     user     = Sys.getenv("MKT615_USER"),
                     password = Sys.getenv("MKT615_PWD"))
    listings   <- setDT(dbGetQuery(con, "SELECT * FROM airbnb_sample"))
    zip_market <- setDT(dbGetQuery(con, "SELECT * FROM zip_market"))
    dbDisconnect(con)
    TRUE
  }, error = function(e) { message("MySQL unreachable (", conditionMessage(e),
                                   "); falling back to parquet."); FALSE })
  use_mysql <- ok
}
if (!use_mysql) {
  library(duckdb)
  con <- dbConnect(duckdb())
  listings   <- setDT(dbGetQuery(con,
    "SELECT * FROM 'data/airbnb_parquet/listings_0*.parquet'"))
  zip_market <- setDT(dbGetQuery(con,
    "SELECT * FROM 'data/airbnb_parquet/zip_market.parquet'"))
  dbDisconnect(con, shutdown = TRUE)
}

# Row order differs between the MySQL and parquet loads. Every number below
# matches either way; only order-dependent displays (head(), ties in sorted
# tables) may show the same rows in a different order than the slide.
print(dim(listings))     # slide: [1] 200000     26
print(dim(zip_market))   # slide: [1]  11398      5

# both keys arrive as zero-padded character; the whole zip section relies on it
stopifnot(is.character(listings$zipcode), is.character(zip_market$zip))

# ---- Slide: Many-to-many ----------------------------------------------------
hosts <- listings[, .(host_id, city, state)]   # <- looks per-host. is not.

try(  # slide: Error ... 2201094 rows; more than 400000 = nrow(x)+nrow(i)
  panel <- merge(listings, hosts, by = "host_id", all.x = TRUE)
)

# ---- Slide: Why it happened -------------------------------------------------
print(nrow(listings))                # slide: 200,000
print(uniqueN(listings$host_id))     # slide: 138,635

# ---- Slide: Many-to-many, continued -----------------------------------------
hosts <- listings[, .(n_listings = .N), by = host_id]
stopifnot(!any(duplicated(hosts$host_id)))
panel <- merge(listings, hosts, by = "host_id", all.x = TRUE)
stopifnot(nrow(panel) == nrow(listings))

# ---- Slide: The inner join that eats your sample ----------------------------
quality <- listings[!is.na(review_rating_cleanliness),
                    .(listing_id, review_rating_cleanliness,
                      review_rating_location, review_rating_value)]
panel <- merge(listings, quality, by = "listing_id")   # inner
print(nrow(panel))                                     # slide: [1] 69616

# ---- Slide: Why this one is dangerous ---------------------------------------
print(listings[, mean(price, na.rm = TRUE)])   # slide: 195.69
print(panel[,    mean(price, na.rm = TRUE)])   # slide: 177.19

# ---- Slide: Say what you did ------------------------------------------------
# the pattern, on a copy so later numbers still match the deck
listings_active <- listings[reviews_count > 0]
cat(sprintf("filter reviews_count > 0 dropped %d of %d rows\n",
            nrow(listings) - nrow(listings_active), nrow(listings)))

# ---- Slide: Key type mismatches ---------------------------------------------
print(class(listings$zipcode))    # slide: "character"
print(class(zip_market$zip))      # slide: "character"

# correct: both sides character
m_ok <- merge(listings, zip_market, by.x = "zipcode", by.y = "zip")

# but suppose an earlier line already coerced one side:
listings[, zipcode_chr := zipcode]        # keep a copy BEFORE coercing
listings[, zipcode := as.numeric(zipcode)]

try(  # slide: Error in bmerge(...) typeof x.zipcode (double) != i.zip (character)
  merge(listings, zip_market, by.x = "zipcode", by.y = "zip")
)

# ---- Slide: what coercion did to the zeros ----------------------------------
print(listings[zipcode_chr %chin% c("01966", "02909", "07093"),
               .(city, state, zipcode_chr, zipcode)])
# slide: 07093 -> 7093, 01966 -> 1966

# ---- Slide: It is worse than leading zeros ----------------------------------
print(head(listings[grepl("[^0-9]", zipcode_chr), zipcode_chr]))
# slide: ZIP+4 ("62621-8070"), trailing spaces ("10128 "), garbage ("2661 0271")

# undo the damage; the rest of the script needs the character key
listings[, zipcode := zipcode_chr]

# ---- Slide: Keys that are almost the same -----------------------------------
print(uniqueN(listings$state))    # slide: [1] 116

# ---- Slide: Look at what is in there ----------------------------------------
print(listings[nchar(state) != 2 | state != toupper(state),
               .N, by = state][order(-N)])
# slide: Mt 35 (case, not spelling), empties, "California", ...

# ---- Slide: The fix, and the assertion --------------------------------------
listings[, state := toupper(trimws(state))]

# Slide: "That assertion fails on this data. Good. That is the point."
# toupper/trimws fixes case and whitespace, but "California" and friends
# are still in there, and the assertion catches them.
try(stopifnot(all(nchar(listings$state) == 2)))

# ---- Slide: Where to put them -----------------------------------------------
stopifnot(!any(duplicated(zip_market$zip)))
stopifnot(!any(is.na(zip_market$zip)))

n_before <- nrow(listings)
panel <- merge(listings, zip_market,
               by.x = "zipcode", by.y = "zip", all.x = TRUE)
stopifnot(nrow(panel) == n_before)
cat(sprintf("zip merge matched %.1f%% of rows\n",
            100 * panel[, mean(!is.na(mean_price))]))

# ---- Slide: More assertions worth writing -----------------------------------
if (requireNamespace("fixest", quietly = TRUE)) {
  m <- fixest::feols(price ~ instant_bookable | city, panel, cluster = ~host_id)
  cat(sprintf("feols used %d of %d rows\n", nobs(m), nrow(panel)))
  # The slide's assertion, and on this data it FAILS: feols silently drops
  # NA rows and fixed-effect singletons. That is the assertion doing its
  # job -- you now know your estimation sample is not nrow(panel).
  try(stopifnot(nobs(m) == nrow(panel)))
} else message("fixest not installed; skipping the regression assertion")

stopifnot(!any(duplicated(panel$listing_id)))

# is instant_bookable really a host-level choice, as you assumed?
print(panel[!is.na(instant_bookable),
            .(k = uniqueN(instant_bookable)), by = host_id][, .N, by = k][order(k)])
# slide: k=1 125,052 hosts; k=2 2,785 hosts set it BOTH ways

# drop the !is.na() and uniqueN() counts NA as a level, inventing k = 3
print(panel[, .(k = uniqueN(instant_bookable)), by = host_id][, .N, by = k][order(k)])

# ---- Slide: duckdb is the one to learn --------------------------------------
library(duckdb)
con <- dbConnect(duckdb())
print(dbGetQuery(con, "
  SELECT state, room_type, COUNT(*) AS n, AVG(price) AS mean_price
  FROM 'data/airbnb_parquet/listings_0*.parquet'
  WHERE price > 0
  GROUP BY state, room_type
  ORDER BY n DESC
  LIMIT 5"))
dbDisconnect(con, shutdown = TRUE)

cat("\ndone: every example ran.\n")
