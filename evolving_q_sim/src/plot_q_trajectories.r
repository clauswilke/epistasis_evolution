##########################################################################
# This script plots evolutionary trajectories over time. It will produce #
# two plots: mean fitness over replicate populations over time, and mean #
# epistatis over replicate populations over time.                        #
#                                                                        #
# Author: Dariya K. Sydykova                                             #
##########################################################################

# load packages necessary to run the following script
library(tidyverse)
library(glue)
library(cowplot)
library(readr)
library(here)

# supress scientific notation in R to make plots
options(scipen = 999)

# set up input file. Output plot files are generated automatically and are stored in /evolving_q_sim/test_plots
root_dir <- here() # get the directory of the root of the project
base_name <- "mu_prob0.01_s0.01" # set base name to match input and output files
infile <- paste(root_dir, "/evolving_q_sim/processed_results/evolved_q_", base_name, ".csv", sep = "") # data frame that contains simulation results for the plot

# read in simulation output for evolving q
t <- read_csv(
  infile,
  col_types = cols(
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
  )
)

# extract output for less time points to reduce the data frame
times_wanted <- seq(0, max(t$time), 100000)
t %>% filter(time %in% times_wanted) -> t_filtered

# # make `rep` (number of replicates) and `q_start` (starting q) into a factor
# # this allows for grouping on two variables possible later
# t_final$rep <- factor(t_final$rep)
# t_final$q_start <- factor(t_final$q_start)

# calculate mean fitness per replicates
t_filtered %>%
  group_by(q_start, q_prob_label, q_step, time) %>%
  summarise(
    mean_rep_fitness = mean(mean_fitness),
    mean_rep_q = mean(mean_q)
  ) ->
t_summary

##########################################################################
# Plotting fitness over time
##########################################################################

# plot fitness over time for different q mutation rate and delta q
p_fitness1 <-
  t_summary %>%
  filter(q_prob_label == "0.0001") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(
    name = "mean fitness",
    limits = c(0, 1.00),
    breaks = seq(0, 1, 0.2)
  ) +
  scale_x_continuous(
    name = "time (millions)",
    limits = c(0, 100200000),
    breaks = seq(0, 100200000, 25000000),
    labels = c("0", "25", "50", "75", "100")
  ) +
  background_grid(major = "xy", minor = "ny") +
  draw_text(
    x = 0,
    y = 0,
    hjust = 0,
    vjust = 0,
    text = "pr(q) = 0.0001, dq = 0.001",
    size = 12,
    fontface = "bold"
  ) +
  scale_color_manual(
    values = c(
      "#FDE333",
      "#C6E149",
      "#88D867",
      "#38C980",
      "#00B691",
      "#009F99",
      "#008599",
      "#00698F",
      "#324C7F",
      "#432D68",
      "#46024E"
    )
  )

p_fitness2 <- t_summary %>%
  filter(q_prob_label == "0.001") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(
    name = "mean fitness",
    limits = c(0, 1.00),
    breaks = seq(0, 1, 0.2)
  ) +
  scale_x_continuous(
    name = "time (millions)",
    limits = c(0, 100200000),
    breaks = seq(0, 100200000, 25000000),
    labels = c("0", "25", "50", "75", "100")
  ) +
  background_grid(major = "xy", minor = "ny") +
  geom_text(
    x = 0,
    y = 0,
    hjust = 0,
    vjust = 0,
    label = "mu[q] = 0.001 Delta q = 0.001",
    size = 12,
    fontface = "bold",
    parse = T
  ) +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

