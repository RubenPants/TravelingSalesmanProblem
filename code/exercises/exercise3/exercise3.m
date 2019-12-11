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
                tic
                for i=1:length(data_list)
                    intermediate = zeros(1, 10);
                    for j=1:10
                        output = run_data(data_list(i), r, c, m, d);
                        intermediate(j) = output("minimum");
                    end
                    total(i) = mean(intermediate) / optima(i);
                    fprintf("#")
                end
                performance = mean(total) * 100;  % Percentage of 100 is perfect match
                fprintf("\nResult: %s - %s - %s - diversify: %d - performance: %.2f - time (s): %.2f\n\n", r, c, m, d, performance, toc);
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

Result: adjacency - xalt_edges - reciprocal_exchange - diversify: 0 - performance: 195.68 - time (s): 80.75
Result: adjacency - xalt_edges - reciprocal_exchange - diversify: 1 - performance: 191.55 - time (s): 83.91
Result: adjacency - xalt_edges - inversion - diversify: 0 - performance: 185.38 - time (s): 84.88
Result: adjacency - xalt_edges - inversion - diversify: 1 - performance: 185.13 - time (s): 87.00
Result: adjacency - heuristic_crossover - reciprocal_exchange - diversify: 0 - performance: 104.14 - time (s): 100.61
Result: adjacency - heuristic_crossover - reciprocal_exchange - diversify: 1 - performance: 105.19 - time (s): 103.14
Result: adjacency - heuristic_crossover - inversion - diversify: 0 - performance: 103.01 - time (s): 103.99
Result: adjacency - heuristic_crossover - inversion - diversify: 1 - performance: 103.36 - time (s): 104.28

Result: path - xalt_edges - reciprocal_exchange - diversify: 0 - performance: 194.84 - time (s): 86.15
Result: path - xalt_edges - reciprocal_exchange - diversify: 1 - performance: 191.34 - time (s): 85.91
Result: path - xalt_edges - inversion - diversify: 0 - performance: 184.44 - time (s): 85.26
Result: path - xalt_edges - inversion - diversify: 1 - performance: 185.73 - time (s): 87.40
Result: path - heuristic_crossover - reciprocal_exchange - diversify: 0 - performance: 104.26 - time (s): 94.87
Result: path - heuristic_crossover - reciprocal_exchange - diversify: 1 - performance: 105.09 - time (s): 96.92
Result: path - heuristic_crossover - inversion - diversify: 0 - performance: 103.10 - time (s): 98.92
Result: path - heuristic_crossover - inversion - diversify: 1 - performance: 103.79 - time (s): 96.79
%}