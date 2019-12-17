%{
parent_selection.m

Parent method to call the parent selection methods. 

input parameters:
    ObjV: column vector containing the fitness values of the population
    
    Chrom: matrix containing the population (each row is a genome)

    GGAP: Percentage of the population that need to be selected as parents
    
    NIND: Number of individuals

    PARENT_SELECTION: type of parent selector that is needed (currently
        containing 'ranking', 'scaling' and 'tournament')

    SUBPOP: amount of subpopulations
    
ouput parameter:
    ParentSelCh: a matrix containing the chosen parent genomes
%}

function ParentSelCh = parent_selection(ObjV,Chrom,GGAP,NIND,PARENT_SELECTION, SUBPOP)
if PARENT_SELECTION == "ranking"
        FitnV=ranking(ObjV,NaN, SUBPOP);
elseif PARENT_SELECTION == "scaling"
        FitnV=scaling(ObjV,SUBPOP);
        
end
    
if PARENT_SELECTION=="tournament"
    ParentSelCh = tournament_selection(ObjV,Chrom,GGAP, SUBPOP);
else 
    ParentSelCh=select('sus', Chrom, FitnV, GGAP, SUBPOP);
end
end