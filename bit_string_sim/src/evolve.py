import argparse
import numpy as np
from population import population 

def evolve(L, N, s, q, mu, t, delta_t_out, k_start, out):

	pop = population(L, N, s, q, mu, k_start)
	
	for t_i in range(t):
		pop.replicate()
		pop.mutate()
		#if (t_i % delta_t_out == 0):
		#	out.write('%d\t%.10f\t%.10f\t%.10f\t%d\t%d\t%d\t%d\t%f\n' %(t_i, 1-q, s, mu, N, L, k_start, i+1, pop.mean_fitness()))
		#	out.flush()
		if (t_i == t-1):
			out.write('%d\t%.10f\t%.10f\t%.10f\t%d\t%d\t%d\t%f\n' %(t_i, 1-q, s, mu, N, L, k_start, pop.mean_fitness()))

def main():
	'''
	simulate bitstring population
	'''
	#creating a parser
	parser = argparse.ArgumentParser(description='Simulations of the evolution in asexual population')
	#adding arguments

	##simulation input parameters
	parser.add_argument('-s', metavar='<selection coefficient>', type=float, 
		help='selection coefficient')
	parser.add_argument('-m', metavar='<probability of mutation>', type=float, 
		help='the probability of moving to one mutation class')
	parser.add_argument('-N', metavar='<effective population size>', type=int,
		help='the size of the population')
	parser.add_argument('-L', metavar='<number of classes of mutations>', type=int, 
		help='the number of the maximum mutations allowed in the population')
	parser.add_argument('-k_start', metavar='<number of mutations>', type=int, 
		help='number of mutations that population starts with')
	parser.add_argument('-eps', metavar='<epistasis coefficient>', type=float, 
		help='the epistatic effects of mutations')
	
	##simulation output file
	parser.add_argument('-o', metavar='<mean_fitness.txt>', type=str, 
		help='output file with mean fitness values')
	
	args = parser.parse_args()

	#set up output file name if none is given
	if args.o is None:
		outfile = 'mean_fitness.txt'
	else:
		outfile = args.o
	
	s=args.s
	N=args.N
	mu=args.m
	
	L = args.L ##number of classes of mutations
	eps = args.eps ##epistasis
	q = 1-eps ##q=1-epsilon. if q is large ~ fitness is low and vice versa.
	
	if N*mu >= 1:
		t = 500000 ##number of time steps or number of generations
	elif N*mu == 0.1:
		t = 1000000
	else:
		t = 2000000
		
	delta_t_out = 1000 # at which time steps should output be printed?
				
	out = open(outfile,'w')
	out.write('time\tepistasis_coef\tsel_coef\tmu_prob\tNe\tL\tk_start\tmean_fitness\n')

	evolve(L, N, s, q, mu, t, delta_t_out, 0, out)
	
	out.close()
		
if __name__ == "__main__":
    main()

