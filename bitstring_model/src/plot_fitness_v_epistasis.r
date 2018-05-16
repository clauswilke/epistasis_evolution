library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)


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

qmin <- function(s, N, L){log(L*log(2)/(2*s*N-2*s))/log(L/2)}

t <- read_csv("../processed_results/varying_eps_N100_max1.csv")

t %>% mutate(q=1-epistasis_coef) %>% 
  group_by(q,sel_coef,mu_prob,k_start,rep) %>%
  summarise(mean_f_over_time=mean(mean_fitness)) -> t_sum

for (s in c(0.01, 0.001, 0.0001)){
  t_sum %>% filter(sel_coef==s) -> f
  Ne <- t$Ne[1]
  L <- t$L[1]
  an_f <- w_vs_eps(Ne, L, s, -1, 1) %>% mutate(q=1-eps)
  q_est <- qmin(s,Ne,100)
  
  p <- ggplot()+ 
    stat_summary(data=f,
                 inherit.aes=FALSE,
                 aes(x=q,y=mean_f_over_time,color=factor(mu_prob)),
                 fun.y = mean,
                 fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)),
                 fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)),
                 geom = "pointrange",
                 size=0.4)+
    geom_line(data=an_f, aes(x=q,y = w_ave))+
    #geom_vline(xintercept = q_est, linetype = 2)+
    #draw_text(x = q_est+0.02, y =1, hjust = 0, vjust = 1, text = "predicted q*", size = 12)+
    #scale_y_continuous(breaks=seq(0.2,1,0.2))+
    coord_cartesian(ylim=c(0.7,1),xlim=c(0,2))+
    guides(col = guide_legend(title="\u03BC"))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12),
          legend.position = "none")+
    xlab('Q') +
    ylab('Mean fitness')
  save_plot(paste0("../plots/mean_fit_v_Q_s",s,"_N",Ne,"_max1.png"), p)
}

p3 <- make_fig(L = 100, s = 0.001, N = 100)