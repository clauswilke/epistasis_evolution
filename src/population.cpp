#include "population.h"
#include "random.h"

#include <iostream>
#include <algorithm>
#include <utility>

using namespace std;

Population::Population(int N, double mu, Organism o){
	m_N = N;
	m_mu = mu;
	
	vector<Organism> pop, pop2;
	// create initial population
	for (int i=0; i<N; i++){
		pop.push_back(o);
	}

	m_pop.push_back(pop);
	m_pop.push_back(pop2); // empty population for Wright-Fisher sampling 
	
	// create pointer to first population
	m_current_pop = m_pop.begin();
}

void Population::do_Wright_Fisher_step()
{
	// first we need to generate a weights vector with
	// pointers to the corresponding organism
	typedef pair<double, IndividualsVect::iterator> wipair;
	vector<wipair> wi;
	wi.reserve(m_N);
	
	double wsum = 0; // running fitness sum
	for (auto it = m_current_pop->begin();
			  it != m_current_pop->end(); it++)
	{
		double w = it->get_fitness();
		wsum += w;
		wi.emplace_back(w, it);
		//it->print(cout);
	}
	
	// normalize to fitness to sum = 1
	for (auto it = wi.begin(); it != wi.end(); it++)
	{
		it->first /= wsum;
	}
	
	// output for debug purposes
    //for (auto it=wi.begin(); it!=wi.end(); it++)
	//{
	//	cout << it->first << " ";
	//	it->second->print(cout);
	//}
		
	// sort weight--index pairs by weight
	sort(wi.begin(), wi.end(),
          [] (wipair const& a, wipair const& b) { return a.first > b.first; });
          
    // output for debug purposes
    //cout << endl;
    //for (auto it=wi.begin(); it!=wi.end(); it++)
	//{
	//	cout << it->first << " ";
	//	it->second->print(cout);
	//}
	
	// now create new population by sampling from old
	auto new_pop = get_next_pop();
	new_pop->clear(); // empty out the target container for the new population

	for (int k=0; k<m_N; k++)
	{
		//cout << k << endl;
		// sample randomly
		auto it = wi.begin();
		double sum = it->first;
		double cut = Random::rng.runif();
		while (cut > sum)
		{
			it++;
			sum += it->first;
		}
		new_pop->push_back( *(it->second) ); // copy organism over
		//cout << "before: "; new_pop->back().print(cout);
		new_pop->back().mutate(m_mu); // mutate the organism
		//cout << "after:  "; new_pop->back().print(cout);
	} 

	// switch population over
	m_current_pop = new_pop;
}




double Population::get_mean_fitness() const
{
	double mean = 0.;
	for (auto it=m_current_pop->begin(); it!=m_current_pop->end(); it++){
		mean += (*it).get_fitness();
	}
	mean /= m_N;
	
	return mean;
}


