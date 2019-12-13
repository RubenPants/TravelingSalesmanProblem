
% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data = ["070", "100", "127"];

for d=data
    data = load(sprintf('rondrit%s.tsp', d));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    dist = zeros(1,10);
    fprintf("%s - ", d)
    for i=1:10
        data = containers.Map;
        data("x") = x;
        data("y") = y;
        data("nind") = 512;
        data("maxgen") = 100;
        data("pr_cross") = 0.2;
        data("pr_mut") = 0.4;
        data("loop_detect") = true;
        data("diversify") = false;
        data("crossover") = 'heuristic_crossover';
        data("mutation") = 'inversion';
        c = run_ga(data);
        dist(i) = c("minimum");
        fprintf("#")
    end
    fprintf(" - minimum: %f\n", min(dist))
end
