
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

InstallMethod(CoSkeleton,
	[IsManiplex],
	function (m)
	local p;
	p:=PointGraph(LayerGraph(Dual(m),0,1));
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





InstallMethod(EdgeLabeledGraphFromEdges,
	[IsList, IsList, IsList],
	function(listv,liste,listl)
	local fam, egraph;
	egraph:=Objectify(NewType(EdgeLabeledGraphFamily, IsEdgeLabeledGraph and IsEdgeLabeledGraphListRep), rec(vertices:=listv, edges:=liste, labels:=listl));
	return(egraph);
	end);


InstallMethod( ViewObj,
	[IsEdgeLabeledGraph],
	function(p)
	Print(Concatenation("Edge labeled graph with ", String(Size(p!.vertices)), " vertices, and labels ", String(Set(p!.labels))));
	end);


InstallMethod(FlagGraph,
	[IsGroup],
	function(g)
	local all;
	all:= FlagGraphWithLabels(g);
	return(EdgeLabeledGraphFromEdges(Vertices(all[1]),all[2],all[3]));
	end);


InstallMethod(FlagGraph,
	[IsManiplex],
	function(m)
	local c, all;
	c:=ConnectionGroup(m);
	all:= FlagGraphWithLabels(c);
	return(EdgeLabeledGraphFromEdges(Vertices(all[1]),all[2],all[3]));
	end);


InstallMethod(UnlabeledSimpleGraph,
	[IsEdgeLabeledGraph],
	function(f)
	local i,start;
	start:=f!.edges;
	for i in start do
		if Size(Set(i)) <> 2 then
		Remove(start,i);
		fi;
	od;
	return GraphFromListOfEdges(f!.vertices,start);
	end);


#Note this is complicated and slow. Looking for better answers here.  
#It should give the correct action on the flags.
InstallMethod(EdgeLabelPreservingAutomorphismGroup,
	[IsEdgeLabeledGraph],
	function(f)
	local newV, sorted, r, sv, newE, i, j, k, l, colors, sortedl, ci, gamma, A, newG, M, gens, H;
	newV:=[1..Size(Set(f!.labels))*Size(f!.vertices)];
	sortedl:=Set(f!.labels);
	r:=Size(sortedl);
	sv:=Size(f!.vertices);
	newE:=[];	
	for i in [1..sv] do
		for j in [1..r-1] do
			Add(newE,[(j-1)*sv+i , j*sv+i]);
		od;
		Add(newE, [i,(r-1)*sv+i]);	
	od;
	for k in [1..Size(f!.edges)] do
		l:=f!.labels[k];
		Add(newE,[(l-1)*sv+f!.edges[k][1],(l-1)*sv+f!.edges[k][2]]);
	od;
	colors:=[];
	for i in [1..r] do
		ci:=[];
		for j in [1..sv] do
			Add(ci,(i-1)*sv+j);
		od;
		Add(colors,ci);
	od;
	gamma:=GraphFromListOfEdges(newV,newE);
	A:= AutGroupGraph( gamma, colors );
	newG:=[];
	M:=Size(MovedPoints(A));
	gens:=GeneratorsOfGroup(A);
	for i in gens do
		Add(newG,RestrictedPerm(i,[1..Int(M/r)]));
	od;
	H:=Group(newG);
	return H;
	end);


InstallMethod(Simple,
	[IsEdgeLabeledGraph],
	function(f)
	local ed, l, good, i ;
	ed:=f!.edges;
	l:=f!.labels;
	good:=[1];
	SortParallel(ed,l);
	for i in [2..Size(ed)] do
		if Size(ed[i]) = 2 and (not ed[i] = ed[i-1]) then
			Add(good,i);
		fi;
	od;
	return EdgeLabeledGraphFromEdges(f!.vertices,ed{good},l{good});
	end);


InstallMethod(ConnectedComponents,
	[IsEdgeLabeledGraph],
	function(f)
	local f2, f3 ;
	f2:=Simple(f);
	f3:=GraphFromListOfEdges(f2!.vertices,f2!.edges);
	return ConnectedComponents(f3);
	end);


InstallMethod(ConnectedComponents,
	[IsEdgeLabeledGraph, IsList],
	function(f,bad)
	local f2, good, ed, l, i, f3 ;
	f2:=Simple(f);	
	good:=[];
	ed:=f2!.edges;
	l:=f2!.labels;
	for i in [1..Size(ed)] do
		if not (l[i] in bad) then
		Add(good,i);
		fi;
	od;
	f3:=GraphFromListOfEdges(f2!.vertices,ed{good});
	return ConnectedComponents(f3);
	end);
		

InstallMethod(PRGraph,
	[IsGroup],
	function(g)
	local gens, V, labels, edges, r, i, j ;
	gens:=GeneratorsOfGroup(g);
	V:=MovedPoints(g);
	labels:=[];
	edges:=[];
	for r in [1..Size(gens)] do
	for i in [1..Size(V)-1] do
	for j in [i+1..Size(V)] do
		if i^gens[r] = j then
			Add(labels,r);
			Add(edges, [i,j]);
		fi;
	od;
	od;
	od;
	return EdgeLabeledGraphFromEdges(V,edges,labels);
	end);


InstallMethod(CPRGraphFromGroups,
	[IsGroup,IsGroup],
	function(g,h)
	return PRGraph(Range(FactorCosetAction(g,h)));
	end);




InstallMethod(Vertices,
	[IsEdgeLabeledGraph],
	function(g);
	return g!.vertices;
	end);

InstallMethod(Edges,
	[IsEdgeLabeledGraph],
	function(g);
	return g!.edges;
	end);


InstallMethod(Labels,
	[IsEdgeLabeledGraph],
	function(g);
	return g!.labels;
	end);




