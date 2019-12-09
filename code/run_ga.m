%{
run_ga.m

This method will run the genetic algorithm for the given configuration.
Updates will be visualized by the h* figures. Note that to do so, the
figures must be created first (see tspgui).
%}

function output = run_ga(data)
% usage: run_ga(data)
%
% data-container can consist of (keys):
%   x, y:                   [MUST] coordinates of the cities
%   nind:                   number of individuals [def=64]
%   maxgen:                 maximal number of generations [def=100]
%   elite:                  percentage of elite population [def=0.05]
%   repr:                   chosen genome representation [def='adjacency']
%   crossover:              crossover opertor [def='xalt_edges']
%   pr_cross:               probability for crossover [def=0.2]
%   mutation:               mutation operator [def='inversion']
%   pr_mut:                 probability for mutation [def=0.2]
%   loop_detect:            loop-detection [def=0]
%   stopping_criteria:
%       perc:               percentage of equal fitness (stop criterium) [def=0.9]
%       thr:                threshold under which the algorithm stops if reached by minimum [def=0]
%   visual:
%       ah1:                graph visualization
%       ah2:                minimum, mean, and maximum visualization
%       ah3:                population-fitness overview
%   heuristics:
%       threefour:
%       localmut:

% Parse data from data-container
if ~any(strcmp(keys(data), "x")) && ~any(strcmp(keys(data), "y"))
    ME = MException("Coordinates must be given");
    throw(ME)
else
    x = data("x");
    y = data("y");
end
if any(strcmp(keys(data), "nind")); NIND=data("nind"); else; NIND=128; end
if any(strcmp(keys(data), "maxgen")); MAXGEN=data("maxgen"); else; MAXGEN=100; end
if any(strcmp(keys(data), "elite")); ELITIST=data("elite"); else; ELITIST=0.05; end
if any(strcmp(keys(data), "representation")); REPR=data("representation"); else; REPR='adjacency'; end
if any(strcmp(keys(data), "crossover")); CROSSOVER=data("crossover"); else; CROSSOVER="xalt_edges"; end
if any(strcmp(keys(data), "pr_cross")); PR_CROSS=data("pr_cross"); else; PR_CROSS=0.2; end
if any(strcmp(keys(data), "mutation")); MUTATION=data("mutation"); else; MUTATION='inversion'; end
if any(strcmp(keys(data), "pr_mut")); PR_MUT=data("pr_mut"); else; PR_MUT=0.4; end
if any(strcmp(keys(data), "loop_detect")); LOCALLOOP=data("loop_detect"); else; LOCALLOOP=0; end
if any(strcmp(keys(data), "stop_perc")); STOP_PERC = data('stop_perc'); else; STOP_PERC = 0.9; end
if any(strcmp(keys(data), "stop_thr")); STOP_THR = data('stop_thr'); else; STOP_THR = 0; end
if any(strcmp(keys(data), "stop_gen_incr")); STOP_GEN_INCR = data('stop_gen_incr'); else; STOP_GEN_INCR = 0; end
if any(strcmp(keys(data), "print")); PRINT = true; else; PRINT= false; end
if any(strcmp(keys(data), "visual")); VISUAL = true; else; VISUAL = false; end
if any(strcmp(keys(data), "heu_threefour")); THREEFOUR = true; else; THREEFOUR = false; end
if any(strcmp(keys(data), "heu_localMUT")); LOCALMUT = data("heu_localMut"); else; LOCALMUT = 0; end
if VISUAL
    temp = data("visual");
    ah1 = temp("ah1");
    ah2 = temp("ah2");
    ah3 = temp("ah3");
    if MAXGEN == Inf; MAXGEN = 9999; end
end

% Fill in other used parameters
NVAR = size(x,1);
if REPR == "adjacency"
    REPR_ID = 1;
else
    REPR_ID = 2;
end

