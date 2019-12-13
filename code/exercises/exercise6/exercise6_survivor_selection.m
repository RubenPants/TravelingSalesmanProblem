%{
exercise6_survivor_selection.m

Check the influence of each of the survivor_selection algorithms for the case of:
    #population=128
    elitism=0.05
    representation=path
    crossover=heuristic_crossover
    mutation=inversion
    maxgen=100

Performance scores depict how much longer the found solution is compared to
the real optimum.
%}

% Parameters
global GENERATIONS RUNS CALCULATE_NEW
CALCULATE_NEW = true;
GENERATIONS = 100;
RUNS = 20;

% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

SURVIVOR_SELECTION = ["elitism", "round_robin"];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(SURVIVOR_SELECTION), GENERATIONS);
    mean_f = zeros(length(data_list), length(SURVIVOR_SELECTION), GENERATIONS);
    worst_f = zeros(length(data_list), length(SURVIVOR_SELECTION), GENERATIONS);
    for s=1:length(SURVIVOR_SELECTION)
        fprintf("Calculating %s - Progress: ", SURVIVOR_SELECTION(s))
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), SURVIVOR_SELECTION(s));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
            end
            total(i) = geomean(intermediate) / optima(i);
            best_f(i,s,:) = intermediate_best / RUNS;
            mean_f(i,s,:) = intermediate_mean / RUNS;
            worst_f(i,s,:) = intermediate_worst / RUNS;
            fprintf("#")
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %s - performance: %.2f\n\n", SURVIVOR_SELECTION(s), performance);
    end
    % Save all the matrices
    save('total_survivor', 'total');
    save('best_f_survivor', 'best_f');
    save('mean_f_survivor', 'mean_f');
    save('worst_f_survivor', 'worst_f');
end

% Load in the matrices
file = matfile('total_survivor'); total = file.total;
file = matfile('best_f_survivor'); best_f = file.best_f;
file = matfile('mean_f_survivor'); mean_f = file.mean_f;
file = matfile('worst_f_survivor'); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s.fig", data_list(i));
    create_figure(data_list(i)+"_survivor", best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end

% Function called to run each of the configurations
function c = run_data(set, s)
    global GENERATIONS
    
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = GENERATIONS;
    data("representation") = "path";
    data("crossover") = "heuristic_crossover";
    data("pr_cross") = 0.2;
    data("mutation") = "inversion";
    data("pr_mut") = 0.2;
    data("diversify") = true;
    data("survivor_selection") = s;
    
    % Run experiment
    c = run_ga(data);
end

% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    figure();
    x=0:length(best_f)-1;
    
    % Split up data
    best_elitism = squeeze(best_f(1,1,:));
    best_round_robin = squeeze(best_f(1,2,:));
    
    mean_elitism = squeeze(mean_f(1,1,:));
    mean_round_robin = squeeze(mean_f(1,2,:));
    
    worst_elitism = squeeze(worst_f(1,1,:));
    worst_round_robin = squeeze(worst_f(1,2,:));
    
    hold on
    plot(x, best_elitism, 'g', x, best_round_robin, 'g--')
    plot(x, mean_elitism, 'b', x, mean_round_robin, 'b--')
    plot(x, worst_elitism, 'r', x, worst_round_robin, 'r--')
    ylabel("Fitness")
    xlabel("Generation")
    legend("best elitism", "best round_robin", "mean elitism", "mean round_robin", "worst elitism", "worst round_robin");
    savefig(title);
    hold off
end



%{
Results:

Result: elitism - performance: 104.18

Result: round_robin - performance: 103.86
%}