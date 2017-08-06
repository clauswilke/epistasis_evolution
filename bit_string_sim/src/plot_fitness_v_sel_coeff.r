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

file_lst <- list.files("sim_results",pattern="n\\d+.\\d+.txt",full.names=T)

for (file in file_lst) {
    t <- read_delim(file,delim="\t")
    
    t %>% filter(k_start==0) -> t_0
    t %>% filter(k_start==100) -> t_100
      
    eps <- t$epistasis_coef[1]
    Ne <- t$Ne[1]
    L <- t$L[1]
    s <- t$sel_coef[1]
    
    an_mf <- predict_mean_fitness(Ne, L, s, eps)
    
    p <- ggplot()+
      geom_line(data=t_0, aes(x=time,y=mean_fitness,group=repl_num)) +
      geom_line(data=t_100, aes(x=time,y=mean_fitness,group=repl_num)) +
      geom_hline(yintercept = an_mf,color="red")+
      xlab('Time') +
      ylab('Mean fitness') +
      #scale_x_continuous(breaks=c(0,5000,10000),labels=c("0","5,000","10,000"))+
      #scale_y_continuous(breaks=seq(0.99,1,0.005))+
      theme(axis.title = element_text(size = 14),
            axis.text = element_text(size = 12),
            legend.text = element_text(size = 11),
            legend.title = element_text(size = 12))
    
  save_plot(paste0("plots/mean_fit_v_time_s",s,"_m",s,"_n",Ne,".pdf"), p)
  
}


