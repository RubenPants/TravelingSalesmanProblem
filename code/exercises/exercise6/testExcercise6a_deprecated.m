
NUMBER_OF_TESTS=10;


% Add paths to other files
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code'
addpath 'D:\User\Documents\School\Genetics\TravelingSalesmanProblem\code\datasets'

data = load('rondrit016.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);
y=data(:,2)/max([data(:,1);data(:,2)]);
dataWithRanking = containers.Map;
    dataWithRanking("x") = x;
    dataWithRanking("y") = y;
    dataWithRanking("parent_selection")="ranking";
dataWithScaling = containers.Map;
    dataWithScaling("x") = x;
    dataWithScaling("y") = y;
    dataWithScaling("parent_selection") = "scaling";
dataWithTournament = containers.Map;
    dataWithTournament("x") = x;
    dataWithTournament("y") = y;
    dataWithTournament("parent_selection") = "tournament";

wait = waitbar(0,'Please wait for senpai to notice me...');
resultScaling = run_ga(dataWithScaling);
resultRanking = run_ga(dataWithRanking);
resultTournament = run_ga(dataWithTournament);

scalingBest = resultScaling('best');
scalingMean = resultScaling('mean_fits');
scalingWorst = resultScaling('worst');

rankingBest = resultRanking('best');
rankingMean = resultRanking('mean_fits');
rankingWorst = resultRanking('worst');

tournamentBest = resultTournament('best');
tournamentMean = resultTournament('mean_fits');
tournamentWorst = resultTournament('worst');

for i=1:NUMBER_OF_TESTS-1
resultScaling = run_ga(dataWithScaling);
resultRanking = run_ga(dataWithRanking);
resultTournament = run_ga(dataWithTournament);

scalingBest =scalingBest+ resultScaling('best');
scalingMean = scalingMean+resultScaling('mean_fits');
scalingWorst = scalingWorst+resultScaling('worst');

rankingBest =rankingBest+ resultRanking('best');
rankingMean = rankingMean+resultRanking('mean_fits');
rankingWorst =rankingWorst+ resultRanking('worst');

tournamentBest =tournamentBest+ resultTournament('best');
tournamentMean = tournamentMean+resultTournament('mean_fits');
tournamentWorst = tournamentWorst+resultTournament('worst');

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
tournamentBest = tournamentBest/NUMBER_OF_TESTS;
tournamentMean = tournamentMean/NUMBER_OF_TESTS;
tournamentWorst = tournamentWorst/NUMBER_OF_TESTS;



plot(x_values,tournamentBest,'r',x_values,rankingBest,'r--',x_values,scalingBest,'r:',x_values,tournamentMean,'b',x_values,rankingMean,'b--',x_values,scalingMean,'b:',x_values,tournamentWorst,'g',x_values,rankingWorst,'g--',x_values,scalingWorst,'g:')
    