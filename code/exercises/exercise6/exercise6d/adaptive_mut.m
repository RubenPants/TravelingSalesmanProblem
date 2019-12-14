%{
adaptive_mut.m

Evaluate the influence "adaptive mutation" (implemented in mutateTSP) has
on the population's performance.
%}

% Parameters
global CALCULATE_NEW GENERATIONS PR_CROSS PR_MUT RUNS
CALCULATE_NEW = true;
GENERATIONS = 200;
RUNS = 20;
PR_CROSS = 0.2;
PR_MUT = 0.2;

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\benchmarks'

% Load all the datasets
data_list = ["bcl380", "belgiumtour", "rbx711", "xqf131", "xql662"];
optima = load('benchmark_optima.tsp');

ADAPTIVE = [false, true];

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), 2, GENERATIONS);
    mean_f = zeros(length(data_list), 2, GENERATIONS);
    worst_f = zeros(length(data_list), 2, GENERATIONS);
    for a=1:length(ADAPTIVE)
        for i=1:length(data_list)
            fprintf("Calculating %d - %s - Progress: ", ADAPTIVE(a), data_list(i))
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                output = run_data(data_list(i), ADAPTIVE(a));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
                fprintf("#")
            end
            result = 100 * geomean(intermediate) / optima(i);
            best_f(i,a,:) = intermediate_best / RUNS;
            mean_f(i,a,:) = intermediate_mean / RUNS;
            worst_f(i,a,:) = intermediate_worst / RUNS;
            fprintf("\nResult: %d - %s - performance: %.2f\n\n", ADAPTIVE(a), data_list(i), result);
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
function c = run_data(set, adaptive)
    global GENERATIONS PR_CROSS PR_MUT
    
    % Load data
    data = load(sprintf('%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("nind") = 128;
    data("maxgen") = GENERATIONS;
    data("representation") = "path";
    data("crossover") = "heuristic_crossover";
    data("pr_cross") = PR_CROSS;
    data("mutation") = "inversion";
    data("pr_mut") = PR_MUT;
    data("loop_detect") = true;
    data("adaptive_mut") = adaptive;
    
    % Run experiment
    c = run_ga(data);
end


% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)    
    figure();
    x=0:length(best_f)-1;
    title = title + ".fig";
    
    % Split up data
    best_off = squeeze(best_f(1,1,:));
    best_on = squeeze(best_f(1,2,:));
    
    mean_off = squeeze(mean_f(1,1,:));
    mean_on = squeeze(mean_f(1,2,:));
    
    worst_off = squeeze(worst_f(1,1,:));
    worst_on = squeeze(worst_f(1,2,:));
    
    hold on
    plot(x, best_off, 'g', x, best_on, 'g--')
    plot(x, mean_off, 'b', x, mean_on, 'b--')
    plot(x, worst_off, 'r', x, worst_on, 'r--')
    ylabel("Fitness")
    xlabel("Generation")
    legend("best off", "best on", "mean off", "mean on", "worst off", "worst on");
    savefig("figures/" + title);
    hold off
end


%{
Results:

--> pr_cross=0.2; pr_mut=0.2;
Result: 0 - bcl380 - performance: 119.30
Result: 1 - bcl380 - performance: 117.24
Result: 0 - belgiumtour - performance: 101.91
Result: 1 - belgiumtour - performance: 101.62
Result: 0 - rbx711 - performance: 124.32
Result: 1 - rbx711 - performance: 122.34
Result: 0 - xqf131 - performance: 108.23
Result: 1 - xqf131 - performance: 107.93
Result: 0 - xqf662 - performance: 126.27
Result: 1 - xqf662 - performance: 125.76


--> pr_cross=0.2; pr_mut=0.4;


--> pr_cross=0.4; pr_mut=0.2;


--> pr_cross=0.4; pr_mut=0.4;
%}