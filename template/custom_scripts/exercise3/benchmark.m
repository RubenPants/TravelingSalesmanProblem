%{
benchmark.m

Test each of the possible combinations for each of the provided
test-samples.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global NIND MAXGEN ELITIST PR_CROSS PR_MUT LOCALLOOP
NIND=128;                   % Number of individuals
MAXGEN=100;                 % Maximum no. of generations
ELITIST=0.05;               % percentage of the elite population
LOCALLOOP=0;                % local loop removal
PR_CROSS=.2;                % probability of crossover
PR_MUT=.4;                  % probability of mutation

% Custom parameters
AVG_COUNT=10;               % No. of times the same configuration is played
NCITIES=40;                 % No. of cities
STEPS=20;                   % 1/STEPS=STEP_SIZE (mutation, crossover)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template'

% Load all the datasets
data = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];

% Possible representations
REPRESENTATION = ["adjacency", "path"];

% Possible crossover operators
CROSSOVER = ["xalt_edges", "order", "sequential_constructive"];

% Possible mutation operators
MUTATION = ["reciprocal_exchange", "inversion"];

% Run for all the possibilities, this may take a while
for repr=REPRESENTATION
    for cross=CROSSOVER
        for mut=MUTATION
            total = zeros(1,11);
            for i=1:11
                total(i) = run_data(data(i), repr, cross, mut);
            end
            summed_time = sum(total);
            fprintf("%s - %s - %s - time (s): %f \n", repr, cross, mut, summed_time);
        end
    end
end

function time = run_data(set, repr, cross, mut)
    global NIND MAXGEN ELITIST PR_CROSS PR_MUT LOCALLOOP
    % Run the given configuration on the requested dataset
    data = load(sprintf('rondrit%s.tsp', set));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    time = run_ga_ex3(x, y, NIND, MAXGEN, ELITIST, PR_CROSS, PR_MUT, repr, cross, mut, LOCALLOOP);
end
