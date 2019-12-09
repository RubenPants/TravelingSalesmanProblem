%{
adj2path.m

This function converts the adjacency representation to the path
representation. Note that produced paths will always start at 1.

Example:
    Adj =
        2   3   1
        3   1   2
    Path =
        1   2   3
        1   3   2
%}

function Path = adj2path(Adj)
	Path=zeros(size(Adj));
    if size(Adj, 1) == 1
        walking_index=1;
        Path(1)=1;
        for t=2:size(Adj,2)
            Path(t)=Adj(walking_index);
            walking_index=Path(t);
        end
    else
        for r=1:size(Adj,1)
            Path(r,:) = adj2path(Adj(r,:));
        end
    end
