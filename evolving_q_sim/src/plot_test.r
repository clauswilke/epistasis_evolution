##########################################################################
# This script plots evolutionary trajectories over time. It will produde #
# two plots: mean fitness over replicate populations over time, and mean #
# epistatis over replicate populations over time.                        #
#                                                                        #  
# Author: Dariya K. Sydykova                                             #
##########################################################################

# load packages necessary to run the following script
library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)
library(here)

# set up input file. Output plot files are generated automatically and are stored in /evolving_q_sim/test_plots
root_dir <- here() # get the directory of the root of the project
infile <- paste0(root_dir, "/evolving_q_sim/processed_results/evolved_q_mu0.01.csv") # data frame that contains simulation results for the plot

# read in simulation output for evolving q
t <- read_csv(infile, col_types = cols(
  time = col_integer(),
  sel_coef = col_double(),
  mu_prob = col_double(),
  Ne = col_integer(),
  L = col_integer(),
  k_start = col_integer(),
  q_start = col_double(),
  q_prob = col_double(),
  q_step = col_double(),
  mean_fitness = col_double(),
  mean_q = col_double(),
  rep = col_character(),
  q_prob_label = col_character()
))

# extract output for less time points to reduce the data frame
times_wanted <- seq(0, max(t$time), 100000)
t %>% filter(time %in% times_wanted) -> t_filtered

# calculate mean fitness over replicates and mean epistasis (q) over replicates
t_filtered %>% group_by(q_prob_label, q_start, q_step, time) %>% 
  summarise(mean_fitness_over_rep = mean(mean_fitness), mean_q_over_rep = mean(mean_q)) -> t_final

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot fitness over time for different start points of q and k
p_fitness <- t_final %>%
  ggplot(aes(x = time, y = mean_fitness_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step~q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name = "starting q")

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/fitness_v_time.png"), 
          p_fitness,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 7,
          base_width = 8)

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot epistasis over time for different start points of q and k
p_epistasis <- t_final %>%
  ggplot(aes(x = time, y = mean_q_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 4),
                     breaks = seq(0, 4, 1)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step~q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name = "starting q")

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/epistasis_v_time.png"), 
          p_epistasis,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 7,
          base_width = 8)