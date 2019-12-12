%{
local_heuristic.m

Parent method to call the local heuristic methods. Both heuristics are
based on the paper https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf.
%}

function Chrom = local_heuristic(HEUR_F, Chrom, Dist, Representation, MutPr)
    if Representation == 1
        Chrom = adj2path(Chrom);
    end
    
    for i=1:size(Chrom,2)
        % Do the local heuristic
        if HEUR_F == "2-opt"
            Chrom(i,:) = two_opt(Chrom(i,:), Dist);
        elseif HEUR_F == "inversion"
            if rand < MutPr
                NewChrom = inversion(Chrom(i,:));
                if tspfun(NewChrom, Dist, 2) < tspfun(Chrom(i,:), Dist, 2)
                    Chrom(i,:) = NewChrom;
                end
            end
        else
            ME = MException("Requested local heuristic is not supported!");
            throw(ME)
        end        
    end
    
    if Representation == 1
        Chrom = path2adj(Chrom);
    end
    