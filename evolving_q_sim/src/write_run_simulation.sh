#!/bin/bash
repl_num=10
sel_coef=0.001 ##s*N < 1
mut_prob=0.0001
num_class=100
k_start=0
eff_pop=100
q_prob_arr=(0.1 0.01 0.001)
runfile=run_simulation.sh

if [ -f $runfile ]; then
    rm $runfile
fi

if [ ! -d ../test_sim ]; then
    mkdir ../test_sim
fi

for q_start in $(seq 0 0.2 2.01)
do  
    for q_prob in ${q_prob_arr[*]}
    do
        for i in $(seq 1 $repl_num) 
        do
            outfile=complexity_evolution/evolving_q_sim/test_sim/q_start${q_start}_q_prob${q_prob}_rep${i}.txt
            echo python complexity_evolution/evolving_q_sim/src/evolve.py -s $sel_coef -m $mut_prob -N $eff_pop -L 100 -k_start $k_start -q_start $q_start -q_prob $q_prob $outfile >> $runfile 
        done
    done
done