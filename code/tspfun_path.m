%{
tspfun_path.m

Implementation of the TSP fitness function for path-representations
 * Phen contains the phenocode of the matrix coded in path representation
	Rows = genomes (candidates), Columns = cities (genome encoding)
 * Dist is the matrix with precalculated distances between each pair of cities
    Distance matrix, distance to self=0
 * ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
    Vector with calculated distances for each of the genomes
%}

function ObjVal = tspfun_path(Phen, Dist)
	% Turn to adjacency representation
    s=size(Phen);
    chromosomes_amnt = s(1);
    Phen_adj = zeros(s);
    for row=1:chromosomes_amnt
        Phen_adj(row,:)=path2adj(Phen(row,:));  % Don't use adjacency
    end
    
    % Determine distance
	ObjVal=Dist(Phen_adj(:,1),1);
	for t=2:size(Phen_adj,2)
    	ObjVal=ObjVal+Dist(Phen_adj(:,t),t);
	end
