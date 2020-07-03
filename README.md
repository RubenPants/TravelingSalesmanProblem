# Traveling Salesman Problem via Genetic Algorithms
## Introduction

The **Traveling Salesman Problem** (TSP) was properly written down the first time in 1832, but no concise solution was formulated. Since then, a lot of new mathematical and computer based fields have originated, which led to better and better solution approximations for this well known problem. The problem at hand states that a salesman wants to visit a set of cities exactly once before returning to its starting position, whilst minimizing its total distance travelled.

The main problem with the TSP is that it doesn't scale well for larger datasets, implying a drastic decrease in performance. To handle these larger datasets, more complicated algorithms are needed. **Genetic algorithms** (GA) provide a way to tackle this problem since they provide an efficient way of traversing the search space. The algorithm is based on a population of individuals that each roam the search space in an evolutionary manner. The best performing individuals are used each generation to setup the next generation. By doing so, GA's manage to find close approximations of the solution fairly quick and elegant.

## Overview

In the first exercise of this project, the provided algorithm is analyzed to form a baseline for the project. Exercise 2 extends the catalogue of possible stopping criteria which are used to prevent the algorithm from performing redundant calculations. Next, Exercise 3 discusses an alternative way of representing the cities in the algorithm, together with appropriate crossover and mutation operators. Exercise 4 introduces the notion of local heuristics, which try to optimize only select parts of the solution. Exercise 5 discusses small additions to the algorithm which further increase its performance. The last section, Exercise 6, bundles all our findings together and compares the performance of our best performing algorithm to that of the baseline. 

In the end, our algorithm finds on average a path for the benchmark dataset which is 9.12 times shorter than the baseline when evolved for only one hundred generations. Furthermore, the found path is on average only 11.83% longer than its optimum.

## Project

To run the project in **MatLab**, run the *tspgui.m* file or type "tspgui" in the Command Window when in the *code* directory.

<p align="center">
  <img src="https://github.com/RubenPants/TravelingSalesmanProblem/blob/master/program.png"/>
</p>

## Report

The report corresponding this project can be found under the main branch of this repository, titled "*report_bocklandt_broekx.pdf*".
