%{
reciprocal_exchange.m

Swap two cities in the tour at random.
Parameters:
    OldChrom:       List of cities
%}

function NewChrom = reciprocal_exchange(OldChrom)
    NewChrom=OldChrom;

    % swap two random cities in the tour
    rndi=zeros(1,2);  % Choose two integers at random which will be swapped
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    
    % Do the swap
    buffer=NewChrom(rndi(1));
    NewChrom(rndi(1))=NewChrom(rndi(2));
    NewChrom(rndi(2))=buffer;
