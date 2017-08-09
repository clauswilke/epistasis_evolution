library(dplyr)
library(readr)

setwd("complexity_evolution/bit_string_sim/")

#f_lst <- list.files("sim_results",full.names=T)
f_lst <- list.files("varying_eps_sim",full.names=T)
d <- data.frame()

for (f in f_lst) {
  r <- read_delim(f,"\t")

  if (nrow(d)==0) {
    d <- r 
    } else d <- rbind(d,r)
}

write_csv(d,"processed_results/varying_eps.csv")