library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

setwd("complexity_evolution/bit_string_sim/")

t <- read_csv("processed_results/equilib_test.csv")

for (eps in c(-1,-0.5, 0, 0.5, 1)){
  t %>% filter(epistasis_coef==eps) -> f
  
  p <- ggplot(f, aes(x=time, y=mean_fitness))+
    geom_line(aes(group=k_start))+
    xlab('time')+
    ylab('mean fitness')+
    facet_grid(mu_prob ~ sel_coef)+
    scale_y_continuous(breaks=seq(0,1,0.2))+
    scale_x_continuous(breaks=seq(0,5000000,1000000),label=c("0","1","2","3","4","5"))+
    coord_cartesian(ylim=c(0,1),xlim=c(0,5000000))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  
  save_plot(paste0("plots/mean_fit_v_time_eps",eps,".pdf"), p, base_height=6, base_width=8)
}