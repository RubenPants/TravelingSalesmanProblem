%{
adj2path.m

This function converts the adjacency representation to the path
representation. Paths are represented by row-vectors.
%}

function Path = adj2path(Adj)
	walking_index=1;
	Path=zeros(size(Adj));
	Path(1)=1;
	for t=2:size(Adj,2)
		Path(t)=Adj(walking_index);
		walking_index=Path(t);
	end
