
% Add paths to other files
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code'
addpath 'C:\Users\Ruben\Documents\Projects\TravelingSalesmanProblem\code\datasets'

p = zeros(2,3);
p(1,:) = [1,2,3];
p(2,:) = [3,2,1];

disp(p)

disp("---------------------------")

a = zeros(size(p));
for r=1:size(p,1)
    a(r,:) = path2adj(p(r,:));
end
disp(a)

disp("---------------------------")

p2 = zeros(size(a));
for r=1:size(a,1)
    p2(r,:) = adj2path(a(r,:));
end
disp(p2)


disp("###########################")
disp(p)
disp("---------------------------")
disp(path2adj(p))
disp("---------------------------")
disp(adj2path(path2adj(p)))
disp("---------------------------")




%{
% Load all the datasets
data = ["016", "018", "023", "025", "048", "050", "051", "067", "070", "100", "127"];

for d=data
    data = load(sprintf('rondrit%s.tsp', d));
    x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
    data = containers.Map;
    data("x") = x;
    data("y") = y;
    data("nind") = 128;
    data("maxgen") = 2000;
    data("pr_cross") = 0.05;
    data("pr_mut") = 0.4;
    data("loop_detect") = true;
    c = run_ga(data);
    fprintf("%s - minimum: %f - generation: %f\n", d, c("minimum"), c("generation"))
end
%}