from population import population 

pop = population(100, 100, 0.001, 0.1, 0, 1, 0.01)

for t in range(50):
    print("t =", t, "-----------------------------------------")
    pop.replicate()
    pop.mutate()
    print("f:",pop.mean_fitness())
    print("q:",pop.mean_epistasis())
