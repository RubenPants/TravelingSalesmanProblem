% alternating edges crossover for TSP as described in the book by Zbigniew 
% Michalewicz on page 212. This crossover assumes that the ADJACENCY
% representation is used to represent TSP tours.
%
% KULeuven, december 2002 
% email: Tim.Volodine@cs.kuleuven.ac.be
%
%
% Syntax:  NewChrom = xals_edges(OldChrom, Representation, XOVR)
%
% Input parameters:
%    OldChrom       - Matrix containing the chromosomes of the old
%                     population. Each line corresponds to one individual
%                     (in any form, not necessarily real values).
%   Representation  - integer specifying which encoding is used
%                       1 : adjacency representation
%                       2 : path representation
%    XOVR           - Probability of recombination occurring between pairs
%                     of individuals.
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
%

function NewChrom = xalt_edges(OldChrom, Representation, ~, XOVR)
    if nargin < 4, XOVR = NaN; end  % No recombination will happen

    % Transform path to adjacency
    if Representation==2
        OldChrom=path2adj(OldChrom);
    end
    
    [rows,~]=size(OldChrom);

    maxrows=rows;
    if rem(rows,2)~=0
        maxrows=maxrows-1;
    end

    NewChrom = zeros(size(OldChrom));
    for row=1:2:maxrows
        % crossover of the two chromosomes results in 2 offsprings
        if rand<XOVR
            NewChrom(row,:)=cross_alternate_edges([OldChrom(row,:);OldChrom(row+1,:)]);
            NewChrom(row+1,:)=cross_alternate_edges([OldChrom(row+1,:);OldChrom(row,:)]);
        else
            NewChrom(row,:)=OldChrom(row,:);
            NewChrom(row+1,:)=OldChrom(row+1,:);
        end
    end

    if rem(rows,2)~=0
        NewChrom(rows,:)=OldChrom(rows,:);
    end
    
    % Transform adjacency back to path
    if Representation==2
        NewChrom=adj2path(NewChrom);
    end
