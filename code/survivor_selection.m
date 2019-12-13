%{
survivor_selection.m

Parent method to call the survivor_selection methods
%}

function [Chrom,ObjV] = survivor_selection(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SURVIVOR_SELECTION)
if SURVIVOR_SELECTION == "elitism"
        [Chrom, ObjV]=reins(Chrom,ChildSelCh,1,1,ObjV,ObjVSelChildren);
else 
        [Chrom, ObjV] = round_robin(ChildSelCh, Chrom, ObjV, ObjVSelChildren);
end
end