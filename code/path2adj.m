%{
path2adj.m

This function converts the path representation to the adjacency 
representation. 

Example:
    Path =
        1   2   3
        3   2   1
    Adj =
        2   3   1
        3   1   2
%}

function Adj = path2adj(Path)
	Adj=zeros(size(Path));
    if size(Path, 1) == 1
        for t=1:size(Path,2)-1
            Adj(Path(t))=Path(t+1);
        end
        Adj(Path(size(Path,2)))=Path(1);
    else
        for r=1:size(Path,1)
            Adj(r,:) = path2adj(Path(r,:));
        end
    end
	