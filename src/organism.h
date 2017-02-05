#ifndef ORGANISM_H
#define ORGANISM_H

#include "random.h"

#include <vector>
#include <ostream>


class Organism{
public:
	typedef std::vector<double> Genome;
private:
	Organism();
	
	int m_L; // genome length
	double m_s; // selection coeff.
	double m_q; // epistasis coeff.
	Genome m_genome; // genome
	Genome m_genome_mutation; // vector to hold mutations
	double m_fitness; // current fitness value

	void calc_fitness();
	
public:
	Organism(int L, double s, double q);
	Organism(const Organism& o) :
		m_L(o.m_L), m_s(o.m_s), m_q(o.m_q),
		m_genome(o.m_genome), m_genome_mutation(o.m_L, 0.),
		m_fitness(o.m_fitness) {}

	void mutate(double mu, double r=0.1);
		
	const double get_fitness() {return m_fitness;}
	const Genome get_genome() {return m_genome;}
	const void print(std::ostream &out)
	{
		out << "c(";
		for (auto it=m_genome.begin(); it!=m_genome.end(); it++) out << *it << ", ";
		out << ") " << m_L << " " << m_s << " " << m_fitness << std::endl;
	}
};

#endif
