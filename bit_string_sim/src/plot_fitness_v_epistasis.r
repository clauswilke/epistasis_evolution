library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

setwd("complexity_evolution/bit_string_sim/")

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

t <- read_csv("processed_results/varying_eps.csv")

t %>% mutate(q=1-epistasis_coef) -> t_sum

for (s in c(0.1, 0.01, 0.001)){
  t_sum %>% filter(sel_coef==s) -> f
  Ne <- f$Ne[1]
  L <- f$L[1]
  an_f <- w_vs_eps(Ne, L, s, -1, 1) %>% mutate(q=1-eps)
  
  p <- ggplot()+ 
    stat_summary(data=f,
                 inherit.aes=FALSE,
                 aes(x=q,y=mean_fitness,color=factor(mu_prob)),
                 fun.y = mean,
                 fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)), 
                 fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)), 
                 geom = "pointrange",
                 size=0.4)+
    geom_line(data=an_f, aes(x=q,y = w_ave))+
    xlab('Q')+
    ylab('Mean fitness')+
    guides(col = guide_legend(title="Mu",reverse = TRUE))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  save_plot(paste0("plots/mean_fit_v_Q_s",s,".pdf"), p)
}