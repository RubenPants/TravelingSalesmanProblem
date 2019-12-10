addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'

% Run the tests
test_path2adj()
test_adj2path()

function test_path2adj()
    % Init tests
    p = zeros(2,3);
    p(1,:) = [1,2,3];
    p(2,:) = [3,2,1];
    
    % Do transformation
    a = path2adj(p);
    
    % Run asserts
    isequal(a(1,:), [2,3,1]);
    isequal(a(2,:), [3,1,2]);
    fprintf("Test '%s' succeeded!\n", "test_path2adj")
end

function test_adj2path()
    % Init tests
    a = zeros(2,3);
    a(1,:) = [2,3,1];
    a(2,:) = [3,1,2];
    
    % Do transformation
    p = adj2path(a);
    
    % Run asserts
    isequal(p(1,:), [1,2,3]);
    isequal(p(2,:), [1,3,2]);
    fprintf("Test '%s' succeeded!\n", "test_adj2path")
end
