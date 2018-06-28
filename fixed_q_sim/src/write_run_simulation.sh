#!/bin/bash
repl_num=10
#sel_coef_arr=(0.01 0.001 0.0001)  ##s*N < 1
#mut_prob_arr=(0.0001 0.001 0.01 0.1 1) ##pick mutation prob such that N*mu = 0.1, 1, 10
sel_coef_arr=(0.01)  ##s*N < 1
mut_prob_arr=(1)
num_class=100
k_start=0
max_move=4
eff_pop=100
runfile=run_simulation_N${eff_pop}_max${max_move}.sh


if [ -f $runfile ]; then
	rm $runfile
fi

if [ ! -d ../varying_eps_sim/N${eff_pop}_max${max_move} ]; then
	mkdir ../varying_eps_sim/N${eff_pop}_max${max_move}
fi

for eps in $(seq -1 0.2 1.01)
do	
	for sel_coef in ${sel_coef_arr[*]}
	do 	
		for mut_prob in ${mut_prob_arr[*]} 	 
		do
			for i in $(seq 1 $repl_num) 
			do
				outfile=complexity_evolution/bitstring_model/varying_eps_sim/N${eff_pop}_max${max_move}/eps${eps}_s${sel_coef}_m${mut_prob}_rep${i}.txt
				mutfile=complexity_evolution/bitstring_model/mutation_matrix/m${mut_prob}.npy
				echo python complexity_evolution/bitstring_model/src/evolve.py -s $sel_coef -m $mut_prob -N $eff_pop -L $num_class -k_start $k_start -eps ${eps} -max $max_move $mutfile $outfile >> $runfile 
			done
		done
	done
done
