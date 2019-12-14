%{
inversion.m

Reverse a subsequence of cities.
Parameters:
    Chrom:       List of cities
    max_size:    Maximum size of inversion
%}

function Chrom = inversion(Chrom)   
    rndi=zeros(1,2);  % Choose the start and stop index of the reversed path
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(Chrom,2)]);
    end
    rndi = sort(rndi);  % Start must come before stop

    Chrom(rndi(1):rndi(2)) = Chrom(rndi(2):-1:rndi(1));
