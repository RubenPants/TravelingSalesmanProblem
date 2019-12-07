%{
exercise1_population_size.m

Visualize the impact that the population size has on finding the shortest
path. In this experiment, crossover and mutation rates are fixed at 0.05
and 0.4 respectively.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PRECI=1;                    % Precision of variables
ELITIST=0.05;               % percentage of the elite population
GGAP=1-ELITIST;             % Generation gap
STOP_PERCENTAGE=.95;        % percentage of equal fitness individuals for stopping
LOCALLOOP=0;                % local loop removal
CROSSOVER='xalt_edges';     % default crossover operator

% Custom parameters
AVG_COUNT=10;               % No. of times the same configuration is played
CALCULATE_NEW=1;            % Calculate a new Avg array (time consuming)
NCITIES=40;                 % No. of cities
STEPS=20;                   % 1/STEPS=STEP_SIZE (mutation, crossover)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dataset: Create circular city dataset
x = (cos((0:NCITIES-1) * 2 * pi / NCITIES) + 1)/2;
x = x(:);  % Transform to column vector
y = (sin((0:NCITIES-1) * 2 * pi / NCITIES) + 1)/2;
y = y(:);  % Transform to column vector

% Visualize cities
%{
figure(1);
scatter(x,y)
%}

% Run for all the possibilities, this may take a while
if CALCULATE_NEW == 1
    Avg = zeros(STEPS+1, 1);
    for size=[16, 32, 128, 256, 512, 1024]
        tic
        total = zeros(1,AVG_COUNT);
        fprintf("%d - ", size);
        for i = 1:AVG_COUNT
            total(i) = run_ga_thr(x, y, size, NCITIES, ELITIST, STOP_PERCENTAGE, 0.0, 0.40, CROSSOVER, LOCALLOOP, 3.14);
            fprintf("#");
        end
        fprintf("\n --> Size: %d - Time (s): %f - Number of generations needed: %d \n", size, toc, mean(total));
    end

    % Save the array as a text file
    save('exercise1_matrix.txt', 'Avg');
end

%{
Crossover=0.05, Mutation:0.40

16 - ##########
 --> Size: 16 - Time (s): 2.102279 - Number of generations needed: 7.343000e+02 
32 - ##########
 --> Size: 32 - Time (s): 2.250948 - Number of generations needed: 5.248000e+02 
128 - ##########
 --> Size: 128 - Time (s): 4.420304 - Number of generations needed: 2.913000e+02 
256 - ##########
 --> Size: 256 - Time (s): 6.736575 - Number of generations needed: 2.164000e+02 
512 - ##########
 --> Size: 512 - Time (s): 21.189499 - Number of generations needed: 1.992000e+02 
1024 - ##########
 --> Size: 1024 - Time (s): 60.501540 - Number of generations needed: 1.719000e+02 
%}

%{
Crossover=0.20, Mutation:0.40

16 - ##########
 --> Size: 16 - Time (s): 3.069060 - Number of generations needed: 8.666000e+02 
32 - ##########
 --> Size: 32 - Time (s): 3.800148 - Number of generations needed: 6.198000e+02 
128 - ##########
 --> Size: 128 - Time (s): 7.021100 - Number of generations needed: 3.156000e+02 
256 - ##########
 --> Size: 256 - Time (s): 11.108763 - Number of generations needed: 2.409000e+02 
512 - ##########
 --> Size: 512 - Time (s): 28.547403 - Number of generations needed: 2.052000e+02 
1024 - ##########
 --> Size: 1024 - Time (s): 76.666797 - Number of generations needed: 1.825000e+02 
%}

%{
Crossover=0.20, Mutation:0.40

16 - ##########
 --> Size: 16 - Time (s): 2.110742 - Number of generations needed: 8.243000e+02 
32 - ##########
 --> Size: 32 - Time (s): 2.070218 - Number of generations needed: 5.497000e+02 
128 - ##########
 --> Size: 128 - Time (s): 3.571978 - Number of generations needed: 2.701000e+02 
256 - ##########
 --> Size: 256 - Time (s): 6.005493 - Number of generations needed: 235 
512 - ##########
 --> Size: 512 - Time (s): 19.928341 - Number of generations needed: 2.062000e+02 
1024 - ##########
 --> Size: 1024 - Time (s): 63.292165 - Number of generations needed: 1.877000e+02 
%}

%{
NCITIES - Shortest distance
     20 - 3.1287
     40 - 3.1384
%}
