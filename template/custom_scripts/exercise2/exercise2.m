%{
aaa_exercise1.m

Visualize the impact the mutation and selection rates have on the total
minimum distance in a three dimensional graph.

If you only want to view the latest created graph, then make sure to set
CALCULATE_NEW to zero! Otherwise, the whole computation (run_ga) will
happen again, which is very time-consuming.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NIND=128;                   % Number of individuals
MAXGEN=100;                 % Maximum no. of generations
PRECI=1;                    % Precision of variables
ELITIST=0.05;               % percentage of the elite population
GGAP=1-ELITIST;             % Generation gap
STOP_PERCENTAGE=.95;        % percentage of equal fitness individuals for stopping
LOCALLOOP=0;                % local loop removal
CROSSOVER='xalt_edges';     % default crossover operator

% Custom parameters
AVG_COUNT=5;                % No. of times the same configuration is played
CALCULATE_NEW=0;            % Calculate a new Avg array (time consuming)
NCITIES=40;                 % No. of cities
STEPS=50;                   % 1/STEPS=STEP_SIZE (mutation, crossover)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template\custom_scripts'

% Create circular city dataset
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
    Avg = zeros(STEPS+1);
    for m = 0:STEPS  
        for c = 0:STEPS
            fprintf("%.3f percent done\n", (m*STEPS + c)/(STEPS^2+STEPS));
            total = zeros(1,AVG_COUNT);
            for i = 1:AVG_COUNT
                total(i) = ex2_run_ga(x, y, NIND, MAXGEN, NCITIES, ELITIST, STOP_PERCENTAGE, c/STEPS, m/STEPS, CROSSOVER, LOCALLOOP);
            end
            Avg(m+1, c+1) = mean(total);
        end
    end

    % Save the array as a text file
    save('aaa_exercise1_matrix.txt', 'Avg');
end

% Load the saved file
file = matfile('aaa_exercise1_matrix.txt');
Avg = file.Avg;

% Plot the result
figure(2);
s = size(Avg);
[X,Y] = meshgrid(0:1.0/(s(1)-1):1, 0:1.0/(s(2)-1):1);
surf(X,Y,Avg)
colorbar
savefig("aaa_exercise1_figure.fig")

%{
NCITIES - Shortest distance
     20 - 3.1287
     40 - 3.1384
%}