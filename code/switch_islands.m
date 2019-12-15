function [Chrom,ObjV] = switch_islands(Chrom, ObjV,index1,index2, SUBPOP)
[NindCh,Nvar] = size(Chrom);
Nind = NindCh/SUBPOP;
extra = 2*ceil(Nind/SUBPOP);

ChromSub=Chrom((index1-1)*Nind+1:index1*Nind,:);
ObjVSub=ObjV((index1-1)*Nind+1:index1*Nind);

NextChromSub=Chrom((index2-1)*Nind+1:index2*Nind,:);
NextObjVSub=ObjV((index2-1)*Nind+1:index2*Nind);

for index=1:extra
    random = randi(Nind);
    substitute = ChromSub(random,:);
    substituteObjV = ObjVSub(random,1);
    ChromSub(random,:)=NextChromSub(random,:);
    ObjVSub(random,1)=NextObjVSub(random,1);
    NextChromSub(random,:)=substitute;
    NextObjVSub(random,1)=substituteObjV;

end
%{
for remove=1:extra %remove excessive rows at random
    random=randi(1,Nind+extra);
    ChromSub(random,:)=[];
    ObjVSub(random,:)=[];
    random=randi(1,Nind+extra);
    NextChromSub(random,:)=[];
    NextObjVSub(random,:)=[];  
end
%}
Chrom((index1-1)*Nind+1:index1*Nind,:)=ChromSub;
ObjV((index1-1)*Nind+1:index1*Nind)=ObjVSub;
Chrom((index2-1)*Nind+1:index2*Nind,:)=NextChromSub;
ObjV((index2-1)*Nind+1:index2*Nind)=NextObjVSub;
end

