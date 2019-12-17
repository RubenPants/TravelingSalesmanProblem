%{
genome_distance.m

calculate the distance between two genomes in adjacency representation
based on:
Crowding Population-based Ant ColonyOptimisation for the Multi-objective TravellingSalesman Problem

The distance is the number of unshared edges between the two genomes
%}

function distance = genome_distance(genome1,genome2)
    distance=0;
    for i=1:size(genome1,2)
        if genome1(1,i) ~=genome2(1,i) %count the number of edges that is not the same
            distance = distance+1;
        end
    end
end