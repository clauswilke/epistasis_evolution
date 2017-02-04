#include <iostream>


#include <vector>
#include <algorithm>
#include <utility>

#include "organism.h"
#include "population.h"
#include "random.h"

using namespace std;

void test_random()
{
	cout << "\nTest Poisson random variates" << endl;

    Random::rng.set_seed(5);
    
    double mean = 3;
    cout << "Poisson random variates, mean " << mean << endl;
    for ( int i = 0; i < 5; i++ ) {
		cout << Random::rng.rpoisson(3) << endl;
    }
        
    Random::rng.set_seed(5);
    double m1 = 0;
    double m2 = 0;
    int n = 1000000;
    for ( int i = 0; i < n; i++ ) {
    	int k = Random::rng.rpoisson(3);
    	m1 += k;
    	m2 += k*k;
    }
    m1 /= n;
    cout << "Mean and variance of " << n << " Poisson random variates with mean " << mean << endl;
	cout << m1 << " " << m2/n - m1*m1 << endl;
}

void test_organism()
{
	cout << "\nTest Organism class" << endl;

	Organism o(10, .1);
	o.print(cout);
	o.mutate(5);
	o.print(cout);
	o.mutate(5);
	o.print(cout);
	o.mutate(5);
	o.print(cout);
	o.mutate(5);
	o.print(cout);
}

void test_population()
{
	cout << "\nTest Population class" << endl;

	int L = 10;
	int N = 100;
	double s = 0.01;
	
	Organism o(L, s);
	Population pop(N, o);
	
	cout << "Mean fitness: " << pop.get_mean_fitness() << endl;
}

void test_sampling()
{
	vector<double> w = {.1, .1, .2, .1, .4, .05, .04, .01};
	int n = w.size();
	
	// create vector of weight--index pairs
	typedef pair<double, int> wipair;
	vector<wipair> wi;
	
	int i=0;
	for (auto it=w.begin(); it!=w.end(); it++)
	{
		wi.emplace_back(*it, i);
		i++;
	}

    for (auto it=wi.begin(); it!=wi.end(); it++)
	{
		cout << (*it).first << " " << (*it).second << endl;
	}
		
	// sort weight--index pairs by weight
	std::sort(wi.begin(), wi.end(),
          [] (wipair const& a, wipair const& b) { return a.first > b.first; });
          
    cout << endl;
    for (auto it=wi.begin(); it!=wi.end(); it++)
	{
		cout << (*it).first << " " << (*it).second << endl;
	}
		
	cout << endl;
	int count7 = 0;
	int count4 = 0;
	for (int k=0; k<1000; k++)
	{
		double sum = wi.begin()->first;
		double cut = Random::rng.runif();
		auto it = wi.begin();
		while (cut > sum)
		{
			it++;
			sum += (*it).first;
		}
		//cout << (*it).second << endl;
		int i = (*it).second;
		if (i==4) count4 += 1;
		if (i==7) count7 += 1;
	} 
	cout << count4/1000. << " " << count7/1000. << endl;
}

int main()
{
	//test_random();
	//test_organism();
	//test_population();
	
	test_sampling();
	
	return 0;
}


/* Store for later reference on how to read parameters from command line, from https://shihho.wordpress.com/2013/01/02/random-variates-with-boost/
#include <iostream>
  using std::cout;
  using std::endl;
#include <iomanip>
  using std::setprecision;
#include <cstdlib>
  using std::atoi;
  using std::atof;
#include <ctime>
  using std::time;
#include <boost/random/mersenne_twister.hpp>
  using boost::mt19937;
#include <boost/random/poisson_distribution.hpp>
  using boost::poisson_distribution;
#include <boost/random/variate_generator.hpp>
  using boost::variate_generator;
 
int main(int argc, char * argv[]) {
  int Nsim=atoi(argv[1]);
  double exp=atof(argv[2]);
  mt19937 gen;
  gen.seed(time(NULL));
  poisson_distribution<int> pdist(exp);
  variate_generator< mt19937, poisson_distribution<int> > rvt(gen, pdist);
  for(int i=0; i<Nsim; i++) cout << rvt() << endl;
  return 0;
}

*/