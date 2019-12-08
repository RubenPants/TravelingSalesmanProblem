%{
test.m

Test the newly implemented functions.
%}

% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\template\custom_scripts'

% Run tests
test_path_representation()

function test_path_representation()
    % Simple graph
    x = [0, 0.5, 1, 0.5];
    y = [0.5, 1, 0.5, 0];
    Dist=zeros(4,4);
    for i=1:size(x,2)
        for j=1:size(y,2)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    
    % Setup chromosomes
    Chrom=zeros(2,4);
    Chrom(1,:) = [1,2,3,4]; % Smallest path = 4*sqrt(2*0.5^2)
    Chrom(2,:) = [1,3,2,4]; % Longest path = 2+2*sqrt(2*0.5^2)
    
    % Get distance vector
    ObjVal = tspfun_path(Chrom, Dist);
    assert(ObjVal(1) == 4*sqrt(2*0.5^2))
    assert(ObjVal(2) == 2+2*sqrt(2*0.5^2))
    disp("Test path-representation finished succesfully!");
    
end
    