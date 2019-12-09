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
optima = [2.828427, 3.128609, 3.138306, 3.349954, 2.927273, 3.242449, 4.017236, 4.371113, 5.828265, 6.235421, 4.450222, 6.999226, 8.213131, 6.151962];
% Possible representations
REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
CROSSOVER = ["xalt_edges", "order", "sequential_constructive"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion"];

% Run the experiment
for r=REPRESENTATION
    for c=CROSSOVER
        for m=MUTATION
            fprintf("Calculating %s - %s - %s\n", r, c, m)
            total = zeros(1,length(data_list));
            for i=1:length(data_list)
                fprintf("\t%s - ", data_list(i))
                itermediate = zeros(1, 10);
                for j=1:10
                    output = run_data(data_list(i), r, c, m);
                    intermediate = output("minimum");
                    fprintf("#")
                end
                total(i) = mean(intermediate) / optima(i);
                fprintf("\n")
            end
            performance = mean(total) * 100;  % Percentage of 100 is perfect match
            fprintf("Result: %s - %s - %s - performance: %.2f \n\n", r, c, m, performance);
        end
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
    data("maxgen") = 50;  % TODO: Change back to 500
    data("representation") = repr;
    data("crossover") = cross;
    data("pr_cross") = 0.2;
    data("mutation") = mut;
    data("pr_mut") = 0.4;
    
    % Run experiment
    c = run_ga(data);
end