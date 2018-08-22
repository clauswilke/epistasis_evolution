library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

# read in simulation output for evolved q
t <- read.csv("../processed_results/evolved_q_prob0.csv")

t %>% group_by(q_start, rep) %>% 
  summarise(mean_sim_fitness = mean(mean_fitness)) %>%
  mutate(q_mode = "evolved") -> t_evolved

# read in simulation output for fixed q
t_N100 <- read_csv("../../fixed_q_sim/processed_results/varying_eps_N100_max1.csv")

t_N100 %>% mutate(q_start = 1-epistasis_coef) %>% 
  filter(sel_coef == 0.001, mu_prob == 0.0001) %>%
  group_by(q_start, rep) %>% #one mean per simulation
  summarise(mean_sim_fitness = mean(mean_fitness)) %>%
  mutate(q_mode = "fixed") -> t_fixed

rbind(t_fixed, t_evolved) -> t

p <- t %>%
  ggplot(aes(x = q_start, y = mean_sim_fitness, color = q_mode)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4) +
  scale_y_continuous(name = "fitness",
                     limits = c(0, 1.05),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 1.05, hjust = 0, vjust = 0, text = "p = 0, s = 0.001, mu = 0.0001, N = 100", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


save_plot("../plots/fitness_fixed_v_evolved_q.png", p,
          # each individual subplot should have an aspect ratio of 1.3
          base_height=5,
          base_width=6)