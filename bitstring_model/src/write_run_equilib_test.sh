#!/bin/bash
sel_coef_arr=(0.1 0.01 0.001 0.0001)  ##s*N < 1
mut_prob_arr=(0.0001 0.001 0.01) ##pick mutation prob such that N*mu = 0.1, 1, 10
eff_pop=10
num_class=100
k_start_arr=(0 $num_class)
eps_arr=(0.9 0.45 0 -0.45 -0.9)
max_move=3
runfile=src/run_equilib_test_N${eff_pop}_max${max_move}.sh

if [ -f $runfile ]; then
	rm $runfile
fi

for eps in ${eps_arr[*]}
do
	for sel_coef in ${sel_coef_arr[*]}
	do 	
		for mut_prob in ${mut_prob_arr[*]} 	 
		do
			for k in ${k_start_arr[*]} 
			do
				outfile=complexity_evolution/bitstring_model/equilib_test/N${eff_pop}/eps${eps}_s${sel_coef}_m${mut_prob}_k_start${k}.txt
				mutfile=complexity_evolution/bitstring_model/mutation_matrix/m${mut_prob}.npy
				echo python complexity_evolution/bitstring_model/src/equilib_test.py -s $sel_coef -m $mut_prob -N $eff_pop -L $num_class -k_start $k -eps $eps -max $max_move $mutfile $outfile >> $runfile 
			done
		done
	done
done
