# Traveling Salesman Problem
 Solution to the Sales Man Problem using genetic algorithms (neuro-evolution)

## Project Progress

None



## Q&As

* **[Ruben] Are there constraints on which paths to take in the assignments? How to tackle those if there are any?** <br> [Answer needed]



## TODOs

* [Ruben] Experiment with different **selection** mechanisms from chapter 5.
* [Ruben] Most likely we'll use an *Integer **Representation*** (p54).
* [Ruben] For **recombination**, I'd choose the *cycle crossover* discussed on page 73. An alternative would be to choose order crossover. Interesting comparison if you ask me? (I think the latter would become unstable due to the many fluctuations in choices, i.e. the crossover would become too stochastic).



## Ideas

* [Ruben] Use a form of ***Novelty Search*** in our algorithm to efficiently explore the whole search space. A possible way to add novelty is to compare the Hamming distance between two strings. I think it could be beneficial, however the introduction of an objective function is straight forward in this case. ***Quality Diversity*** could be the "solution" to this. 