library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

t <- read_csv("../processed_results/equilib_test_N100_max1.csv") 
s_lst <- unique(t$sel_coef)

predict_mean_fitness <- function(Ne, L, s, eps)
{
  k <- c(0:L)
  f <- exp(-s*k^(1-eps))	
  p_k <- (f^(2*Ne-2)*choose(L, k))/sum(f^(2*Ne-2)*choose(L, k))
  sum(f*p_k)
}

for (s in s_lst) {
  
  t %>% 
    filter(sel_coef==s) %>%
    mutate(q=1-epistasis_coef) -> t_filtered
  
  p <- ggplot(t_filtered, aes(x=time, y=mean_fitness,color=factor(k_start)))+
    background_grid(major = c("xy"))+
    geom_line(size=1.1)+
    xlab('Time (million generations)')+
    ylab('Mean fitness')+
    scale_y_continuous(breaks=seq(0,1,0.2))+
    scale_x_continuous(breaks=seq(0,4000000,1000000),labels=c("0","1","2","3","4"))+
    coord_cartesian(ylim=c(0,1),xlim=c(0,4000000))+
    facet_grid(mu_prob ~ q)+
    theme(axis.title = element_text(size = 20),
          axis.text = element_text(size = 14),
          legend.position="none")
  
  save_plot(paste0("../plots/fit_v_time_s",s,"_N100_max1.png"),
            base_width=10,
            base_height=8, p)
}

t %>% 
  mutate(q=1-epistasis_coef) %>%
  filter(sel_coef==0.01, q==1.45, mu_prob==0.0001)  -> t_filtered

w_ave <- predict_mean_fitness(100, 100, 0.01, 1-1.45) 

p <- ggplot(t_filtered, aes(x=time, y=mean_fitness,color=factor(k_start)))+
  background_grid(major = c("xy"))+
  geom_line(size=1.1)+
  xlab('Time (million generations)')+
  ylab('Mean fitness')+
  geom_hline(yintercept=w_ave,size=1.1)+
  scale_y_continuous(breaks=seq(0,1,0.2))+
  scale_x_continuous(breaks=seq(0,4000000,1000000),labels=c("0","1","2","3","4"))+
  coord_cartesian(ylim=c(0,1),xlim=c(0,4000000))+
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 14),
        legend.position="none")

save_plot(paste0("../plots/one_facte_fit_v_time_s0.01_N100_max1.png"),
          base_width=6,
          base_height=6, p)

