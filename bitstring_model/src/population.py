#!/usr/bin/python

'''
The script creates a class population.

'''

import numpy as np
import sys
import os.path

class population:

	def __init__(self, L, N, s, q, mu, k_start):
		self.L = L
		self.N = N
		self.s = s
		self.q = q
		self.mu = mu
		self.k_start = k_start

		self.initialize(k_start)
	
	def replicate(self):
		prob_repl = self.f*self.n_k/np.sum(self.f*self.n_k) #probability of being replicated based on the number of individuals within a mutation class and the fitness of the mutation class
		self.n_k = np.random.multinomial(self.N, prob_repl) #draws offspring based on the probability of replication for each mutation class
	
	def mutate(self, mut_matrix_file):
		if os.path.isfile(mut_matrix_file): #load the file if it exists in the directory provided
			mut_matrix=np.load(mut_matrix_file)
		else:
			print('The mutation matrix file does not exist')
			sys.exit()
		
		redistr = np.empty([self.L+1,7]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		for k in self.k_class:
			#index an array of probabilities of moving from to k+3, to k+2, to k+1, of staying at k, 
			#and moving to k-3, to k-2, to k-1.
			r = [i for i in range(k-3,k+3+1) if i >= 0 and i<=self.L] #find the proper range of values to index i.e. if k=0, then range is 0,1,2,3 etc.
			prob_mut=mut_matrix[k,r]
			
			if 1-np.sum(prob_mut)>0.0001:
				print(1-np.sum(prob_mut)) 
				print('class k:',k)
				print('Probabilities of moving to different mutational classes does not add up to 1')
				sys.exit()
			
			#draw numbers of individuals to move
			m = np.random.multinomial(self.n_k[k], prob_mut)
			
			#make an array so there are 0 individuals to move from k to k < 0 and to k > L
			if k-3<0:
				z = np.zeros(7-len(m))
				m = np.append(z,m)
			elif k+3>self.L:
				z = np.zeros(7-len(m))
				m = np.append(m,z)
			else:	
				pass
				
			redistr[k]=m
					
		self.redistribute_n_k(redistr,3)
		
	def redistribute_n_k(self, redistr_arr, max_step): #function takes both numpy arrays and list of lists

		#move n_k into different mutation classes
		for k in self.k_class:
			r = redistr_arr[k]
			
			#set the range of steps an individual can go.
			i_range = [j for j in range(k-max_step,k+max_step+1) if j>=0 and j<=self.L]			
			
			for i in i_range: 
				if i==k:
					continue 
				else:
					self.n_k[i]=self.n_k[i]+r[i-k+max_step] #add individuals into a new class
					self.n_k[k]=self.n_k[k]-r[i-k+max_step] #subtract individuals moved in previous step from class k
										
		if np.sum(self.n_k)!=self.N:
			print(self.n_k)
			print('The total number of individuals does not add up to Ne')
			sys.exit()
		
	def mean_fitness(self):
		mean_fitness = np.average(self.f, weights = self.n_k)
		return mean_fitness
				
	def initialize(self, k_start):
		#intialize an array of mutation classes, k=1,2,3,...,L
		self.k_class = np.array(range(self.L+1))
		
		#calculate an array that contains fitness values for each mutation class k
		self.f = np.exp(-self.s*(self.k_class**(self.q)))
		
		#initialize a zero array to hold individuals (n_k) for each mutation class (k)
		self.n_k =  np.zeros(self.L + 1)
	
		if self.f[k_start]==0: # check if the fitness at t=0 equals to zero
			nonzero_f = np.nonzero(np.around(self.f,decimals=2)) #find fitness values > 0.0001
			k_start = np.argmin(self.f[nonzero_f]) #find the minimum fitness value among fitness > 0.0001   
			
		#set the entire population to start at mutation class k_start.
		self.n_k[k_start] = self.N
			