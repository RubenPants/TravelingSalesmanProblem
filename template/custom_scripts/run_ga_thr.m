%{
run_ga_thr.m

A literal copy of "run_ga.m" with the main difference that now no
visualizations will be given. On the other hand, useful statistics will be
returned (which was not the case for "run_ga.m").

Furthermore, the stop-criteria will be when the given threshold THR is
exceeded (i.e. objective distance is smaller than threshold).

The number of generations needed is returned afterwards.
%}

function gen = run_ga_thr(x, y, NIND, NVAR, ELITIST, STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, LOCALLOOP, THR)
% x, y: coordinates of the cities
% NIND: number of individuals
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% THR: the threshold that must be exceeded before the algorithm halts
% calculate distance matrix between each pair of cities

    GGAP = 1 - ELITIST;
    Dist=zeros(NVAR,NVAR);
    for i=1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end

    % initialize population
    Chrom=zeros(NIND,NVAR);
    for row=1:NIND
        Chrom(row,:)=path2adj(randperm(NVAR));
        %Chrom(row,:)=randperm(NVAR);
    end
    gen=0;

    % number of individuals of equal fitness needed to stop
    stopN=ceil(STOP_PERCENTAGE*NIND);

    % evaluate initial population
    ObjV = tspfun(Chrom,Dist);    

    % Run untill threshold is exceeded
    while true
        best(gen+1)=min(ObjV);
        minimum=best(gen+1);
        
        % Break the "while true" loop if the minimum distance exceeds THR
        if (minimum <= THR)
              break;
        end  
        
        %assign fitness values to entire population
        FitnV=ranking(ObjV);

        %select individuals for breeding
        SelCh=select('sus', Chrom, FitnV, GGAP);

        %recombine individuals (crossover)
        SelCh = recombin(CROSSOVER,SelCh,PR_CROSS);
        SelCh=mutateTSP('inversion',SelCh,PR_MUT);

        %evaluate offspring, call objective function
        ObjVSel = tspfun(SelCh,Dist);

        %reinsert offspring into population
        [Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel);
        Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);

        %increment generation counter
        gen=gen+1;            
    end
end
