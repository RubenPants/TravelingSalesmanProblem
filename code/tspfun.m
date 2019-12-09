%{
tspfun_path.m

Implementation of the TSP fitness function
 * Phen - contains the phenocode of the matrix, the rows are the genomes 
          (candidates) and the columns the genome encoding (integer list)
 * Dist - the matrix with precalculated distances between each pair of 
          cities, distance to self is zero
 * Repr - integer representing the chosen representation with 1 for the 
          adjacency representation and 2 for the path representation
 * ObjVal - vector with the fitness values (summed distance) for each 
            candidate tour (=each row of Phen)
%}

function ObjVal = tspfun(Phen, Dist, Repr)
    % Transform Phen to adj representaion if needed
    if Repr==2
        Phen = adj2path(Phen);
    end
    
    % Calculate the distances
    ObjVal=Dist(Phen(:,1),1);
    for t=2:size(Phen,2)
        ObjVal=ObjVal+Dist(Phen(:,t),t);
    end
