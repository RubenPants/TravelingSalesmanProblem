%{
survivor_selection.m

Parent method to call the survivor_selection methods

input parameters:
    ChildSelCh: a matrix containing the offspring

    Chrom: a matrix containing the population

    ObjV: a column vector containing tne fitness values of the population
    
    ObjVSelChildren: a column vector containing the fitness values of the offspring

    SURVIVOR_SELECTION: type of the survivor selector (currently is
        supported: 'elitism', 'round robin')

    SUBPOP: amount of subpopulations

output parameters: 
    Chrom: the newly formed population
    
    ObjV: the fitness values of the new population
%}

function [Chrom,ObjV] = survivor_selection(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SURVIVOR_SELECTION, SUBPOP)
if SURVIVOR_SELECTION == "elitism"
        [Chrom, ObjV]=reins(Chrom,ChildSelCh,SUBPOP,1,ObjV,ObjVSelChildren);
else 
        [Chrom, ObjV] = round_robin(ChildSelCh, Chrom, ObjV, ObjVSelChildren, SUBPOP);
end
end