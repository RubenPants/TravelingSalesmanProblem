
NUMBER_OF_TESTS=100;


% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load('rondrit127.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
dataWithBoth = containers.Map;
    dataWithBoth("x") = x;
    dataWithBoth("y") = y;
    dataWithBoth("heu_localMUT")=0.2;
    dataWithBoth("heu_threefour")=1;
    dataWithBoth("maxgen")= 700;
%  dataWithThreeFour = containers.Map;
%     dataWithThreeFour("x") = x;
%     dataWithThreeFour("y") = y;
%     dataWithThreeFour("heu_threefour")=1;   
%   dataWithLocalMut = containers.Map;
%     dataWithLocalMut("x") = x;
%     dataWithLocalMut("y") = y;
%     dataWithLocalMut("heu_localMUT")=0.2; 
  dataWithNoHeur = containers.Map;
    dataWithNoHeur("x") = x;
    dataWithNoHeur("y") = y;
    dataWithNoHeur("maxgen") = 700;
wait = waitbar(0,'Please wait for senpai to notice me...');
resultWithout = run_ga(dataWithNoHeur);
resultWith = run_ga(dataWithBoth);
withoutBest = resultWithout('best');
withBest = resultWith('best');
withoutMean = resultWithout('mean_fits');
withMean = resultWith('mean_fits');
withoutWorst = resultWithout('worst');
withWorst = resultWith('worst');

for i=1:NUMBER_OF_TESTS-1
resultWithout = run_ga(dataWithNoHeur);
resultWith = run_ga(dataWithBoth);
withoutBest = withoutBest+ resultWithout('best');
withBest = withBest+resultWith('best');
withoutMean = withoutMean+resultWithout('mean_fits');
withMean =withMean+resultWith('mean_fits');
withoutWorst =withoutWorst+ resultWithout('worst');
withWorst =withWorst+ resultWith('worst');
waitbar(i/NUMBER_OF_TESTS);
end
close(wait);
disp("FINAL HEURISTICS")
x_values =0:699;
withBest = withBest/NUMBER_OF_TESTS;
withoutBest = withoutBest/NUMBER_OF_TESTS;

withWorst = withWorst/NUMBER_OF_TESTS;
withoutWorst = withoutWorst/NUMBER_OF_TESTS;
withMean = withMean/NUMBER_OF_TESTS;
withoutMean = withoutMean/NUMBER_OF_TESTS;


plot(x_values,withoutBest,'g--',x_values,withBest,'g',x_values,withoutMean,'b--',x_values,withMean,'b',x_values,withoutWorst,'m--',x_values,withWorst,'m')
    