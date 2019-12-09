% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Load all the datasets
data = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];

for d=data
    data = load(sprintf('rondrit%s.tsp', d));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("nind") = 128;
    data("maxgen") = 2000;
    data("pr_cross") = 0.05;
    data("pr_mut") = 0.4;
    data("loop_detect") = true;
    c = run_ga(data);
    fprintf("%s - minimum: %f - generation: %f\n", d, c("minimum"), c("generation"))
end

function c = run_data(set, repr, cross, mut)
    global NIND MAXGEN ELITIST PR_CROSS PR_MUT LOCALLOOP
    % Run the given configuration on the requested dataset
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    c = run_ga_ex3(x, y, NIND, MAXGEN, ELITIST, PR_CROSS, PR_MUT, repr, cross, mut, LOCALLOOP);
end