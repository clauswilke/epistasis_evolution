import numpy as np

class population:

	def __init__(self, L, N, s, q, mu):
		self.L = L
		self.N = N
		self.s = s
		self.q = q
		self.mu = mu

		self.initialize(0)
			
	def replicate(self):
		prob_repl = self.f*self.n_k/np.sum(self.f*self.n_k) #probability of being replicated based on the number of individuals within a mutation class and the fitness of the mutation class
		self.n_k = np.random.multinomial(self.N, prob_repl) #draws offspring based on the probability of replication for each mutation class
		
	def mutate(self):
		redistr = np.empty([self.L+1, 3]) #set up an empty array to keep track of individuals to move
		
		#calculate the number of individuals to move for each mutation class
		for k in self.k_class:
			#an array of probabilities of moving to k-1, stay at k, and moving to k+1
			prob_mut = np.array([k/self.L*self.mu , 1-self.mu, (self.L-k)/self.L*self.mu]) 
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
				self.n_k[k] = self.n_k[k]-(up+down)
				self.n_k[k+1] = self.n_k[k+1]+up
			
			if k==self.L:
				self.n_k[k-1] = self.n_k[k-1]+down
				self.n_k[k] = self.n_k[k]-(up+down)
			
			if k>0 and k<self.L:
				self.n_k[k-1] = self.n_k[k-1]+down
				self.n_k[k] = self.n_k[k]-(up+down)
				self.n_k[k+1] = self.n_k[k+1]+up
				
	def mean_fitness(self):
		return np.mean(self.f)
		
	def evolve(self, t):
		for t_i in range(t):
			print("---------------")
			print("time step: ", t_i)
			print("n_k: ", self.n_k)
			self.replicate()
			print("n_k after replication: ", self.n_k)
			self.mutate()
			print("n_k after mutation: ", self.n_k)
	
	def initialize(self, k_start):
		#intialize an array of mutation classes, k=1,2,3,...,L
		self.k_class = np.array(range(self.L+1))
		
		#initialize a zero array to hold n_k for each mutation class k
		self.n_k =  np.zeros(self.L + 1)
		
		#calculate an array that contains fitness values for each mutation class k
		self.f = np.exp(-self.s*self.k_class)
		
		#set the entire population to mutation class k=0.
		self.n_k[k_start] = self.N
		
		
def main():
	
	L = 10 ##number of classes of mutations
	N = 100 ##total population size 
	s = 0.1 ##selection coefficient
	q = 1 ##
	mu = 0.1 ##probability of mutating
	t = 10 ##number of time steps or number of generations
	
	pop = population(L, N, s, q, mu)
	pop.evolve(t)

main()
