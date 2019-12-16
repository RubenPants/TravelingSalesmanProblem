% MUTATETSP.M       (MUTATion for TSP high-level function)
%
% This function takes a matrix OldChrom containing the 
% representation of the individuals in the current population,
% mutates the individuals and returns the resulting population.
%
% Syntax:  NewChrom = mutate(MUT_F, OldChrom, MutOpt, Representation)
%
% Input parameter:
%   MUT_F           - String containing the name of the mutation function
%   OldChrom        - Matrix containing the chromosomes of the old
%                     population. Each line corresponds to one individual.
%   MutOpt          - mutation rate
%   Representation  - integer specifying which encoding is used
%                       1 : adjacency representation
%                       2 : path representation
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mutation in the same format as OldChrom.


function Chrom = mutateAdaptiveTSP(MUT_F, Chrom, MutOpt, Representation)
    % Ensure path-representation
    if Representation==1 
        Chrom=adj2path(Chrom);
    end
    
    % Loop over all the chromosomes and mutate if needed
    [rows,~]=size(Chrom);
    dic = string(zeros(1,rows));
    frac = rows / 20;  % Start extra mutation if genome occupies more than 5% of population
    for r=1:rows
        k = join(string(Chrom(r,:)),"");
        if sum(k==dic) > frac  % Only mutate if enough occurrences
            while rand < MutOpt
                Chrom(r,:) = feval(MUT_F, Chrom(r,:));
            end
            k = join(string(Chrom(r,:)),"");
        end
        dic(r) = k;
    end
    
    % Put back to starting representation
    if Representation==1
        Chrom=path2adj(Chrom);
    end
