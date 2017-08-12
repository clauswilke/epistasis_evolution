import numpy as np
import sys

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
		
	def mutate(self):
		redistr = np.empty([self.L+1, 3]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		for k in self.k_class:
			#an array of probabilities of moving to k-1, stay at k, and moving to k+1
			prob_mut = np.array([self.mu*k/self.L , 1-self.mu, self.mu*(self.L-k)/self.L]) 
			#draw numbers of individuals to move
			m = np.random.multinomial(self.n_k[k], prob_mut)
			
			#store number of individuals to move to k-1, to keep in k, and to move to k+1 for each k class
			redistr[k]=m

		#move n_k into different mutation classes
		for k in self.k_class:
			down = redistr[k,0] #number of ind in class k to move down to class k-1
			up = redistr[k,2] #number of ind in class k to move up to class k+1

			#redistribute n_k for different mutational classes
			if k==0:
				self.n_k[k] = self.n_k[k]-up
				self.n_k[k+1] = self.n_k[k+1]+up
			
			if k==self.L:
				self.n_k[k-1] = self.n_k[k-1]+down
				self.n_k[k] = self.n_k[k]-down
			
			if k>0 and k<self.L:
				self.n_k[k-1] = self.n_k[k-1]+down
				self.n_k[k] = self.n_k[k]-(up+down)
				self.n_k[k+1] = self.n_k[k+1]+up
			
		if np.sum(self.n_k)!=self.N:
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
	
		#set the entire population to start at mutation class k_start.
		self.n_k[k_start] = self.N
			