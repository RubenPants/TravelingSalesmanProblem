# Traveling Salesman Problem
 Solution to the Sales Man Problem using genetic algorithms (neuro-evolution)



## Notes

* Start custom-created files' name with `aaa_` (e.g. `aaa_test_ruben.m`), such it's easy to distinct the custom created and provided files (MatLab complaints if you only start with an underscore..).



## Project Progress

None



## Questions

### Question 2 [Ruben]

* Map out a Matrix, beautify the boi.

* Mutation vs Selection (matrix)
* Number of generations vs population size

### Question 3 [Sieben]

* Stagnation (multiple species?)
* Cut-off (stop when threshold found) --> Rational in report why not ideal
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.91.9167&rep=rep1&type=pdf (stopping criterion reference)

### Question 4 [Ruben]

* Adjacency to path representation (needed?)
* Binary representation (with corresponding mutation and selection). Generalize to variable length of bit-strings.
* Cycle-crossover

### Question 5 [Sieben]

* Not completely sure Extra form of mutation <br>
   https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf 

### Question 6 [NaN]

* Run the boiii

### Question 7

#### Sub-question a

* H5 

#### Sub-question b [Ruben]

* Novelty Search

#### Sub-question c

* k-NN for specie-selection

#### Sub-question d

* Let the mutation rates, k-NN (if used) and other parameters co-evolve.



## Project Components

### tspgui

`tspgui.m` can be run to visualize the progress of the evolutionary algorithm, however, this decreases performance drastically.

### run_ga

`run_ga` is where its at, since this call is the one that will invoke the GA. Several arguments are given with this call:

* `x` List of coordinates expressing the x-coordinate of the cities <br> Default: [0.6200, 
      0.8328, 
      0.8589, 
      0.5103, 
      0.4073, 
      0.6189, 
      0.0469, 
      0.0707, 
      1.0000, 
      0.4881, 
      0.5007, 
      0.3483, 
      0.5696, 
      0.7694, 
      0.3197, 
      0.3242]
* `y` List of coordinates expressing the y-coordinate of the cities<br> Default: [0.4647,
      0.0117,
      0.1958,
      0.3871,
      0.4804,
      0.2203,
      0.5166,
      0.0584,
      0.3687,
      0.0681,
      0.2556,
      0.0704,
      0.5459,
      0.4746,
      0.3242,
      0.1927]
* `NIND` The number of individuals<br> Default: 50
* `MAXGEN` The maximal number of generations <br> Default: 100
* `NVAR` The size of the chromosome (genome) <br> Default: 16
* `ELITIST` The elitist-percentage <br> Default: 0.05
* `STOP_PERCENTAGE` Percentage of equal fitness (stop criterium) <br> Default: 0.95
* `PR_CROSS` The probability for applying crossover between two parents <br> Default: 0.95
* `PR_MUT` The probability for applying mutation to an allele of the gene of a candidate (after crossover) <br> Default 0.05
* `CROSSOVER` The crossover operator <br> Default: `xalt_edges` (reference to MatLab file `xalt_edges.m`)
* `LOCALLOOP` The loop-checking mechanism (0 for False and 1 for True) <br> Default: 0
* `ah1`, `ah2`, `ah3` Axes handles to visualize the TSP



## Q&As

* **[Ruben] Are there constraints on which paths to take in the assignments? How to tackle those if there are any?** <br> No.



## TODOs

* [Ruben] Experiment with different **selection** mechanisms from chapter 5.
* [Ruben] Most likely we'll use an *Integer **Representation*** (p54). (Adjacency)
* [Ruben] For **recombination**, I'd choose the *cycle crossover* discussed on page 73. An alternative would be to choose order crossover. Interesting comparison if you ask me? (I think the latter would become unstable due to the many fluctuations in choices, i.e. the crossover would become too stochastic).



## Ideas

* [Ruben] Use a form of ***Novelty Search*** in our algorithm to efficiently explore the whole search space. A possible way to add novelty is to compare the Hamming distance between two strings. I think it could be beneficial, however the introduction of an objective function is straight forward in this case. ***Quality Diversity*** could be the "solution" to this. 
* [Ruben] For the first exercise, I wanted to create a circle of 20 cities. The reason why is that in this case, the search space is tremendously large, but the solution is still very notable. Next, I would set the parameters for generations and population-size fixed, (e.g.) 100 and 256 respectively. Next, I would see what the average (over 10 runs) distance would be for f(mutation, selection). A nice visualization would be to do all possible combinations of range(0,100,5) for both mutation and selection (400 possibilities, for 10 runs equals 4000 tests). Next, the points got interpolated to visualize the "performance space" (3D wave with x=mutation, y=selection, z=1/distance).