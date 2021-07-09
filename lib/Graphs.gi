
InstallMethod(DirectedGraphFromListOfEdges,
	[IsList,IsList],
	function(Lv,Le)
	local p;
	return Graph( Group(()), Lv, OnPoints,
        function(x,y) return ([x,y] in Le); end,
        true );;
end);


InstallMethod(GraphFromListOfEdges,
	[IsList,IsList],
	function(Lv,Le)
	local p;
	p:=UnderlyingGraph(DirectedGraphFromListOfEdges(Lv,Le));
return p;
end);




InstallMethod(UnlabeledFlagGraph,
	[IsGroup],
	function(c)
	local M, Edges, g, i, j, p;
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
	p:=GraphFromListOfEdges([1..M],Edges);
	return p;
end);


InstallMethod(UnlabeledFlagGraph,
	[IsManiplex],
	function(m)
	local p;
	p:=UnlabeledFlagGraph(ConnectionGroup(m));
	return p;
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
	local p;
	p:= FlagGraphWithLabels(ConnectionGroup(m));
	return p;
end);
	



#Note this can be cleaned up using edge lists rather than Adjacency Matrices
InstallMethod(LayerGraph,
	[IsGroup,IsInt, IsInt],
	function(c,i,j)
	local n, ranksi, ranksj, iFaces, jFaces, Mi, Mj, I, a, b,p;
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
	p:=UnderlyingGraph(Graph( Group(()), [1..Mi+Mj], OnPoints,
        function(x,y) return I[x][y]=1; end,
        true ));;
	return p; 

	end);  	


InstallMethod(LayerGraph,
	[IsManiplex,IsInt, IsInt],
	function(m,i,j)
	local p;
	p:=LayerGraph(ConnectionGroup(m),i,j);
	return p;
	
end);





InstallMethod(Skeleton,
	[IsManiplex],
	function(m)
	local p;
	p:=PointGraph(LayerGraph(m,0,1));
	return p;

end);




#Want to run this on just connection groups, but have to rebuild f-vectors on the fly.
InstallMethod(Hasse,
	[IsManiplex],
	function(m)
	local  r, c, F0, Fr, Faces, i, FV, Ranks, ranksi, p;
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
	p:=Graph( Group(()), [1..Size(Faces)], OnPoints,
        function(x,y) return 
	(Size(Intersection(Faces[x],Faces[y])) > 0) and (Ranks[x] = Ranks[y] + 1); end,
        true );;
	return p;
end);



InstallMethod(QuotientByLabel,
	[IsObject,IsList, IsList, IsList],
	function(g,ed,lab,ks)
	local Rel, i, Q, E2, V2, gnew;	
	Rel:=[];
	for i in [1..Size(ed)] do
		if not (lab[i] in ks) then
			Add(Rel,ed[i]);
		fi;
	od;
	Q:=UnderlyingGraph(QuotientGraph(g,Rel));
	E2:=DirectedEdges(Q);
	V2:=Vertices(Q);
	for i in V2 do
		RemoveSet(E2,[i,i]);
	od;
	gnew:=GraphFromListOfEdges(V2,E2);
	return gnew;
end);












