library(tidyverse)
library(cowplot)

f <- function(L, s, q, k){exp(-s*k**q)}
p_num <- function(L, s, N, q, k){choose(L, k)*f(L, s, q, k)**(2*N-1)}
Z <- function(L, s, N, q){sum(p_num(L, s, N, q, 0:L))}
fave <- function(L, s, N, q){sum(f(L, s, q, 0:L)*p_num(L, s, N, q, 0:L))/Z(L, s, N, q)}

# assume p(k) independent of f(k) (i.e., no selection)
p_num2 <- function(L, s, N, q, k){choose(L, k)}
Z2 <- function(L, s, N, q){sum(p_num2(L, s, N, q, 0:L))}
fave2 <- function(L, s, N, q){sum(f(L, s, q, 0:L)*p_num2(L, s, N, q, 0:L))/Z2(L, s, N, q)}

# assume k <= kmax only (limited drift)
Z3 <- function(L, s, N, q, kmax){sum(p_num(L, s, N, q, 0:kmax))}
fave3 <- function(L, s, N, q, kmax){sum(f(L, s, q, 0:kmax)*p_num(L, s, N, q, 0:kmax))/Z3(L, s, N, q, kmax)}

# predicted q with minimum f_ave
qmin <- function(s, N){log(L*log(2)/(2*s*N))/log(L/2)}

make_fig <- function(L, s, N) {
  q <- seq(0, 3, .01)
  df <- data.frame(
    q = q,
    full_model = vapply(q, function(x) fave(L, s, N, x), numeric(1)),
    no_selection = vapply(q, function(x) fave2(L, s, N, x), numeric(1)),
    limited_drift = vapply(q, function(x) fave3(L, s, N, x, 20), numeric(1))
  ) %>% gather(formula, f_ave, -q)

  ggplot(df, aes(q, f_ave, color = formula)) +
    geom_line() + geom_vline(xintercept = qmin(s, N), linetype = 2) +
    draw_text(x = qmin(s, N) + .02, y = fave(L, s, N, qmin(s, N)), hjust = 0, vjust = 1, text = "predicted q*", size = 12) +
    labs(title = paste0("L = ", L, ", s = ", s, ", N = ", N)) +
    theme(plot.title = element_text(hjust = 0))
}

p1 <- make_fig(L = 1000, s = 0.0001, N = 1000)
p2 <- make_fig(L = 1000, s = 0.01, N = 100)
p3 <- make_fig(L = 100, s = 0.001, N = 1000)
p4 <- make_fig(L = 100, s = 0.01, N = 100)
plot_grid(p1, p2, p3, p4)
