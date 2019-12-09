%{
tspfun_path.m

Implementation of the TSP fitness function for adjacency-representations
 * Phen contains the phenocode of the matrix coded in adjacency representation
	Rows = genomes (candidates), Columns = cities (genome encoding)
 * Dist is the matrix with precalculated distances between each pair of cities
    Distance matrix, distance to self=0
 * ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
    Vector with calculated distances for each of the genomes
%}

function ObjVal = tspfun_adj(Phen, Dist)
	ObjVal=Dist(Phen(:,1),1);
	for t=2:size(Phen,2)
    	ObjVal=ObjVal+Dist(Phen(:,t),t);
	end
