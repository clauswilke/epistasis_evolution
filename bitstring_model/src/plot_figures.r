library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)
library(ggthemes)

### Functions that evaluate theoretical fitness according to Sella and Hirsh
predict_mean_fitness <- function(Ne, L, s, eps)
{
  k <- c(0:L)
  f <- exp(-s*k^(1-eps))	
  p_k <- (f^(2*Ne-2)*choose(L, k))/sum(f^(2*Ne-2)*choose(L, k))
  sum(f*p_k)
}

w_vs_eps <- function(Ne, L, s, epsstart, epsstop, epssteps = 0.01)
{
  eps <- seq(epsstart, epsstop, epssteps)  
  w_ave <- vapply(eps, function(eps){predict_mean_fitness(Ne, L, s, eps)}, 1)
  data.frame(s, w_ave, Ne, L, eps)
}

#########################################################################
### Figure 1:                                                         ###
### Epistasis vs Fitness                                              ###
#########################################################################
# import simulation results
t_N100 <- read_csv("../processed_results/varying_eps_N100_max3.csv")
t_N10 <- read_csv("../processed_results/varying_eps_N10_max3.csv")

t <- rbind(t_N100, t_N10)

# calculate a mean fitness across time when the population reached epistasis
t %>% mutate(q = 1-epistasis_coef) %>% 
  group_by(q, sel_coef, mu_prob, Ne, k_start, rep) %>% #one mean per simulation
  summarise(mean_f_over_time = mean(mean_fitness)) -> t_sum

L = 100 #Number of maximum mutations

### Sub-figure N=10, s=0.01
pop_size = 10
s = 0.01

t_sum %>% filter(sel_coef == s, Ne == pop_size) -> f
an_f <- w_vs_eps(pop_size, L, s, -1, 1) %>% mutate(q=1-eps)

p_N10_s0.01 <- ggplot()+ 
  stat_summary(data = f,
               inherit.aes = FALSE,
               aes(x = q, y = mean_f_over_time,color=factor(mu_prob)),
               fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4)+
  geom_line(data = an_f, aes(x = q, y = w_ave))+
  #geom_vline(xintercept = q_est, linetype = 2)+
  #draw_text(x = q_est+0.02, y =1, hjust = 0, vjust = 1, text = "predicted q*", size = 12)+
  scale_y_continuous(breaks=seq(0,1,0.2))+
  coord_cartesian(ylim=c(0,1),xlim=c(0,2))+
  guides(col = guide_legend(title="Mutation\nrate"))+
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12))+
        #legend.position = "none")+
  xlab('Q') +
  ylab('Mean fitness') +
  scale_color_manual(values = colorblind_pal()(8)[c(2,4,6,7)])

### Sub-figure N=10, s=0.001
pop_size = 10
s = 0.001

t_sum %>% filter(sel_coef == s, Ne == pop_size) -> f
an_f <- w_vs_eps(pop_size, L, s, -1, 1) %>% mutate(q=1-eps)

p_N10_s0.001 <- ggplot()+ 
  stat_summary(data = f,
               inherit.aes = FALSE,
               aes(x = q, y = mean_f_over_time,color=factor(mu_prob)),
               fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4)+
  geom_line(data = an_f, aes(x = q, y = w_ave))+
  #geom_vline(xintercept = q_est, linetype = 2)+
  #draw_text(x = q_est+0.02, y =1, hjust = 0, vjust = 1, text = "predicted q*", size = 12)+
  scale_y_continuous(breaks=seq(0,1,0.2))+
  coord_cartesian(ylim=c(0,1),xlim=c(0,2))+
  guides(col = guide_legend(title="Mutation\nrate"))+
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12))+
  #legend.position = "none")+
  xlab('Q') +
  ylab('Mean fitness') +
  scale_color_manual(values = colorblind_pal()(8)[c(2,4,6,7)])

### Sub-figure N=100, s=0.01
pop_size = 100
s = 0.01

t_sum %>% filter(sel_coef == s, Ne == pop_size) -> f
an_f <- w_vs_eps(pop_size, L, s, -1, 1) %>% mutate(q=1-eps)

p_N100_s0.01 <- ggplot()+ 
  stat_summary(data = f,
               inherit.aes = FALSE,
               aes(x = q, y = mean_f_over_time,color=factor(mu_prob)),
               fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4)+
  geom_line(data = an_f, aes(x = q, y = w_ave))+
  #geom_vline(xintercept = q_est, linetype = 2)+
  #draw_text(x = q_est+0.02, y =1, hjust = 0, vjust = 1, text = "predicted q*", size = 12)+
  scale_y_continuous(breaks=seq(0,1,0.2))+
  coord_cartesian(ylim=c(0,1),xlim=c(0,2))+
  guides(col = guide_legend(title="Mutation\nrate"))+
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12))+
  #legend.position = "none")+
  xlab('Q') +
  ylab('Mean fitness') +
  scale_color_manual(values = colorblind_pal()(8)[c(2,4,6,7)])

