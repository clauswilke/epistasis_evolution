import argparse
from population import population 

def evolve(L, N, s, q, mu, t, repl_num, k_start, outfile):

	out = open(outfile,'w')
	
	for i in range(repl_num):
		pop = population(L, N, s, q, mu, k_start)
	
		pop.n_k[k_start] = N-1
		pop.n_k[k_start-1] = 1

		for t_i in range(t):
			if (pop.n_k[k_start-1] == 100):
				out.write("1\n")
				break
		
			if (pop.n_k[k_start-1] == 0):
				out.write("0\n")
				break 
		
			pop.replicate()
			pop.mutate()

	out.close()

def main():
	'''
	simulate bitstring population
	'''
	#creating a parser
	parser = argparse.ArgumentParser(description='Simulations of the evolution in asexual population')
	
	##simulation output file
	parser.add_argument('-o', metavar='<mean_fitness.txt>', type=str, 
		help='output file with mean fitness values')
	
	args = parser.parse_args()

	#set up output file name if none is given
	if args.o is None:
		outfile = 'fixation_test.txt'
	else:
		outfile = args.o
	
	##simulation input parameters
	L = 100 ##number of classes of mutations
	N = 100 ##total population size. Set N to have N*mu << 1
	s = 0.01 ##selection coefficient
	eps = 0 ##epistasis
	q = 1-eps ##q=1-epsilon. if q is large ~ fitness is low and vice versa.
	mu = 0 ##probability of mutating
	t = 10000000 ##number of time steps or number of generations
	k_start = 100
	repl_num = 100000
	
	evolve(L, N, s, q, mu, t, repl_num, k_start, outfile)
	

if __name__ == "__main__":
    main()

