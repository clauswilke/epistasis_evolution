#ifndef POPULATION_H
#define POPULATION_H

#include <vector>
#include "organism.h"


class Population{
private:
	Population();
	Population(const Population &);
	
	int m_N; // population size
	std::vector<Organism> m_pop; // actual population

public:
	Population(int N, Organism o);

	double get_mean_fitness();
};

#endif
