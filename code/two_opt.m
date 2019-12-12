%{
two_opt.m

Swap two cities 

Reference paper: https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf
%}

% Based on 
%Take for each 4 sequential cities the two middle cities, swap them and check
%whether this configuration is better than the previous one

%Chrom= the matrix containing all the individuals
%Dist = The matrix containing the distances between the cities
%NVar = the number of cities
%NInd = the number of individuals
function best_chrom =  two_opt(Chrom, Dist)
    best_chrom = Chrom;
    best_dist = tspfun(Chrom, Dist, 2);
    
    for i=1:size(Chrom,2)-1
        NewChrom = Chrom(1,:);
        
        % Do the swap
        a = NewChrom(i); NewChrom(i) = NewChrom(i+1); NewChrom(i+1) = a;
        
        % Evaluate
        new_dist = tspfun(NewChrom, Dist, 2);
        if new_dist < best_dist
            best_dist = new_dist;
            best_chrom = NewChrom;
        end
    end
end
