%{
exercise3.m

Evaluate all of the possible representation - crossover - mutation
combination on each of the benchmarks.
%}

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template\datasets'

% Load all the datasets
data = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];

% Possible representations
REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
CROSSOVER = ["xalt_edges", "order", "sequential_constructive"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion"];



% TODO: Code for loops



function time = run_data(set, repr, cross, mut)
    global NIND MAXGEN ELITIST PR_CROSS PR_MUT LOCALLOOP
    % Run the given configuration on the requested dataset
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    time = run_ga_ex3(x, y, NIND, MAXGEN, ELITIST, PR_CROSS, PR_MUT, repr, cross, mut, LOCALLOOP);
end