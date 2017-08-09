#!/bin/bash
repl_num=10
sel_coef_arr=(0.1 0.01 0.001)  ##s*N < 1
mut_prob_arr=(0.0001 0.001 0.01 0.1) ##pick mutation prob such that N*mu = 0.1, 1, 10
eff_pop=100
num_class=100
k_start=0
#eps_arr=(seq -1 0.2 1.01)

if [ -f src/run_simulation.sh ]; then
	rm src/run_simulation.sh 
fi

for eps in $(seq -1 0.2 1.01)
do
	for sel_coef in ${sel_coef_arr[*]}
	do 	
		for mut_prob in ${mut_prob_arr[*]} 	 
		do
			for i in $(seq 1 $repl_num) 
			do
				out_file=complexity_evolution/bit_string_sim/varying_eps_sim/eps${eps}_s${sel_coef}_m${mut_prob}_rep${i}.txt
				echo python complexity_evolution/bit_string_sim/src/evolve.py -s $sel_coef -m $mut_prob -N $eff_pop -L $num_class -k_start $k_start -eps $eps -o $out_file >> src/run_simulation.sh 
			done
		done
	done
done
