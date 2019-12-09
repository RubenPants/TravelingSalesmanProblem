% tsp_ImprovePopulation.m
% Author: Mike Matton
% 
% This function improves a tsp population by removing local loops from
% each individual.
%
% Syntax: improvedPopulation = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists)
%
% Input parameters:
%   popsize     - The population size
%   ncities     - the number of cities
%   pop         - the current population (adjacency representation)
%   improve     - Improve the population (0 = no improvement, <>0 = improvement)
%   dists       - distance matrix with distances between the cities
%   repr_id     - choosen representation (1=adjacency, 2=path)
%
% Output parameter:
%   improvedPopulation  - the new population after loop removal (if improve
%                          <> 0, else the unchanged population).

function newpop = tsp_ImprovePopulation(popsize, ncities, pop, improve, dists, repr_id)
    if (improve)
       for i=1:popsize
         if repr_id == 1
             result = improve_path(ncities, adj2path(pop(i,:)),dists);
             pop(i,:) = path2adj(result);
         else
             pop(i,:) = improve_path(ncities, pop(i,:),dists);
         end
       end
    end

    newpop = pop;