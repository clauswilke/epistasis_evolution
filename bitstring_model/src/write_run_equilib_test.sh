#!/bin/bash
sel_coef_arr=(0.1 0.01 0.001 0.0001)  ##s*N < 1
mut_prob_arr=(0.0001 0.001 0.01) ##pick mutation prob such that N*mu = 0.1, 1, 10
eff_pop=100
num_class=100
k_start_arr=(0 $num_class)
eps_arr=(1 0.5 0 -0.5 -1)

if [ -f src/run_equilib_test.sh ]; then
	rm src/run_equilib_test.sh 
fi

for eps in ${eps_arr[*]}
do
	for sel_coef in ${sel_coef_arr[*]}
	do 	
		for mut_prob in ${mut_prob_arr[*]} 	 
		do
			for k in ${k_start_arr[*]} 
			do
				out_file=complexity_evolution/bitstring_model/equilib_test/eps${eps}_s${sel_coef}_m${mut_prob}_k_start${k}.txt
				echo python complexity_evolution/bitstring_model/src/evolve.py -s $sel_coef -m $mut_prob -N $eff_pop -L $num_class -k_start $k -eps $eps -o $out_file >> src/run_equilib_test.sh 
			done
		done
	done
done
