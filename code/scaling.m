% SCALING.m - linear fitness scaling
%
% This function implements a linear fitness scaling algorithm as described
% by Goldberg in "Genetic Algorithms in Search, Optimization and Machine
% Learning", Addison Wesley, 1989.  It use is not recommended when fitness
% functions produce negative results as the scaling will become unreliable.
% It is included in this version of the GA Toolbox only for the sake of
% completeness.
%
% Syntax:	FitnV = scaling(ObjV, Smul)
%
% Input parameters:
%
%		Objv	- A vector containing the values of individuals
%			  fitness.
%
%		Smul	- Optional scaling parameter (default 2).
%
% Output parameters:
%
%		FitnV	- A vector containing the individual fitnesses
%			  for the current population.
%			  
%

% Author: Andrew Chipperfield
% Date: 24-Feb-94


function FitnV = scaling( ObjV,SUBPOP, Smul )
[Nind, ~] = size( ObjV ) ;
Nind=Nind/SUBPOP;
for i=1:size(ObjV,1) %as we are working with distances -> invert them
    if(ObjV(i,1)~= 0)
        ObjV(i,1)=1/ObjV(i,1);
    end
end
if nargin ~=3
	Smul = 2 ;
end
FitnV=[];
for irun=1:SUBPOP
    ObjVSub = ObjV((irun-1)*Nind+1:irun*Nind);
Oave = sum( ObjVSub ) / Nind ;
Omin = min( ObjVSub ) ;
Omax = max( ObjVSub) ;

if (Omin > ( Smul * Oave - Omax ) / ( Smul - 1.0 ))
	delta = Omax - Oave; 
	a = ( Smul - 1.0 ) * Oave / delta ;
	b = Oave * ( Omax - Smul * Oave ) / delta; 
else
	delta = Oave - Omin; 
	a = Oave / delta ;
	b = -Omin * Oave / delta; 
end
FitnVSub = (ObjVSub.*a + b) ;
FitnV=[FitnV;FitnVSub];
end
FitnV(FitnV<0)=0;
if isequal(FitnV,zeros(Nind,1)) || isequal(isnan(FitnV),ones(Nind,1))
    FitnV=ObjV;
end

