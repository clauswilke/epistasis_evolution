#!/usr/bin/python

'''
This script calculates a LxL mutation matrix (L is the number of sites in an individuals genome). The cell k, j corresponds to the mutation rate from a genome with k mutations to a genome with j mutations. 

The matrix is outputted as a numpy file into the ../mutation_matrix directory

Author: Dariya K. Sydykova
'''

import numpy as np
import sys
from sympy import *

# this function returns a probability of mutating for cell k, j
def probmut(L, k, j):
    u = Symbol('u')
    return sum([binomial(k, i)*binomial(L-k, i-k+j)*u**(j-k+2*i)*(1-u)**(L+k-j-2*i) for i in range(max(0, k-j), max(L-j, k))])
    
# this function calculates a mutation matrix. 
def calc_mut_matrix(L, u_eval, max_step, order):
    
    #initiate a zero matrix to be filled with mutation probabilities
    mut_matrix = np.zeros((L+1, L+1))
    
    print('Calculating mutation matrix for u =', u_eval)
    for k in range(L+1):
        print('row:', k)
        
        if k==1:
            break

        for j in range(k-max_step, (k+max_step)+1):
        
            if (j<0 or j>L):
                continue
            
            u = Symbol('u')
            expr = series(probmut(L, k, j), u, 0, order) #expand the summation
            print("cell:", k, j)
            print("expr:", expr)
            expr_noO = expr.removeO() #remove the O(u) term
            mu_k_to_j = expr_noO.evalf(subs={u: u_eval}) #evaluate the expanded expression for a given u value
            mut_matrix[k, j] = mu_k_to_j #plug in the mutation probability into the matrix  
            print(mut_matrix[k, j])

    return mut_matrix

# this function generates a mutation matrix and writes to a file `outfile`
def write_matrix_file(mu_prob, L, max_step, outfile):
    u = mu_prob/L # calculate per site mutation rate
    order = max_step+1 # expand to this order
    
    mut_matrix = calc_mut_matrix(L, u, max_step, order) # calculate a mutation matrix for a given u, L, and maximum step.
    np.save(outfile, mut_matrix) # write a numpy object

    
def main():
    '''
    calculate a LxL mutation matrix
    '''
    
    #mu_prob_lst = [10, 1, 0.1, 0.01, 0.001, 0.0001] # mutation rates per genome
    mu_prob_lst = [1.1] # mutation rates per genome

    L = 100 # genome size or maximum number of mutations
    
    # calculate a mutation matrix for the list above
    for mu_prob in mu_prob_lst:
    
        # set maximum number of k mutations an individual can make
        if mu_prob == 10: # for high mutation rate, maximum steps are set to 5 or 4
            max_step = 4
        elif mu_prob >= 1: 
            max_step = 4
        else: # set maximum steps to 3 otherwise
            max_step = 3
        
        outfile = '../mutation_matrix/m%s.npy' %mu_prob # name of an output matrix
        write_matrix_file(mu_prob, L, max_step, outfile) # write a mutation matrix to the output file

if __name__ == "__main__":
    main()
