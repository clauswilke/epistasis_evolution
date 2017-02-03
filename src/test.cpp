#include <iostream>

#include "organism.h"
#include "population.h"
#include "random.h"

using namespace std;

int main2()
{
	int L = 10;
	int N = 100;
	double s = 0.01;
	
	Organism o(L, s);
	Population pop(N, o);
	
	cout << "Mean fitness: " << pop.get_mean_fitness() << endl;
	
     return 0;
}


int main()
{
	Random r(5);
    for ( int i = 0; i < 5; i++ ) {
		cout << r.runif() << endl;
    }
    //return 0;
    
    r.set_seed(5);
    for ( int i = 0; i < 5; i++ ) {
		cout << r.runif() << endl;
    }
    return 0;

}