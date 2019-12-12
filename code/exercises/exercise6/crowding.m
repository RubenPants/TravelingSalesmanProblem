%Calculate the pairwise distances
%pair the most similar ones together -> dist(c1p1+c2p2 < c1p2+c2p1)
%let these pairs battle to each other using the fitness values
%the best one for eacht battle is put in to reinsert
function result = crowding(ParentSelCh, ObjVSelParents,ChildSelCh,ObjVSelChildren)
[NindP,NvarP] = size(ParentSelCh);
[NindC,NvarC] = size(ChildSelCh);
if NindP ~= NindC, error('NindP and NindC disagree'); end
if NvarP ~= NvarC, error('NvarP and NvarC disagree'); end
result=[];
for i=1:2:NindP
    pdist1 = ObjVSelParents(i,1);
    pdist2 = ObjVSelParents(i+1,1);
    cdist1 = ObjVSelChildren(i,1);
    cdist2 = ObjVSelChildren(i+1,1);
    if abs(pdist1-cdist1)+abs(pdist2-cdist2) < abs(pdist1-cdist2)+abs(pdist2-cdist1)
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