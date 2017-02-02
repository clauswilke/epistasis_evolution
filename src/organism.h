#ifndef ORGANISM_H
#define ORGANISM_H

#include <vector>


class Organism{
private:
	Organism();
	
	int m_L; // genome length
	double m_s; // selection coeff.
	std::vector<int> m_genome; // genome
	double m_fitness; // current fitness value

public:
	Organism(int L, double s);
	Organism(const Organism& o); 
	
	void calc_fitness();
	
	const double get_fitness() {return m_fitness;}
};

#endif
