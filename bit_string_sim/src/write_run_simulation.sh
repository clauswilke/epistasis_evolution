#!/bin/bash
repl_num=1
sel_coef_arr=(0.001 0.0001)  ##s*N < 1
mut_prob_arr=(0.0001 0.001 0.01 0.1) ##pick mutation prob such that N*mu<<1
##Claus has simulated N*mu of 0.1, 1, 10
eff_pop=100
num_class=100
k_start=0
eps=0

for sel_coef in ${sel_coef_arr[*]}
do 	
	for mut_prob in ${mut_prob_arr[*]} 	 
	do
		out_file=sim_results/s${sel_coef}_m${mut_prob}_n${eff_pop}_kstart${k_start}.txt
		echo python src/evolve.py -s $sel_coef -m $mut_prob -N $eff_pop -L $num_class -k_start $k_start -eps $eps -o $out_file >> src/run_simulation.sh 
	done
done