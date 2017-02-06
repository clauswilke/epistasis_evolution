#include <iostream>
#include <cstdlib>
#include <cmath>

#include "organism.h"
#include "population.h"

using namespace std;

Organism do_Markov_step(const Organism &o, int N, double r)
{
	double w_orig = o.get_fitness();
	Organism o2(o);
	o2.mutate(1, r);
	double w_new = o2.get_fitness();
	double pi = (1.-(w_orig/w_new)*(w_orig/w_new))/(1.-pow(w_orig/w_new, 2*N));
	//cout << w_orig << " " << w_new << " " << pi << endl;
	if (Random::rng.runif()<pi)
		return o2;
	else
	 	return o;
} 

void evolve_trajectory(int L, int N, double s, double q, double r, int time_steps)
{
	cout << "time fitness" << endl;
	Organism o(L, s, q);

	for (int t=0; t<=time_steps; t++)
	{
		cout << t << " " << o.get_fitness() << endl;
		for (int i=0; i<1000; i++)
			o = do_Markov_step(o, N, r);
	}
}



int main(int argc, char * argv[])
{
	if (argc != 7)
	{
		cout << "Usage:" << endl;
		cout << "  " << argv[0] << " <L> <N> <s> <q> <r> <time_steps>" << endl;
		cout << "\nwith:\n  <L>: genome length\n  <N>: population size\n  <s>: selection coefficient\n  <q>: epistasis coefficient\n  <r>: mutation distance\n  <time_steps>: number of time-steps to run the simulation" << endl;
		return 0;
	}

	int L = atoi(argv[1]);
	int N = atoi(argv[2]);
	double s = atof(argv[3]);
	double q = atof(argv[4]);
	double r = atof(argv[5]);
	int time_steps = atoi(argv[6]);

	evolve_trajectory(L, N, s, q, r, time_steps);
	
	return 0;
}
