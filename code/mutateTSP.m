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


function NewChrom = mutateTSP(MUT_F, OldChrom, MutOpt, Representation, diversify)
    % Check parameter consistency
    if nargin < 2,  error('Not enough input parameters'); end

    [rows,~]=size(OldChrom);
    NewChrom=OldChrom;

    for r=1:rows
        if (diversify && (r > 1) && ismember(OldChrom(r,:),NewChrom(1:r-1,:),'rows')) || (rand < MutOpt)  % TODO: Check if really needed!
            NewChrom(r,:) = feval(MUT_F, OldChrom(r,:), Representation);
        end
    end

