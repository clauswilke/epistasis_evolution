#include <iostream>
#include <cstdlib>
#include <cmath>
#include <utility>

#include "organism.h"
#include "population.h"

using namespace std;

pair<double, double> evolve_trajectory(int L, int N, double s, double q, double mu, double r, int burn_in, int measure_time)
{
	// start from predicted equilibrium frequency
	double f_pred = pow(1.-1./(2*N-1.), L/q);

	Organism o(L, s, q);
	o.set_genome_from_fitness(f_pred);
	Population pop(N, mu, r, o);
	
	for (int t=0; t<burn_in; t++)
	{
		pop.do_Wright_Fisher_step();
	}

	double mean = 0;
	double max = 0;
	for (int t=0; t<measure_time; t++)
	{
		mean += pop.get_mean_fitness();
		max += pop.get_max_fitness();
		pop.do_Wright_Fisher_step();
	}
	mean /= measure_time;
	max /= measure_time;

	return pair<double, double>(mean, max);
}



void equil_mean_fitness(int L, int N, double s, double q, double mu, double r, int burn_in, int measure_time, int reps)
{	
	for (int rep=0; rep<reps; rep++)
	{	
		pair<double, double> p = evolve_trajectory(L, N, s, q, mu, r, burn_in, measure_time);

		cout << L << "\t" << N << "\t" << s << "\t" << q << "\t" << mu << "\t" << r << "\t" << rep << "\t" << p.first << "\t" << p.second << endl;
	
	}
}




int main(int argc, char * argv[])
{
	if (argc != 6)
	{
		cout << "Usage:" << endl;
		cout << "  " << argv[0] << " <L> <N> <s> <q> <r>" << endl;
		cout << "\nwith:\n  <L>: genome length\n  <N>: population size\n  <s>: selection coefficient\n  <q>: epistasis coefficient\n  <mu>: per-genome mutation rate" << endl;
		return 0;
	}

	int L = atoi(argv[1]);
	int N = atoi(argv[2]);
	double s = atof(argv[3]);
	double q = atof(argv[4]);
	double r = atof(argv[5]);

	int burn_in = 50000;
	int measure_time =  20000;
	int reps = 5;

	cout << "L\tN\ts\tq\tmu\tr\trep\tmean\tmax" << endl;

	equil_mean_fitness(L, N, s, q, 1., r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .33, r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .1, r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .033, r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .01, r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .0033, r, burn_in, measure_time, reps);
	equil_mean_fitness(L, N, s, q, .001, r, burn_in, measure_time, reps);
	
	return 0;
}
