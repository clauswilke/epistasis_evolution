##########################################################################
# This script plots evolutionary trajectories over time. It will produce #
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
base_name <- "mu_prob0.01_s0.01" # set base name to match input and output files
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
t %>% filter(time %in% times_wanted) -> t_final

# # make `rep` (number of replicates) and `q_start` (starting q) into a factor
# # this allows for grouping on two variables possible later
# t_final$rep <- factor(t_final$rep)
# t_final$q_start <- factor(t_final$q_start)

# calculate mean fitness per replicates
t_final %>% group_by(q_start, q_prob_label, time) %>% 
  summarise(mean_rep_fitness = mean(mean_fitness),
            mean_rep_q = mean(mean_q)) -> t_final

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot fitness over time for different q mutation rate and delta q
p_fitness1 <- t_final %>% filter(q_prob_label == "0.0001") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "ny") +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "pr(q) = 0.0001, dq = 0.001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

p_fitness2 <- t_final %>% filter(q_prob_label == "0.001") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "ny") +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "pr(q) = 0.001, dq = 0.001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

p_fitness3 <- t_final %>% filter(q_prob_label == "0.01") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.00),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "ny") +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "pr(q) = 0.01, dq = 0.0001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

# arrange subfigures
p_fitness <- plot_grid(p_fitness1 + theme(legend.position = "none"),
                         p_fitness2 + theme(axis.title.y = element_blank(), legend.position = "none"),
                         p_fitness3 + theme(axis.title.y = element_blank(), legend.position = "none"),
                         align = 'vh',
                         hjust = -1,
                         ncol = 3,
                         nrow = 1)
# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/plots/fitness_v_time_", base_name, ".png", sep = ""), 
          p_fitness,
          base_height = 3,
          base_width = 10)

##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################

# plot epistasis over time for different q mutation rate and delta q
p_epistasis1 <- t_final %>% filter(q_prob_label == "0.0001") %>%
  ggplot(aes(x = time, y = mean_rep_q, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 2.6),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "y") +
  draw_text(x = 0, y = 2.6, hjust = 0, vjust = 0, text = "pr(q) = 0.0001, dq = 0.001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

p_epistasis2 <- t_final %>% filter(q_prob_label == "0.001") %>%
  ggplot(aes(x = time, y = mean_rep_q, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 2.6),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "y") +
  draw_text(x = 0, y = 2.6, hjust = 0, vjust = 0, text = "pr(q) = 0.001, dq = 0.001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

p_epistasis3 <- t_final %>% filter(q_prob_label == "0.01") %>%
  ggplot(aes(x = time, y = mean_rep_q, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 2.6),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  background_grid(major = "xy", minor = "y") +
  draw_text(x = 0, y = 2.6, hjust = 0, vjust = 0, text = "pr(q) = 0.01, dq = 0.0001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

# arrange subfigures
p_epistasis <- plot_grid(p_epistasis1 + theme(legend.position = "none"),
               p_epistasis2 + theme(axis.title.y = element_blank(), legend.position = "none"),
               p_epistasis3 + theme(axis.title.y = element_blank(), legend.position = "none"),
               align = 'vh',
               hjust = -1,
               ncol = 3,
               nrow = 1)

# save the plot
save_plot(paste(root_dir, "/evolving_q_sim/plots/epistasis_v_time_", base_name, ".png", sep = ""), 
          p_epistasis,
          base_height = 4,
          base_width = 12)