#!/usr/bin/python

'''
This script compares the mutation probabilities calculated different ways 

'''

import numpy as np

def compare_mut(L, u, mu_matrix):
		
		#calculate the number of individuals to move for each mutation class
		for k in range(L+1):
			pr_minus3=(1/6)*k*(k-1)*(k-2)*u**3
			pr_minus2=(1/2)*k*(k-1)*u**2*(1-(L-2)*u)
			pr_minus1=k*u*(1-(L-1)*u+(1/2)*(L-1)*(L-2)*u**2)+(1/2)*k*(k-1)*(L-k)*u**3
			pr_stay=(1-L*u+(1/2)*L*(L-1)*u**2-(1/6)*L*(L-1)*(L-2)*u**3)+k*(L-k)*u**2*(1-L*u)
			pr_plus1=(L-k)*u*(1-(L-1)*u-(1/2)*(L-1)*(L-2)*u**2)+(1/2)*k*(L-k)*(L-k-1)*u**3			
			pr_plus2=(1/2)*(L-k)*(L-k-1)*u**2*(1-(L-2)*u)
			pr_plus3=(1/6)*(L-k)*(L-k-1)*(L-k-2)*u**3

			#an array of probabilities of moving from to k+3, to k+2, to k+1, of staying at k, 
			#and moving to k-3, to k-2, to k-1.
			prob_mut1 = np.array([pr_minus3, pr_minus2, pr_minus1, pr_stay, pr_plus1, pr_plus2, pr_plus3]) 
	
			ind = np.array([ j for j in range(k-3,(k+3)+1) if j>=0 and j<=L ])
			prob_mut2 = mu_matrix[k,ind]
			
			prob_mut1 = prob_mut1[ind-k+3]
			
			for i in range(len(prob_mut2)):
				if abs(prob_mut2[i]-prob_mut1[i])>0.001:
					print("mutation schemes are different")	
					print('mut2:',prob_mut2[i])
					print('mut1:',prob_mut1[i])
				
def main():
	'''
	read in a mutation matrix file
	'''
	
	mu_prob_lst=[0.1,0.01,0.001,0.0001]
	L=100
	
	for mu_prob in mu_prob_lst:
		u=mu_prob/L
		outfile="mutation_matrix/m"+str(mu_prob)+".npy"
		mu_matrix=np.load(outfile)
		compare_mut(L, u, mu_matrix)
		
if __name__ == "__main__":
    main()