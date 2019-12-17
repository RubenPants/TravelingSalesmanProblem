%{
local_heuristic.m

Parent method to call the local heuristic methods. Both heuristics are
based on the paper https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf.

input parameters: 
    HEUR_F: type of local heuristic that is used
    
    Chrom: matrix containing the population -> each row is a genome

    Dist: matrix containing the distances between 2 cities
    
    Representation: integer representing the representation (1=adjacent,
        2=path)

    MutPr: float between 0 and 1 representing the mutation rate for the
        local inversion heuristic

output parameter:
    Chrom: the new population
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
    