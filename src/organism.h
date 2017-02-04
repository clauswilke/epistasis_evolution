#ifndef ORGANISM_H
#define ORGANISM_H

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
	Organism(int L, double s);
	Organism(const Organism& o); 

	void mutate(double mu);
	
	const double get_fitness() {return m_fitness;}
	const Genome get_genome() {return m_genome;}
	const void print(std::ostream &out)
	{
		for (auto it=m_genome.begin(); it!=m_genome.end(); it++) out << *it;
		out << " " << m_fitness << std::endl;
	}
};

#endif
