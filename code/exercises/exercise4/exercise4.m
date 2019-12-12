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

% Load all the datasets
data_list = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];
optima = load('rondrit_optima.tsp');

HEURISTIC = ["off", "inversion", "2-opt", "both"];

% Run the experiment
for h=HEURISTIC
    fprintf("Calculating %s - Progress: ", h)
    total = zeros(1,length(data_list));
    for i=1:length(data_list)
        intermediate = zeros(1, 10);
        for j=1:10
            output = run_data(data_list(i), h);
            intermediate(j) = output("minimum");
        end
        total(i) = geomean(intermediate) / optima(i);
        fprintf("#")
    end
    performance = mean(total) * 100;  % Percentage of 100 is perfect match
    fprintf("\nResult: %s - performance: %.2f\n\n", h, performance);
end

function c = run_data(set, h)
    % Load data
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Create input container
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = 100;
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

%{
Results:

Result:   - performance: 103.98
%}