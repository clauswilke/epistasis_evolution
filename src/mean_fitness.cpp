#include <iostream>
#include <cstdlib>

#include "organism.h"
#include "population.h"

using namespace std;

double evolve_trajectory(int L, int N, double s, double q, double mu, int burn_in, int measure_time)
{
	Organism o(L, 0, s, q);
	Population pop(N, mu, o);	
	
	for (int t=0; t<burn_in; t++)
	{
		pop.do_Wright_Fisher_step();
	}

	double mean = 0;
	for (int t=0; t<measure_time; t++)
	{
		mean += pop.get_mean_fitness();
		pop.do_Wright_Fisher_step();
	}
	mean /= measure_time;

	return mean;
}



void equil_mean_fitness(int L, int N, double s, double q, double mu, int burn_in, int measure_time, int reps)
{
	double m1 = 0;
	double m2 = 0;
	
	cout << "#";
	for (int rep=0; rep<reps; rep++)
	{	
		double mean = evolve_trajectory(L, N, s, q, mu, burn_in, measure_time);
		cout << "[" << rep+1 << "/" << reps << "] "; 
		m1 += mean;
		m2 += mean*mean;
	}
	
	m1 /= reps;
	m2 /= reps;
	
	cout << endl << m1 << " " << m2-m1*m1 << endl;
}




int main(int argc, char * argv[])
{
	if (argc != 6)
	{
		cout << "Usage:" << endl;
		cout << "  " << argv[0] << " <L> <N> <s> <q> <mu>" << endl;
		cout << "\nwith:\n  <L>: genome length\n  <N>: population size\n  <s>: selection coefficient\n  <q>: epistasis coefficient\n  <mu>: per-genome mutation rate" << endl;
		return 0;
	}

	int L = atoi(argv[1]);
	int N = atoi(argv[2]);
	double s = atof(argv[3]);
	double q = atof(argv[4]);
	double mu = atof(argv[5]);

	int burn_in = 1000;
	int measure_time =  1000;
	int reps = 20;

	equil_mean_fitness(L, N, s, q, mu, burn_in, measure_time, reps);
	
	return 0;
}
