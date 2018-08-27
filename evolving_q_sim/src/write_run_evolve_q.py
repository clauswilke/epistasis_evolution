#!/bin/bash

# set parameters in the simulations
repl_num=5 # number of replicates
sel_coef=0.01 # selection coefficient, set such that s*N << 1 (s is selection coefficient, N is effective population size) 
mut_prob=0.01 # mutation rate per genome
num_class=100 # number of maximum mutations (denoted as L)
eff_pop=100 # effective population size
k_start_arr=(0 100) # an array where each element corresponds to a number of mutations a population starts with
q_start_arr=(2 0.2 0.9)
q_prob_start=0
q_prob=0.0001
L=100
runfile=run_evolve_q.sh # the name of the script that will contain a command line for each run of a simulation

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
for k_start in ${k_start_arr[*]}
do
    for q_start in ${q_start_arr[*]}
    do
        for i in $(seq 1 $repl_num) 
        do
            # set the name of the file that will contain output produced by evolve_q.py
            # each output file will keep track of a population from the start (t = 0) until t = 5,000,000.
            outfile=../raw_results/q_start${q_start}_k_start${k_start}_rep${i}.txt
            echo nohup python evolve_q.py -s $sel_coef -m $mut_prob -N $eff_pop -L $L -k_start $k_start -q_start $q_start -q_prob_start $q_prob_start -q_prob $q_prob $outfile \& >> $runfile 
        done
    done
done

chmod +x $runfile
chmod +x $runfile