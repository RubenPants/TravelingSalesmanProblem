

% Add paths to other files
% addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
% addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load(['rondrit016.tsp']);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
data = containers.Map;
data("x") = x;
data("y") = y;
data("local_heur_pr")=0.3;
data("local_heur")='2-opt';
result = run_ga(data);
