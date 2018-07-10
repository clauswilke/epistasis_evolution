import argparse
import textwrap
import numpy as np
from population import population 

def evolve(L, N, s, mu, k_start, q_start, q_prob, t, delta_t_out, outfile):
    
    out = open(outfile,'w')
    out.write('time,sel_coef,mu_prob,Ne,L,k_start,q_start,q_prob,mean_fitness,mean_epistasis\n')
    
    pop = population(L, N, s, mu, k_start, q_start, q_prob) #initiate a population with given parameters
    
    for t_i in range(t+1000001): #for each time point replicate and mutate the population
        pop.replicate()
        pop.mutate()

        if (t_i >= t):
            if (t_i % delta_t_out == 0):
                out.write('%d,%.10f,%.10f,%d,%d,%d,%.10f,%.10f,%.10f,%.10f\n' %(t_i, s, mu, N, L, k_start, q_start, q_prob, pop.mean_fitness(), pop.mean_epistasis()))
                out.flush()
    out.close()

def main():
    '''
    simulate bitstring population
    '''
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
        help='mutation rate per genome')
    parser.add_argument('-N', metavar='<N>', type=int, required=True,
        help='the size of the population')
    parser.add_argument('-L', metavar='<L>', type=int, required=True,
        help='the number of the maximum mutations allowed in the population')
    parser.add_argument('-k_start', metavar='<k>', type=int, required=True,
        help='number of mutations that a population starts with')
    parser.add_argument('-q_start', metavar='<q_start>', type=float, required=True,
        help='epistasis coefficient that a population starts with')
    parser.add_argument('-q_prob', metavar='<q_prob>', type=float, required=True,
        help='the probability that epistatic coefficient changes during mutation')

        
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
    q_start=args.q_start
    q_prob=args.q_prob
    L = args.L ##number of classes of mutations
    
    #set the time when fitness reaches equilibrium based on equilibrium test plots
    t = 1500000 # testing
    delta_t_out = 1000 # at which time steps should output be printed?

    evolve(L, N, s, mu, k_start, q_start, q_prob, t, delta_t_out, outfile)
        
if __name__ == "__main__":
    main()
