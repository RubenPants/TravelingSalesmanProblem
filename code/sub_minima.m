%{
sub_minima.m

Function that selects the maximum fitness of each subpopulation and puts it into a
column vector

input parameters:
    ObjV: column vactor containing the fitness values of the population
    
    SUBPOP: amount of subpopulations
   
output parameter:
    minima: column vector containg the maximum fitness of each
    subpopulations
    
%REMARK
as we are dealing with distances: maximum fitness = minimum distance

function minima=sub_minima(ObjV,SUBPOP)
minima=[];
Nind=size(ObjV,1)/SUBPOP;
for irun=1:SUBPOP
    minima=[minima;min(ObjV((irun-1)*Nind+1:irun*Nind))];
end
end