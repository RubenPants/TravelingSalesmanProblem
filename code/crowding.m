%{
crowding.m

The crowding algorithm tries to keep diversity in the population.
The distance used in the algorithm is based on the following paper:
 
Crowding Population-based Ant ColonyOptimisation for the Multi-objective TravellingSalesman Problem

The use of deterministic crowding is based on the following paper:
Generalized Crowding for Genetic Algorithms

input parameters:
    ParentSelCh is a matrix containing the parent genomes

    ObjVSelParents is a column vector containg the fitness values of the
        parents

    ChilfSelCh is a matrix containing the mutated offspring genomes

    ObjVSelChildren is a column vector containg the fitness values of the
        offspring

    REPR_ID is an integer representing the representation (1= adjacency,
        2=path)

output parameter:
    result = the new population

The way crowding works: each pair of children is paired with its parents
using the genome distance. Each child-parent pair has to 'fight' to get
back in population. Deterministic crowding is used here -> best fitness
wins.

%}
function result = crowding(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren,REPR_ID)
[NindP,NvarP] = size(ParentSelCh);
[NindC,NvarC] = size(ChildSelCh);
 if REPR_ID ==2 % We need adjacency for the genome distance
     ParentSelCh=path2adj(ParentSelCh); 
     ChildSelCh=path2adj(ChildSelCh);
 end
if NindP ~= NindC, error('NindP and NindC disagree'); end
if NvarP ~= NvarC, error('NvarP and NvarC disagree'); end
result=[];
for i=1:2:NindP
    
    parent1 = ParentSelCh(i,:);  %select the parents and their offspring
    parent2 = ParentSelCh(i+1,:);
    child1 = ChildSelCh(i,:);
    child2 = ChildSelCh(i+1,:);
    
    p1c1 = genome_distance(parent1,child1); %calculate the pairwise genome distances
    p1c2 = genome_distance(parent1,child2);
    p2c1 = genome_distance(parent2,child1);
    p2c2 = genome_distance(parent2,child2);
    
    pdist1 = ObjVSelParents(i,1); %get the fitness values of the parents and their offspring
    pdist2 = ObjVSelParents(i+1,1);
    cdist1 = ObjVSelChildren(i,1);
    cdist2 = ObjVSelChildren(i+1,1);
    
    if p1c1+p2c2 < p1c2+p2c1 %pair the children with their closest parents
        
        if cdist1<pdist1     %'fight'
            c1 = ChildSelCh(i,:);
        else
        c1 = ParentSelCh(i,:);
        end
        if cdist2<pdist2
            c2 = ChildSelCh(i+1,:);
        else
        c2 = ParentSelCh(i+1,:);
        end
       
    else
         if cdist1<pdist2
            c1 = ChildSelCh(i,:);
        else
        c1 = ParentSelCh(i+1,:);
        end
        if cdist2<pdist1
            c2 = ChildSelCh(i+1,:);
        else
        c2 = ParentSelCh(i,:);
        end
        
        
    end  
    result =[result;c1;c2];
   
end
if REPR_ID ==2
     result = adj2path(result); %set the result back to the original path representation
end
end