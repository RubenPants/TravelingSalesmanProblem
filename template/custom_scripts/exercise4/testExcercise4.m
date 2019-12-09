%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=10;                   % Number of individuals
MAXGEN=100;                 % Maximum no. of generations
PRECI=1;                    % Precision of variables
ELITIST=0.05;               % percentage of the elite population
GGAP=1-ELITIST;             % Generation gap
STOP_PERCENTAGE=.95;        % percentage of equal fitness individuals for stopping
LOCALLOOP=1;                % local loop removal
CROSSOVER='xalt_edges';     % default crossover operator

% Custom parameters
AVG_COUNT=10;               % No. of times the same configuration is played
CALCULATE_NEW=0;            % Calculate a new Avg array (time consuming)
LOCAL_MUT = 0.5;
MUTATION_PERCENTAGE=0.2;
CROSSOVER_PERCENTAGE = 0.2;
%TEST PARAMETERS
NUMBER_OF_TESTS=100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\datasets'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\custom_scripts'

data = load(['rondrit016.tsp']);
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
NCITIES = size(x,1);
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
    