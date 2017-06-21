#ifndef RANDOM_H
#define RANDOM_H

#include "boost/random.hpp"
#include "boost/generator_iterator.hpp"

namespace Random {

typedef boost::mt19937 RNGType;


class Random{
private:
	Random(const Random &);
	
	
    RNGType m_rng;
    boost::uniform_real<> m_unif_dist;
    
    boost::variate_generator< RNGType,
    	boost::uniform_real<> > m_runif;

public:
	Random() : 
		m_rng(), m_runif(m_rng, m_unif_dist) {};
	Random(int seed) :
		m_rng(seed), m_runif(m_rng, m_unif_dist) {};
	
	void set_seed(int seed);
	
    double runif() {return m_runif();}
    
    int rint(int max) {return static_cast<int>(max * m_runif());}
    
    int rpoisson(double mean) 
    {
    	// generate poisson variate by inversion
        double p = exp(-mean);
        int x = 0;
        double u = runif();
        while(u > p) {
            u = u - p;
            ++x;
            p = mean * p / x;
        }
        return x;
    }
};

extern Random rng;

}

#endif