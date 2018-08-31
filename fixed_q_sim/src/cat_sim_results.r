##########################################################################
# This script will concatenate simulation output generated by: 
# complexity_evolution/evolving_q_sim/src/evolve.py
# complexity_evolution/evolving_q_sim/src/equilib_test.py
# complexity_evolution/fixed_q_sim/src/evolve.py
# complexity_evolution/fixed_q_sim/src/equilib_test.py
#
# Author: Dariya K. Sydykova
##########################################################################

# load packages necessary to run the following script
library(dplyr)
library(here)
library(readr)

# set up input and output directories and name the output file
root_dir <- here() # get the directory of the root of the project
in_dir <- paste0(root_dir, "/evolving_q_sim/test_run/mu_prob0.01") # set the directory that contains the simulation results to be concatenated
outfile <- paste0(root_dir, "/evolving_q_sim/processed_results/evolved_q_mu0.01.csv") # name the CSV output file
pattern <- "" # find files with this pattern in the file names (optional)

# get a list of files to be concatenated from the directory `in_dir`
f_lst <- list.files(path = in_dir, pattern = pattern, full.names = T)
d <- data.frame() # create an empty data frame that will store the concatenated results

# loop over individual files 
for (f in f_lst) {
  r <- read_csv(f) # read the data frame in a file
  
  # if concatenating output files for distributions of mutations (those files contains "k_distr" in the name)
  if (pattern == "k_distr") {
    # if the file name contains 'rep' ('rep' indicates replicate number of a simulation), add the replicate number to the data frame as an extra variable
    if (grepl("rep", f, fixed = TRUE)){
      start <- regexpr("rep", f)[1] # find the position of 'rep' in file name
      end <- regexpr("_k_distr.csv", f)[1] # find the end of file name (replicate number is given immediately before '.txt')
      rep <- as.numeric(substr(f, start+3, end-1)) # extract the replicate number from file name
      r %>% mutate(rep = rep) -> r # add the replicate number as a new column in the data frame
    }
    
    # if the file name contains 'q_probb' ('q_prob' indicates the probability that q changes after the population has reached an equilibrium), add the probability of q changing to the data frame as an extra variable
    if (grepl("q_step", f, fixed = TRUE)){
      start <- regexpr("q_step", f)[1] # find the position of 'q_prob' in file name
      end <- regexpr("_rep", f)[1] # find the position of '_q_step' in file name (probability of q changing is given immediately before '_q_step')
      q_step <- substr(f, start+6, end-1) # extract the probability of q changing from file name
      r %>% mutate(q_step = q_step) -> r # add the probability of q changing as a new column in the data frame
    }
    
    # if the file name contains 'q_probb' ('q_prob' indicates the probability that q changes after the population has reached an equilibrium), add the probability of q changing to the data frame as an extra variable
    if (grepl("q_start", f, fixed = TRUE)){
      start <- regexpr("q_start", f)[1] # find the position of 'q_prob' in file name
      end <- regexpr("_q_prob", f)[1] # find the position of '_q_step' in file name (probability of q changing is given immediately before '_q_step')
      q_start <- substr(f, start+7, end-1) # extract the probability of q changing from file name
      r %>% mutate(q_start = q_start) -> r # add the probability of q changing as a new column in the data frame
    }
    
  # if not concatenating output files for distributions of mutations
  } else {
    # if the file name contains 'rep' ('rep' indicates replicate number of a simulation), add the replicate number to the data frame as an extra variable
    if (grepl("rep", f, fixed = TRUE)){
      start <- regexpr("rep", f)[1] # find the position of 'rep' in file name
      end <- regexpr(".csv", f)[1] # find the end of file name (replicate number is given immediately before '.txt')
      rep <- as.numeric(substr(f, start+3, end-1)) # extract the replicate number from file name
      r %>% mutate(rep = rep) -> r # add the replicate number as a new column in the data frame
    }
    
    # if the file name contains 'q_probb' ('q_prob' indicates the probability that q changes after the population has reached an equilibrium), add the probability of q changing to the data frame as an extra variable
    if (grepl("q_prob", f, fixed = TRUE)){
      start <- regexpr("q_prob", f)[1] # find the position of 'q_prob' in file name
      end <- regexpr("_q_step", f)[1] # find the position of '_q_step' in file name (probability of q changing is given immediately before '_q_step')
      q_prob_label <- substr(f, start+6, end-1) # extract the probability of q changing from file name
      r %>% mutate(q_prob_label = q_prob_label) -> r # add the probability of q changing as a new column in the data frame
    }
  }
  
  # add the data frame to previously loaded data frames
  d <- rbind(d, r)
}

# write the final one data frames to a file
write_csv(d, outfile)