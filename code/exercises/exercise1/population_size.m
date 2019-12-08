%{
population_size.m

Visualize the impact that the population size has on finding the shortest
path. In this experiment, crossover and mutation rates are fixed at 0.05
and 0.4 respectively.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ELITIST=0.05;               % percentage of the elite population
STOP_PERCENTAGE=.95;        % percentage of equal fitness individuals for stopping
REPR = "adjacency";         % Chosen representation (genome)
CROSSOVER = 'xalt_edges';   % default crossover operator
PR_CROSS=.05;               % probability of crossover
MUTATION = 'inversion';     % default mutation operator
PR_MUT=.40;                 % probability of mutation
LOCALLOOP=0;                % local loop removal

% Custom parameters
AVG_COUNT=20;               % No. of times the same configuration is played
NCITIES=40;                 % No. of cities
STEPS=20;                   % 1/STEPS=STEP_SIZE (mutation, crossover)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TSP_GA\code'

% Dataset: Create circular city dataset
x = (cos((0:NCITIES-1) * 2 * pi / NCITIES) + 1)/2;
x = x(:);  % Transform to column vector
y = (sin((0:NCITIES-1) * 2 * pi / NCITIES) + 1)/2;
y = y(:);  % Transform to column vector

% Define the optimum (used as stopping criterium)
OPTIMUM = 3.14;

% Init data-container
data = containers.Map;
data("x") = x;
data("y") = y;
data("maxgen") = Inf;
data("elite") = ELITIST;
data("repr") = REPR;
data("crossover") = CROSSOVER;
data("pr_cross") = PR_CROSS;
data("mutation") = MUTATION;
data("pr_mut") = PR_MUT;
data("loop_detect") = LOCALLOOP;
data("stop_perc") = STOP_PERCENTAGE;
data("stop_thr") = OPTIMUM;

% Run for all the possibilities, this may take a while
Avg = zeros(STEPS+1, 1);
for size=[12, 16, 24, 32, 48, 64, 96, 128, 192, 256, 384, 512]
    tic
    total = zeros(1,AVG_COUNT);
    fprintf("%d - ", size);
    for i = 1:AVG_COUNT
        data("nind") = size;
        container = run_ga(data);
        total(i) = container('generation');
        fprintf("#");
    end
    fprintf("\n --> Size: %d - Time (s): %f - Number of generations needed: %d \n", size, toc/AVG_COUNT, mean(total));
end

%{
Crossover=0.05, Mutation:0.40, no loop-detection

12 - ####################
 --> Size: 12 - Time (s): 0.266623 - Number of generations needed: 1.149500e+03 
16 - ####################
 --> Size: 16 - Time (s): 0.226572 - Number of generations needed: 8.333000e+02 
24 - ####################
 --> Size: 24 - Time (s): 0.222415 - Number of generations needed: 6.396000e+02 
32 - ####################
 --> Size: 32 - Time (s): 0.215578 - Number of generations needed: 5.107000e+02 
48 - ####################
 --> Size: 48 - Time (s): 0.275935 - Number of generations needed: 4.693500e+02 
64 - ####################
 --> Size: 64 - Time (s): 0.275879 - Number of generations needed: 3.522500e+02 
96 - ####################
 --> Size: 96 - Time (s): 0.337878 - Number of generations needed: 3.106500e+02 
128 - ####################
 --> Size: 128 - Time (s): 0.387839 - Number of generations needed: 2.732500e+02 
192 - ####################
 --> Size: 192 - Time (s): 0.543884 - Number of generations needed: 2.539000e+02 
256 - ####################
 --> Size: 256 - Time (s): 0.668059 - Number of generations needed: 2.354500e+02 
384 - ####################
 --> Size: 384 - Time (s): 1.407828 - Number of generations needed: 2.118000e+02 
512 - ####################
 --> Size: 512 - Time (s): 1.980649 - Number of generations needed: 1.928000e+02 
%}

%{
Crossover=0.05, Mutation:0.40, with loop-detection

12 - ####################
 --> Size: 12 - Time (s): 0.072884 - Number of generations needed: 2.106500e+02 
16 - ####################
 --> Size: 16 - Time (s): 0.063272 - Number of generations needed: 1.846500e+02 
24 - ####################
 --> Size: 24 - Time (s): 0.051015 - Number of generations needed: 1.133500e+02 
32 - ####################
 --> Size: 32 - Time (s): 0.056286 - Number of generations needed: 106 
48 - ####################
 --> Size: 48 - Time (s): 0.053607 - Number of generations needed: 7.175000e+01 
64 - ####################
 --> Size: 64 - Time (s): 0.072027 - Number of generations needed: 6.410000e+01 
96 - ####################
 --> Size: 96 - Time (s): 0.093991 - Number of generations needed: 6.130000e+01 
128 - ####################
 --> Size: 128 - Time (s): 0.097220 - Number of generations needed: 4.965000e+01 
192 - ####################
 --> Size: 192 - Time (s): 0.138085 - Number of generations needed: 4.440000e+01 
256 - ####################
 --> Size: 256 - Time (s): 0.170744 - Number of generations needed: 4.195000e+01 
384 - ####################
 --> Size: 384 - Time (s): 0.341448 - Number of generations needed: 3.920000e+01 
512 - ####################
 --> Size: 512 - Time (s): 0.464260 - Number of generations needed: 3.525000e+01
%}

%{
NCITIES - Shortest distance
     20 - 3.1287
     40 - 3.1384
%}
