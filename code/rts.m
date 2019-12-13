%{
crowding.m

The rts algorithm tries to keep diversity in the population.
The distance used in the algorithm is based on the following paper:
 
Crowding Population-based Ant ColonyOptimisation for the Multi-objective TravellingSalesman Problem

The use of rts is based on the following paper:
Runtime analysis of probabilistic crowding and restricted tournament selection for bimodal optimisation

%}
function result = rts(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren,REPR_ID)
[NindP,NvarP] = size(ParentSelCh);
[NindC,NvarC] = size(ChildSelCh);
 if REPR_ID ==2
     ParentSelCh=path2adj(ParentSelCh);
     ChildSelCh=path2adj(ChildSelCh);
 end
if NindP ~= NindC, error('NindP and NindC disagree'); end
if NvarP ~= NvarC, error('NvarP and NvarC disagree'); end
result=[];
for i=1:NindC
    
    child = ChildSelCh(i,:);
    max = size(child,2);
    for p=1:NindP
        gdist=genome_distance(child,ParentSelCh(p,:));
        if gdist<max
            max=gdist;
            closest=ParentSelCh(p,:);
            pdist=ObjVSelParents(p,1);
        end
    end
   
   cdist = ObjVSelChildren(i,1);
    
    if cdist < pdist    
        result =[result;child];
    else
        result =[result;closest];
    end
        
end
if REPR_ID ==2
     result = adj2path(result);
end
end