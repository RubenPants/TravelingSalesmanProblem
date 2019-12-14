
% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\benchmarks'

% Load all the datasets
data_list = ["belgiumtour"];%, "rbx711", "xqf131", "xql662"];

for d=data_list
    data = load(sprintf('%s.tsp', d));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    dist = zeros(1,10);
    fprintf("%s - ", d)
    for i=1:10
        data = containers.Map;
        data("x") = x;
        data("y") = y;
        data("nind") = 256;
        data("maxgen") = 200;
        data("pr_cross") = 0.4;
        data("pr_mut") = 0.4;
        data("loop_detect") = true;
        data("crossover") = 'heuristic_crossover';
        data("mutation") = 'inversion';
        c = run_ga(data);
        dist(i) = c("minimum");
        fprintf("#")
    end
    fprintf(" - minimum: %f\n", min(dist))
end
