#ifndef ORGANISM_H
#define ORGANISM_H

#include "random.h"

#include <vector>
#include <ostream>


class Organism{
public:
	typedef std::vector<int> Genome;
private:
	Organism();
	
	int m_L; // genome length
	double m_s; // selection coeff.
	Genome m_genome; // genome
	double m_fitness; // current fitness value

	void calc_fitness();
	
public:
	Organism(int L, int k, double s);
	Organism(const Organism& o) :
		m_L(o.m_L), m_s(o.m_s),
		m_genome(o.m_genome), m_fitness(o.m_fitness) {}

	void mutate(double mu)
	{
		mutate_k_sites(Random::rng.rpoisson(mu));
	}
	
	// mutate a randomly chosen k sites
	void mutate_k_sites(int k);
	
	// set the number of mutations to k, randomly distributed
	// differs from `mutate_k_sites` by first setting entire
	// genome to 1s.
	void set_num_mutations(int k);
	
	const double get_fitness() {return m_fitness;}
	const Genome get_genome() {return m_genome;}
	const void print(std::ostream &out)
	{
		for (auto it=m_genome.begin(); it!=m_genome.end(); it++) out << *it;
		out << " " << m_L << " " << m_s << " " << m_fitness << std::endl;
	}
};

#endif
