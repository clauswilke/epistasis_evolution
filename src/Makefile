LIB=-L/usr/local/lib/
INC=-I/usr/local/include/ 

CXXFLAGS=-std=c++11 $(LIB) $(INC)

all: mean_fitness fitness_trajectory origin_fixation

test: test.cpp population.cpp organism.cpp random.cpp

mean_fitness: mean_fitness.cpp population.cpp organism.cpp random.cpp

fitness_trajectory: fitness_trajectory.cpp population.cpp organism.cpp random.cpp

origin_fixation: origin_fixation.cpp population.cpp organism.cpp random.cpp

clean:
	rm -f test mean_fitness fitness_trajectory