p_fitness3 <-
  t_summary %>%
  filter(q_prob_label == "0.01") %>%
  ggplot(aes(x = time, y = mean_rep_fitness, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(
    name = "mean fitness",
    limits = c(0, 1.00),
    breaks = seq(0, 1, 0.2)
  ) +
  scale_x_continuous(
    name = "time (millions)",
    limits = c(0, 100200000),
    breaks = seq(0, 100200000, 25000000),
    labels = c("0", "25", "50", "75", "100")
  ) +
  background_grid(major = "xy", minor = "ny") +
  draw_text(x = 0, y = 0, hjust = 0, vjust = 0, text = "pr(q) = 0.01, dq = 0.0001", size = 12, fontface = "bold") +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E"))

# arrange subfigures
p_fitness <-
  plot_grid(
    p_fitness1 +
      theme(legend.position = "none"),
    p_fitness2 +
      theme(axis.title.y = element_blank(), legend.position = "none"),
    p_fitness3 +
      theme(axis.title.y = element_blank(), legend.position = "none"),
    align = "vh",
    hjust = -1,
    ncol = 3,
    nrow = 1
  )

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/plots/fitness_v_time_", base_name, ".png", sep = ""),
  p_fitness,
  base_height = 3,
  base_width = 10
)

##########################################################################
# Plotting epistasis over time
##########################################################################
t_summary$q_prob_label <- factor(t_summary$q_prob_label,
  labels = c(
    "list(mu[q]==0.0001, Delta*q==0.001)",
    "list(mu[q]==0.001, Delta*q==0.001)",
    "list(mu[q]==0.01, Delta*q==0.0001)"
  )
)

p_epistasis <- t_summary %>%
  ggplot(aes(x = time, y = mean_rep_q, group = q_start)) +
  geom_line(aes(color = factor(q_start))) +
  scale_y_continuous(
    name = "mean epistasis",
    limits = c(0, 2.1),
    breaks = seq(0, 2.0, 0.5)
  ) +
  scale_x_continuous(
    name = "time (millions)",
    limits = c(0, 100200000),
    breaks = seq(0, 100200000, 25000000),
    labels = c("0", "25", "50", "75", "100")
  ) +
  background_grid(major = "xy", minor = "y") +
  facet_grid(~q_prob_label, labeller = label_parsed) +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste(root_dir, "/evolving_q_sim/plots/epistasis_v_time_", base_name, ".png", sep = ""),
  p_epistasis,
  base_height = 4,
  base_width = 12
)

##########################################################################
# Plotting epistasis over time (2 trajectories)
##########################################################################

# create a data frame with labels for the plot
labels_df <- data.frame(
  q_start = c(1.4, 1.6, 1.8),
  q_start_label = c(
    "q[t==0]==1.4",
    "q[t==0]==1.6",
    "q[t==0]==1.8"
  )
)

# filter for all trajectories that start at 1.8, 1.6, or 1.4
t_filtered %>%
  filter(
    q_prob_label == "0.001",
    q_start == 1.8 | q_start == 1.6 | q_start == 1.4
  ) %>% 
  left_join(labels_df) -> t_subset1

# plot epistasis over time for different q mutation rate and delta q
t_summary %>%
  filter(
    q_prob_label == "list(mu[q]==0.001, Delta*q==0.001)",
    q_start == 1.8 | q_start == 1.6 | q_start == 1.4
  ) %>%
  left_join(labels_df) -> t_subset2

p_epistasis1 <- ggplot() +
  geom_line(data = t_subset1, aes(x = time, y = mean_q, group = rep), color = "#7d7d7d", size = 0.3) +
  geom_line(data = t_subset2, aes(x = time, y = mean_rep_q, group = q_start, color = factor(q_start)), size = 1.2) +
  scale_y_continuous(
    name = "epistasis",
    limits = c(0, 2.6),
    breaks = seq(0, 2.5, 0.5)
  ) +
  scale_x_continuous(
    name = "time (millions)",
    limits = c(0, 100200000),
    breaks = seq(0, 100200000, 25000000),
    labels = c("0", "25", "50", "75", "100")
  ) +
  background_grid(major = "xy", minor = "y") +
  facet_grid(~q_start_label, labeller = label_parsed) +
  scale_color_manual(values = c("#00698F", "#324C7F", "#432D68")) +
  theme(legend.position = "none")

# save the plot
save_plot(paste(root_dir, "/evolving_q_sim/plots/epistasis_v_time_", base_name, "_subset.png", sep = ""),
  p_epistasis1,
  base_height = 4,
  base_width = 12
)