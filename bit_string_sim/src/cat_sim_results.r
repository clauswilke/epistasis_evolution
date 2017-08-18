library(dplyr)
library(readr)

setwd("complexity_evolution/bit_string_sim/")

in_dir <- "equilib_test"
outfile <- "processed_results/equilib_test.csv"

f_lst <- list.files(in_dir,full.names=T)
d <- data.frame()

for (f in f_lst) {
  r <- read_delim(f,"\t")

  if (nrow(d)==0) {
    d <- r 
    } else d <- rbind(d,r)
}

write_csv(d,outfile)