import argparse
import textwrap
import numpy as np
from population import population 

def evolve(L, N, s, q, mu, k_start, max_move, t, delta_t_out, outfile, mutfile=None):
	
	out = open(outfile,'w')
	out.write('time\tepistasis_coef\tsel_coef\tmu_prob\tNe\tL\tk_start\tmean_fitness\n')
	
	pop = population(L, N, s, q, mu, k_start) #initiate a population with given parameters
	
	mut_file='complexity_evolution/bitstring_model/mutation_matrix/m'+str(mu)+'.npy' #file that contains the mutation matrix
	for t_i in range(t+1000001): #for each time point replicate and mutate the population
		pop.replicate()
		pop.mutate(max_move, mutfile)
	
		if (t_i >= t): #after the population reaches the equilibrium at t=1,500,000 record the fitness at increments of 1000
			if (t_i % delta_t_out == 0): 
				out.write('%d\t%.10f\t%.10f\t%.10f\t%d\t%d\t%d\t%f\n' %(t_i, 1-q, s, mu, N, L, k_start, pop.mean_fitness()))
				out.flush()
	out.close()

def main():
	'''
	simulate bitstring population
	'''
	#creating a parser
	#creating a parser
	parser = argparse.ArgumentParser(
	formatter_class=argparse.RawDescriptionHelpFormatter,
	description='Bitstring simulations of the population fitness',
	epilog=textwrap.dedent('''\
            This script produces a CSV with the following columns: 
			
            Column name           Description
            ===================================================================
            time
            epistasis_coef
            sel_coef
            mu_prob
            Ne
            L
            k_start
            mean_fitness                 
            '''))
	#adding arguments

	##simulation input parameters
	parser.add_argument('-s', metavar='<s>', type=float, required=True, 
		help='selection coefficient')
	parser.add_argument('-m', metavar='<m>', type=float, required=True,
		help='the probability of moving to one mutation class')
	parser.add_argument('-N', metavar='<N>', type=int, required=True,
		help='the size of the population')
	parser.add_argument('-L', metavar='<L>', type=int, required=True,
		help='the number of the maximum mutations allowed in the population')
	parser.add_argument('-k_start', metavar='<k>', type=int, required=True,
		help='number of mutations that population starts with')
	parser.add_argument('-eps', metavar='<eps>', type=float, required=True,
		help='the epistatic effects of mutations')
	parser.add_argument('-max', metavar='<n>', type=int, required=True,
		help='max number of classes an individual can move from the current class')
	parser.add_argument('mutation_matrix', metavar='<matrix.npy>', type=str, 
		help='mutation matrix file')
		
	##simulation output file
	parser.add_argument('fitness_file', metavar='<mean_fitness.txt>', type=str, 
		help='output file with population parameters and fitness')
	
	args = parser.parse_args()

	#set up output file name if none is given
	if args.fitness_file is None:
		outfile = 'mean_fitness.txt'
	else:
		outfile = args.fitness_file
	
	s=args.s 
	N=args.N
	mu=args.m
	k_start=args.k_start
	L = args.L ##number of classes of mutations
	eps = args.eps ##epistasis
	q = 1-eps ##q=1-epsilon. if q is large ~ fitness is low and vice versa.
	max_move = args.max
	
	#set the time when fitness reaches equilibrium based on equilibrium test plots
	if (N==100 and max_move==1 or max_move==3): #for Ne=100 and max mutation move is 1 or 3 the equilibrium is reached at 1.5 million for all other parameter values.
		t=1500000
		
	if (N==10 and max_move==3): #for Ne=10 and max mutation move is 3 the equilibrium is reached at 2 million for all other parameter values.
		t=2000000
		
	delta_t_out = 1000 # at which time steps should output be printed?
	
	mutfile=args.mutation_matrix
	if mutfile is None:
		if max_move==3:
			print('Mutation matrix file is not specified')
			sys.exit()
		else:
			pass
			
	evolve(L, N, s, q, mu, k_start, max_move, t, delta_t_out, outfile, mutfile)
		
if __name__ == "__main__":
    main()

