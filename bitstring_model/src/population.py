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
			print(self.n_k) 
			print('The total number of individuals does not add up to Ne')
			sys.exit()
	
	def mutate_3step(self):
		redistr = np.empty([self.L+1, 7]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		u=self.mu/self.L
		for k in self.k_class:
			pr_minus3=(1/6)*k*(k-1)*(k-2)*u**3
			pr_minus2=(1/2)*k*(k-1)*u**2*(1-(self.L-2)*u)
			pr_minus1=k*u*(1-(self.L+1)*u+(1/2)*self.L*(self.L+1)*u**2)+(1/2)*k*(k-1)*(self.L-k)*u**3
			pr_stay=(1-self.L*u+self.L*(self.L-1)*u**2-self.L*(self.L-1)*(self.L-2)*u**3)+k*(self.L-k)*u**2*(1-self.L*u)
			pr_plus1=(self.L-k)*u*(1-(self.L-1)*u-(self.L-1)*(self.L-2)*u**2)+k*(self.L-k)*(self.L-k-1)*u**3			
			pr_plus2=(1/2)*(self.L-k)*(self.L-k-1)*u**2*(1-(self.L-2)*u)
			pr_plus3=(1/6)*(self.L-k)*(self.L-k-1)*(self.L-k-2)*u**3

			#an array of probabilities of moving from to k+3, to k+2, to k+1, of staying at k, 
			#and moving to k-3, to k-2, to k-1.
			prob_mut = np.array([pr_minus3, pr_minus2, pr_minus1, pr_stay, pr_plus1, pr_plus2, pr_plus3]) 
			#renormalize the probabilities so they sum up to 1 because they are approximated
			prob_norm = prob_mut/np.sum(prob_mut)
			#draw numbers of individuals to move
			m = np.random.multinomial(self.n_k[k], prob_norm)
			
			#store number of individuals to move to k-1, to keep in k, and to move to k+1 for each k class
			redistr[k]=m

		#move n_k into different mutation classes
		for k in self.k_class:
			down3 = redistr[k,0] #number of ind in class k to move down to class k-3
			down2 = redistr[k,1] #number of ind in class k to move down to class k-2
			down1 = redistr[k,2] #number of ind in class k to move down to class k-1
			up1 = redistr[k,4] #number of ind in class k to move up to class k+1
			up2 = redistr[k,5] #number of ind in class k to move up to class k+2
			up3 = redistr[k,6] #number of ind in class k to move up to class k+3
	
			#redistribute n_k for different mutational classes
			if k==0:
				self.n_k[k] = self.n_k[k]-(up3+up2+up1)
				self.n_k[k+1] = self.n_k[k+1]+up1
				self.n_k[k+2] = self.n_k[k+2]+up2	
				self.n_k[k+3] = self.n_k[k+3]+up3
			
			elif k==1:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k] = self.n_k[k]-(down1+up3+up2+up1)
				self.n_k[k+1] = self.n_k[k+1]+up1
				self.n_k[k+2] = self.n_k[k+2]+up2	
				self.n_k[k+3] = self.n_k[k+3]+up3
			
			elif k==2:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k-2] = self.n_k[k-2]+down2
				self.n_k[k] = self.n_k[k]-(down1+down2+up3+up2+up1)
				self.n_k[k+1] = self.n_k[k+1]+up1
				self.n_k[k+2] = self.n_k[k+2]+up2	
				self.n_k[k+3] = self.n_k[k+3]+up3
										
			elif k==self.L:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k-2] = self.n_k[k-2]+down2
				self.n_k[k-3] = self.n_k[k-3]+down3
				self.n_k[k] = self.n_k[k]-(down1+down2+down3)

			elif k==self.L-1:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k-2] = self.n_k[k-2]+down2
				self.n_k[k-3] = self.n_k[k-3]+down3
				self.n_k[k] = self.n_k[k]-(down1+down2+down3+up1)
				self.n_k[k+1] = self.n_k[k+1]+up1

			elif k==self.L-2:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k-2] = self.n_k[k-2]+down2
				self.n_k[k-3] = self.n_k[k-3]+down3
				self.n_k[k] = self.n_k[k]-(down1+down2+down3+up1+up2)
				self.n_k[k+1] = self.n_k[k+1]+up1
				self.n_k[k+2] = self.n_k[k+2]+up2	

			#if (k+2)>0 and k<(self.L-2):
			else:
				self.n_k[k-1] = self.n_k[k-1]+down1
				self.n_k[k-2] = self.n_k[k-2]+down2
				self.n_k[k-3] = self.n_k[k-3]+down3
				self.n_k[k] = self.n_k[k]-(down1+down2+down3+up3+up2+up1)
				self.n_k[k+1] = self.n_k[k+1]+up1
				self.n_k[k+2] = self.n_k[k+2]+up2	
				self.n_k[k+3] = self.n_k[k+3]+up3
			
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
	
		#set the entire population to start at mutation class k_start.
		self.n_k[k_start] = self.N
			