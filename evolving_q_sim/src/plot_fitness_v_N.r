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

# this function calculates population fitness for different sizes of population.
w_vs_Ne <- function(eps, L, s, Nestart, Nestop, Nesteps = 0.1)
{
  Ne <- seq(Nestart, Nestop, Nesteps)  
  w_ave <- vapply(Ne, function(Ne){predict_mean_fitness(Ne, L, s, eps)}, 1)
  data.frame(s, w_ave, Ne, L, eps)
}

# set parameters to be used in numerical derivations
q <- 1
eps <- 1-q
s <- 0.01
an_f1 <-w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

q <- 1.5
eps <- 1-q
s <- 0.01
an_f2 <-w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

q <- 0.5
eps <- 1-q
s <- 0.01
an_f3 <-w_vs_Ne(eps, 100, s, 0, 1000) %>% mutate(q = q)

rbind(an_f1, an_f2, an_f3) -> an_f

# plot numerically calculated fitness for different N and q
p <- ggplot(an_f, aes(x = Ne, y = w_ave, color = factor(q))) + 
  geom_line(size = 1, lineend = "round", linejoin = "round") +
  scale_color_manual(name = "q", values = c("#d3d4d8", "#3fbac2", "#4d606e")) +
  xlab('N') +
  ylab('Mean fitness') +
  scale_x_log10(limits = c(1, 1000), breaks = c(1, 10, 100, 1000), labels = c("1", "10", "100", "1000")) +
  scale_y_continuous(limits = c(0, 1)) +
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12))

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/plots/fitness_v_N_s", s, "_A.png"), 
          p)
