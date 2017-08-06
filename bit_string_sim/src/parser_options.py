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
	parser.add_argument('-repl_num', metavar='<number of replicates of a simulation>', type=int, 
		help='number of replicates of a simulation')
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