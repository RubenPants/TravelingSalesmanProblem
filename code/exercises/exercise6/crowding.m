%Calculate the pairwise distances
%pair the most similar ones together -> dist(c1p1+c2p2 < c1p2+c2p1)
%let these pairs battle to each other using the fitness values
%the best one for eacht battle is put in to reinsert
function result = crowding(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren,REPR_ID)
[NindP,NvarP] = size(ParentSelCh);
[NindC,NvarC] = size(ChildSelCh);
if NindP ~= NindC, error('NindP and NindC disagree'); end
if NvarP ~= NvarC, error('NvarP and NvarC disagree'); end
result=[];
for i=1:2:NindP
    %dsitances: https://www.academia.edu/972640/Crowding_population-based_ant_colony_optimisation_for_the_multi-objective_travelling_salesman_problem
    % => number of shared edges
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
        if pdist1-cdist1<0 
            c1 = ParentSelCh(i,:);
        else
            c1 = ChildSelCh(i,:);
        end
         if pdist2-cdist2<0 
            c2 = ParentSelCh(i+1,:);
        else
            c2 = ChildSelCh(i+1,:);
        end
    else
         if pdist1-cdist2<0 
            c1 = ParentSelCh(i,:);
        else
            c1 = ChildSelCh(i+1,:);
        end
         if pdist2-cdist1<0 
            c2 = ParentSelCh(i+1,:);
        else
            c2 = ChildSelCh(i,:);
        end
    end
    result =[result;c1;c2];        
end

end