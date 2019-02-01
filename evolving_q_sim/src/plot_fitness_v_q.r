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
p <- ggplot(an_f, aes(x = q,y = w_ave)) +
  geom_line(
    aes(color = factor(Ne)), 
    size = 1.2, 
    lineend = "round", 
    linejoin = "round"
  ) +
  scale_color_manual(values = c("#f67280", "#c06c84", "#6c5b7c")) +
  scale_y_continuous(breaks = seq(0, 1, 0.2)) +
  coord_cartesian(ylim = c(0.3, 1)) +
  xlab('q') +
  ylab('Mean fitness') +
  guides(col = guide_legend(title = "N",reverse = TRUE))

# save the plot
save_plot(
  paste0(
    root_dir, 
    "/evolving_q_sim/plots/fitness_v_q_s", 
    s,
    ".png"
  ), 
  p
)