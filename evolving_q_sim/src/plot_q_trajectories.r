library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)

# read in simulation output for evolving q
t <- read.csv("../processed_results/evolved_q_trajectories.csv")

t$q_start <- factor(t$q_start)
t$rep <- factor(t$rep) 

#######################################################
# Plotting q trajectories                             #
#######################################################
# make separate figures for different probabilities of q changing
# probability q changing for each time step (p) = 0
p0 <- t %>% 
  filter(q_prob == 0) %>%
  ggplot(aes(x = time, y = epistasis_coef, color = q_start, group = interaction(rep, q_start))) +
  geom_line() +
  scale_y_continuous(name = "q",
                     limits = c(0, 2.5),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time",
                     labels = c("0", "0.5", "1", "1.5", "2", "2.5", "3"),
                     breaks = seq(0, 3000000, 500000)) +
  draw_text(x = 0, y = 2.4, hjust = 0, vjust = 0, text = "p = 0", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E")) +
  theme(legend.position="none")

p1 <- t %>% 
  filter(q_prob == 0.001) %>%
  ggplot(aes(x = time, y = epistasis_coef, color = q_start, group = interaction(rep, q_start))) +
  geom_line() + 
  scale_y_continuous(name = "q",
                     limits = c(0, 2.5),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time",
                     labels = c("0", "0.5", "1", "1.5", "2", "2.5", "3"),
                     breaks = seq(0, 3000000, 500000)) +
  draw_text(x = 0, y = 2.4, hjust = 0, vjust = 0, text = "p = 0.001", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E")) +
  theme(legend.position="none")

p2 <- t %>% 
  filter(q_prob == 0.01) %>%
  ggplot(aes(x = time, y = epistasis_coef, color = q_start, group = interaction(rep, q_start))) +
  geom_line() + 
  scale_y_continuous(name = "q",
                     limits = c(0, 2.5),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time",
                     labels = c("0", "0.5", "1", "1.5", "2", "2.5", "3"),
                     breaks = seq(0, 3000000, 500000)) +
  draw_text(x = 0, y = 2.4, hjust = 0, vjust = 0, text = "p = 0.01", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E")) +
  theme(legend.position="none")

p3 <- t %>% 
  filter(q_prob == 0.1) %>%
  ggplot(aes(x = time, y = epistasis_coef, color = q_start, group = interaction(rep, q_start))) +
  geom_line() + 
  scale_y_continuous(name = "q",
                     limits = c(0, 2.5),
                     breaks = seq(0, 2.5, 0.5)) +
  scale_x_continuous(name = "time",
                     labels = c("0", "0.5", "1", "1.5", "2", "2.5", "3"),
                     breaks = seq(0, 3000000, 500000)) +
  draw_text(x = 0, y = 2.4, hjust = 0, vjust = 0, text = "p = 0.1", size = 12, fontface = 'bold') +
  scale_color_manual(values = c("#FDE333", "#C6E149", "#88D867", "#38C980", "#00B691", "#009F99", "#008599", "#00698F", "#324C7F", "#432D68", "#46024E")) +
  theme(legend.position="none")


# arrange subfigures
p <- plot_grid(p0,
               p1,
               p2,
               p3,
               align = 'vh',
               hjust = -1,
               ncol=2,
               nrow=2)

save_plot("../plots/q_trajectory.png", p,
          ncol = 2, # we're saving a grid plot of 3 columns
          nrow = 2, # and 1 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=6)
