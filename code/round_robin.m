%{
round_robin.m

Selects survivors from the old population using the round_robin strategy.
After this selection, form a new population from the survivors and the
given offspring
%}
function [Chrom, ObjV] = round_robin(SelCh, Chrom, ObjV, ObjVSel, SUBPOP);
% Identify the population size (Nind)
   [NindCh,Nvar] = size(Chrom);
   [NindOff,VarOff] = size(SelCh);
   keeping=ceil((NindCh-NindOff)/SUBPOP);
   Nind = NindCh/SUBPOP;
for irun=1:SUBPOP
     ObjVSub = ObjV((irun-1)*Nind+1:irun*Nind);
    for i=1:Nind
        fit = ObjVSub(i,1);
        score = 0;
        for fight=1:10
            random = randi([1,Nind]); 
            contestant = ObjVSub(random,1);
            if (fit < contestant)
                score = score +1;
            end
        end

       Scores(i,1)=score;
    end
 
    newChrom=[];
    newObjV=[];
    for amount=1:keeping
        [maximum,index]=max(Scores);
        newChrom= [newChrom;Chrom((irun-1)*Nind+index,:)];
        newObjV= [newObjV;ObjVSub(index,1)];
        Scores(index,1)=0;
    end
    Chrom=[newChrom;SelCh];
    ObjV=[newObjV;ObjVSel];
end
length= NindCh-NindOff-size(Chrom,1);
if length <0
    k = randperm(size(Chrom,1));
    Ex_Ran = Chrom;
    Ex_Ran(k(1:abs(length)),:) = [];
    Chrom=Ex_Ran;
elseif length > 0
    for i=1:length
        random = randi(1,size(Chrom,1));
        Chrom = [Chrom;Chrom(random,:)];
        ObjV = [ObjV;ObjV(random,1)];
    end    
end
end