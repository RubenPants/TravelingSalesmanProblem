%{
exercise6_BENCHMARKS.m

Check the influence of BENCHMARKS for the case of:
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

BENCHMARKS = [ "without improvements","with improvements"];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(BENCHMARKS), GENERATIONS);
    mean_f = zeros(length(data_list), length(BENCHMARKS), GENERATIONS);
    worst_f = zeros(length(data_list), length(BENCHMARKS), GENERATIONS);
    for b=1:length(BENCHMARKS)
        fprintf("Calculating %s - Progress: ", BENCHMARKS(b))
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), BENCHMARKS(b));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
            end
            total(i) = geomean(intermediate) / optima(i);
            best_f(i,b,:) = intermediate_best / RUNS;
            mean_f(i,b,:) = intermediate_mean / RUNS;
            worst_f(i,b,:) = intermediate_worst / RUNS;
            fprintf("#")
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %s - performance: %.2f\n\n", BENCHMARKS(b), performance);
    end
    % Save all the matrices
    save('total_BENCHMARKS', 'total');
    save('best_f_BENCHMARKS', 'best_f');
    save('mean_f_BENCHMARKS', 'mean_f');
    save('worst_f_BENCHMARKS', 'worst_f');
end

% Load in the matrices
file = matfile('total_BENCHMARKS'); total = file.total;
file = matfile('best_f_BENCHMARKS'); best_f = file.best_f;
file = matfile('mean_f_BENCHMARKS'); mean_f = file.mean_f;
file = matfile('worst_f_BENCHMARKS'); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s.fig", data_list(i));
    create_figure(data_list(i)+"_BENCHMARKS", best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end

% Function called to run each of the configurations
function c = run_data(set, b)
    global GENERATIONS
    
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = GENERATIONS;
    data("representation") = "path";
    if b == "with improvements"
    data("crossover") = "heuristic_crossover";
    data("pr_cross") = 0.4;
    data("mutation") = "inversion";
    data("pr_mut") = 0.4;
    data("diversify") = 1;
    data("loop_detect")=1;
    data("parent_selection")="scaling";
    data("survivor_selection")="round_robin";
    data("diversify")=1;
    data("local_heur")="both";
    
    end
    % Run experiment
    c = run_ga(data);
end

% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    figure();
    x=0:length(best_f)-1;
    
    % Split up data
    best_without_BENCHMARKS = squeeze(best_f(1,1,:));
    best_BENCHMARKS = squeeze(best_f(1,2,:));
    
    mean_without_BENCHMARKS = squeeze(mean_f(1,1,:));
    mean_BENCHMARKS = squeeze(mean_f(1,2,:));
    
    worst_without_BENCHMARKS = squeeze(worst_f(1,1,:));
    worst_BENCHMARKS = squeeze(worst_f(1,2,:));
    
    hold on
    plot(x, best_without_BENCHMARKS, 'g', x, best_BENCHMARKS, 'g--');
    plot(x, mean_without_BENCHMARKS, 'b', x, mean_BENCHMARKS, 'b--');
    plot(x, worst_without_BENCHMARKS, 'r', x, worst_BENCHMARKS, 'r--');
    ylabel("Fitness")
    xlabel("Generation")
    legend("best without BENCHMARKS", "best BENCHMARKS", "mean without BENCHMARKS", "mean BENCHMARKS", "worst without BENCHMARKS", "worst BENCHMARKS");
    savefig(title);
    hold off
end



%{
Results:
Result: 0 - performance: 104.27 (no BENCHMARKS)
Result: 1 - performance: 106.03 (BENCHMARKS)
%}