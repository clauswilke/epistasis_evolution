library(dplyr)

in_dir <- "../raw_results/"
outfile <- "../processed_results/evolved_q_prob0.csv"

f_lst <- list.files(path = in_dir, pattern = "q_prob0_", full.names = T)
d <- data.frame()

for (f in f_lst) {
  #r <- read_delim(f,"\t")
  r <- read.csv(f)
  
  if (grepl("rep", f, fixed = TRUE)){
    start <- regexpr("rep", f)[1]
    end <- regexpr(".txt", f)[1]
    num <- as.numeric(substr(f, start+3, end-1))
    r$rep <- rep(num, length(r$Ne))
  }

  if (nrow(d) == 0) {
    d <- r 
    } else d <- rbind(d, r)
}

write.csv(d, outfile)