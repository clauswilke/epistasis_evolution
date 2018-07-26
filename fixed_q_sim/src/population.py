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
    
    def move_class(self, max_move, redistr):
        
        if max_move == 1:
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
            
        elif max_move == 3: 
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
 
                else:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
            
        elif max_move == 4: 
            #move n_k into different mutation classes
            for k in self.k_class:
                down4 = redistr[k,0] #number of ind in class k to move down to class k-4
                down3 = redistr[k,1] #number of ind in class k to move down to class k-3
                down2 = redistr[k,2] #number of ind in class k to move down to class k-2
                down1 = redistr[k,3] #number of ind in class k to move down to class k-1
                up1 = redistr[k,5] #number of ind in class k to move up to class k+1
                up2 = redistr[k,6] #number of ind in class k to move up to class k+2
                up3 = redistr[k,7] #number of ind in class k to move up to class k+3
                up4 = redistr[k,8] #number of ind in class k to move up to class k+4
    
                #redistribute n_k for different mutational classes
                if k==0:
                    self.n_k[k] = self.n_k[k]-(up4+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
                    self.n_k[k+4] = self.n_k[k+4]+up4
            
                elif k==1:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k] = self.n_k[k]-(down1+up4+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
                    self.n_k[k+4] = self.n_k[k+4]+up4
            
                elif k==2:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k] = self.n_k[k]-(down1+down2+up4+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
                    self.n_k[k+4] = self.n_k[k+4]+up4

                elif k==3:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+up4+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
                    self.n_k[k+4] = self.n_k[k+4]+up4
                                                                                
                elif k==self.L:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k-4] = self.n_k[k-4]+down4
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+down4)
 
                elif k==self.L-1:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k-4] = self.n_k[k-4]+down4
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+down4+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
 
                elif k==self.L-2:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k-4] = self.n_k[k-4]+down4
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+down4+up1+up2)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   

                elif k==self.L-3:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k-4] = self.n_k[k-4]+down4
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+down4+up1+up2+up3)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3   
 
                else:
                    self.n_k[k-1] = self.n_k[k-1]+down1
                    self.n_k[k-2] = self.n_k[k-2]+down2
                    self.n_k[k-3] = self.n_k[k-3]+down3
                    self.n_k[k-4] = self.n_k[k-4]+down4
                    self.n_k[k] = self.n_k[k]-(down1+down2+down3+down4+up4+up3+up2+up1)
                    self.n_k[k+1] = self.n_k[k+1]+up1
                    self.n_k[k+2] = self.n_k[k+2]+up2   
                    self.n_k[k+3] = self.n_k[k+3]+up3
                    self.n_k[k+4] = self.n_k[k+4]+up4       
    
    def draw_indiv_to_move(self, max_move, mut_matrix_file = None):
        # set up an empty list of lists to keep track of individuals to move
        # first index is the class k, and the second index is the number of individuals to move to k-1, k-2, etc. class.
        redistr = np.empty([self.L+1, 2*max_move+1]) 

        #move n_k into different mutation classes
        if max_move == 1:

            #calculate the number of individuals to move for each mutation class
            for k in self.k_class:
                #an array of probabilities of moving to k-1, stay at k, and moving to k+1
                prob_mut = np.array([self.mu*k/self.L , 1-self.mu, self.mu*(self.L-k)/self.L]) 
                #draw numbers of individuals to move
                m = np.random.multinomial(self.n_k[k], prob_mut)
        
                #store number of individuals to move to k-1, to keep in k, and to move to k+1 for each k class
                redistr[k]=m
        
        elif max_move == 3 or max_move == 4:
            if os.path.isfile(mut_matrix_file): #load the file if it exists in the directory provided
                mut_matrix=np.load(mut_matrix_file)
            else:
                print('The mutation matrix file does not exist')
                sys.exit()
                            
            #calculate the number of individuals to move for each mutation class
            for k in self.k_class:
                #index an array of probabilities of moving from to k+3, to k+2, to k+1, of staying at k, 
                #and moving to k-3, to k-2, to k-1.
                r = [i for i in range(k-max_move, k+max_move+1) if i >= 0 and i<=self.L] #find the proper range of values (or columns) to index. If k=0, then range is 0,1,2,3 etc.
                prob_mut=mut_matrix[k,r] #extract a correct row and columns from the probability matrix
            
                #check that the probabilities add up to 1
                if 1-np.sum(prob_mut)>0.0001:
                    print(1-np.sum(prob_mut)) 
                    print('class k:',k)
                    print('Probabilities of moving to different mutational classes does not add up to 1')
                    sys.exit()
            
                #draw numbers of individuals to move
                m = np.random.multinomial(self.n_k[k], prob_mut)
            
                #extend the array so there are 0 individuals to move from k to k < 0 and to k > L
                if k-max_move<0:
                    z = np.zeros(2*max_move+1-len(m))
                    m = np.append(z,m)
                elif k+max_move>self.L:
                    z = np.zeros(2*max_move+1-len(m))
                    m = np.append(m,z)
                else:   
                    pass
                
                #add the number of individuals to move
                redistr[k]=m
                
        else:
            print('Class population does not support maximum class moves '+str(max_move))
            sys.exit()
        
        return redistr
        
    def mutate(self, max_move, mut_matrix_file = None):

        # draw number of individuals to move classes
        redistr = self.draw_indiv_to_move(max_move, mut_matrix_file)
        
        # move individuals into different classes
        self.move_class(max_move, redistr)
        
        # check that the number of individuals didn't change
        if np.sum(self.n_k) != self.N:
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
            