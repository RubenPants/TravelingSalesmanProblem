%{
inversion.m

Reverse a subsequence of cities.
Parameters:
    OldChrom:       List of cities
%}

function NewChrom = inversion(OldChrom)
    NewChrom=OldChrom;

    % select two positions in the tour
    rndi=zeros(1,2);  % Choose the start and stop index of the reversed path
    while rndi(1)==rndi(2)
        rndi=rand_int(1,2,[1 size(NewChrom,2)]);
    end
    rndi = sort(rndi);  % Start must come before stop

    NewChrom(rndi(1):rndi(2)) = NewChrom(rndi(2):-1:rndi(1));
