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
	
	def mutate_1step(self):
		redistr = np.empty([self.L+1, 3]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		for k in self.k_class:
			#an array of probabilities of moving to k-1, stay at k, and moving to k+1
			prob_mut = np.array([self.mu*k/self.L , 1-self.mu, self.mu*(self.L-k)/self.L]) 
			#draw numbers of individuals to move
			m = np.random.multinomial(self.n_k[k], prob_mut)
			
			#store number of individuals to move to k-1, to keep in k, and to move to k+1 for each k class
			redistr[k]=m

		self.redistribute_n_k(redistr)
	
	def mutate_3step_v1(self):
		redistr = np.empty([self.L+1, 7]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		u=self.mu/self.L
		for k in self.k_class:
			pr_minus3=(1/6)*k*(k-1)*(k-2)*u**3
			pr_minus2=(1/2)*k*(k-1)*u**2*(1-(self.L-2)*u)
			pr_minus1=k*u*(1-(self.L-1)*u+(1/2)*(self.L-1)*(self.L-2)*u**2)+(1/2)*k*(k-1)*(self.L-k)*u**3
			pr_stay=(1-self.L*u+(1/2)*self.L*(self.L-1)*u**2-(1/6)*self.L*(self.L-1)*(self.L-2)*u**3)+k*(self.L-k)*u**2*(1-self.L*u)
			pr_plus1=(self.L-k)*u*(1-(self.L-1)*u-(1/2)*(self.L-1)*(self.L-2)*u**2)+(1/2)*k*(self.L-k)*(self.L-k-1)*u**3			
			pr_plus2=(1/2)*(self.L-k)*(self.L-k-1)*u**2*(1-(self.L-2)*u)
			pr_plus3=(1/6)*(self.L-k)*(self.L-k-1)*(self.L-k-2)*u**3

			#an array of probabilities of moving from to k+3, to k+2, to k+1, of staying at k, 
			#and moving to k-3, to k-2, to k-1.
			prob_mut = np.array([pr_minus3, pr_minus2, pr_minus1, pr_stay, pr_plus1, pr_plus2, pr_plus3]) 

			#check that probability array add up to 1
			if 1-np.sum(prob_mut)>0.0001:
				print(prob_mut) 
				print('class k:',k)
				print('Probabilities of moving to different mutational classes does not add up to 1')
				sys.exit()

			#draw numbers of individuals to move
			m = np.random.multinomial(self.n_k[k], prob_mut)

			#store number of individuals to move to k-1, to keep in k, and to move to k+1 for each k class
			redistr[k]=m
		
		self.redistribute_n_k(redistr)
	
	def mutate_3step_v2(self, mut_matrix_file):
		if os.path.isfile(mut_matrix_file): #load the file if it exists in the directory provided
			mut_matrix=np.load(mut_matrix_file)
		else:
			print('The mutation matrix file does not exist')
			sys.exit()
		
		redistr = np.empty([self.L+1, 7]) #set up an empty array to keep track of individuals to move
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
			
			#format a zero array to add to m array 
			if len(m)<7:
				zero_arr=np.zeros(7-len(m))
				if k-3<0:
					full_m=np.append(zero_arr,m)
				elif k+3>self.L:
					full_m=np.append(m,zero_arr)
				redistr[k]=full_m
			else:
				redistr[k]=m

		self.redistribute_n_k(redistr)
		
	def redistribute_n_k(self, redistr_arr): #function takes both numpy arrays and list of lists

		#move n_k into different mutation classes
		for k in self.k_class:
			max_step=int((len(redistr_arr[k])-1)/2)

			for i in range(k-max_step,k+max_step+1): #set the range of steps an individual can go.
				
				if i<0 or i>self.L: #check if the range is out of bounds
					continue
								
				if k==i:
					continue 
				else:
					self.n_k[i]=self.n_k[i]+redistr_arr[k][i-k+max_step] #add individuals into a new class
					self.n_k[k]=self.n_k[k]-redistr_arr[k][i-k+max_step] #subtract individuals moved in previous step from class k
										
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
			