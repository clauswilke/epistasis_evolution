#include "organism.h"
#include "random.h"

#include <iostream>
#include <set>
#include <cmath>

Organism::Organism(int L, double s, double q) :
	m_L(L), m_genome(L, 0.), m_genome_mutation(L, 0), m_s(s), m_q(q)
{
	calc_fitness();
}

void Organism::calc_fitness()
{
	double x = 0; 
	for (auto it=m_genome.begin(); it!=m_genome.end(); it++)
	{
		x += (*it)*(*it);
	}
	x = sqrt(x);
	m_fitness = exp(-m_s*pow(x, m_q));
}

void Organism::mutate(double mu, double r)
{
	if (Random::rng.runif() >= mu)
		return;
	
	double x = 0;
	for (auto it=m_genome_mutation.begin(); it!=m_genome_mutation.end(); it++)
	{
		double delta = Random::rng.runif()-.5;
		*it = delta;
		x += delta*delta;
	}
	x = sqrt(x);
	
	for (int i=0; i<m_L; i++)
	{
		m_genome[i] += m_genome_mutation[i]/(x/r);
	}

	calc_fitness();
}

