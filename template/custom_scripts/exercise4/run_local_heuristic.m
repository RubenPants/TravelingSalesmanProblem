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
NCITIES=16;                 % No. of cities
LOCAL_MUT = 0.05;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\datasets'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\template\custom_scripts'

data = load(['rondrit016.tsp'])
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
disp(ex4_run_ga(x, y, NIND, MAXGEN, NCITIES, ELITIST, STOP_PERCENTAGE, 0.95, 0.05, CROSSOVER, LOCALLOOP, LOCAL_MUT))