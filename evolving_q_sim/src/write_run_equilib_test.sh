#!/bin/bash

# set parameters in the simulations
repl_num=1 # number of replicates
sel_coef=0.001 # selection coefficient, set such that s*N << 1 (s is selection coefficient, N is effective population size) 
mut_prob=0.0001 # mutation rate per genome
num_class=100 # number of maximum mutations (denoted as L)
k_start=0 # number of mutations a population starts with
eff_pop=100 # effective population size
#q_prob_arr=(0.1 0.01 0.001) # an array where each element corresponds to a probability that epistasis will change at each time step
q_prob_arr=(0)
runfile=run_equilib_test.sh # the name of the script that will contain a command line for each run of a simulation

# remove a file to run the simulations if it exists in the current directory already
if [ -f $runfile ]; then
    rm $runfile
fi

# create output directory
# every output will be saved in this directory
if [ ! -d ../raw_results ]; then
    mkdir ../equilib_test
fi

# write a script to run every simulation
for q_start in $(seq 0 0.2 2.01)
do  
    for q_prob in ${q_prob_arr[*]}
    do
        for i in $(seq 1 $repl_num) 
        do
            # set the name of the file that will contain output produced by evolve.py
            # each output file will keep track of a population from the start (t = 0) until t = 5,000,000.
            outfile=../equilib_test/q_start${q_start}_q_prob${q_prob}_rep${i}.txt
            echo python equilib_test.py -s $sel_coef -m $mut_prob -N $eff_pop -L 100 -k_start $k_start -q_start $q_start -q_prob $q_prob $outfile >> $runfile 
        done
    done
done

chmod +x $runfile