%{
heuristic_crossover.m

heuristic crossover for TSP. This crossover assumes that the ADJACENCY
representation is used to represent TSP tours.

Input parameters:
	OldChrom        - Matrix containing the chromosomes of the old
                      population. Each line corresponds to one individual
                      (in any form, not necessarily real values).
    Representation  - integer specifying which encoding is used
                        1 : adjacency representation
                        2 : path representation
    XOVR            - Probability of recombination occurring between pairs
                      of individuals.

Output parameter:
    NewChrom  - Matrix containing the chromosomes of the population
                after mating, ready to be mutated and/or evaluated,
                in the same format as OldChrom.
%}

function NewChrom = heuristic_crossover(OldChrom, Representation, Dist, XOVR)
    if nargin < 4, XOVR = NaN; end  % No recombination will happen

    % Transform path to adjacency
    if Representation==1
        OldChrom=adj2path(OldChrom);
    end
    
    [rows,~]=size(OldChrom);

    maxrows=rows;
    if rem(rows,2)~=0
        maxrows=maxrows-1;
    end

    NewChrom = zeros(size(OldChrom));
    for row=1:maxrows
        if rand<XOVR
            % Create single offspring from current and next parent
            if (row < maxrows); next = row + 1; else; next = 1; end
            NewChrom(row,:) = heuristic(OldChrom(row,:),OldChrom(next,:),Dist);
        else
            NewChrom(row,:)=OldChrom(row,:);
        end
    end

    if rem(rows,2)~=0
        NewChrom(rows,:)=OldChrom(rows,:);
    end
    
    % Transform adjacency back to path
    if Representation==1
        NewChrom=path2adj(NewChrom);
    end
