%{
exercise3.m

Evaluate all of the possible representation - crossover - mutation
combination on each of the benchmarks.
%}

% Parameters
global CALCULATE_NEW CONFIG GENERATIONS MUTATION PR_CROSS PR_MUT RUNS
CALCULATE_NEW = false;
GENERATIONS = 100;
RUNS = 20;
PR_CROSS = 0.4;
PR_MUT = 0.4;
CONFIG = sprintf("%d_%d", PR_CROSS*100, PR_MUT*100);

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
    save(CONFIG + "/total", 'total');
    save(CONFIG + "/best_f", 'best_f');
    save(CONFIG + "/mean_f", 'mean_f');
    save(CONFIG + "/worst_f", 'worst_f');
end

% Load in the matrices
file = matfile(CONFIG + "/total"); total = file.total;
file = matfile(CONFIG + "/best_f"); best_f = file.best_f;
file = matfile(CONFIG + "/mean_f"); mean_f = file.mean_f;
file = matfile(CONFIG + "/worst_f"); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s", data_list(i));
    % TODO: Create figures for best combination (or 127 for each of the combinations?)
    %create_figure(data_list(i), best_f(i,:,:,:), mean_f(i,:,:,:), worst_f(i,:,:,:));
end


% Function called to run each of the configurations
function c = run_data(set, repr, cross, mut)
    global GENERATIONS PR_CROSS PR_MUT
    
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
    data("pr_cross") = PR_CROSS;
    data("mutation") = mut;
    data("pr_mut") = PR_MUT;
    data("diversify") = true;
    
    % Run experiment
    c = run_ga(data);
end


% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    global MUTATION CONFIG
    
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
    savefig(CONFIG + "/figures/" + title);
    hold off
end


%{
Results:

--> pr_cross=0.2; pr_mut=0.2;
Result: adjacency - xalt_edges - inversion - performance: 184.95
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 189.71
Result: adjacency - xalt_edges - scramble - performance: 209.87

Result: path - heuristic_crossover - inversion - performance: 103.99
Result: path - heuristic_crossover - reciprocal_exchange - performance: 105.62
Result: path - heuristic_crossover - scramble - performance: 105.85


--> pr_cross=0.2; pr_mut=0.4;
Result: adjacency - xalt_edges - inversion - performance: 184.28
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 190.47
Result: adjacency - xalt_edges - scramble - performance: 220.97

Result: path - heuristic_crossover - inversion - performance: 103.81
Result: path - heuristic_crossover - reciprocal_exchange - performance: 105.05
Result: path - heuristic_crossover - scramble - performance: 106.04


--> pr_cross=0.4; pr_mut=0.2;
Result: adjacency - xalt_edges - inversion - performance: 189.65
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 193.22
Result: adjacency - xalt_edges - scramble - performance: 209.72

Result: path - heuristic_crossover - inversion - performance: 102.59
Result: path - heuristic_crossover - reciprocal_exchange - performance: 103.76
Result: path - heuristic_crossover - scramble - performance: 103.88


--> pr_cross=0.4; pr_mut=0.4;
Result: adjacency - xalt_edges - inversion - performance: 190.53
Result: adjacency - xalt_edges - reciprocal_exchange - performance: 197.06
Result: adjacency - xalt_edges - scramble - performance: 223.75

Result: path - heuristic_crossover - inversion - performance: 102.17
Result: path - heuristic_crossover - reciprocal_exchange - performance: 103.61
Result: path - heuristic_crossover - scramble - performance: 103.72
%}