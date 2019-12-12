%{
two_opt.m

Swap two cities and check if the local distance decreased. If so, return
the mutated chromosome back.

Reference paper: https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf
%}

function Chrom =  two_opt(Chrom, Dist)
    for i=1:size(Chrom,2)-3
        if local_distance(swap(Chrom(1,i:i+3)), Dist) < local_distance(Chrom(1,i:i+3), Dist)
            Chrom(1,i:i+3) = swap(Chrom(1,i:i+3));
            break;
        end
    end
end

% Swap the second and third element from a four-valued chromosome
function Chrom = swap(Chrom)
    a = Chrom(2); Chrom(2) = Chrom(3); Chrom(3) = a;
end

function dist = local_distance(Chrom, Dist)
    dist = Dist(Chrom(1), Chrom(size(Chrom,2)));
    for i=1:size(Chrom,2)-1
        dist = dist + Dist(Chrom(i), Chrom(i+1));
    end
end
