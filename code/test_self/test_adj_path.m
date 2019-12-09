addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'

% Run the tests
test_path2adj()

function test_path2adj()
    % Init tests
    p = zeros(2,3);
    p(1,:) = [1,2,3];
    p(2,:) = [3,2,1];
    
    % Do transformation
    a = path2adj(p);
    
    % Run asserts
    r = zeros(2,3);
    isequal(a(1,:), [2,3,1]);
    isequal(a(2,:), [3,1,2]);
    fprintf("Test '%s' succeeded!\n", "test_path2adj")
end