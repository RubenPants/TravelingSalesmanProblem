%{
reciprocal_exchange.m

Swap two cities in the tour at random.
Parameters:
    OldChrom:       List of cities
%}

function Chrom = reciprocal_exchange(Chrom)
    % swap two random cities in the tour
    rndi=zeros(1,2);  % Choose two integers at random which will be swapped
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(Chrom,2)]);
    end
    
    % Do the swap
    buffer=Chrom(rndi(1));
    Chrom(rndi(1))=Chrom(rndi(2));
    Chrom(rndi(2))=buffer;