### Sub-figure N=100, s=0.001
pop_size = 100
s = 0.001

t_sum %>% filter(sel_coef == s, Ne == pop_size) -> f
an_f <- w_vs_eps(pop_size, L, s, -1, 1) %>% mutate(q=1-eps)

p_N100_s0.001 <- ggplot()+ 
  stat_summary(data = f,
               inherit.aes = FALSE,
               aes(x = q, y = mean_f_over_time,color=factor(mu_prob)),
               fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4)+
  geom_line(data = an_f, aes(x = q, y = w_ave))+
  #geom_vline(xintercept = q_est, linetype = 2)+
  #draw_text(x = q_est+0.02, y =1, hjust = 0, vjust = 1, text = "predicted q*", size = 12)+
  scale_y_continuous(breaks=seq(0,1,0.2))+
  coord_cartesian(ylim=c(0,1),xlim=c(0,2))+
  guides(col = guide_legend(title="Mutation\nrate"))+
  theme(axis.title = element_text(size = 14),
        axis.text = element_text(size = 12),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12))+
  #legend.position = "none")+
  xlab('Q') +
  ylab('Mean fitness') +
  scale_color_manual(values = colorblind_pal()(8)[c(2,5,6,7)])

# extract the legend form the first sub-figure
grobs <- ggplotGrob(p_N10_s0.01)$grobs
legend <- grobs[[which(sapply(grobs, function(x) x$name) == "guide-box")]]

# arrange subfigures
prow <- plot_grid(p_N10_s0.01 + labs(title = "N = 10, s = 0.01") + theme(plot.title = element_text(hjust = 0), legend.position="none"),
                       p_N10_s0.001 + labs(title = "N = 10, s = 0.001") + theme(plot.title = element_text(hjust = 0), legend.position="none", axis.title.y = element_blank()),
                       p_N100_s0.01 + labs(title = "N = 100, s = 0.01") + theme(plot.title = element_text(hjust = 0), legend.position="none"),
                       p_N100_s0.001 + labs(title = "N = 100, s = 0.001") + theme(plot.title = element_text(hjust = 0), legend.position="none", axis.title.y = element_blank()),
                       labels=c("A","B","C","D"),
                       align = 'vh',
                       hjust = -1,
                       ncol=2,
                       nrow=2)

p <- plot_grid(prow, legend, rel_widths = c(2, .3))

