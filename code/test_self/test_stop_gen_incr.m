addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'


% Run the tests
test_gen_incr()

function test_gen_incr()
    % Init test
    MAX_GEN = 100;
    STAGNATION = 10;
    
    % Load date
    data = load('a_simple.tsp');
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    
    % Run algorithm
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("maxgen") = MAX_GEN;
    data("stop_stagnation") = STAGNATION;
    output = run_ga(data);
    
    % Check for assert
    assert(output("generation") < MAX_GEN)
    assert(output("generation") == STAGNATION)  % Solution found in init
    fprintf("Test '%s' succeeded!\n", "test_gen_incr")
    fprintf(" --> Finished after %d generations\n", output("generation"))
end