% Print out GA configuration (only for tspgui)
if VISUAL || PRINT
    fprintf("Current configuration:\n")
    fprintf("\tNumber of individuals: %d\n", NIND)
    fprintf("\tMaximum generations: %d\n", MAXGEN)
    fprintf("\tNumber of cities: %d\n", NVAR)
    fprintf("\tElitist percentage: %.2f\n", ELITIST)
    fprintf("\tChosen representation: %s (ID: %d)\n", REPR, REPR_ID)
    fprintf("\tCrossover operator: %s - with percentage %.2f\n", CROSSOVER, PR_CROSS)
    fprintf("\tMutation operator: %s - with percentage %.2f\n", MUTATION, PR_MUT)
    fprintf("\tLoop-detection enabled: %d\n", LOCALLOOP)
    fprintf("\tStop percentage: %.2f\n", STOP_PERC)
    fprintf("\tStop threshold: %.2f\n", STOP_THR)
end

% Initialize the algorithm
GGAP = 1 - ELITIST;
mean_fits = zeros(1,0);
worst = zeros(1,0);
best = zeros(1, 0);

Dist=zeros(NVAR,NVAR);
for i=1:size(x,1)
    for j=1:size(y,1)
        Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
    end
end

% initialize population
Chrom=zeros(NIND,NVAR);
for row=1:NIND
    if REPR_ID == 1  % Adjacency
        Chrom(row,:)=path2adj(randperm(NVAR));
    else  % Path
        Chrom(row,:)=randperm(NVAR);
    end
end

% number of individuals of equal fitness needed to stop
if STOP_PERC
    stopN=ceil(STOP_PERC*NIND);
end

% evaluate initial population
ObjV = tspfun(Chrom, Dist, REPR_ID);

% generational loop
gen=0;
while gen < MAXGEN
    sObjV=sort(ObjV);
    best(gen+1)=min(ObjV);
    minimum=best(gen+1);
    mean_fits(gen+1)=mean(ObjV);
    worst(gen+1)=max(ObjV);
    
    % TODO: remove if 't' is never used
    for t=1:size(ObjV,1)
        if (ObjV(t)==minimum)
            break;
        end
    end
    
    % Stopping criteria based on threshold
    if STOP_THR && minimum <= STOP_THR
        break;
    end 
    
    % Stopping criteria based on generational improvement
    if STOP_GEN_INCR
        gen_interval, delta = STOP_GEN_INCR;
        if (gen > gen_interval) && (abs(best(gen+1) - best(gen+1-gen_interval)) < delta)
            break
        end        
    end

    % Visualize progress
    if VISUAL
        if REPR_ID == 1
            visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        else
            visualizeTSP(x,y,Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        end
    end

    % Stop criteria if 95% of candidates equal to minimum 
    if STOP_PERC && (sObjV(stopN)-sObjV(1) <= 1e-15)
          break;
    end

    %assign fitness values to entire population
    FitnV=ranking(ObjV);

    %select individuals for breeding
    SelCh=select('sus', Chrom, FitnV, GGAP);

    %recombine individuals (crossover)
    SelCh = recombin(CROSSOVER, SelCh, REPR_ID, PR_CROSS);

    % Mutation
    SelCh=mutateTSP(MUTATION, SelCh, PR_MUT, REPR_ID);

    % Evaluate offspring, call objective function
    ObjVSel = tspfun(SelCh, Dist, REPR_ID);

    % Reinsert offspring into population
    [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
    Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom, LOCALLOOP, Dist, REPR_ID);
    
    %Local heuristics
    if THREEFOUR       
        Chrom = four_vertices_three_edges(Chrom,Dist,NVAR,NIND);           
    end
    if LOCALMUT
        Chrom = single_sample_mutation(Chrom,Dist,NVAR,NIND,LOCALMUT);
    end
    
    % Increment generation counter
    gen=gen+1;            
end

% Create the output-container
output = containers.Map;
output('minimum') = minimum;
output('generation') = gen;
output('best')=best;
output('worst')=worst;
output('mean_fits')=mean_fits;
