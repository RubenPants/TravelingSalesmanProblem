%{
exercise3.m

Evaluate all of the possible representation - crossover - mutation
combination on each of the benchmarks.
%}

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

% Possible representations
% REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
% CROSSOVER = ["xalt_edges", "heuristic_crossover"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion", "scramble"];

% Run the experiment
for i=1:2
    if i == 1
        r = "adjacency";
        c = "xalt_edges";
    else
        r = "path";
        c = "heuristic_crossover";
    end
    for m=MUTATION
        fprintf("Calculating %s - %s - %s - Progress: ", r, c, m)
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            intermediate = zeros(1, 10);
            for j=1:10
                output = run_data(data_list(i), r, c, m);
                intermediate(j) = output("minimum");
            end
            total(i) = geomean(intermediate) / optima(i);
            fprintf("#")
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %s - %s - %s - performance: %.2f\n\n", r, c, m, performance);
    end
end

function c = run_data(set, repr, cross, mut)
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = 100;
    data("representation") = repr;
    data("crossover") = cross;
    data("pr_cross") = 0.4;
    data("mutation") = mut;
    data("pr_mut") = 0.4;
    
    % Run experiment
    c = run_ga(data);
end

%{
Results:

--> pr_cross=0.2; pr_mut=0.2;
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 190.84
Result: adjacency - xalt_edges - inversion - performance: 187.93
Result: adjacency - xalt_edges - scramble - performance: 210.85

Result: path - heuristic_crossover - reciprocal_exchange - performance: 106.24
Result: path - heuristic_crossover - inversion - performance: 105.10
Result: path - heuristic_crossover - scramble - performance: 107.08

--> pr_cross=0.4; pr_mut=0.4;
%}