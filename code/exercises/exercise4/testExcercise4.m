
NUMBER_OF_TESTS=100;

% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\datasets'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\custom_scripts'

data = load(['rondrit016.tsp']);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
data1 = containers.Map;
    data("x") = x;
    data("y") = y;
    data("heu_localMUT")=0.3;
    data("heu_threefour")=1;
    
result = run_ga(data);
withHeuristic = zeros(1,MAXGEN);
withoutHeuristic = zeros(1,MAXGEN);
wait = waitbar(0,'Please wait for senpai to notice me...');
for i=1:NUMBER_OF_TESTS
    withHeuristic = withHeuristic + ex4_run_ga(x, y, NIND, MAXGEN, NCITIES, ELITIST, STOP_PERCENTAGE, CROSSOVER_PERCENTAGE, MUTATION_PERCENTAGE, CROSSOVER, LOCALLOOP,LOCAL_MUT);
    withoutHeuristic = withoutHeuristic + ex4_run_without_heuristics(x, y, NIND, MAXGEN, NCITIES, ELITIST, STOP_PERCENTAGE, CROSSOVER_PERCENTAGE, MUTATION_PERCENTAGE, CROSSOVER, LOCALLOOP);
    waitbar(i/NUMBER_OF_TESTS);
end
close(wait);
disp("FINAL HEURISTICS")
x_values =0:99;
size(x_values)
plot(x_values,withoutHeuristic/NUMBER_OF_TESTS,'--',x_values,withHeuristic/NUMBER_OF_TESTS)
    