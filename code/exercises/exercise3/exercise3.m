%{
exercise3.m

Evaluate all of the possible representation - crossover - mutation
combination on each of the benchmarks.
%}

% Parameters
global CALCULATE_NEW GENERATIONS MUTATION RUNS
CALCULATE_NEW = false;
GENERATIONS = 100;
RUNS = 20;

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016"];%, "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

% Possible representations
% REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
% CROSSOVER = ["xalt_edges", "heuristic_crossover"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion", "scramble"];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), 2, length(MUTATION), GENERATIONS);
    mean_f = zeros(length(data_list), 2, length(MUTATION), GENERATIONS);
    worst_f = zeros(length(data_list), 2, length(MUTATION), GENERATIONS);
    for ex=1:2
        if ex == 1
            r = "adjacency";
            c = "xalt_edges";
        else
            r = "path";
            c = "heuristic_crossover";
        end
        for m=1:length(MUTATION)
            fprintf("Calculating %s - %s - %s - Progress: ", r, c, MUTATION(m))
            total = zeros(1,length(data_list));
            for i=1:length(data_list)
                intermediate = zeros(1, RUNS);
                intermediate_best = zeros(1,GENERATIONS);
                intermediate_mean = zeros(1,GENERATIONS);
                intermediate_worst = zeros(1,GENERATIONS);
                for j=1:RUNS
                    output = run_data(data_list(i), r, c, MUTATION(m));
                    intermediate(j) = output("minimum");
                    intermediate_best = intermediate_best + output("best");
                    intermediate_mean = intermediate_mean + output("mean_fits");
                    intermediate_worst = intermediate_worst + output("worst");
                end
                total(i) = geomean(intermediate) / optima(i);
                best_f(i,ex,m,:) = intermediate_best / RUNS;
                mean_f(i,ex,m,:) = intermediate_mean / RUNS;
                worst_f(i,ex,m,:) = intermediate_worst / RUNS;
                fprintf("#")
            end
            performance = mean(total) * 100;  % Percentage of 100 is perfect match
            fprintf("\nResult: %s - %s - %s - performance: %.2f\n\n", r, c, MUTATION(m), performance);
        end
    end
    % Save all the matrices
    save('total', 'total');
    save('best_f', 'best_f');
    save('mean_f', 'mean_f');
    save('worst_f', 'worst_f');
end

% Load in the matrices
file = matfile('total'); total = file.total;
file = matfile('best_f'); best_f = file.best_f;
file = matfile('mean_f'); mean_f = file.mean_f;
file = matfile('worst_f'); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s", data_list(i));
    create_figure(data_list(i), best_f(i,:,:,:), mean_f(i,:,:,:), worst_f(i,:,:,:));
end


% Function called to run each of the configurations
function c = run_data(set, repr, cross, mut)
    global GENERATIONS
    
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = GENERATIONS;
    data("representation") = repr;
    data("crossover") = cross;
    data("pr_cross") = 0.2;
    data("mutation") = mut;
    data("pr_mut") = 0.2;
    data("diversify") = true;
    
    % Run experiment
    c = run_ga(data);
end


% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    global MUTATION
    
    figure();
    x=0:length(best_f)-1;
    
    %MUT = 1;  % reciprocal_exchange
    MUT = 2;  % inversion
    %MUT = 3;  % scramble
    title = title + sprintf("_%s.fig", MUTATION(MUT));
    
    % Split up data
    best_adj = squeeze(best_f(1,1,MUT,:));
    best_path = squeeze(best_f(1,2,MUT,:));
    
    mean_adj = squeeze(mean_f(1,1,MUT,:));
    mean_path = squeeze(mean_f(1,2,MUT,:));
    
    worst_adj = squeeze(worst_f(1,1,MUT,:));
    worst_path = squeeze(worst_f(1,2,MUT,:));
    
    hold on
    plot(x, best_adj, 'g', x, best_path, 'g--')
    plot(x, mean_adj, 'b', x, mean_path, 'b--')
    plot(x, worst_adj, 'r', x, worst_path, 'r--')
    ylabel("Fitness")
    xlabel("Generation")
    legend("best adjacency", "best path", "mean adjacency", "mean path", "worst adjacency", "worst path");
    savefig("figures/" + title);
    hold off
end


%{
Results:

--> pr_cross=0.2; pr_mut=0.2;
Result: adjacency - xalt_edges - inversion - performance: 187.93
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 190.84
Result: adjacency - xalt_edges - scramble - performance: 210.85

Result: path - heuristic_crossover - inversion - performance: 105.10
Result: path - heuristic_crossover - reciprocal_exchange - performance: 106.24
Result: path - heuristic_crossover - scramble - performance: 107.08


--> pr_cross=0.2; pr_mut=0.4;
Result: adjacency - xalt_edges - inversion - performance: 184.46
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 192.31
Result: adjacency - xalt_edges - scramble - performance: 222.37

Result: path - heuristic_crossover - inversion - performance: 103.52
Result: path - heuristic_crossover - reciprocal_exchange - performance: 105.44
Result: path - heuristic_crossover - scramble - performance: 105.89


--> pr_cross=0.4; pr_mut=0.2;
Result: adjacency - xalt_edges - inversion - performance: 188.03
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 190.81
Result: adjacency - xalt_edges - scramble - performance: 209.07

Result: path - heuristic_crossover - inversion - performance: 102.75
Result: path - heuristic_crossover - reciprocal_exchange - performance: 103.58
Result: path - heuristic_crossover - scramble - performance: 103.68


--> pr_cross=0.4; pr_mut=0.4;
Result: adjacency - xalt_edges - inversion - performance: 191.29
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 198.10
Result: adjacency - xalt_edges - scramble - performance: 221.52

Result: path - heuristic_crossover - inversion - performance: 102.33
Result: path - heuristic_crossover - reciprocal_exchange - performance: 103.54
Result: path - heuristic_crossover - scramble - performance: 103.62
%}