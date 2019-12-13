%{
exercise4_ruben.m

Check the influence of each of the heuristic types for the case of:
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
CALCULATE_NEW = false;
GENERATIONS = 100;
RUNS = 20;

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

HEURISTIC = ["off", "inversion", "2-opt", "both"];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(HEURISTIC), GENERATIONS);
    mean_f = zeros(length(data_list), length(HEURISTIC), GENERATIONS);
    worst_f = zeros(length(data_list), length(HEURISTIC), GENERATIONS);
    for h=1:length(HEURISTIC)
        fprintf("Calculating %s - Progress: ", HEURISTIC(h))
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), HEURISTIC(h));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
            end
            total(i) = geomean(intermediate) / optima(i);
            best_f(i,h,:) = intermediate_best / RUNS;
            mean_f(i,h,:) = intermediate_mean / RUNS;
            worst_f(i,h,:) = intermediate_worst / RUNS;
            fprintf("#")
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %s - performance: %.2f\n\n", HEURISTIC(h), performance);
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
    title = sprintf("%s.fig", data_list(i));
    create_figure(data_list(i), best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end

% Function called to run each of the configurations
function c = run_data(set, h)
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
    data("local_heur") = h;
    
    % Run experiment
    c = run_ga(data);
end

% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    figure();
    x=0:length(best_f)-1;
    
    % Split up data
    best_off = squeeze(best_f(1,1,:));
    %best_inversion = squeeze(best_f(1,2,:));
    %best_2_opt = squeeze(best_f(1,3,:));
    best_both = squeeze(best_f(1,4,:));
    
    mean_off = squeeze(mean_f(1,1,:));
    %mean_inversion = squeeze(mean_f(1,2,:));
    %mean_2_opt = squeeze(mean_f(1,3,:));
    mean_both = squeeze(mean_f(1,4,:));
    
    worst_off = squeeze(worst_f(1,1,:));
    %worst_inversion = squeeze(worst_f(1,2,:));
    %worst_2_opt = squeeze(worst_f(1,3,:));
    worst_both = squeeze(worst_f(1,4,:));
    
    hold on
    %plot(x, best_off, 'g', x, best_inversion,'g--', x, best_2_opt, 'g:', x, best_both, 'g-.')
    %plot(x, mean_off, 'b', x, mean_inversion,'b--', x, mean_2_opt, 'b:', x, mean_both, 'b-.')
    %plot(x, worst_off, 'r', x, worst_inversion,'r--', x, worst_2_opt, 'r:', x, worst_both, 'r-.')
    plot(x, best_off, 'g', x, best_both, 'g--')
    plot(x, mean_off, 'b', x, mean_both, 'b--')
    plot(x, worst_off, 'r', x, worst_both, 'r--')
    ylabel("Fitness")
    xlabel("Generation")
    %legend("best off", "best inversion", "best 2-opt", "best both", "mean off", "mean inversion", "mean 2-opt", "mean both", "worst off", "worst inversion", "worst 2-opt", "worst both");
    legend("best off", "best both", "mean off", "mean both", "worst off", "worst both");
    savefig(title);
    hold off
end



%{
Results:

Result: off - performance: 104.30
Result: inversion - performance: 103.67
Result: 2-opt - performance: 102.70
Result: both - performance: 102.20
%}