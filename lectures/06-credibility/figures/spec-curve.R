# Specification curve for Lecture 6.
#
# Data: Jung, Shavitt, Viswanathan & Hilbe (2014), "Female hurricanes are deadlier
# than male hurricanes," PNAS 111(24):8782-8787. 92 Atlantic hurricanes that made
# U.S. landfall, 1950-2012, excluding Katrina and Audrey as in the original paper.
# Copied from the DHARMa R package (data/hurricanes.rda) into hurricanes.csv.
#
# Simonsohn, Simmons & Nelson (2020, Nature Human Behaviour) use the same data as
# their worked example. This is a smaller curve built for the slides: 128
# specifications from seven binary choices.
#
# Run from this folder: Rscript spec-curve.R

library(MASS)
library(ggplot2)
library(patchwork)

d <- read.csv("hurricanes.csv")
d$female <- d$Gender_MF
d$log_ndam <- log(d$NDAM + 1)
d$log_deaths <- log(d$alldeaths + 1)

# The claim in Jung et al. is about damaging storms (their key term is femininity x
# damage), so every specification is evaluated for a storm at the 90th percentile of
# damage in the full sample. Without the interaction the % effect is the same at every
# damage level, so this matters only for the interaction specifications.
d90 <- quantile(d$NDAM, 0.9)

grid <- expand.grid(
  fem      = c("Femininity index", "Female name (0/1)"),
  model    = c("Negative binomial", "OLS, log(1 + deaths)"),
  damage   = c("Damage in levels", "Damage in logs"),
  inter    = c("Femininity x damage", "No interaction"),
  pressure = c("Pressure control", "No pressure control"),
  deadly   = c("All storms", "Drop 4 with 100+ deaths"),
  years    = c("1950-2012", "1979-2012"),
  stringsAsFactors = FALSE
)

estimate <- function(s) {
  x <- d
  if (s$deadly == "Drop 4 with 100+ deaths") x <- x[x$alldeaths <= 100, ]
  if (s$years == "1979-2012") x <- x[x$Year >= 1979, ]

  fem_var <- if (s$fem == "Femininity index") "MasFem" else "female"
  dmg_var <- if (s$damage == "Damage in levels") "NDAM" else "log_ndam"
  dmg_at  <- if (s$damage == "Damage in levels") d90 else log(d90 + 1)
  rhs <- c(fem_var, dmg_var)
  if (s$pressure == "Pressure control") rhs <- c(rhs, "Minpressure_Updated_2014")
  int_var <- paste0(fem_var, ":", dmg_var)
  if (s$inter == "Femininity x damage") rhs <- c(rhs, int_var)

  if (s$model == "Negative binomial") {
    m <- glm.nb(reformulate(rhs, "alldeaths"), data = x,
                control = glm.control(maxit = 200))
    df <- Inf
  } else {
    m <- lm(reformulate(rhs, "log_deaths"), data = x)
    df <- m$df.residual
  }
  b <- coef(m); V <- vcov(m)
  # Effect of femininity at the evaluation damage level, and its standard error
  w <- setNames(rep(0, length(b)), names(b))
  w[fem_var] <- 1
  if (s$inter == "Femininity x damage") w[int_var] <- dmg_at
  g <- sum(w * b)
  se <- sqrt(as.numeric(t(w) %*% V %*% w))
  p <- 2 * pt(-abs(g / se), df)

  # Put every specification on one scale: the % difference in deaths between a
  # female-named and a male-named storm. For the index, scale by the gap in mean
  # femininity between female- and male-named storms in the sample.
  gap <- if (fem_var == "MasFem") {
    mean(x$MasFem[x$female == 1]) - mean(x$MasFem[x$female == 0])
  } else 1
  to_pct <- function(v) 100 * (exp(v * gap) - 1)

  data.frame(s, n = nrow(x), est = to_pct(g),
             lo = to_pct(g - 1.96 * se), hi = to_pct(g + 1.96 * se), p = p)
}

