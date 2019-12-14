%{
survivor_selection.m

Parent method to call the survivor_selection methods
%}

function [Chrom,ObjV] = survivor_selection(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SURVIVOR_SELECTION, SUBPOP)
if SURVIVOR_SELECTION == "elitism"
        [Chrom, ObjV]=reins(Chrom,ChildSelCh,SUBPOP,1,ObjV,ObjVSelChildren);
else 
        [Chrom, ObjV] = round_robin(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SUBPOP);
end
end