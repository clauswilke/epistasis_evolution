import numpy as np
import sys
from sympy import *


def probmut(L, k, j):
	u = Symbol('u')
	return sum([binomial(k, i)*binomial(L-k, i-k+j)*u**(j-k+2*i)*(1-u)**(L+k-j-2*i) for i in range(max(0, k-j), max(L-j, k))])
	
def calc_mut_matrix(L, u_eval, max_step, order):
	
	#initiate a zero matrix to be filled with mutation probabilities
	mut_matrix = np.zeros((L+1,L+1))
	
	print('Calculating mutation matrix for u =',u_eval)
	for k in range(L+1):
		print('row:',k)
		for j in range(k-max_step,(k+max_step)+1):
		
			if (j<0 or j>L): 
				continue	
			
			u = Symbol('u')
			expr=series(probmut(L, k, j), u, 0, order) #expand the summation 
			expr_noO=expr.removeO() #remove the O(u) term
			mu_k_to_j=expr_noO.evalf(subs={u: u_eval}) #evaluate the expanded expression for a given u value
			mut_matrix[k,j]=mu_k_to_j #plug in the mutation probability into the matrix
			
	return mut_matrix

def main():
	'''
	calculate a LxL mutation matrix
	'''
	
	#mu_prob_lst=[0.1,0.01,0.001,0.0001]
	L=100
	mu_prob_lst=[0.01]
	
	for mu_prob in mu_prob_lst:
		u=mu_prob/L
		mut_matrix=calc_mut_matrix(L, u, 3, 4)
		outfile="mutation_matrix/m"+str(mu_prob)+".npy"
		np.save(outfile, mut_matrix)
		
if __name__ == "__main__":
    main()
