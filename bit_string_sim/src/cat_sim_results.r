library(dplyr)
library(readr)

setwd("complexity_evolution/bit_string_sim/")
f_lst <- list.files("sim_results",pattern="n10_stepwise_fit.txt",full.names=T)
d <- data.frame()

for (f in f_lst) {
  r1 <- read_delim(f,"\t")
  #a <- gsub("stepwise_fit", "analytical_mean_fitness", f)
  #r2 <- read_delim(a,"\t") 
  #r1 %>% left_join(r2) -> temp
  r1 -> temp
  
  if (nrow(d)==0) {
    d <- temp 
    } else d <- rbind(d,temp)
}

write_csv(d,"processed_results/all_n10_stepwise_fit.csv")