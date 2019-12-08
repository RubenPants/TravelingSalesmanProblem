%{
run_ga_path.m

A variation of run_ga that uses the path-representation and also doesn't
use visualizations (same as in run_ga_no_h).
%}

function min_obj = run_ga_ex3(x, y, NIND, MAXGEN, ELITIST, PR_CROSS, PR_MUT, REPR, CROSSOVER, MUTATION, LOOP)
% x, y: coordinates of the cities
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% REPR: chosen representation
% CROSSOVER: the crossover operator (xalt_edges)
% MUTATION: the mutation operator (reciprocal_exchange, inversion)
% LOOP: Enables loop-detection
    
    NVAR = size(x,1);  % Number of cities
    GGAP = 1 - ELITIST;
    mean_fits=zeros(1,MAXGEN+1);
    worst=zeros(1,MAXGEN+1);
    Dist=zeros(NVAR,NVAR);
    for i=1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end

    % initialize population
    Chrom=zeros(NIND,NVAR);
    for row=1:NIND
        if REPR=="adjacency"
            Chrom(row,:)=path2adj(randperm(NVAR));  % Adjacency-representation
            ObjV = tspfun(Chrom,Dist);
        elseif REPR=="path"
            Chrom(row,:)=randperm(NVAR);  % Path-representation
            ObjV = tspfun_path(Chrom,Dist);
        else
            disp("Invalid representation")
            ME = MException("Invalid representation chosen: %s", REPR);
            throw(ME)
        end
    end
    gen=0;
    
    
    best=zeros(1,MAXGEN);

    % generational loop
    while gen < MAXGEN
        best(gen+1)=min(ObjV);
        minimum=best(gen+1);
        mean_fits(gen+1)=mean(ObjV);
        worst(gen+1)=max(ObjV);
        
               
        for t=1:size(ObjV,1)
            if (ObjV(t)==minimum)
                break;
            end
        end
        
             

        %assign fitness values to entire population
        FitnV=ranking(ObjV);

        %select individuals for breeding
        SelCh=select('sus', Chrom, FitnV, GGAP);

        %recombine individuals (crossover)
        SelCh = recombin(CROSSOVER, SelCh, PR_CROSS);
        
        % Mutation
        SelCh=mutateTSP(MUTATION, SelCh, PR_MUT);

        %evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh,Dist);

        %reinsert offspring into population
        [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
        Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOOP,Dist);

        %increment generation counter
        gen=gen+1;            
    end
    
    % Create return value
    min_obj = min(ObjV);
end
