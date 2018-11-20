##########################################################################
# This script plots evolutionary trajectories over time. It will produde
# two plots: mean fitness over replicate populations over time, and mean 
# epistatis over replicate populations over time.
#
# Author: Dariya K. Sydykova
##########################################################################

# load packages necessary to run the following script
library(tidyr)
library(ggplot2)
library(ggridges)
library(dplyr)
library(cowplot)
library(readr)
library(here)

# set up input file. Output plot files are generated automatically and are stored in /evolving_q_sim/test_plots
root_dir <- here() # get the directory of the root of the project
base_name <- "mu_prob0.01_s0.01" # set base name to match input and output files
infile <- paste(root_dir, "/evolving_q_sim/processed_results/evolved_q_", base_name, "_k_distr.csv", sep = "") # data frame that contains simulation results for the plot

# read in simulation output for evolving q and add a variable for starting number of mutations k
t <- read_csv(infile)

###########################################################################
# Plotting distribution of mutations (k) over time for population N = 100 #
###########################################################################

# create a vector of time points at equal time steps
times_wanted <- seq(0, max(t$time),  2000000) 

# plot mean mutations k over time
t %>% filter(time %in% times_wanted, q_step == 0.0001 |
           #    q_step == 0.0002 | 
          #     q_step == 0.0003 | 
          #     q_step == 0.0006 | 
          #     q_step == 0.001,
          #     q_prob == 0.01, 
             q_start == 2) -> t_final

# make q_prob_label and q_start into a factor
# this allows for grouping on two variables possible later
t_final$q_prob_label <- factor(t_final$q_prob_label)
t_final$q_start <- factor(t_final$q_start)

t_final %>% ggplot(aes(x = k, y = time, height = num, group = time)) + 
  geom_density_ridges(stat = "identity", scale = 1) +
  scale_y_continuous(name = "time (millions)",
                     limits = c(0, 100200000),
                     breaks = seq(0, 100200000, 25000000),
                     labels = c("0", "25", "50", "75", "100")) +
  scale_x_continuous(name = "mean mutations",
                   limits = c(0, 100),
                   breaks = seq(0, 100, 10)) -> p_distr

# save the plot
save_plot(paste0(root_dir, "/evolving_q_sim/test_plots/mean_k_v_time_N100.png"), 
          p_distr,
          # each individual subplot should have an aspect ratio of 1.3
          base_height=7,
          base_width=7)