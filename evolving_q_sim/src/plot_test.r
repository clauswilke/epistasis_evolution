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
infile <- paste0(root_dir, "/evolving_q_sim/processed_results/evolved_q_trajectories.csv") # data frame that contains simulation results for the plot

# read in simulation output for evolving q
t <- read_csv(infile)

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################
# calculate mean fitness over replicates
# perform calculations separately for fitness before and after equlibrium
t %>% group_by(q_prob_label, q_start, q_step, time) %>% 
  summarise(mean_fitness_over_rep = mean(mean_fitness)) -> t_final

# make k_start and q_start into a factor
# this allows for grouping on two variables possible later
t_final$q_prob_label <- factor(t_final$q_prob_label)
t_final$q_start <- factor(t_final$q_start)

# separate the dataset into two datasets for different changes in q
t_final %>% filter(q_step == 0.1) -> t_final1
t_final %>% filter(q_step == 0.01) -> t_final2

# plot fitness over time for different start points of q and k
p_fitness1 <- t_final1 %>%
  ggplot(aes(x = time, y = mean_fitness_over_rep, group = interaction(q_prob_label, q_start))) +
  geom_line(aes(color = q_start)) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_wrap(~q_prob_label) +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "q step = 0.1", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name = "starting q")

# plot fitness over time for different start points of q and k
p_fitness2 <- t_final2 %>%
  ggplot(aes(x = time, y = mean_fitness_over_rep, group = interaction(q_prob_label, q_start))) +
  geom_line(aes(color = q_start)) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_wrap(~q_prob_label) +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "q step = 0.01", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name = "starting q")

# combine two plots together
p_fitness <- plot_grid(p_fitness1, p_fitness2, ncol = 1, align = 'v')

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/fitness_v_time.png"), 
          p_fitness,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 6,
          base_width = 10)

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################
# calculate mean epistasis (q) over replicates
t %>% group_by(q_prob_label, q_start, q_step, time) %>% 
  summarise(mean_q_over_rep = mean(mean_q)) -> t_final 

# make k_start and q_start into a factor
# this allows for grouping on two variables possible later
t_final$q_prob_label <- factor(t_final$q_prob_label)
t_final$q_start <- factor(t_final$q_start)

# separate the dataset into two datasets for different changes in q
t_final %>% filter(q_step == 0.1) -> t_final1
t_final %>% filter(q_step == 0.01) -> t_final2

# plot epistasis over time for different start points of q and k
p_epistasis1 <- t_final1 %>%
  ggplot(aes(x = time, y = mean_q_over_rep, group = interaction(q_prob_label, q_start))) +
  geom_line(aes(color = q_start)) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 4),
                     breaks = seq(0, 4, 1)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_wrap(~q_prob_label) +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "q step = 0.1", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name="starting q")

# plot epistasis over time for different start points of q and k
p_epistasis2 <- t_final2 %>%
  ggplot(aes(x = time, y = mean_q_over_rep, group = interaction(q_prob_label, q_start))) +
  geom_line(aes(color = q_start)) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 4),
                     breaks = seq(0, 4, 1)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_wrap(~q_prob_label) +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "q step = 0.01", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none") +
  scale_color_discrete(name="starting q")

# combine two plots together
p_epistasis <- plot_grid(p_epistasis1, p_epistasis2, ncol = 1, align = 'v')

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/epistasis_v_time.png"), 
          p_epistasis,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 6,
          base_width = 10)