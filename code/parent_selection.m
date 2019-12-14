%{
parent_selection.m

Parent method to call the parent selection methods. 

%}

function ParentSelCh = parent_selection(ObjV,Chrom,GGAP,NIND,PARENT_SELECTION)
if PARENT_SELECTION == "ranking"
        FitnV=ranking(ObjV);
elseif PARENT_SELECTION == "scaling"
        FitnV=scaling(ObjV);   
end
    
if PARENT_SELECTION=="tournament"
    ParentSelCh = tournament_selection(ObjV,Chrom,floor(GGAP*NIND));
else 
    ParentSelCh=select('sus', Chrom, FitnV, GGAP);
end
end