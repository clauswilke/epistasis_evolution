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

#file_lst <- list.files("sim_results",pattern="n100.txt",full.names=T)
t <- read_csv("../processed_results/all.csv")

t %>% group_by(sel_coef,epistasis_coef,mu_prob) %>%
  mutate(an_mean_fitness=predict_mean_fitness(100,100,sel_coef,epistasis_coef),q=1-epistasis_coef)-> t_sum

for (s in c(0.1, 0.01, 0.001, 0.0001)){
  t_sum %>% filter(sel_coef==s) -> f
  
  p <- ggplot(f, aes(x=mu_prob*100, y=mean_fitness,color=factor(q)))+
    stat_summary(fun.y = mean,
                 fun.ymin = function(x) mean(x) - sd(x)/sqrt(length(x)), 
                 fun.ymax = function(x) mean(x) + sd(x)/sqrt(length(x)), 
                 geom = "pointrange",
                 size=0.4)+
    geom_line(aes(y = an_mean_fitness,group=factor(epistasis_coef),color=factor(q)))+
    xlab('Ne*mu')+
    ylab('Mean fitness')+
    scale_x_log10()+
    #scale_y_continuous(breaks=seq(0.99,1,0.005))+
    guides(col = guide_legend(title="Q",reverse = TRUE))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  
  save_plot(paste0("../plots/mean_fit_v_time_s",s,".pdf"), p)
}



