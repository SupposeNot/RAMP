
InstallMethod(DirectedGraphFromListOfEdges,
	[IsList,IsList],
	function(Lv,Le)
	return Graph( Group(()), Lv, OnPoints,
        function(x,y) return ([x,y] in Le); end,
        true );;
end);


InstallMethod(GraphFromListOfEdges,
	[IsList,IsList],
	function(Lv,Le)
return UnderlyingGraph(DirectedGraphFromListOfEdges(Lv,Le));
end);




InstallMethod(UnlabeledFlagGraph,
	[IsGroup],
	function(c)
	local M, Edges, g, i, j;
	M:=Size(MovedPoints(c));
	Edges:=[];
	for g in GeneratorsOfGroup(c) do
	for i in [1..M] do
	for j in [1..M] do
		if i^g = j then 
		Add(Edges,[i,j]);
		fi;
	od;
	od;
	od;
	return GraphFromListOfEdges([1..M],Edges);
end);


InstallMethod(UnlabeledFlagGraph,
	[IsManiplex],
	function(m)
	return UnlabeledFlagGraph(ConnectionGroup(m));
	end);



InstallMethod(FlagGraphWithLabels,
	[IsGroup],
	function(c)
	local Labels,gens,g, i,j,n, p, M, Ed;
	gens:=GeneratorsOfGroup(c);;
	n := Size(gens);
	M:=Size(MovedPoints(c));
	p:=UnlabeledFlagGraph(c);
	Ed:=UndirectedEdges(p);;
	Labels:=[];
	for i in [1..Size(Ed)] do
	for j in [1..n] do
		if Ed[i][1]^gens[j] = Ed[i][2] then
			Labels[i]:=j;
		fi;
	od;
	od;
	return([p,Ed,Labels]);
end);


InstallMethod(FlagGraphWithLabels,
	[IsManiplex],
	function(m)
	return FlagGraphWithLabels(ConnectionGroup(m));
end);
	



#Note this can be cleaned up using edge lists rather than Adjacency Matrices
InstallMethod(LayerGraph,
	[IsGroup,IsInt, IsInt],
	function(c,i,j)
	local n, ranksi, ranksj, iFaces, jFaces, Mi, Mj, I, a, b;
	n:=Size(GeneratorsOfGroup(c));
	ranksi:=[1..n];
	Remove(ranksi,i+1);
	ranksj:=[1..n];
	Remove(ranksj,j+1);
	iFaces:=Orbits(Subgroup(c, GeneratorsOfGroup(c){ranksi}));
	jFaces:=Orbits(Subgroup(c, GeneratorsOfGroup(c){ranksj}));
	Mi:=Size(iFaces);
	Mj:=Size(jFaces);

	I:=NullMat(Mi+Mj,Mi+Mj);;
	for a in [1..Mi] do
	for b in [1..Mj] do
	if Size(Intersection(iFaces[a],jFaces[b])) > 0 then
	I[a][b+Mi]:=I[a][b+Mi]+1;
	fi;
	od;
	od;
	return UnderlyingGraph(Graph( Group(()), [1..Mi+Mj], OnPoints,
        function(x,y) return I[x][y]=1; end,
        true ));;
	end);  	


InstallMethod(LayerGraph,
	[IsManiplex,IsInt, IsInt],
	function(m,i,j)
	return LayerGraph(ConnectionGroup(m),i,j);
end);





InstallMethod(Skeleton,
	[IsManiplex],
	function(m)
	return PointGraph(LayerGraph(m,0,1));
end);




#Want to run this on just connection groups, but have to rebuild f-vectors on the fly.
InstallMethod(Hasse,
	[IsManiplex],
	function(m)
	local  r, c, F0, Fr, Faces, i, FV, Ranks, ranksi;
	r:=Rank(m);
	c:=ConnectionGroup(m);
	F0:=MovedPoints(c);
	Fr:=MovedPoints(c);
	Faces:=[F0];
	for i in [1..r] do
		ranksi:=[1..r];
		Remove(ranksi,i); 
		Append(Faces,Orbits(Subgroup(c, GeneratorsOfGroup(c){ranksi})));
	od;
	Append(Faces,[Fr]);
	FV:=Fvector(m);
	Ranks:=[0];
	for i in [1..r] do
	Append(Ranks, ListWithIdenticalEntries(FV[i],i));
	od;
	Append(Ranks,[r+1]);
	return Graph( Group(()), [1..Size(Faces)], OnPoints,
        function(x,y) return 
	(Size(Intersection(Faces[x],Faces[y])) > 0) and (Ranks[x] = Ranks[y] + 1); end,
        true );;
end);















