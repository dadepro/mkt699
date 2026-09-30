# One simulated dataset for the FWER vs FDR slides in Lecture 6.
#
# 50 review attributes tested for a difference between verified and unverified reviews.
# 20 truly differ (expected z of 3), 30 do not. The seed is one where both rules flag
# about their average number (Bonferroni 8, Benjamini-Hochberg 15).
#
# Run from this folder: Rscript fwer-fdr.R

library(ggplot2)

set.seed(155)
k <- 50; k1 <- 20; mu <- 3; alpha <- 0.05
z <- c(rnorm(k1, mu), rnorm(k - k1))
d <- data.frame(p = 2 * pnorm(-abs(z)),
                truth = c(rep("Truly differs", k1), rep("Does not differ", k - k1)))
d <- d[order(d$p), ]
d$rank <- seq_len(k)
d$bh_cut <- alpha * d$rank / k

n_bon <- sum(d$p < alpha / k)
n_bh <- max(which(d$p <= d$bh_cut))
cat(sprintf("Bonferroni flags %d (false: %d); BH flags %d (false: %d)\n",
            n_bon, sum(d$truth[1:n_bon] == "Does not differ"),
            n_bh, sum(d$truth[1:n_bh] == "Does not differ")))

show <- d[d$rank <= 30, ]
cols <- c("Truly differs" = "#1f4e79", "Does not differ" = "#c0392b")

p <- ggplot(show, aes(rank, p)) +
  annotate("rect", xmin = 0.5, xmax = n_bh + 0.5, ymin = min(show$p) / 2, ymax = 1,
           fill = "#e8f0f8") +
  annotate("rect", xmin = 0.5, xmax = n_bon + 0.5, ymin = min(show$p) / 2, ymax = 1,
           fill = "#c9dcee") +
  annotate("text", x = n_bon / 2 + 0.5, y = 0.2, label = "Bonferroni\nflags 8",
           size = 7.5, lineheight = 0.9) +
  annotate("text", x = (n_bon + n_bh) / 2 + 0.5, y = 0.2, label = "BH also\nflags 7 more",
           size = 7.5, lineheight = 0.9) +
  geom_hline(yintercept = alpha / k, linetype = "dashed", linewidth = 0.7) +
  geom_line(aes(y = bh_cut), linewidth = 0.7) +
  annotate("text", x = 30, y = alpha / k * 0.55, label = "Bonferroni cutoff: .001",
           hjust = 1, size = 7) +
  annotate("text", x = 30, y = alpha * 30 / k * 0.5, label = "BH cutoff: .001 × rank",
           hjust = 1, size = 7) +
  geom_point(aes(colour = truth), size = 4.5) +
  scale_colour_manual(values = cols, name = NULL, breaks = c("Truly differs", "Does not differ")) +
  scale_y_log10(limits = c(min(show$p) / 2, 1), expand = c(0, 0), breaks = c(1e-6, 1e-4, 1e-3, 1e-2, 0.05, 1),
                labels = c(".000001", ".0001", ".001", ".01", ".05", "1")) +
  scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 25, 30), expand = expansion(add = 0.3)) +
  labs(x = "Attributes sorted by p-value (first 30 of 50)",
       y = "p-value (log scale)") +
  theme_minimal(base_size = 25) +
  theme(panel.grid.minor = element_blank(), legend.position = "top",
        legend.justification = "left")

ggsave("fwer-fdr.png", p, width = 12, height = 6.2, dpi = 200, bg = "white")
