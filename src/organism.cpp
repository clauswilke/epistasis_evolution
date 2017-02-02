#include "organism.h"

#include <iostream>

Organism::Organism(int L, double s) :
	m_L(L), m_genome(L, 0), m_s(s) {
	calc_fitness();
}

Organism::Organism(const Organism& o) :
	m_L(o.m_L), m_genome(o.m_genome), m_s(o.m_s) {
	calc_fitness();
}

void Organism::calc_fitness()
{
	double fitness = 1;
	for (auto it=m_genome.begin(); it!=m_genome.end(); it++){
		if (*it==0){
			fitness *= 1-m_s;
		}  
	}
	m_fitness = fitness;
}