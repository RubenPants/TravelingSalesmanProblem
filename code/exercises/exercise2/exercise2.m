%{
exercise2.m

Evaluate each of the rondrit's data-samples for 1000 generations to see 
which stop earlier due to stagnation. If they stop earlier, see the 
difference between the found results and the configuration' optimum.
%}

% stagnation parameter
MAXGEN = Inf;
STAGNATION = 100;

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

% Run the experiment
total_dist = zeros(1,length(data_list));
total_gen = zeros(1,length(data_list));
for i=1:length(data_list)
    fprintf("%s - ", data_list(i))
    
    % Setup dataset
    data = load(sprintf('rondrit%s.tsp', data_list(i)));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("loop_detect") = true;
    data("maxgen") = MAXGEN;
    data("stop_stagnation") = STAGNATION;
    
    % Run experiment 10 times and average results
    intermediate_dist = zeros(1, 10);
    intermediate_gen = zeros(1, 10);
    for j=1:10
        output = run_ga(data);
        intermediate_dist(j) = output("minimum");
        intermediate_gen(j) = output("generation");
        fprintf("#")
    end
    total_dist(i) = geomean(intermediate_dist);
    total_gen(i) = mean(intermediate_gen);
    fprintf("\n")
end

% Print results
for i=1:length(data_list)
    if total_gen(i) < MAXGEN * 0.95
        fprintf("%s - Stagnation occurred after %.f generations \t- Found solution: %f \t- Real solution: %f\n", data_list(i), total_gen(i), total_dist(i), optima(i))
    else
        fprintf("%s - No stagnation occurred - Found solution: %f \t- Real solution: %f\n", data_list(i), total_dist(i), optima(i))
    end
end

%{
016 - Stagnation occurred after 113 generations - Found solution: 3.349954 - Real solution: 3.349954
018 - Stagnation occurred after 117 generations - Found solution: 2.927273 - Real solution: 2.927273
023 - Stagnation occurred after 138 generations - Found solution: 3.242449 - Real solution: 3.242449
025 - Stagnation occurred after 154 generations - Found solution: 4.017236 - Real solution: 4.017236
048 - Stagnation occurred after 305 generations - Found solution: 4.328854 - Real solution: 4.328854
050 - Stagnation occurred after 282 generations - Found solution: 5.961795 - Real solution: 5.828265
051 - Stagnation occurred after 303 generations - Found solution: 6.305255 - Real solution: 6.217125
067 - Stagnation occurred after 387 generations - Found solution: 4.384586 - Real solution: 4.368553
070 - Stagnation occurred after 485 generations - Found solution: 6.825748 - Real solution: 6.825748
100 - Stagnation occurred after 702 generations - Found solution: 7.917037 - Real solution: 7.854177
127 - Stagnation occurred after 1006 generations- Found solution: 6.100259 - Real solution: 5.929081
%}
