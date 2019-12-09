% low level function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation

function NewChrom = inversion(OldChrom,Representation)
    NewChrom=OldChrom;

    % Transform adjacency to path
    if Representation==1
        NewChrom=adj2path(NewChrom);
    end

    % select two positions in the tour
    rndi=zeros(1,2);  % Choose the start and stop index of the reversed path
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    rndi = sort(rndi);  % Start must come before stop

    NewChrom(rndi(1):rndi(2)) = NewChrom(rndi(2):-1:rndi(1));

    % Transform path back to adjacency
    if Representation==1
        NewChrom=path2adj(NewChrom);
    end
