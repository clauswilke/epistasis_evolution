Directory structure
-------------------

The following tree demonstrates the files that are contained in this
repository. This section is meant to give you an overview of the
information contained here. The following section will explain in detail
the content of each folder.

    ## .
    ## ├── LICENSE
    ## ├── README.Rmd
    ## ├── README.md
    ## ├── epistasis_evolution.Rproj
    ## ├── evolving_q_sim
    ## │   ├── plots
    ## │   └── src
    ## └── fixed_q_sim
    ##     ├── mutation_matrix
    ##     ├── plots
    ##     ├── pop_sim.Rmd
    ##     ├── pop_sim.html
    ##     ├── qstar.Rmd
    ##     ├── qstar.html
    ##     ├── src
    ##     └── varying_eps_sim

This repo is broken down into two main sub-directories,`evolving_q_sim`
and `fixed_q_sim`. The sub-directory `evolving_q_sim` contains code to
simulate populations that can evolve epistasic interactions among
different genotypes (denoted as `q` throughout), and the sub-directory
`fixed_q_sim` contains code to simulate populations that cannot evolve
epistatic interactions. The latter maintains the same `q` throughout the
time of a simulation.

Each of these sub-directories contains a folder `src` that contains code
to run simulations and to analyze simulation results. A folder `plots`
contains figures made for the paper.
