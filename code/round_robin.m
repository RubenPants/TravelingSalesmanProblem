%{
round_robin.m

Selects survivors from the old population using the round_robin strategy.
After this selection, form a new population from the survivors and the
given offspring

input parameters:
    SelCh: a matrix containing the offspring

    Chrom: a matrix containing the population

    ObjV: a column vector containing tne fitness values of the population
    
    ObjVSel: a column vector containing the fitness values of the offspring

    SUBPOP: amount of subpopulations

output parameters: 
    Chrom: the newly formed population
    
    ObjV: the fitness values of the new population
%}
function [Chrom, ObjV] = round_robin(SelCh, Chrom, ObjV, ObjVSel, SUBPOP);
% Identify the population size (Nind)
   [NindCh,Nvar] = size(Chrom);
   [NindOff,VarOff] = size(SelCh);
   keeping=ceil((NindCh-NindOff)/SUBPOP);
   Nind = NindCh/SUBPOP;
for irun=1:SUBPOP
     ObjVSub = ObjV((irun-1)*Nind+1:irun*Nind); %if Subpop=1 => ObjVSub = ObjV
    for i=1:Nind %loop over each genome
        fit = ObjVSub(i,1);
        score = 0;
        for fight=1:10 %let it fight with 10 other genomes
            random = randi(Nind); 
            contestant = ObjVSub(random,1); %other random genome
            if (fit < contestant) %if the contestor has a better value, increment the score
                score = score +1;
            end
        end

       Scores(i,1)=score;
    end
 
    
    for amount=1:keeping %select the genomes that stay in the population
        [maximum,index]=max(Scores);
        newChrom= [newChrom;Chrom((irun-1)*Nind+index,:)];
        newObjV= [newObjV;ObjVSub(index,1)];
        Scores(index,1)=0; %this way, the same genome will not be chosen twice
    end    
end
Chrom=[newChrom;SelCh];
ObjV=[newObjV;ObjVSel];
end