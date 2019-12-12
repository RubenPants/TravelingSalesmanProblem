%{
local_heuristic.m

Parent method to call the local heuristic methods. Both heuristics are
based on the paper https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf.
%}

function Chrom = local_heuristic(HEUR_F, Chrom, Dist, Representation, MutPr)
    if Representation == 1
        Chrom = adj2path(Chrom);
    end
    
    for i=1:size(Chrom,1)
        switch HEUR_F
            case "2-opt"
                Chrom(i,:) = two_opt(Chrom(i,:), Dist);
            case "inversion"
                if rand < MutPr
                    NewChrom = inversion(Chrom(i,:));
                    if tspfun(NewChrom, Dist, 2) < tspfun(Chrom(i,:), Dist, 2)
                        Chrom(i,:) = NewChrom;
                    end
                end
            case "both"
                Chrom(i,:) = two_opt(Chrom(i,:), Dist);
                if rand < MutPr
                    NewChrom = inversion(Chrom(i,:));
                    if tspfun(NewChrom, Dist, 2) < tspfun(Chrom(i,:), Dist, 2)
                        Chrom(i,:) = NewChrom;
                    end
                end
        end
    end
    
    if Representation == 1
        Chrom = path2adj(Chrom);
    end
    