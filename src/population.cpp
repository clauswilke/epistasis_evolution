#include "population.h"

#include <iostream>

Population::Population(int N, Organism o){
	m_N = N;
	for (int i=0; i<N; i++){
		m_pop.push_back(o);
	}
}

double Population::get_mean_fitness()
{
	double mean = 0.;
	for (auto it=m_pop.begin(); it!=m_pop.end(); it++){
		mean += (*it).get_fitness();
	}
	mean /= m_N;
	
	return mean;
}

