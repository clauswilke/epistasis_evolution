library(tidyr)
library(ggplot2)
library(dplyr)
library(cowplot)
library(readr)

t <- read_csv("../processed_results/equilib_test_N100_max1.csv") 
s_lst <- unique(t$sel_coef)

for (s in s_lst) {
  
  t %>% 
    filter(sel_coef==s) %>%
    mutate(q=1-epistasis_coef) -> t_filtered
  
  p <- ggplot(t_filtered, aes(x=time, y=mean_fitness,group=k_start))+
    background_grid(major = c("xy"))+
    geom_line()+
    xlab('Time')+
    ylab('Mean fitness')+
    scale_y_continuous(breaks=seq(0,1,0.2))+
    scale_x_continuous(breaks=seq(0,4000000,1000000),labels=c("0","1","2","3","4"))+
    coord_cartesian(ylim=c(0,1),xlim=c(0,4000000))+
    facet_grid(mu_prob ~ q)+
    theme(axis.title = element_text(size = 14),
          axis.text = element_text(size = 12),
          legend.text = element_text(size = 11),
          legend.title = element_text(size = 12))
  
  save_plot(paste0("../plots/fit_v_time_s",s,"_N100_max1.pdf"),
            base_width=10,
            base_height=8, p)
}



