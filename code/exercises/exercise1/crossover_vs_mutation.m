%{
crossover_vs_mutation.m

Visualize the impact the mutation and crossover rates have on the total
minimum distance in a three dimensional graph.

If you only want to view the latest created graph, then make sure to set
CALCULATE_NEW to zero! Otherwise, the whole computation (run_ga) will
happen again, which is very time-consuming.
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AVG_COUNT=10;               % No. of times the same configuration is played
CALCULATE_NEW=false;        % Calculate a new Avg array (time consuming)
NCITIES=40;                 % No. of cities
STEPS=20;                   % 1/STEPS = STEP_SIZE (mutation, crossover)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

% Parameters
matrix_name = "crossover_vs_mutation_matrix.txt";

data = load(sprintf('circle%s.tsp', "040"));
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);

% Init data-container
data = containers.Map;
data("x") = x;
data("y") = y;
data("stop_perc") = false;

% Run for all the possibilities, this may take a while
if CALCULATE_NEW
    Avg = zeros(STEPS+1);
    for m = 0:STEPS 
        for c = 0:STEPS
            fprintf("%.3f percent done\n", (m*STEPS + c)/(STEPS^2+STEPS));
            total = zeros(1,AVG_COUNT);
            for i = 1:AVG_COUNT
                data("pr_cross") = c/STEPS;
                data("pr_mut") = m/STEPS;
                container = run_ga(data);
                total(i) = container('minimum');
            end
            Avg(m+1, c+1) = geomean(total);
        end
    end

    % Save the array as a text file
    save(matrix_name, 'Avg');
end

% Load the saved file
file = matfile(matrix_name);
Avg = file.Avg;

% Plot the result
figure(2);
s = size(Avg);
[X,Y] = meshgrid(0:1.0/(s(1)-1):1, 0:1.0/(s(2)-1):1);
surf(X,Y,Avg)
ylabel("Mutation")
xlabel("Crossover")
colorbar
savefig("crossover_vs_mutation.fig")

