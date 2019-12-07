% Based on https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf
%Take for each 4 sequential cities the two middle cities, swap them and check
%whether this configuration is better than the previous one

%Chrom= the matrix containing all the individuals
%Dist = The matrix containing the distances between the cities
%NVar = the number of cities
%NInd = the number of individuals
function Chrom =  aaa_four_vertices_three_edges(Chrom, Dist, NVar, NInd)
for indiv = 1:NInd
    individual = Chrom(indiv, 1:NVar);
    for quatro = 1:NVar-3
        sample = individual(1,quatro:quatro+3);
        original_distance = Dist(sample(1,1),sample(1,2))+(Dist(sample(1,3),sample(1,4)));
        new_distance = Dist(sample(1,1),sample(1,3))+(Dist(sample(1,2),sample(1,4)));
        if (original_distance >= new_distance)
            individual(1,quatro+1:quatro+2) = [sample(1,3),sample(1,2)];
            break;
        end
    end
    Chrom(indiv,1:NVar)=individual;
    end
end
end
