%{
crowding.m

The crowding algorithm tries to keep diversity in the population.
The distance used in the algorithm is based on the following paper:
 
Crowding Population-based Ant ColonyOptimisation for the Multi-objective TravellingSalesman Problem

The use of probabilistic crowding is based on the following paper:
Generalized Crowding for Genetic Algorithms

%}
function result = crowding(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren,REPR_ID)
[NindP,NvarP] = size(ParentSelCh);
[NindC,NvarC] = size(ChildSelCh);
if NindP ~= NindC, error('NindP and NindC disagree'); end
if NvarP ~= NvarC, error('NvarP and NvarC disagree'); end
result=[];
for i=1:2:NindP
    if REPR_ID ==1
        parent1 = ParentSelCh(i,:);
        parent2 = ParentSelCh(i+1,:);
        child1 = ChildSelCh(i,:);
        child2 = ChildSelCh(i+1,:);
    else
        parent1 = path2adj(ParentSelCh(i,:));
        parent2 = path2adj(ParentSelCh(i+1,:));
        child1 = path2adj(ChildSelCh(i,:));
        child2 = path2adj(ChildSelCh(i+1,:));
    end
    
    p1c1 = genome_distance(parent1,child1);
    p1c2 = genome_distance(parent1,child2);
    p2c1 = genome_distance(parent2,child1);
    p2c2 = genome_distance(parent2,child2);
    pdist1 = ObjVSelParents(i,1);
    pdist2 = ObjVSelParents(i+1,1);
    cdist1 = ObjVSelChildren(i,1);
    cdist2 = ObjVSelChildren(i+1,1);
    
    if p1c1+p2c2 < p1c2+p2c1
        prob1 = pdist1/(pdist1+cdist1);
        prob2 = pdist2/(pdist2+cdist2);
        if (rand < prob1)
             c1 = ParentSelCh(i,:);
        else
            c1 = ChildSelCh(i,:);
        end
        if (rand < prob2)
             c2 = ParentSelCh(i+1,:);
        else
            c2 = ChildSelCh(i+1,:);
        end
       
    else
        prob1 = pdist1/(pdist1+cdist2);
        prob2 = pdist2/(pdist2+cdist1);
        if (rand < prob1)
             c1 = ParentSelCh(i,:);
        else
            c1 = ChildSelCh(i+1,:);
        end
        if (rand < prob2)
             c2 = ParentSelCh(i+1,:);
        else
            c2 = ChildSelCh(i,:);
        end
    end
    if REPR_ID==1
        result =[result;c1;c2];
    else
        result =[result;adj2path(c1);adj2path(c2)];
    end
end

end