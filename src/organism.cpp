#include "organism.h"
#include "random.h"

#include <iostream>
#include <set>

Organism::Organism(int L, double s) :
	m_L(L), m_genome(L, 0), m_s(s)
{
	calc_fitness();
}

Organism::Organism(const Organism& o) :
	m_L(o.m_L), m_genome(o.m_genome), m_s(o.m_s)
{
	calc_fitness();
}

void Organism::calc_fitness()
{
	double fitness = 1;
	for (auto it=m_genome.begin(); it!=m_genome.end(); it++)
	{
		if (*it==0)
		{
			fitness *= 1-m_s;
		}  
	}
	m_fitness = fitness;
}

void Organism::mutate(double mu)
{
	int k = Random::rng.rpoisson(mu); // number of mutations
	
	// cannot mutate more than every single site
	if (k>m_L) k = m_L;
	
	std::cout << "# of mutations: " << k << std::endl;
	std::set<int> sites_mutated;  
		
	for (int i=0; i<k; i++)
	{
		int site = Random::rng.rint(m_L);
		std::cout << "mutating site " << site << std::endl;
		if (sites_mutated.find(site) != sites_mutated.end())
		{
			std::cout << "site " << site << " already mutated" << std::endl;
			i--; // decrement counter to uncount this mutation
			continue;
		}
		else
		{
			sites_mutated.insert(site);
			// mutate
			m_genome[site] = m_genome[site] ^ 1; // bit-wise XOR
		}
	}
	calc_fitness();
}