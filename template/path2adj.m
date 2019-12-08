% path2adj(Path)
% function to convert between path and adjacency representation for TSP
% Path and Adj are row vectors
%
% Example:
%   Path      = [4,1,2,3]
%   Adjacency = [2,3,4,1], since 1(first_pos)->2, 2(second_pos)->3, 3->4, 4->1
%

function Adj = path2adj(Path)
	Adj=zeros(size(Path));
	for t=1:size(Path,2)-1
		Adj(Path(t))=Path(t+1);
	end
	Adj(Path(size(Path,2)))=Path(1);
	