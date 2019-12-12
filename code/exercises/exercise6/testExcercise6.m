
NUMBER_OF_TESTS=1;


% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load('rondrit016.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
dataWithRanking = containers.Map;
    dataWithRanking("x") = x;
    dataWithRanking("y") = y;
    dataWithRanking("selection")="ranking";
  dataWithScaling = containers.Map;
    dataWithScaling("x") = x;
    dataWithScaling("y") = y;
    dataWithScaling("selection") = "scaling";
wait = waitbar(0,'Please wait for senpai to notice me...');
resultScaling = run_ga(dataWithScaling);
resultRanking = run_ga(dataWithRanking);
scalingBest = resultScaling('best');
rankingBest = resultRanking('best');
scalingMean = resultScaling('mean_fits');
rankingMean = resultRanking('mean_fits');
scalingWorst = resultScaling('worst');
rankingWorst = resultRanking('worst');

for i=1:NUMBER_OF_TESTS-1
resultScaling = run_ga(dataWithScaling);
resultRanking = run_ga(dataWithRanking);
scalingBest =scalingBest+ resultScaling('best');
rankingBest =rankingBest+ resultRanking('best');
scalingMean = scalingMean+resultScaling('mean_fits');
rankingMean = rankingMean+resultRanking('mean_fits');
scalingWorst = scalingWorst+resultScaling('worst');
rankingWorst =rankingWorst+ resultRanking('worst');
waitbar(i/NUMBER_OF_TESTS);
end
close(wait);
disp("FINAL HEURISTICS")
x_values =0:99;
scalingBest = scalingBest/NUMBER_OF_TESTS;
scalingMean = scalingMean/NUMBER_OF_TESTS;
scalingWorst = scalingWorst/NUMBER_OF_TESTS;
rankingBest = rankingBest/NUMBER_OF_TESTS;
rankingMean = rankingMean/NUMBER_OF_TESTS;
rankingWorst = rankingWorst/NUMBER_OF_TESTS;



plot(x_values,rankingBest,'g--',x_values,scalingBest,'g',x_values,rankingMean,'b--',x_values,scalingMean,'b',x_values,rankingWorst,'m--',x_values,scalingWorst,'m')
    