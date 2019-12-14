function minima=sub_minima(ObjV,SUBPOP)
minima=[];
Nind=size(ObjV,1)/SUBPOP;
for irun=1:SUBPOP
    minima=[minima;min(ObjV((irun-1)*Nind+1:irun*Nind))];
end
end