%{
reciprocal_exchange.m

Swap two cities in the tour at random.
Parameters:
    OldChrom:       List of cities
    Representation: Integer indicating the used representation
                        1: Adjacency
                        2: Path
%}

function NewChrom = reciprocal_exchange(OldChrom,Representation)
    NewChrom=OldChrom;

    if Representation==1 
        NewChrom=adj2path(NewChrom);
    end

    % swap two random cities in the tour
    rndi=zeros(1,2);  % Choose two integers at random which will be swapped
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    
    % Do the swap
    buffer=NewChrom(rndi(1));
    NewChrom(rndi(1))=NewChrom(rndi(2));
    NewChrom(rndi(2))=buffer;

    if Representation==1
        NewChrom=path2adj(NewChrom);
    end


