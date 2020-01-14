%{
knn_init.m

Initialize the chromosome by using the KNN-algorithm. A random first city
is chosen, the next city in the row will always be the shortest one
remaining. The final chromosome is in adjacency representation.


Input parameters:
	NVAR - Length of the chromosome, which is equal to the amount of cities
    DIST - Distance matrix indicating distance between two cities

Output parameter:
    Chrom - Chromosome in path representation
%}

function Chrom = knn_init(NVAR, Dist)
    Chrom = zeros(1,NVAR);
    Chrom(1,1) = randi(NVAR);
    for p=2:NVAR
        C = Chrom(1,p-1);  % Previous city to which distance is calculated
        
        % Loop over all the possible cities to find the closest one not yet in Chrom
        p2 = 0;
        dist = inf;
        for x=1:NVAR
            % x may not yet be used in Chrom and new distance must be shorter
            if ~any(Chrom==x) && Dist(C, x) < dist
                p2 = x;
                dist = Dist(C, x);
            end
        end
        
        % Add closest city to Chrom
        Chrom(1,p) = p2;
    end
end