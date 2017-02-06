#ifndef POPULATION_H
#define POPULATION_H

#include <vector>
#include "organism.h"


class Population{
private:
	Population();
	Population(const Population &);
	
	int m_N; // population size
	double m_mu; // mutation rate
	
	typedef std::vector<Organism> IndividualsVect;
	typedef std::vector<IndividualsVect> PopulationsVect;
	PopulationsVect m_pop; // actual population, 2 copies
	PopulationsVect::iterator m_current_pop; // pointer to current population

	// get an iterator to the alternative population
	PopulationsVect::iterator get_next_pop()
	{
		PopulationsVect::iterator it = m_current_pop;
		it++;
		if (it == m_pop.end()) it = m_pop.begin();
		return it;
	}

public:
	Population(int N, double mu, Organism o);
	
	void place(Organism o)
	{
		*(m_current_pop->begin()) = o;
	}

	void do_Wright_Fisher_step();

	double get_mean_fitness() const;
	
	void print(std::ostream &out) const
	{
		for (auto it=m_current_pop->begin();
				  it!=m_current_pop->end(); it++)
						it->print(out);
	}

};

#endif