save_plot("../plots/fitness_vs_epistasis.pdf", p,
          ncol = 2, # we're saving a grid plot of 2 columns
          nrow = 2, # and 2 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=4)

#########################################################################
### Figure 2:                                                         ###
### Theoretical calculations of Q*                                    ###
#########################################################################
# a function that calculates Q* (min of Q)
f <- function(L, s, q, k){exp(-s*k**q)}
p_num <- function(L, s, N, q, k){choose(L, k)*f(L, s, q, k)**(2*N-1)}
Z <- function(L, s, N, q){sum(p_num(L, s, N, q, 0:L))}
fave <- function(L, s, N, q){sum(f(L, s, q, 0:L)*p_num(L, s, N, q, 0:L))/Z(L, s, N, q)}

# assume p(k) independent of f(k) (i.e., no selection)
p_num2 <- function(L, s, N, q, k){choose(L, k)}
Z2 <- function(L, s, N, q){sum(p_num2(L, s, N, q, 0:L))}
fave2 <- function(L, s, N, q){sum(f(L, s, q, 0:L)*p_num2(L, s, N, q, 0:L))/Z2(L, s, N, q)}

# assume k <= kmax only (limited drift)
Z3 <- function(L, s, N, q, kmax){sum(p_num(L, s, N, q, 0:kmax))}
fave3 <- function(L, s, N, q, kmax){sum(f(L, s, q, 0:kmax)*p_num(L, s, N, q, 0:kmax))/Z3(L, s, N, q, kmax)}

eval_model <- function(L, s, N) {
  q <- seq(0, 2, .01)
  df <- data.frame(
    q = q,
    full_model = vapply(q, function(x) fave(L, s, N, x), numeric(1)),
    no_selection = vapply(q, function(x) fave2(L, s, N, x), numeric(1)),
    limited_drift = vapply(q, function(x) fave3(L, s, N, x, 20), numeric(1))
  ) %>% gather(formula, f_ave, -q)
}

# get a data frame of 3 models evaluated for different Q values
df <- eval_model(L = 100, s = 0.01, N = 10)

df %>% filter(formula == "full_model") %>% mutate(model_name = "Full model") -> df1
df %>% filter(formula == "no_selection") %>% mutate(model_name = "No selection") -> df2
df %>% filter(formula == "limited_drift") %>% mutate(model_name = "Limited drift") -> df3

rbind(df1, df2, df3) -> full_df

# Make a plot of the 3 models
p_models <- ggplot(full_df, aes(q, f_ave, color = model_name)) +
    geom_line(size = 1.1) + 
    labs(title = "N = 10, s = 0.01") +
    xlab('Q') +
    ylab('Mean fitness') +
    theme(plot.title = element_text(hjust = 0), legend.title = element_blank()) +
    scale_color_manual(values = c("#000000", "#0072B2", "#D55E00"))

# predicted Q minimum (Q*)
qmin <- function(N, L, s){log(L*log(2)/(2*s*N))/log(L/2)}

# function that evalutes min Q (Q*) vs selection coefficient
qmin_vs_s <- function(Ne, L, s_start, s_stop, s_steps = 0.001)
{
  s <- seq(s_start, s_stop, s_steps)  
  qmin <- vapply(s, function(s){qmin(Ne, L, s)}, 1)
  data.frame(s, qmin, Ne, L)
}

# make a data frame of Q* vs selection coefficient for N=10
df1 <- qmin_vs_s(10, 100, 0.0001, 0.1)

# make a data frame of Q* vs selection coefficient for N=100
df2 <- qmin_vs_s(100, 100, 0.0001, 0.1)

# make a data frame of Q* vs selection coefficient for N=1000
df3 <- qmin_vs_s(1000, 100, 0.0001, 0.1)

df <- rbind(df1, df2, df3)

p_qmin <- ggplot(df, aes(x = s, y = qmin, color = factor(Ne))) +
  geom_line(size = 1.1) + 
  geom_hline(yintercept = 1) +
  scale_y_continuous(breaks=seq(0,2,0.5)) +
  scale_x_log10(breaks=c(0.0001, 0.001, 0.01, 0.1), labels = c("0.0001", "0.001", "0.01", "0.1")) + 
  coord_cartesian(ylim=c(0,2),xlim=c(0.000099999,0.1)) +
  xlab('s') +
  ylab('Minimum of Q') +
  scale_color_colorblind(name = "N")

# arrange subfigures
p <- plot_grid(p_models, p_qmin,
                  labels=c("A","B"),
                  align = 'vh',
                  hjust = -1,
                  ncol=2,
                  nrow=1)

save_plot("../plots/minimum_q_vs_selection.pdf", p,
          ncol = 2, # we're saving a grid plot of 2 columns
          nrow = 1, # and 2 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_height=4,
          base_width=5.5)

#########################################################################
### Figure 3:                                                         ###
### Simulations with high mutation rate and no selection model        ###
#########################################################################
# evaluate fitness vs Q for the formula that's doesn't consider selection.
df <- eval_model(L = 100, s = 0.01, N = 100) %>% filter(formula == "no_selection")
t_N100a <- read_csv("../processed_results/varying_eps_N100_max3.csv")
t_N100b <- read_csv("../processed_results/varying_eps_N100_max4.csv")

t <- rbind(t_N100a, t_N100b) 

# calculate a mean fitness across time when the population reached epistasis
t %>% mutate(q = 1-epistasis_coef) %>% 
  group_by(q, sel_coef, mu_prob, Ne, k_start, rep) %>% #one mean per simulation
  summarise(mean_f_over_time = mean(mean_fitness)) -> t_sum

t_sum %>% filter(sel_coef == 0.01) -> f

p_mu <- ggplot() +
  geom_line(data = df, aes(q, f_ave), size = 1.1) + 
  stat_summary(data = f,
               inherit.aes = FALSE,
               aes(x = q, y = mean_f_over_time, color=factor(mu_prob)),
               fun.y = mean,
               fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
               fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
               geom = "pointrange",
               size=0.4) +
  xlab('Q') +
  ylab('Mean fitness') +
  guides(col = guide_legend(title="Mutation\nrate")) +
  scale_color_manual(labels= c("0.0001", "0.001", "0.01", "0.1", "1"),
                     values = c("#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00"))

save_plot("../plots/no_selection_model_vs_mu.pdf", p_mu,
          # each individual subplot should have an aspect ratio of 1.3
          base_height=5,
          base_width=6)
  
