##########################################################################
#
# Author: Dariya K. Sydykova
##########################################################################

# load packages necessary to run the following script
library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(here)

# set up input file. Output plot files are generated automatically and are stored in /evolving_q_sim/test_plots
root_dir <- here() # get the directory of the root of the project

# this function calculates population fitness according to Sella and Hirsh's theory
# the function takes in as an argument size of the population (`Ne`), maximum number of mutations (`L`), selection coefficient (`s`), and epistasis coefficient (`eps`)
predict_mean_fitness <- function(Ne, L, s, eps)
{
  k <- c(0:L)
  f <- exp(-s*k^(1-eps))	
  p_k <- (f^(2*Ne-2)*choose(L, k))/sum(f^(2*Ne-2)*choose(L, k))
  sum(f*p_k)
}

# this function calculates population fitness for different values of epistasis coefficient.
w_vs_eps <- function(Ne, L, s, epsstart, epsstop, epssteps = 0.01)
{
  eps <- seq(epsstart, epsstop, epssteps)  
  w_ave <- vapply(eps, function(eps){predict_mean_fitness(Ne, L, s, eps)}, 1)
  data.frame(s, w_ave, Ne, L, eps)
}

# this function calculates population fitness for different sizes of population.
w_vs_Ne <- function(eps, L, s, Nestart, Nestop, Nesteps = 0.1) {
  Ne <- seq(Nestart, Nestop, Nesteps)
  w_ave <- vapply(Ne, function(Ne) {
    predict_mean_fitness(Ne, L, s, eps)
  }, 1)
  data.frame(s, w_ave, Ne, L, eps)
}

# set parameters to be used in numerical derivations
q <- 1
eps <- 1 - q
s <- 0.01
an_f1 <- w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

q <- 1.5
eps <- 1 - q
s <- 0.01
an_f2 <- w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

q <- 0.5
eps <- 1 - q
s <- 0.01
an_f3 <- w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

# combine all output
rbind(an_f1, an_f2, an_f3) -> an_f

# plot numerically calculated fitness for different N and q
p1 <- ggplot(an_f, aes(x = Ne, y = w_ave, color = factor(q))) +
  geom_line(size = 1, lineend = "round", linejoin = "round") +
  scale_color_manual(name = "q", values = c("#d3d4d8", "#3fbac2", "#4d606e")) +
  xlab("N") +
  ylab("Mean fitness") +
  scale_x_log10(limits = c(1, 1000), breaks = c(1, 10, 100, 1000), labels = c("1", "10", "100", "1000")) +
  coord_cartesian(ylim = c(0, 1)) +
  theme(
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    legend.text = element_text(size = 11),
    legend.title = element_text(size = 12)
  )

# set parameters to be used in numerical derivations
N <- 10
s <- 0.01
an_f1 <- w_vs_eps(N, 100, s, -1, 1) %>% mutate(q = 1 - eps)

N <- 50
s <- 0.01
an_f2 <- w_vs_eps(N, 100, s, -1, 1) %>% mutate(q = 1 - eps)

N <- 100
s <- 0.01
an_f3 <- w_vs_eps(N, 100, s, -1, 1) %>% mutate(q = 1 - eps)

# combine all output
rbind(an_f1, an_f2, an_f3) -> an_f

# plot numerically calculated fitness for different N and q
p2 <- ggplot(an_f, aes(x = q,y = w_ave)) +
  geom_line(
    aes(color = factor(Ne)), 
    size = 1.2, 
    lineend = "round", 
    linejoin = "round"
  ) +
  scale_color_manual(values = c("#f67280", "#c06c84", "#6c5b7c")) +
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  coord_cartesian(ylim = c(0, 1)) +
  xlab('q') +
  ylab('Mean fitness') +
  guides(col = guide_legend(title = "N",reverse = TRUE))

p <- plot_grid(p1, p2, labels = c("A", "B"))

# save the plot
save_plot(
  paste0(root_dir, "/evolving_q_sim/plots/theoretical_fitness_s", s, ".png"),
  p,
  base_height = 4,
  base_width = 9
)
