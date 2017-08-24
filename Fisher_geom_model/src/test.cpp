#include <iostream>

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

	Organism o(10, 1, 1);
	o.print(cout);
	o.mutate(1, .1);
	o.print(cout);
	o.mutate(1, .1);
	o.print(cout);
	o.mutate(1, 1);
	o.print(cout);
	o.mutate(1, 1);
	o.print(cout);
}

/*
void test_population()
{
	cout << "\nTest Population class" << endl;
	Random::rng.set_seed(2);
    
	int L = 10;
	int N = 100;
	double mu = 0;
	double s = 0.08;
	
	//cout << "time mean_fitness" << endl;
	int count = 0;
	for (int rep=0; rep<100; rep++)
	{	
		Organism o(L, s, q);
//		double w1 = o.get_fitness();
		Population pop(N, mu, o);	

		for (int t=0; t<=1000; t++)
		{
			//pop.print(cout);
			//cout << t << " " << pop.get_mean_fitness() << endl;
			pop.do_Wright_Fisher_step();
		}
		if (pop.get_mean_fitness() > .5*(w1+w2))
			count += 1;
		//cout << rep << " " << pop.get_mean_fitness() << endl;
	}
	cout << "Expected prob: " << 2*s << endl;
	cout << "Observed prob: " << count/100. << endl;
}
*/

int main()
{
	//test_random();
	test_organism();
	//test_population();
	
	return 0;
}
