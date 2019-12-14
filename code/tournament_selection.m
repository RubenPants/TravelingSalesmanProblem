%{
tournament_selection.m

The algorithm selects the best parents from a population by using the
tournament selection strategy. An individual can be chosen multiple times. 
%}
%http://www.iaeng.org/publication/WCE2011/WCE2011_pp1134-1139.pdf?fbclid=IwAR2ZzQW0HCqTXdoAvMveLAwqB-Qgi4KGgQ5oqjuSizeSWTG9fYuU32sg7kw
function SelCh = tournament_selection( ObjV, Chrom, GGAP, SUBPOP)
% Identify the population size (Nind)
   [NindCh,Nvar] = size(Chrom);
   [NindF,VarF] = size(ObjV);
   if NindCh ~= NindF, error('Chrom and FitnV disagree'); end
   if VarF ~= 1, error('FitnV must be a column vector'); end
   Nind=NindCh/SUBPOP;
   NSel=max(floor(Nind*GGAP+.5),2);

   SelCh=[];
for irun=1:SUBPOP
    for i=1:NSel
        random1 = randi([1,Nind]);
        random2 = randi([1,Nind]);
        ObjVSub = ObjV((irun-1)*Nind+1:irun*Nind);
        if ObjVSub(random1)<ObjVSub(random2)
            result=Chrom((irun-1)*Nind+random1,:);
        else
            result=Chrom((irun-1)*Nind+random2,:);
        end
        SelCh=[SelCh;result];
    end
end
end