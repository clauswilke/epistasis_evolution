#include "organism_binary_genome.h"
#include "random.h"

#include <iostream>
#include <set>
#include <cmath>

Organism::Organism(int L, int k, double s, double q) :
	m_L(L), m_genome(L, 0), m_s(s), m_q(q)
{
	set_num_mutations(k);
}

void Organism::calc_fitness()
{
	int count=0; 
	for (auto it=m_genome.begin(); it!=m_genome.end(); it++)
	{
		if (*it==0)
		{
			count += 1;
		}  
	}
	m_fitness = exp(-m_s*pow(count, m_q));
}

void Organism::mutate_k_sites(int k)
{
	if (k == 0) return; // no mutations, nothing to be done
	
	// cannot mutate more than every single site
	if (k>m_L) k = m_L;
	
	//std::cout << "# of mutations: " << k << std::endl;
	std::set<int> sites_mutated;  
		
	for (int i=0; i<k; i++)
	{
		int site = Random::rng.rint(m_L);
		//std::cout << "mutating site " << site << std::endl;
		if (sites_mutated.find(site) != sites_mutated.end())
		{
			//std::cout << "site " << site << " already mutated" << std::endl;
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



void Organism::set_num_mutations(int k)
{
	for (auto it=m_genome.begin(); it!=m_genome.end(); it++)
	{
		*it = 1;
	}
	
	calc_fitness();

	mutate_k_sites(k);
}