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
%   diversify       - integer specifying if diversity must be enforced
%                       0: No
%                       1: Yes
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mutation in the same format as OldChrom.


function Chrom = mutateTSP(MUT_F, Chrom, MutOpt, Representation)
    % Ensure path-representation
    if Representation==1 
        Chrom=adj2path(Chrom);
    end
    
    % Loop over all the chromosomes and mutate if needed
    [rows,~]=size(Chrom);
    for r=1:rows
        if rand < MutOpt
            Chrom(r,:) = feval(MUT_F, Chrom(r,:));
        end
    end
    
    % Put back to starting representation
    if Representation==1
        Chrom=path2adj(Chrom);
    end
