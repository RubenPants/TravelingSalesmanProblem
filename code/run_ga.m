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
%   pr_mut:                 probability for mutation [def=0.4]
%   loop_detect:            loop-detection [def=0]
%   stop_perc:              percentage of equal fitness (stop criterium) [def=0.9]
%   stop_thr:               threshold under which the algorithm stops if reached by minimum [def=0]
%   stop_gen_incr:          stop when less than delta increase over timespan of N generations [def=0]              
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
if any(strcmp(keys(data), "pr_cross")); PR_CROSS=data("pr_cross"); else; PR_CROSS=0.1; end
if any(strcmp(keys(data), "mutation")); MUTATION=data("mutation"); else; MUTATION='inversion'; end
if any(strcmp(keys(data), "pr_mut")); PR_MUT=data("pr_mut"); else; PR_MUT=0.4; end
if any(strcmp(keys(data), "loop_detect")); LOCALLOOP=data("loop_detect"); else; LOCALLOOP=0; end
if any(strcmp(keys(data), "stop_perc")); STOP_PERC = data('stop_perc'); else; STOP_PERC = 0; end
if any(strcmp(keys(data), "stop_thr")); STOP_THR = data('stop_thr'); else; STOP_THR = 0; end
if any(strcmp(keys(data), "stop_stagnation")); STOP_STAG = data('stop_stagnation'); else; STOP_STAG = 0; end
if any(strcmp(keys(data), "print")); PRINT = data('print'); else; PRINT= false; end
if any(strcmp(keys(data), "preserve_diveristy")); PRESERVE_DIVERSITY = data('preserve_diversity'); else; PRESERVE_DIVERSITY = "off"; end
if any(strcmp(keys(data), "adaptive_mut")); ADAPTIVE_MUT = data('adaptive_mut'); else; ADAPTIVE_MUT = false; end
if any(strcmp(keys(data), "visual")); VISUAL = true; else; VISUAL = false; end
if any(strcmp(keys(data), "parent_selection")); PARENT_SELECTION = data("parent_selection"); else; PARENT_SELECTION = "ranking"; end
if any(strcmp(keys(data), "survivor_selection")); SURVIVOR_SELECTION = data("survivor_selection"); else; SURVIVOR_SELECTION = "elitism"; end
if any(strcmp(keys(data), "local_heur")); HEUR = data("local_heur"); else; HEUR = "off"; end
if any(strcmp(keys(data), "local_heur_pr")); HEUR_PR = data("local_heur_pr"); else; HEUR_PR = 0.2; end
if VISUAL
    temp = data("visual");
    ah1 = temp("ah1");
    ah2 = temp("ah2");
    ah3 = temp("ah3");
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
    fprintf("\tHeuristic: %s\n", HEUR)
    fprintf("\tParent selection: %s\n", PARENT_SELECTION)
    fprintf("\tSurvivor selection: %s\n", SURVIVOR_SELECTION)
    fprintf("\tAdaptive mutation: %d\n", ADAPTIVE_MUT)
    fprintf("\tPreserve diveristy: %s\n", PRESERVE_DIVERSITY)
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

    % Visualize progress
    if VISUAL
        if REPR_ID == 1
            visualizeTSP(x,y,adj2path(Chrom(t,:)), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        else
            visualizeTSP(x,y,Chrom(t,:), minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);
        end
    end

    % Stop criteria if X% of candidates equal to minimum 
    if STOP_PERC && (sObjV(stopN)-sObjV(1) <= 1e-15)
        break;
    end
    
    % Stopping criteria based on threshold
    if STOP_THR && minimum <= STOP_THR
        break;
    end 
    
    % Stopping criteria based on generational improvement
    if STOP_STAG && (gen >= STOP_STAG) && (best(gen+1) == best(gen+1-STOP_STAG))
        break    
    end

    % Parent selection
    ParentSelCh = parent_selection(ObjV,Chrom,GGAP,NIND,PARENT_SELECTION);
    ChildSelCh = ParentSelCh;
    
    if ADAPTIVE_MUT
        ChildSelCh = mutateAdaptiveTSP(MUTATION, ChildSelCh, PR_MUT, REPR_ID); 
    end

    %recombine individuals (crossover)
    ChildSelCh = recombin(CROSSOVER, ChildSelCh, REPR_ID, Dist, PR_CROSS); 
    
    % Mutation
    ChildSelCh=mutateTSP(MUTATION, ChildSelCh, PR_MUT, REPR_ID);  
    
    %Local heuristics
    if HEUR ~= "off"
        ChildSelCh = local_heuristic(HEUR, ChildSelCh, Dist, REPR_ID, HEUR_PR);
    end

    % Evaluate offspring, call objective function
    ObjVSelChildren = tspfun(ChildSelCh, Dist, REPR_ID);

    % Keeping diversity -> crowding
    if PRESERVE_DIVERSITY ~= "off"
        ObjVSelParents = tspfun(ParentSelCh, Dist, REPR_ID);
        % TODO: Sieben
        % if PRESERVE_DIVERSITY == "crowding"
        % if PRESERVE_DIVERSITY == "islands"
        ChildSelCh = rts(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren,REPR_ID);
        
        % Evaluate offspring after crowding, call objective function
        ObjVSelChildren = tspfun(ChildSelCh, Dist, REPR_ID);
    end
   
    % Reinsert offspring into population
    [Chrom,ObjV] = survivor_selection(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SURVIVOR_SELECTION);
    
    %Improve the population by removing loops etc
    Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom, LOCALLOOP, Dist, REPR_ID);
    
    % Increment generation counter
    gen=gen+1;            
end

% Create the output-container
output = containers.Map;
output('minimum') = minimum;
output('generation') = gen;
output('best') = best;
output('worst') = worst;
output('mean_fits') = mean_fits;
