%{
exercise5_benchmarks.m

Hceck the influence of the improvements on the benchmark problems.

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
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\benchmarks'
BENCHMARK = ["No improvements","all improvements"];
% Load all the datasets
data_list=["bcl380.tsp","belgiumtour.tsp","rbx711.tsp","xqf131.tsp","xql662.tsp"];

optima=load('benchmark_optima.tsp');

% Run the experiment
if CALCULATE_NEW
    best_f = zeros(length(data_list), length(BENCHMARK), GENERATIONS);
    mean_f = zeros(length(data_list), length(BENCHMARK), GENERATIONS);
    worst_f = zeros(length(data_list), length(BENCHMARK), GENERATIONS);
    for c=1:length(BENCHMARK)
        fprintf("Calculating %s - Progress: \n", BENCHMARK(c))
        total = zeros(1,length(data_list));
        for i=1:length(data_list)
            fprintf(data_list(i)+": \n");
            intermediate = zeros(1, RUNS);
            intermediate_best = zeros(1,GENERATIONS);
            intermediate_mean = zeros(1,GENERATIONS);
            intermediate_worst = zeros(1,GENERATIONS);
            for j=1:RUNS
                fprintf("run: %d ",j);
                output = run_data(data_list(i), BENCHMARK(c));
                intermediate(j) = output("minimum");
                intermediate_best = intermediate_best + output("best");
                intermediate_mean = intermediate_mean + output("mean_fits");
                intermediate_worst = intermediate_worst + output("worst");
                fprintf("# \n");
            end
            total(i) = geomean(intermediate) / optima(i);
            best_f(i,c,:) = intermediate_best / RUNS;
            mean_f(i,c,:) = intermediate_mean / RUNS;
            worst_f(i,c,:) = intermediate_worst / RUNS;
            
        end
        performance = mean(total) * 100;  % Percentage of 100 is perfect match
        fprintf("\nResult: %s - performance: %.2f\n\n", BENCHMARK(c), performance);
    end
    % Save all the matrices
    %{
    save('total_BENCHMARK', 'total');
    save('best_f_BENCHMARK', 'best_f');
    save('mean_f_BENCHMARK', 'mean_f');
    save('worst_f_BENCHMARK', 'worst_f');
    %}
end
%{
% Load in the matrices
file = matfile('total_BENCHMARK'); total = file.total;
file = matfile('best_f_BENCHMARK'); best_f = file.best_f;
file = matfile('mean_f_BENCHMARK'); mean_f = file.mean_f;
file = matfile('worst_f_BENCHMARK'); worst_f = file.worst_f;

% Display all the figures
for i=1:length(data_list)
    title = sprintf("%s.fig", data_list(i));
    create_figure(data_list(i)+"_BENCHMARK_without_crowding", best_f(i,:,:), mean_f(i,:,:), worst_f(i,:,:));
end
%}

% Function called to run each of the configurations
function c = run_data(set, i)
    global GENERATIONS
    
    % Load data
    data = load(set);
    %data=load(set);
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = GENERATIONS;
    data("representation") = "path";
    if i=="all improvements"       
    % Create input container
     data("crossover") = "heuristic_crossover";
    data("pr_cross") = 0.4;
    data("mutation") = "inversion";
    data("pr_mut") = 0.4;
    data("diversify") = 1;
    data("loop_detect")=1;
    data("parent_selection")="scaling";
    data("survivor_selection")="round_robin";
    data("local_heur")="both";
    data("adaptive_mut")=true;
    
    end
    % Run experiment
    c = run_ga(data);
end

% Function called to visualize the progress
function create_figure(title, best_f, mean_f, worst_f)
    figure();
    x=0:length(best_f)-1;
    
    % Split up data
    best_without_BENCHMARK = squeeze(best_f(1,1,:));
    best_2_BENCHMARK = squeeze(best_f(1,2,:));
    
    
    mean_without_BENCHMARK = squeeze(mean_f(1,1,:));
    mean_2_BENCHMARK = squeeze(mean_f(1,2,:));
    
    worst_without_BENCHMARK = squeeze(worst_f(1,1,:));
    worst_2_BENCHMARK = squeeze(worst_f(1,2,:));
    
    hold on
    plot(x, best_without_BENCHMARK, 'g',x,best_2_BENCHMARK, 'g:')
    plot(x, mean_without_BENCHMARK, 'b',x,mean_2_BENCHMARK, 'b:')
    plot(x, worst_without_BENCHMARK, 'r',x,worst_2_BENCHMARK, 'r:')
    
     ylabel("Fitness")
    xlabel("Generation")
    legend("best without improvements","best with improvements", "mean without improvements","mean with improvements", "worst without improvements","with improvements");
    savefig("figures/" + title);
    hold off
end



%{
Results:
Calculating all improvements - Progress: #####
Result: all improvements - performance: 111.88

Calculating No improvements - Progress: #####
Result: No improvements - performance: 807.43
%}