%{
reciprocal_exchange.m

Swap two cities in the tour at random.
Parameters:
    OldChrom:       List of cities
%}

function Chrom = scramble(Chrom)
    % Determine the beginning and the end of the scramble
    rndi=zeros(1,2);
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(Chrom,2)]);
    end
    rndi = sort(rndi);  % Start must come before stop
    
    % Do the scramble
    piece = Chrom(rndi(1):rndi(2));
    Chrom(rndi(1):rndi(2)) = piece(randperm(length(piece)));
