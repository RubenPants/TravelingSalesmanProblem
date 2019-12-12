function [Chrom, ObjV] = round_robin(SelCh, Chrom, ObjV, ObjVSel);
% Identify the population size (Nind)
   [NindCh,Nvar] = size(Chrom);
   [NindOff,VarOff] = size(SelCh);
   keeping=NindCh-NindOff;
for i=1:NindCh
    fit = ObjV(i,1);
    score = 0;
    for fight=1:10
        random = randi([1,NindCh]); 
        contestant = ObjV(random,1);
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
        newChrom= [newChrom;Chrom(index,:)];
        newObjV= [newObjV;ObjV(index,1)];
        Scores(index,1)=0;
    end
    Chrom=[newChrom;SelCh];
    ObjV=[newObjV;ObjVSel];
end