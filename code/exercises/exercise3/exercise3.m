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
REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
CROSSOVER = ["xalt_edges", "heuristic_crossover"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion", "merge"];

DIVERSIFY = [false, true];

% Run the experiment
for r=REPRESENTATION
    for c=CROSSOVER
        for m=MUTATION
            for d=DIVERSIFY
                fprintf("Calculating %s - %s - %s - diversify: %d - Progress: ", r, c, m, d)
                total = zeros(1,length(data_list));
                for i=1:length(data_list)
                    intermediate = zeros(1, 10);
                    for j=1:10
                        output = run_data(data_list(i), r, c, m, d);
                        intermediate(j) = output("minimum");
                    end
                    total(i) = geomean(intermediate) / optima(i);
                    fprintf("#")
                end
                performance = mean(total) * 100;  % Percentage of 100 is perfect match
                fprintf("\nResult: %s - %s - %s - diversify: %d - performance: %.2f\n\n", r, c, m, d, performance);
            end
        end
    end
end


function c = run_data(set, repr, cross, mut, div)
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
    data("pr_cross") = 0.2;
    data("mutation") = mut;
    data("pr_mut") = 0.2;
    data("diversify") = div;
    
    % Run experiment
    c = run_ga(data);
end

%{
Results:

Result: adjacency - xalt_edges - reciprocal_exchange - diversify: 0 - performance: 188.21
Result: adjacency - xalt_edges - reciprocal_exchange - diversify: 1 - performance: 189.18
Result: adjacency - xalt_edges - inversion - diversify: 0 - performance: 183.15
Result: adjacency - xalt_edges - inversion - diversify: 1 - performance: 184.60
Result: adjacency - xalt_edges - merge - diversify: 0 - performance: 189.04
Result: adjacency - xalt_edges - merge - diversify: 1 - performance: 188.82
Result: adjacency - heuristic_crossover - reciprocal_exchange - diversify: 0 - performance: 104.11
Result: adjacency - heuristic_crossover - reciprocal_exchange - diversify: 1 - performance: 104.13
Result: adjacency - heuristic_crossover - inversion - diversify: 0 - performance: 102.75
Result: adjacency - heuristic_crossover - inversion - diversify: 1 - performance: 103.02
Result: adjacency - heuristic_crossover - merge - diversify: 0 - performance: 103.18
Result: adjacency - heuristic_crossover - merge - diversify: 1 - performance: 103.12

Result: path - xalt_edges - reciprocal_exchange - diversify: 0 - performance: 188.95
Result: path - xalt_edges - reciprocal_exchange - diversify: 1 - performance: 189.63
Result: path - xalt_edges - inversion - diversify: 0 - performance: 184.33
Result: path - xalt_edges - inversion - diversify: 1 - performance: 184.75
Result: path - xalt_edges - merge - diversify: 0 - performance: 189.61
Result: path - xalt_edges - merge - diversify: 1 - performance: 188.86
Result: path - heuristic_crossover - reciprocal_exchange - diversify: 0 - performance: 105.47
Result: path - heuristic_crossover - reciprocal_exchange - diversify: 1 - performance: 105.76
Result: path - heuristic_crossover - inversion - diversify: 0 - performance: 103.92
Result: path - heuristic_crossover - inversion - diversify: 1 - performance: 103.83
Result: path - heuristic_crossover - merge - diversify: 0 - performance: 104.56
Result: path - heuristic_crossover - merge - diversify: 1 - performance: 104.63
%}