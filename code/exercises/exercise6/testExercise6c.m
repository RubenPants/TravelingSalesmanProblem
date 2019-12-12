
NUMBER_OF_TESTS=100;


% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load('rondrit016.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
dataWithoutCrowding= containers.Map;
    dataWithoutCrowding("x") = x;
    dataWithoutCrowding("y") = y;
    %dataWithoutCrowding("maxgen") = 500;
    
dataWithCrowding = containers.Map;
    dataWithCrowding("x") = x;
    dataWithCrowding("y") = y;
    %dataWithCrowding("maxgen") = 500;
    dataWithCrowding("crowding") = 1;


wait = waitbar(0,'Please wait for senpai to notice me...');
resultWithout= run_ga(dataWithoutCrowding);
resultCrowding = run_ga(dataWithCrowding);

withoutBest = resultWithout('best');
withoutMean = resultWithout('mean_fits');
withoutWorst = resultWithout('worst');

crowdingBest = resultCrowding('best');
crowdingMean = resultCrowding('mean_fits');
crowdingWorst = resultCrowding('worst');

for i=1:NUMBER_OF_TESTS-1
resultWithout= run_ga(dataWithoutCrowding);
resultCrowding = run_ga(dataWithCrowding);

withoutBest =withoutBest+ resultWithout('best');
withoutMean =withoutMean+ resultWithout('mean_fits');
withoutWorst =withoutWorst+ resultWithout('worst');

crowdingBest =crowdingBest+ resultCrowding('best');
crowdingMean =crowdingMean+ resultCrowding('mean_fits');
crowdingWorst =crowdingWorst+ resultCrowding('worst');


waitbar(i/NUMBER_OF_TESTS);
end
close(wait);
disp("FINAL HEURISTICS")
x_values =0:99;
withoutBest = withoutBest/NUMBER_OF_TESTS;
withoutMean = withoutMean/NUMBER_OF_TESTS;
withoutWorst = withoutWorst/NUMBER_OF_TESTS;
crowdingBest = crowdingBest/NUMBER_OF_TESTS;
crowdingMean = crowdingMean/NUMBER_OF_TESTS;
crowdingWorst = crowdingWorst/NUMBER_OF_TESTS;

plot(x_values,crowdingBest,'r',x_values,withoutBest,'r:',x_values,crowdingMean,'b',x_values,withoutMean,'b:',x_values,crowdingWorst,'g',x_values,withoutWorst,'g:')
    