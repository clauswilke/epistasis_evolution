library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

t <- read_csv("processed_results/equilib_test_N10_max3.csv") 
eps_lst <- unique(t$epistasis_coef)
for (eps in eps_lst) {
  
  t %>% filter(epistasis_coef==eps) -> t_filtered
  
  p <- ggplot(t_filtered, aes(x=time, y=mean_fitness,group=k_start))+
    background_grid(major = c("xy"))+
    geom_line()+
    xlab('Time')+
    ylab('Mean fitness')+
    scale_y_continuous(breaks=seq(0,1,0.2))+
    scale_x_continuous(breaks=seq(0,3000000,1000000),labels=c("0","1","2","3"))+
    coord_cartesian(ylim=c(0,1),xlim=c(0,3200000))+
    facet_grid(sel_coef ~ mu_prob)+
    guides(col = guide_legend(title="eps",reverse = TRUE))+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  
  save_plot(paste0("plots/mean_fit_v_time_eps",eps,"_N10_max3.pdf"),
            base_width=10,
            base_height=10, p)
}



