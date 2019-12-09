%{
population_size.m

Visualize the impact that the population size has on finding the shortest
path. In this experiment, crossover and mutation rates are fixed at 0.05
and 0.4 respectively.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AVG_COUNT=10;               % No. of times the same configuration is played
NCITIES=40;                 % No. of cities
STEPS=20;                   % 1/STEPS=STEP_SIZE (mutation, crossover)
OPTIMUM = 3.14;             % Optimum used as stopping criterium
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Dataset: Create circular city dataset
data = load(sprintf('circle%s.tsp', "040"));
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);

% Init data-container
data = containers.Map;
data("x") = x;
data("y") = y;
data("loop_detect") = 1;
data("maxgen") = Inf;
data("stop_perc") = false;
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

12 - ##########
 --> Size: 12 - Time (s): 0.525398 - Number of generations needed: 1.677600e+03 
16 - ##########
 --> Size: 16 - Time (s): 0.481610 - Number of generations needed: 1.331100e+03 
24 - ##########
 --> Size: 24 - Time (s): 0.400355 - Number of generations needed: 9.001000e+02 
32 - ##########
 --> Size: 32 - Time (s): 0.380442 - Number of generations needed: 6.716000e+02 
48 - ##########
 --> Size: 48 - Time (s): 0.376873 - Number of generations needed: 4.587000e+02 
64 - ##########
 --> Size: 64 - Time (s): 0.490047 - Number of generations needed: 4.543000e+02 
96 - ##########
 --> Size: 96 - Time (s): 0.496742 - Number of generations needed: 3.124000e+02 
128 - ##########
 --> Size: 128 - Time (s): 0.597052 - Number of generations needed: 2.877000e+02 
192 - ##########
 --> Size: 192 - Time (s): 0.757569 - Number of generations needed: 2.419000e+02 
256 - ##########
 --> Size: 256 - Time (s): 0.997740 - Number of generations needed: 2.324000e+02 
384 - ##########
 --> Size: 384 - Time (s): 2.084731 - Number of generations needed: 223 
512 - ##########
 --> Size: 512 - Time (s): 2.853927 - Number of generations needed: 1.908000e+02
%}

%{
Crossover=0.05, Mutation:0.40, with loop-detection

12 - ##########
 --> Size: 12 - Time (s): 0.151733 - Number of generations needed: 3.355000e+02 
16 - ##########
 --> Size: 16 - Time (s): 0.137894 - Number of generations needed: 3.144000e+02 
24 - ##########
 --> Size: 24 - Time (s): 0.095764 - Number of generations needed: 1.578000e+02 
32 - ##########
 --> Size: 32 - Time (s): 0.090560 - Number of generations needed: 121 
48 - ##########
 --> Size: 48 - Time (s): 0.121682 - Number of generations needed: 1.106000e+02 
64 - ##########
 --> Size: 64 - Time (s): 0.097889 - Number of generations needed: 6.880000e+01 
96 - ##########
 --> Size: 96 - Time (s): 0.132787 - Number of generations needed: 6.310000e+01 
128 - ##########
 --> Size: 128 - Time (s): 0.121203 - Number of generations needed: 4.260000e+01 
192 - ##########
 --> Size: 192 - Time (s): 0.182640 - Number of generations needed: 4.120000e+01 
256 - ##########
 --> Size: 256 - Time (s): 0.229852 - Number of generations needed: 3.830000e+01 
384 - ##########
 --> Size: 384 - Time (s): 0.402733 - Number of generations needed: 33 
512 - ##########
 --> Size: 512 - Time (s): 0.597869 - Number of generations needed: 3.260000e+01 
%}
