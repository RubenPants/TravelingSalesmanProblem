%{
exercise6_ISLANDS.m

Check the influence of ISLANDS for the case of:
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
RUNS=20;
% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

ISLANDS = [1,4];
%ISLANDS = [1,2,4,8];
% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    mean_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    worst_f = zeros(length(data_list), length(ISLANDS), GENERATIONS);
    for c=1:length(ISLANDS)
        fprintf("Calculating %d - Progress: ", ISLANDS(c))
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), ISLANDS(c));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
            end
            total(i) = geomean(intermediate) / optima(i);
            best_f(i,c,:) = intermediate_best / RUNS;
            mean_f(i,c,:) = intermediate_mean / RUNS;
            worst_f(i,c,:) = intermediate_worst / RUNS;
            fprintf("#")
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %d - performance: %.2f\n\n", ISLANDS(c), performance);
    end
    % Save all the matrices
    save('total_ISLANDS', 'total');
    save('best_f_ISLANDS', 'best_f');
    save('mean_f_ISLANDS', 'mean_f');
    save('worst_f_ISLANDS', 'worst_f');
end

% Load in the matrices
file = matfile('total_ISLANDS'); total = file.total;
file = matfile('best_f_ISLANDS'); best_f = file.best_f;
file = matfile('mean_f_ISLANDS'); mean_f = file.mean_f;
file = matfile('worst_f_ISLANDS'); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s.fig", data_list(i));
    create_figure(data_list(i)+"_ISLANDS", best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end

% Function called to run each of the configurations
function c = run_data(set, i)
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
    data("subpopulations") = i;
    
    % Run experiment
    c = run_ga(data);
end

% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    figure();
    x=0:length(best_f)-1;
    
    % Split up data
    best_without_ISLANDS = squeeze(best_f(1,1,:));
    best_2_ISLANDS = squeeze(best_f(1,2,:));
   % best_4_ISLANDS = squeeze(best_f(1,3,:));
   % best_8_ISLANDS = squeeze(best_f(1,4,:));
    
    
    mean_without_ISLANDS = squeeze(mean_f(1,1,:));
    mean_2_ISLANDS = squeeze(mean_f(1,2,:));
   % mean_4_ISLANDS = squeeze(mean_f(1,3,:));
   % mean_8_ISLANDS = squeeze(mean_f(1,4,:));
    
    worst_without_ISLANDS = squeeze(worst_f(1,1,:));
    worst_2_ISLANDS = squeeze(worst_f(1,2,:));
  %  worst_4_ISLANDS = squeeze(worst_f(1,3,:));
  %  worst_8_ISLANDS = squeeze(worst_f(1,4,:));
    
    hold on
    plot(x, best_without_ISLANDS, 'g',x,best_2_ISLANDS, 'g:')
    plot(x, mean_without_ISLANDS, 'b',x,mean_2_ISLANDS, 'b:')
    plot(x, worst_without_ISLANDS, 'r',x,worst_2_ISLANDS, 'r:')
    
    %plot(x, best_without_ISLANDS, 'g',x,best_2_ISLANDS, 'g:',x,best_4_ISLANDS, 'g-.', x, best_8_ISLANDS, 'g--')
    %plot(x, mean_without_ISLANDS, 'b',x,mean_2_ISLANDS, 'b:',x,mean_4_ISLANDS, 'b-.', x, mean_8_ISLANDS, 'b--')
    %plot(x, worst_without_ISLANDS, 'r',x,worst_2_ISLANDS, 'r:',x,worst_4_ISLANDS, 'r-.', x, worst_8_ISLANDS, 'r--')
     ylabel("Fitness")
    xlabel("Generation")
    %legend("best without ISLANDS", "best 2 ISLANDS","best 4 ISLANDS","best 8 ISLANDS", "mean without ISLANDS", "mean 2 ISLANDS","mean 4 ISLANDS","mean 8 ISLANDS", "worst without ISLANDS", "worst 2 ISLANDS","worst 4 ISLANDS","worst 8 ISLANDS");
    legend("best without ISLANDS","best 8 ISLANDS", "mean without ISLANDS","mean 8 ISLANDS", "worst without ISLANDS","worst 8 ISLANDS");
    
    savefig(title);
    hold off
end



%{
Results:
Result: 0 - performance: 104.27 (no ISLANDS)
Result: 1 - performance: 106.03 (ISLANDS)
%}