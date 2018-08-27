#!/bin/bash

# set parameters in the simulations
repl_num=3 # number of replicates
sel_coef=0.01 # selection coefficient, set such that s*N << 1 (s is selection coefficient, N is effective population size) 
mut_prob=0.01 # mutation rate per genome
num_class=100 # number of maximum mutations (denoted as L)
eff_pop=100 # effective population size
k_start=0 # number of mutations a population starts with
q_start_arr=(2 0.2 0.9)
q_prob_start=0
q_prob_arr=(0.0001 0.001 0.01)
q_step_arr=(0.1 0.01)
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
for q_step in ${q_step_arr[*]}
do
    for q_start in ${q_start_arr[*]}
    do
        for q_prob in ${q_prob_arr[*]}
        do
            for i in $(seq 1 $repl_num) 
            do
                # set the names of the files that will contain output produced by evolve_q.py
                # each output file will keep track of a population from the start (t = 0) until t = 100,000,000.
                # $outfile will contain parameters of a population outputted at increments of 1000 time steps
                outfile=../raw_results/q_start${q_start}_q_prob${q_prob}_q_step${q_step}_rep${i}.csv
                # $distrfile will contain distributions of mutations in a population outputted at increments of 1000 time steps
                distrfile=../raw_results/q_start${q_start}_q_prob${q_prob}_q_step${q_step}_rep${i}_k_distr.csv
                echo nohup python evolve_q.py -s $sel_coef -m $mut_prob -N $eff_pop -L $L -k_start $k_start -q_start $q_start -q_prob_start $q_prob_start -q_prob $q_prob -q_step $q_step -k_distr_file $distrfile $outfile \& >> $runfile 
            done
        done
    done
done

# make $runfile an executable
chmod +x $runfile