###########################################################################
# This script plots evolutionary trajectories over time. It will produde  #
# 4 plots. The first two plots will contain mean fitness over replicate   #
# populations over time, and mean epistatis over replicate populations    #
# over time. The first two plots will plot evolutionary trajectories      #
# when probabilties of q (epistasis) changing are 0.0001, 0.001, and 0.01 #
# and when changes in q are 0.0001, 0.001, 0.01. Each plot will contain   #
# subplots for every possible combination of probabilities of q changing  #
# and changes in q. The last two plots will also contain mean fitness     #
# over replicate populations over time, and mean epistatis over replicate #
# populations over time. The last two plots will plot evolutionary        #
# trajectories when probabilties of q (epistasis) changing is 0.01        #
# and when changes in q are 0.0001, 0.001, 0.01.                          #
#                                                                         #  
# Author: Dariya K. Sydykova                                              #
###########################################################################

# load packages necessary to run the following script
library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)
library(here)

# set up input file. Output plot files are generated automatically and are stored in /evolving_q_sim/test_plots
root_dir <- here() # get the directory of the root of the project
base_name <- "search_param_space" # set base name to match input and output files
infile <- paste(root_dir, "/evolving_q_sim/processed_results/evolved_q_", base_name, ".csv", sep = "") # data frame that contains simulation results for the plot

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
  summarise(mean_fitness_over_rep = mean(mean_fitness),
            mean_q_over_rep = mean(mean_q)) -> t_final

# fix labeling for changes in q
label <- data.frame(q_step = c(0.0001, 0.0002, 0.0003, 0.0006, 0.001, 0.01),
                    q_step_label = c("0.0001", "0.0002", "0.0003", "0.0006", "0.001", "0.01"))

# add new labels to the data set
label %>% right_join(t_final) -> t_final

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot fitness over time for different start points of q and k
p_fitness <- t_final %>% 
  filter(q_step != 0.0002,
         q_step != 0.0003,
         q_step != 0.0006) %>%
  ggplot(aes(x = time, y = mean_fitness_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step_label ~ q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_manual(name = "starting q",
                     values = c("#00BE7D", "#007094", "#4B0055")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/fitness_v_time_", base_name, "1.png", sep = ""), 
          p_fitness,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 6,
          base_width = 7)

# plot epistasis over time for different start points of q and k
p_epistasis <- t_final %>%
  filter(q_step != 0.0002,
         q_step != 0.0003,
         q_step != 0.0006) %>%
  ggplot(aes(x = time, y = mean_q_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 2.15),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step_label ~ q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_manual(name = "starting q",
                     values = c("#00BE7D", "#007094", "#4B0055")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste(root_dir, "/evolving_q_sim/test_plots/epistasis_v_time_", base_name, "1.png", sep = ""), 
          p_epistasis,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 6,
          base_width = 7)

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot fitness over time for different start points of q and k
p_fitness <- t_final %>% 
  filter(q_prob_label == 0.01,
         q_step != 0.01) %>%
  ggplot(aes(x = time, y = mean_fitness_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step_label ~ q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_manual(name = "starting q",
                     values = c("#00BE7D", "#007094", "#4B0055")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/fitness_v_time_", base_name, "2.png", sep = ""), 
          p_fitness,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 8,
          base_width = 3)

# plot epistasis over time for different start points of q and k
p_epistasis <- t_final %>%
  filter(q_prob_label == 0.01,
         q_step != 0.01) %>%
  ggplot(aes(x = time, y = mean_q_over_rep, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 2.15),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  facet_grid(q_step_label ~ q_prob_label) +
  background_grid(major = "xy", minor = "none") +
  scale_color_manual(name = "starting q",
                     values = c("#00BE7D", "#007094", "#4B0055")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste(root_dir, "/evolving_q_sim/test_plots/epistasis_v_time_", base_name, "2.png", sep = ""), 
          p_epistasis,
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 8,
          base_width = 3)
