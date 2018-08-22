library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)

# read in simulation output
t <- read.csv("../processed_results/evolved_q_trajectories.csv")

t %>% filter(time >= 2000000) %>%
  group_by(q_prob, q_start, rep) %>% 
  summarise(mean_sim_fitness = mean(mean_fitness), mean_sim_q = mean(epistasis_coef)) %>%
  mutate(q_change = mean_sim_q - q_start, percent_change = q_change/q_start*100) -> t_sum

t_sum %>% filter(q_change == 0) %>%
  mutate(percent_change = 0) -> t_temp

t_sum %>% filter(q_change != 0) %>%
  bind_rows(t_temp) -> t_final

#######################################################
# Plotting starting q against change in q             #
#######################################################
# make separate figures for different probabilities of q changing
# probability q changing for each time step (p) = 0.001
p1 <- t_final %>% filter(q_prob == 0.001) %>%
  ggplot(aes(x = q_start, y = q_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1) +
  scale_y_continuous(name = "change in q",
                     limits = c(-2, 2),
                     breaks = seq(-2, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.001", size = 12, fontface = 'bold')
  
# probability q changing for each time step (p) = 0.01
p2 <- t_final %>% filter(q_prob == 0.01) %>%
  ggplot(aes(x = q_start, y = q_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1)+
  scale_y_continuous(name = "change in q",
                     limits = c(-2, 2),
                     breaks = seq(-2, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.01", size = 12, fontface = 'bold')

# probability q changing for each time step (p) = 0.1
p3 <- t_final %>% filter(q_prob == 0.1) %>%
  ggplot(aes(x = q_start, y = q_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1) +
  scale_y_continuous(name = "change in q",
                     limits = c(-2, 2),
                     breaks = seq(-2, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.1", size = 12, fontface = 'bold')

# arrange subfigures
p <- plot_grid(p1,
               p2 + theme(axis.title.y = element_blank()),
               p3 + theme(axis.title.y = element_blank()),
               align = 'vh',
               hjust = -1,
               ncol=3,
               nrow=1)

save_plot("../plots/q_start_v_q_change.png", p,
          ncol = 3, # we're saving a grid plot of 3 columns
          nrow = 1, # and 1 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=4)

#######################################################
# Plotting starting q against percent change in q     #
#######################################################
# make separate figures for different probabilities of q changing
# probability q changing for each time step (p) = 0.001
p1 <- t_final %>% filter(q_prob == 0.001) %>%
  ggplot(aes(x = q_start, y = percent_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1) +
  scale_y_continuous(name = "% change in q",
                     limits = c(-100, 100),
                     breaks = seq(-100, 100, 50)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 100, hjust = 0, vjust = 0, text = "p = 0.001", size = 12, fontface = 'bold')

# probability q changing for each time step (p) = 0.01
p2 <- t_final %>% filter(q_prob == 0.01) %>%
  ggplot(aes(x = q_start, y = percent_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1)+
  scale_y_continuous(name = "% change in q",
                     limits = c(-100, 100),
                     breaks = seq(-100, 100, 50)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 100, hjust = 0, vjust = 0, text = "p = 0.01", size = 12, fontface = 'bold')

# probability q changing for each time step (p) = 0.1
p3 <- t_final %>% filter(q_prob == 0.1) %>%
  ggplot(aes(x = q_start, y = percent_change)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.1) +
  scale_y_continuous(name = "% change in q",
                     limits = c(-100, 100),
                     breaks = seq(-100, 100, 50)) +
  scale_x_continuous(name = "starting q",
                     breaks = seq(0, 2, 0.2)) +
  draw_text(x = 0, y = 100, hjust = 0, vjust = 0, text = "p = 0.1", size = 12, fontface = 'bold')

# arrange subfigures
p <- plot_grid(p1,
               p2 + theme(axis.title.y = element_blank()),
               p3 + theme(axis.title.y = element_blank()),
               align = 'vh',
               hjust = -1,
               ncol=3,
               nrow=1)

save_plot("../plots/q_start_v_percent_change.png", p,
          ncol = 3, # we're saving a grid plot of 3 columns
          nrow = 1, # and 1 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=4)

#######################################################
# Plotting evolved q against q start                  #
#######################################################
# make separate figures for different probabilities of q changing
# probability q changing for each time step (p) = 0
p0 <- t_final %>% filter(q_prob == 0) %>%
  ggplot(aes(x = q_start, y = mean_sim_q)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "evolved q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


# probability q changing for each time step (p) = 0.001
p1 <- t_final %>% filter(q_prob == 0.001) %>%
  ggplot(aes(x = q_start, y = mean_sim_q)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "evolved q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.001", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")

# probability q changing for each time step (p) = 0.01
p2 <- t_final %>% filter(q_prob == 0.01) %>%
  ggplot(aes(x = q_start, y = mean_sim_q)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "evolved q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.01", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


# probability q changing for each time step (p) = 0.1
p3 <- t_final %>% filter(q_prob == 0.1) %>%
  ggplot(aes(x = q_start, y = mean_sim_q)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "evolved q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 2.0, hjust = 0, vjust = 0, text = "p = 0.1", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


# arrange subfigures
p <- plot_grid(p0,
               p1 + theme(axis.title.y = element_blank()),
               p2,
               p3 + theme(axis.title.y = element_blank()),
               align = 'vh',
               hjust = -1,
               ncol=2,
               nrow=2)

save_plot("../plots/q_start_v_mean_sim_q.png", p,
          ncol = 2, # we're saving a grid plot of 3 columns
          nrow = 2, # and 1 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height = 4,
          base_width = 4.2)

#######################################################
# Plotting mean fitness against q start               #
#######################################################
# make separate figures for different probabilities of q changing
# probability q changing for each time step (p) = 0
p0 <- t_final %>% filter(q_prob == 0) %>%
  ggplot(aes(x = q_start, y = mean_sim_fitness)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "fitness",
                     limits = c(0, 1.1),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 1.1, hjust = 0, vjust = 0, text = "p = 0", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")

# probability q changing for each time step (p) = 0.001
p1 <- t_final %>% filter(q_prob == 0.001) %>%
  ggplot(aes(x = q_start, y = mean_sim_fitness)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "fitness",
                     limits = c(0, 1.1),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 1.1, hjust = 0, vjust = 0, text = "p = 0.001", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")

# probability q changing for each time step (p) = 0.01
p2 <- t_final %>% filter(q_prob == 0.01) %>%
  ggplot(aes(x = q_start, y = mean_sim_fitness)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "fitness",
                     limits = c(0, 1.1),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 1.1, hjust = 0, vjust = 0, text = "p = 0.01", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


# probability q changing for each time step (p) = 0.1
p3 <- t_final %>% filter(q_prob == 0.1) %>%
  ggplot(aes(x = q_start, y = mean_sim_fitness)) +
  stat_summary(fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size = 0.4) +
  scale_y_continuous(name = "fitness",
                     limits = c(0, 1.1),
                     breaks = seq(0, 1, 0.2)) +
  scale_x_continuous(name = "starting q",
                     limits = c(0, 2.1),
                     breaks = seq(0, 2, 0.5)) +
  draw_text(x = 0, y = 1.1, hjust = 0, vjust = 0, text = "p = 0.1", size = 12, fontface = 'bold') +
  background_grid(major = "xy", minor = "none")


# arrange subfigures
p <- plot_grid(p0,
               p1 + theme(axis.title.y = element_blank()),
               p2,
               p3 + theme(axis.title.y = element_blank()),
               align = 'vh',
               hjust = -1,
               ncol=2,
               nrow=2)

save_plot("../plots/q_start_v_mean_sim_fitness.png", p,
          ncol = 2, # we're saving a grid plot of 3 columns
          nrow = 2, # and 1 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=4.2)

