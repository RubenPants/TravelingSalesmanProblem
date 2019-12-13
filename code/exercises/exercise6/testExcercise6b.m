
NUMBER_OF_TESTS=10;


% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load('rondrit016.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
dataWithElitism= containers.Map;
    dataWithElitism("x") = x;
    dataWithElitism("y") = y;
    %dataWithElitism("maxgen") = 500;
    
dataWithRoundRobin = containers.Map;
    dataWithRoundRobin("x") = x;
    dataWithRoundRobin("y") = y;
    %dataWithRoundRobin("maxgen") = 500;
    dataWithRoundRobin("survivor_selection") = "round_robin";


wait = waitbar(0,'Please wait for senpai to notice me...');
resultElitism = run_ga(dataWithElitism);
resultRoundRobin = run_ga(dataWithRoundRobin);

elitismBest = resultElitism('best');
elitismMean = resultElitism('mean_fits');
elitismWorst = resultElitism('worst');

roundRobinBest = resultRoundRobin('best');
roundRobinMean = resultRoundRobin('mean_fits');
roundRobinWorst = resultRoundRobin('worst');

for i=1:NUMBER_OF_TESTS-1
resultElitism = run_ga(dataWithElitism);
resultRoundRobin = run_ga(dataWithRoundRobin);

elitismBest =elitismBest+ resultElitism('best');
elitismMean = elitismMean+resultElitism('mean_fits');
elitismWorst = elitismWorst+resultElitism('worst');

roundRobinBest =roundRobinBest+ resultRoundRobin('best');
roundRobinMean =roundRobinMean+ resultRoundRobin('mean_fits');
roundRobinWorst = roundRobinWorst+resultRoundRobin('worst');


waitbar(i/NUMBER_OF_TESTS);
end
close(wait);
disp("FINAL HEURISTICS")
x_values =0:99;
elitismBest = elitismBest/NUMBER_OF_TESTS;
elitismMean = elitismMean/NUMBER_OF_TESTS;
elitismWorst = elitismWorst/NUMBER_OF_TESTS;
roundRobinBest = roundRobinBest/NUMBER_OF_TESTS;
roundRobinMean = roundRobinMean/NUMBER_OF_TESTS;
roundRobinWorst = roundRobinWorst/NUMBER_OF_TESTS;

plot(x_values,roundRobinBest,'r',x_values,elitismBest,'r:',x_values,roundRobinMean,'b',x_values,elitismMean,'b:',x_values,roundRobinWorst,'g',x_values,elitismWorst,'g:')
    