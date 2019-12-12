
% Based on https://arxiv.org/ftp/arxiv/papers/1409/1409.3078.pdf
%Take for each individual a random number. If its lower than the given
%LOCAL_MUT, perform a mutation (take two random ints between 1 and N
%reverse the part between these two random ints

%Chrom= the matrix containing all the individuals
%Dist = The matrix containing the distances between the cities
%NVar = the number of cities
%NInd = the number of individuals
%LOCAL_MUT = parameter to trigger the local mutation

function Chrom =  aaa_single_sample_mutation(Chrom, Dist, NVar, NInd, LOCAL_MUT, REPR_ID)
for indiv = 1:NInd
    if REPR_ID == 1
        individual = adj2path(Chrom(indiv, 1:NVar));
    else
        individual = Chrom(indiv, 1:NVar);
    end
    random = rand;
    if (random < LOCAL_MUT)
        beginVar = NVar-2;
        begin = randi([2,beginVar]);
        finalVar = NVar-begin-1;
        final = begin + randi([1,finalVar]);
        original_distance = Dist(individual(1,begin-1),individual(1,begin))+(Dist(individual(1,final),individual(1,final+1)));
        new_distance = Dist(individual(1,begin-1),individual(1,final))+(Dist(individual(1,begin),individual(1,final+1)));
        if (original_distance >= new_distance)
            individual(1,begin:final) = flip(individual(1,begin:final));
            if REPR_ID == 1
                Chrom(indiv,1:NVar)=path2adj(individual);
            else
                Chrom(indiv,1:NVar)=individual;
            end
        end        
    end 
end
end