

% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\datasets'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\custom_scripts'

data = load(['rondrit016.tsp']);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("heu_localMUT")=0.3;
    data("heu_threefour")=1;
run_ga(data);