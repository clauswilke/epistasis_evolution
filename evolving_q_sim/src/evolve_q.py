import argparse
import textwrap
import numpy as np
from population import population 

def evolve(N, k_start, L, s, mu, q_start, q_prob, q_prob_start, q_step, delta_t_out, t_equilib, outfile, distr_file = None):

    # open a file to write simulation output
    out = open(outfile, 'w')
    # write a header
    out.write('time,sel_coef,mu_prob,Ne,L,k_start,q_start,q_prob,q_step,mean_fitness,mean_q\n')

    # open a file to write distributions of mutations (k)
    distr = open(distr_file, 'w')
    # write a header
    distr.write('time,k,num,q_start,q_prob,q_step\n')

    #initiate a population with given parameters
    pop = population(L, N, s, mu, k_start, q_start, q_prob_start, q_step)
    change_q_prob = True # set up a boolean needed to make q evolve

    # evolve a population until it reaches equilibrium at t_equilib and for 100,000,000 time steps after that
    for t_i in range(t_equilib + 100000001): 
        #for each time point replicate and mutate the population
        pop.replicate()
        pop.mutate()

        #record population fitness and epistasis coefficient at increments of delta_t_out
        if (t_i % delta_t_out == 0):

            # set new probability of q mutating when population equilibrates
            if (t_i > t_equilib and change_q_prob):
                pop.q_prob = q_prob # set new probability of q mutating
                change_q_prob = False
            
            # write out population's mean fitness and mean epistasis with other parameters
            out.write('%d,%.5f,%.5f,%d,%d,%d,%.2f,%.4f,%.4f,%.8f,%.8f\n' %(t_i, pop.s, pop.mu, pop.N, pop.L, pop.k_start, pop.q_start, pop.q_prob, pop.q_step, pop.mean_fitness(), pop.mean_epistasis()))
            out.flush()

            # get a distribution of k mutations in a population
            unique, counts = np.unique(pop.individual_k, return_counts=True)
            count_dict = dict(zip(unique, counts))
            for k in count_dict: # loop over a distribution to write it to a file
                distr.write('%d,%d,%d,%.2f,%.4f,%.4f\n' %(t_i, k, count_dict[k], pop.q_start, pop.q_prob, pop.q_step)) # write a distribution at each time point
                distr.flush()

    # close output files
    out.close()
    distr.close()

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
    parser.add_argument('-N', metavar = '<N>', type = int, required = True,
        help='the size of the population')
    parser.add_argument('-k_start', metavar = '<k>', type = int, required = True,
        help='number of mutations that a population starts with')
    parser.add_argument('-L', metavar = '<L>', type = int, required = True,
        help='the number of the maximum mutations allowed in the population')
    parser.add_argument('-s', metavar = '<s>', type = float, required = True, 
        help='selection coefficient')
    parser.add_argument('-m', metavar = '<m>', type = float, required = True,
        help='mutation rate per genome')
    parser.add_argument('-q_start', metavar = '<q>', type = float, required = True,
        help='epistasis coefficient that a population starts with')
    parser.add_argument('-q_prob_start', metavar = '<q_prob_start>', type = float, required = True,
        help='the probability that epistatic coefficient changes before population reaches equilibrium')
    parser.add_argument('-q_prob', metavar = '<q_prob>', type = float,
        help='the probability that epistatic coefficient changes after population reaches equilibrium')
    parser.add_argument('-q_step', metavar = '<q_step>', type = float,
        help='the probability that epistatic coefficient changes after population reaches equilibrium')

    ##simulation output files
    parser.add_argument('fitness_file', metavar = '<mean_fitness.txt>', type = str, 
        help='output file with population parameters and fitness')
    parser.add_argument('-k_distr_file', metavar = '<k_distr_file.txt>', type = str, required = False,
        help='output file with distributions of mutations k')

    args = parser.parse_args()

    #set up output file names if none are given
    if args.fitness_file is None:
        outfile = 'equilib_test.txt'
    else:
        outfile = args.fitness_file

    if args.k_distr_file is None:
        distr_file = None
    else:
        distr_file = args.k_distr_file

    s = args.s 
    N = args.N
    mu = args.m
    k_start = args.k_start
    q_start = args.q_start
    q_prob_start = args.q_prob_start
    q_prob = args.q_prob
    q_step = args.q_step
    L = args.L

    #set time parameters
    t_equilib = 200000 # time when the population equilibrates (previously determined)
    delta_t_out = 10000 # at which time steps should output be printed

    evolve(N, k_start, L, s, mu, q_start, q_prob, q_prob_start, q_step, delta_t_out, t_equilib, outfile, distr_file)

if __name__ == "__main__":
    main()

