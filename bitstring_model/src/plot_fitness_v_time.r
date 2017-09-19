library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

t <- read_csv("processed_results/equilib_test_mut_v2.csv")

for (eps in c(-1,-0.5, 0, 0.5, 1)){
  t %>% filter(epistasis_coef==eps) -> f
  
  p <- ggplot(f, aes(x=time, y=mean_fitness))+
    geom_line(aes(group=k_start))+
    background_grid(major = 'x', minor = "none")+
    xlab('time')+
    ylab('mean fitness')+
    facet_grid(mu_prob ~ sel_coef)+
    scale_y_continuous(breaks=seq(0,1,0.2))+
    scale_x_continuous(breaks=seq(0,3000000,500000),label=c("0","0.5","1","1.5","2","2.5","3"))+
    coord_cartesian(ylim=c(0,1),xlim=c(0,3000000))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  
  save_plot(paste0("plots/mean_fit_v_time_eps",eps,"_mut_v2.pdf"), p, base_height=6, base_width=8)
}