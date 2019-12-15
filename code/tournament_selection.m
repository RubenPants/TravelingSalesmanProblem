%{
tournament_selection.m

The algorithm selects the best parents from a population by using the
tournament selection strategy. An individual can be chosen multiple times. 

Reference: http://www.iaeng.org/publication/WCE2011/WCE2011_pp1134-1139.pdf
%}

function SelCh = tournament_selection(ObjV, Chrom, GGAP, SUBPOP)
    % Identify the population size (Nind)
    [NindCh,~] = size(Chrom);
    [NindF,VarF] = size(ObjV);
    if NindCh ~= NindF, error('Chrom and FitnV disagree'); end
    if VarF ~= 1, error('FitnV must be a column vector'); end
    
    % Update parameters
    Nind = NindCh/SUBPOP;
    NSel=max(floor(Nind*GGAP+.5), 2);
    
    % Selection mechanism
    SelCh=[];
    for i=1:NSel
        random1 = randi([1,NindCh]);
        random2 = randi([1,NindCh]);
        if ObjV(random1)<ObjV(random2)
            SelCh=[SelCh, Chrom(random1,:)];
        else
            SelCh=[SelCh, Chrom(random2,:)];
        end
    end
end