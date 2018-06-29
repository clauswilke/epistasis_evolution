#!/usr/bin/python

'''
The script creates a class population.

'''

import numpy as np
import sys
import os.path

np.random.seed(123)

class population:

    def __init__(self, L, N, s, mu, k_start = 0 , q_start = 1):
        self.L = L # set the number of maximum mutations (or total number of classes)
        self.N = N # set population size
        self.s = s # set selection coefficient
        self.mu = mu # set mutation rate per genome
        self.k_start = k_start # set starting number of mutations for all individuals
        self.q_start = q_start # set starting epistasis for all individuals

        self.initialize(k_start, q_start) # set up individual based arrays

    # creates a new generation in a population according to a Wright-Fisher model (assumes generations do not overlap)
    def replicate(self):
        # calculate frequencies of the individuals in a population
        sample_probabilities = self.individual_f/np.sum(self.individual_f)

        # points at which the associated cumulative distribution function jump
        cdf_jumps = np.cumsum(sample_probabilities)

        # draw a random sample of size N
        random_samples = np.random.rand(self.N)

        # pick individuals for reproduction (picks indices i)
        descendants = np.searchsorted(cdf_jumps, random_samples)

        # replace an old generation with a new one
        self.individual_k = [self.individual_k[i] for i in descendants]

    # mutate a population
    def mutate(self):

        #calculate the number of individuals to move for each mutation class
        for i in range(len(self.individual_k)):
            k = self.individual_k[i]
            #an array of probabilities of moving to k-1, stay at k, and moving to k+1
            prob_mut = np.array([self.mu*k/self.L , 1-self.mu, self.mu*(self.L-k)/self.L]) 
            #draw the move
            move = np.random.multinomial(1, prob_mut)

            # if we drew a beneficial mutation
            if move[0] == 1:
                k -= 1 # decrease k by 1
            # if we drew a deleterious mutation 
            elif move[2] == 1:
                k += 1 # increase k by 1
            # no mutations
            else: 
                pass # keep k as is
            
            #replace k
            self.individual_k[i] = k

    # calculate the mean fitness of a population
    def mean_fitness(self):
        self.individual_f = np.exp(-self.s*(self.individual_k**(self.individual_q)))
        mean_fitness = np.average(self.individual_f)
        return mean_fitness
                
    # set a population with given parameters
    def initialize(self, k_start, q_start):
        # intialize two arrays for individuals
        # first contains mutations k for an individual i, where k = 0, 1, 2,...,L and i = 1, 2, 3,...,N 
        self.individual_k = np.zeros(self.N) 
        # second contains epistasis q for an individual i, where 0 < q < 5
        self.individual_q = np.zeros(self.N)

        #set the entire population to start with k_start number of mutations and with q_start epistasis coefficient
        self.individual_k.fill(k_start)
        self.individual_q.fill(q_start)

        # create an array of fitness values f for each individuals
        self.individual_f = np.exp(-self.s*(self.individual_k**(self.individual_q)))