res <- do.call(rbind, lapply(seq_len(nrow(grid)), function(i) estimate(grid[i, ])))
res <- res[order(res$est), ]
res$rank <- seq_len(nrow(res))
res$sig <- ifelse(res$p < 0.05, "p < .05", "p ≥ .05")

write.csv(res, "spec-curve-estimates.csv", row.names = FALSE)

cat(sprintf("specifications: %d\n", nrow(res)))
cat(sprintf("positive: %d; significant at 5%%: %d (all positive: %s)\n",
            sum(res$est > 0), sum(res$p < 0.05), all(res$est[res$p < 0.05] > 0)))
cat(sprintf("median estimate: %.0f%%; range %.0f%% to %.0f%%\n",
            median(res$est), min(res$est), max(res$est)))
cat("\nsignificant share by choice:\n")
for (v in c("fem", "model", "damage", "inter", "pressure", "deadly", "years")) {
  print(tapply(res$p < 0.05, res[[v]], function(z) sprintf("%d of %d", sum(z), length(z))))
}

# The specification closest to the model in Jung et al. (they also interact
# femininity with pressure, which this grid does not)
res$paper <- with(res, fem == "Femininity index" & model == "Negative binomial" &
  damage == "Damage in levels" & inter == "Femininity x damage" &
  pressure == "Pressure control" & deadly == "All storms" & years == "1950-2012")

cols <- c("p < .05" = "#1f4e79", "p ≥ .05" = "#9a9a9a")
ymax <- 600  # two intervals extend beyond this and are truncated in the figure

top <- ggplot(res, aes(rank, est, colour = sig)) +
  geom_hline(yintercept = 0, linewidth = 0.5) +
  geom_linerange(aes(ymin = lo, ymax = pmin(hi, ymax)), linewidth = 0.7, alpha = 0.6) +
  geom_point(size = 2.4) +
  geom_point(data = res[res$paper, ], shape = 21, size = 6, stroke = 1.2,
             colour = "#b03a2e", fill = NA) +
  annotate("text", x = res$rank[res$paper] - 7, y = res$est[res$paper] + 170,
           label = "Closest to the\npublished model", hjust = 1, size = 5.5,
           colour = "#b03a2e", lineheight = 0.9) +
  scale_colour_manual(values = cols, name = NULL) +
  scale_x_continuous(expand = expansion(add = 0.8)) +
  coord_cartesian(ylim = c(-60, ymax)) +
  labs(x = NULL, y = "Female vs male name:\n% difference in deaths") +
  theme_minimal(base_size = 19) +
  theme(axis.text.x = element_blank(), panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(), legend.position = c(0.1, 0.85),
        legend.background = element_rect(fill = "white", colour = NA))

long <- do.call(rbind, lapply(c("fem", "model", "damage", "inter", "pressure", "deadly", "years"),
  function(v) data.frame(rank = res$rank, sig = res$sig, choice = res[[v]], group = v)))
long$choice <- factor(long$choice, levels = rev(c(
  "Femininity index", "Female name (0/1)",
  "Negative binomial", "OLS, log(1 + deaths)",
  "Damage in levels", "Damage in logs",
  "Femininity x damage", "No interaction",
  "Pressure control", "No pressure control",
  "All storms", "Drop 4 with 100+ deaths",
  "1950-2012", "1979-2012")))

bottom <- ggplot(long, aes(rank, choice, colour = sig)) +
  geom_point(shape = 15, size = 2.2) +
  scale_colour_manual(values = cols, guide = "none") +
  scale_x_continuous(expand = expansion(add = 0.8)) +
  labs(x = "128 specifications, sorted by estimate", y = NULL) +
  theme_minimal(base_size = 19) +
  theme(axis.text.x = element_blank(), panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank())

p <- top / bottom + plot_layout(heights = c(1, 1.15))
ggsave("spec-curve.png", p, width = 13, height = 7.6, dpi = 200, bg = "white")
