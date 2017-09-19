library(dplyr)
library(readr)

in_dir <- "varying_eps_sim"
outfile <- "processed_results/varying_eps.csv"

f_lst <- list.files(in_dir,full.names=T)
d <- data.frame()

for (f in f_lst) {
  r <- read_delim(f,"\t")
  
  start <- regexpr("rep",f)[1]
  end <- regexpr(".txt",f)[1]
  num <- as.numeric(substr(f,start+3,end-1))
  r$rep <- rep(num,length(r$Ne))

  if (nrow(d)==0) {
    d <- r 
    } else d <- rbind(d,r)
}

write_csv(d,outfile)