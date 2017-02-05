#include <iostream>
#include <cstdlib>

#include "organism.h"
#include "population.h"

using namespace std;

void evolve_trajectory(int L, int N, double s, double q, double mu, int time_steps)
{
	Random::rng.set_seed(2);
    
	cout << "time mean_fitness" << endl;
	Organism o(L, s, q);
	Population pop(N, mu, o);	
	
	for (int t=0; t<=time_steps; t++)
	{
			cout << t << " " << pop.get_mean_fitness() << endl;
			pop.do_Wright_Fisher_step();
			//pop.print(cout);
	}
}



int main(int argc, char * argv[])
{
	if (argc != 7)
	{
		cout << "Usage:" << endl;
		cout << "  " << argv[0] << " <L> <N> <s> <q> <mu> <time_steps>" << endl;
		cout << "\nwith:\n  <L>: genome length\n  <N>: population size\n  <s>: selection coefficient\n  <q>: epistasis coefficient\n  <mu>: per-genome mutation rate\n  <time_steps>: number of time-steps to run the simulation" << endl;
		return 0;
	}

	int L = atoi(argv[1]);
	int N = atoi(argv[2]);
	double s = atof(argv[3]);
	double q = atof(argv[4]);
	double mu = atof(argv[5]);
	int time_steps = atoi(argv[6]);

	evolve_trajectory(L, N, s, q, mu, time_steps);
	
	return 0;
}
