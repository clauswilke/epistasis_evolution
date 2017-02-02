#include <iostream>

#include "organism.h"
#include "population.h"

using namespace std;

int main()
{
	int L = 10;
	int N = 100;
	double s = 0.01;
	
	Organism o(L, s);
	Population pop(N, o);
	
	cout << "Mean fitness: " << pop.get_mean_fitness() << endl;
}