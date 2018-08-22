library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)


##########################################################################
# Plotting fitness over time and epistasis coefficient over time         #
##########################################################################
base_name <- "q_start2_q_prob0.0001_s0.01_m0.01_N100"

# read in simulation output for evolving q
f1 <- read_csv(paste0("../test_run/", base_name, "k_start0.csv"))
f2 <- read_csv(paste0("../test_run/", base_name, "k_start100.csv"))

#t <- read.csv(paste0("../test_run/", base_name, ".csv"))
t <- bind_rows(f1, f2)

p_fitness <- t %>%
  ggplot(aes(x = time, y = mean_fitness, group = k_start)) +
  geom_line() +
  scale_y_continuous(name = "mean fitness",
                     limits = c(0, 1.05),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "time",
                     limits = c(0, 300200000),
                     breaks = seq(0, 300200000, 100000000)) +
  background_grid(major = "xy", minor = "none")
save_plot(paste0("../test_plots/", base_name, "_fitness.png"), p_fitness,
          # each individual subplot should have an aspect ratio of 1.3
          base_height=6,
          base_width=6)

p_epistasis <- t %>%
  ggplot(aes(x = time, y = mean_q, group = k_start)) +
  geom_line() +
  scale_y_continuous(name = "mean epistasis",
                     limits = c(0, 5),
                     breaks = seq(0, 5, 1)) +
  scale_x_continuous(name = "time",
                     limits = c(0, 302000000),
                     breaks = seq(0, 302000000, 100000000)) +
  background_grid(major = "xy", minor = "none")

save_plot(paste0("../test_plots/", base_name, "_epistasis.png"), p_epistasis,
          # each individual subplot should have an aspect ratio of 1.3
          base_height=6,
          base_width=6)


##########################################################################
# Plotting distribution of mutations (k) over time                       #
##########################################################################
base_name <- "q_start2_q_prob0.0001_s0.01_m0.01_N100"

# read in simulation output for evolving q
f1 <- read_csv(paste0("../test_run/", base_name, "k_start0_k_distr.csv"))
f2 <- read_csv(paste0("../test_run/", base_name, "k_start100_k_distr.csv"))

#t <- read.csv(paste0("../test_run/", base_name, ".csv"))
t <- bind_rows(f1, f2)
