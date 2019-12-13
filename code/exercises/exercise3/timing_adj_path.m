%{
timing_adj_path.m

Run a batch of test using the same crossover and mutation operators to see
if there is a significant difference in time between the two
representations.
%}

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Parameters
NUMBER_TESTS = 10;

% Load all the datasets
data_list = ["127"];
optima = load('rondrit_optima.tsp');

% Possible representations
REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
CROSSOVER = ["xalt_edges", "heuristic_crossover"];

% Run the experiment
for r=REPRESENTATION
    for c=CROSSOVER
        fprintf("Calculating %s - %s - Progress: ", r, c)
        tic
        for j=1:NUMBER_TESTS
            run_data("127", r, c, "inversion");
        fprintf("#")
        end
        fprintf("\nResult: %s - %s - time (c): %.2f\n\n", r, c, toc / NUMBER_TESTS);
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
    data("maxgen") = 1000;
    data("representation") = repr;
    data("crossover") = cross;
    data("pr_cross") = 0.2;
    data("mutation") = mut;
    data("pr_mut") = 0.2;
    
    % Run experiment
    c = run_ga(data);
end

%{
Results:

Result: adjacency - xalt_edges - time (s):  18.44
Result: path - xalt_edges - time (s):       18.83

Result: adjacency - heuristic_crossover - time (s): 22.00
Result: path - heuristic_crossover - time (s):      21.58
%}
