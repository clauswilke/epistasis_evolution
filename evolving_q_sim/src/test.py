from population import population
import numpy as np
import argparse
import textwrap

def evolve(N, k_start, L, s, mu, q_start, q_prob, q_prob_start, delta_t_out, t_equilib):
    # name the output file that will contain evolution trajectory
    outfile = "../test_run/q_start" + str(q_start) + "_q_prob" + str(q_prob) + "_s" + str(s) + "_m" + str(mu) + "_N" + str(N) + "k_start" + str(k_start) + ".csv"
    # open a file to write simulation output
    out = open(outfile, 'w')
    # write a header
    out.write('time,sel_coef,mu_prob,Ne,L,k_start,q_start,q_prob,mean_fitness,mean_q\n')

    # name output file that will keep track of the distribution of mutations
    distrfile = "../test_run/q_start" + str(q_start) + "_q_prob" + str(q_prob) + "_s" + str(s) + "_m" + str(mu) + "_N" + str(N) + "k_start" + str(k_start) + "_k_distr.csv"
    # open distrfile to write 
    distr = open(distrfile, 'w')
    # write a header
    distr.write('time,k,num\n')

    #initiate a population with given parameters
    pop = population(L, N, s, mu, k_start, q_start, q_prob_start)
    change_q_prob = True

    for t_i in range(t_equilib + 300000001): 
        #for each time point replicate and mutate the population
        pop.replicate()
        pop.mutate()

        #record population fitness and epistasis coefficient at increments of delta_t_out
        if (t_i % delta_t_out == 0):
        
            # set new probability of q mutating when population equilibirates
            if (t_i > t_equilib and change_q_prob):
                pop.q_prob = q_prob # set new probability of q mutating
                change_q_prob = False
        
            out.write('%d,%.5f,%.5f,%d,%d,%d,%.2f,%.4f,%.8f,%.8f\n' %(t_i, pop.s, pop.mu, pop.N, pop.L, pop.k_start, pop.q_start, pop.q_prob, pop.mean_fitness(), pop.mean_epistasis()))
            out.flush()
        
            # get a distribution of k mutations in a population
            k_distr = np.bincount(pop.individual_k)
            for k in range(len(k_distr)): # loop over a distribution to write it to a file
                distr.write('%d,%d,%d\n' %(t_i,k,k_distr[k])) # write a distribution at each time point
                distr.flush()
    out.close()
    distr.close()

def main():
    '''
    simulate bitstring population
    '''
    #creating a parser
    parser = argparse.ArgumentParser(
    formatter_class = argparse.RawDescriptionHelpFormatter,
    description = 'Bitstring simulations of the population fitness',
    epilog = textwrap.dedent('''\
            This script produces a CSV with the following columns: 
            
            Column name           Description
            =====================================================================================================
            time                  time step in the evolution of a population
            sel_coef              selection coefficient 
            mu_prob               rate of mutation per genome
            Ne                    effective population size
            L                     maximum number of mutations per genome
            k_start               number of mutations each individual in a population starts with (t=0)
            q_start               epistatsis coefficient each individual in a population starts with (t=0)
            q_prob                probability of epistasis coefficient changing at each time step per individual
            mean_fitness          mean fitness of the population
            mean_q        mean epistasis coefficient of the population
            '''))
    #adding arguments

    ##simulation input parameters
    parser.add_argument('-N', metavar = '<N>', type = int, required = True,
        help = 'effective population size')
    parser.add_argument('-k_start', metavar = '<k>', type = int, required = True,
        help = 'number of mutations that population starts with')

    args = parser.parse_args()

    N = args.N
    k_start = args.k_start

    L = 100
    s = 0.01
    mu = 0.01
    q_start = 2
    q_prob = 0.0001
    q_prob_start = 0
    delta_t_out = 10000
    t_equilib = 200000

    evolve(N, k_start, L, s, mu, q_start, q_prob, q_prob_start, delta_t_out, t_equilib)

if __name__ == "__main__":
    main()

