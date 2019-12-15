%{
islands.m

Evaluate the influence "islands" (implemented in islands) has on the 
population's performance.
%}

% Parameters
global CALCULATE_NEW GENERATIONS PR_CROSS PR_MUT RUNS NIND
CALCULATE_NEW = true;
NIND = 256;
GENERATIONS = 200;
RUNS = 20;
PR_CROSS = 0.2;
PR_MUT = 0.2;

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

ISLANDS = [1, 2, 4, 8, 16];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    mean_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    worst_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    for island=1:length(ISLANDS)
        for i=1:length(data_list)
            fprintf("Calculating: #populations: %d - %s - Progress: ", ISLANDS(island), data_list(i))
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), ISLANDS(island));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
                fprintf("#")
            end
            result = 100 * geomean(intermediate) / optima(i+4);  % Shift optima since we discarded first 4 experiments
            best_f(i,island,:) = intermediate_best / RUNS;
            mean_f(i,island,:) = intermediate_mean / RUNS;
            worst_f(i,island,:) = intermediate_worst / RUNS;
            fprintf("\nResult: %d - %s - performance: %.2f\n\n", ISLANDS(island), data_list(i), result);
        end
    end
    % Save all the matrices
    save("best_f", 'best_f');
    save("mean_f", 'mean_f');
    save("worst_f", 'worst_f');
end

% Load in the matrices
file = matfile("best_f"); best_f = file.best_f;
file = matfile("mean_f"); mean_f = file.mean_f;
file = matfile("worst_f"); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s", data_list(i));
    create_figure(data_list(i), best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end


% Function called to run each of the configurations
function c = run_data(set, islands)
    global GENERATIONS PR_CROSS PR_MUT NIND
    
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("nind") = NIND;
    data("maxgen") = GENERATIONS;
    data("representation") = "path";
    data("crossover") = "heuristic_crossover";
    data("pr_cross") = PR_CROSS;
    data("mutation") = "inversion";
    data("pr_mut") = PR_MUT;
    data("loop_detect") = true;
    data("subpop") = islands;
    data("pop_stag") = 20;
    
    % Run experiment
    c = run_ga(data);
end


% Function called to visualize the progress
function create_figure(title, best_f, ~, ~)    
    figure();
    x=0:length(best_f)-1;
    title = title + ".fig";
    
    % Split up data
    best_1 = squeeze(best_f(1,1,:));
    best_2 = squeeze(best_f(1,2,:));
    best_4 = squeeze(best_f(1,1,:));
    best_8 = squeeze(best_f(1,2,:));
    best_16 = squeeze(best_f(1,1,:));
    
    hold on
    plot(x, best_1)
    plot(x, best_2)
    plot(x, best_4)
    plot(x, best_8)
    plot(x, best_16)
    ylabel("Fitness")
    xlabel("Generation")
    legend("best 1", "best 2","best 4", "best 8","best 16");
    %savefig("figures/" + title);
    hold off
end


%{
Results: In all rondrits 016, 018, 023, and 025, all island configurations
obtained perfect results in at least one run out of 20. This is why we
discarded these samples for this experiment.

Result: 1 - 048 - performance: 100.98
Result: 1 - 050 - performance: 100.60
Result: 1 - 051 - performance: 101.33
Result: 1 - 067 - performance: 101.07
Result: 1 - 070 - performance: 102.01
Result: 1 - 100 - performance: 103.81
Result: 1 - 127 - performance: 100.00
%}