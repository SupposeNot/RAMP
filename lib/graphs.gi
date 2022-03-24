
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



#Labels are 0 to n-1
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
			Labels[i]:=j-1;    
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
	SetVerts(egraph,listv);
	SetEdges(egraph,liste);
	SetLabels(egraph,listl);
	return(egraph);
	end);


InstallMethod( ViewObj,
	[IsEdgeLabeledGraph],
	function(p)
	Print(Concatenation("Edge labeled graph with ", String(Size(p!.vertices)), " vertices, and edge labels ", String(Set(p!.labels))));
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
		

#Labels go from 0 to r-1
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
			Add(labels,r-1);
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


InstallMethod(LabeledEdges,
	[IsEdgeLabeledGraph],
	function(g)
	local labs, eds, i, labed;
	labs:=g!.labels;
	eds:=g!.edges;
	labed:=[];
	for i in [1..Size(eds)] do
	Add(labed,[eds[i],labs[i]]);
	od;
	return labed;
	end);




InstallOtherMethod(LabeledEdges,
	[IsEdgeLabeledGraph,IsBool],
	function(g,t)
	local labs, eds, i, labed;
	if t = true then
	return LabeledEdges(g);
	else 
	labs:=g!.labels;
	eds:=g!.edges;
	labed:=[];
	for i in [1..Size(eds)] do
	if Size(eds[i]) = 2 then
	Add(labed,[eds[i],labs[i]]);
	fi;
	od;
	return labed;
	fi;
	end);







InstallMethod(AdjacentVertices,
[IsEdgeLabeledGraph, IsObject],
function(g,v)
local verts, eds, i , ans;
verts:=Vertices(g);
eds:=Edges(g);
ans:=[];
for i in [1..Size(verts)] do
if [i,v] in eds or [v,i] in eds then
Add(ans,i);
fi;
od;
return ans;
end);



InstallMethod(LabeledAdjacentVertices,
[IsEdgeLabeledGraph, IsObject],
function(g,v)
local verts, eds, i ,j, labs,  ansv, ansl;
verts:=Vertices(g);
eds:=Edges(g);
labs:=Labels(g);
ansv:=[];
ansl:=[];
for j in [1..Size(eds)] do
i:= eds[j];
if (Size(i) = 2) and (v in i) then
	if i[1] = i[2] then
	Add(ansv,v);
	Add(ansl,labs[j]);

	elif i[1] <> v then
	Add(ansv,i[1]);
	Add(ansl,labs[j]);

	else
	Add(ansv,i[2]);	
	Add(ansl,labs[j]);

	fi;
fi;	
od;
return [ansv,ansl];
end);




InstallMethod(SemiEdges,
[IsEdgeLabeledGraph],
function(g)
return Filtered(Edges(g), i -> Size(i) = 1);
end);






InstallMethod(LabeledSemiEdges,
[IsEdgeLabeledGraph],
function(g)
local anse, ansl, eds, labs, i;
anse:=[];
ansl:=[];
eds:=Edges(g);
labs:=Labels(g);
for i in [1..Size(eds)] do
if Size(eds[i]) = 1 then
Add(anse, eds[i]);
Add(ansl, labs[i]);
fi;
od;
return [anse,ansl];
end);



InstallMethod(LabeledDarts,
	[IsEdgeLabeledGraph],
	function(g)
	local labs, eds, i, labdarts;
	labs:=g!.labels;
	eds:=g!.edges;
	labdarts:=[];
	for i in [1..Size(eds)] do
	if Size(eds[i]) = 2 then
	Add(labdarts,[eds[i],labs[i]]);
	Add(labdarts,[Reversed(eds[i]),labs[i]]);
	fi;
	if Size(eds[i]) = 1 then
	Add(labdarts,[eds[i],labs[i]]);
	fi;
	od;
	return labdarts;
	end);



InstallMethod(DerivedGraph,
	[IsList, IsList,IsList],
	function(verts, labdarts,voltages)
	local G, L, C,  newdarts, newlabels, g, h, i,S ;

	# Want to use CtoL for speed.  
	# (i,j) to k.  i is place in L, j is place in verts.
	# Currently uses Position in cartesian product

	G:=Group(voltages);
	L:=List(G);
	C:=Cartesian(verts,L);
	S:=Size(L)*Size(verts);
	newdarts:=[];
	newlabels:=[];
	for i in [1..Size(labdarts)] do	
	g:=voltages[i];
	for h in L do
	if Size(labdarts[i][1]) = 2 then
		#call this dart (u to v) 
		#want a new dart (u,h) to (v,gh)
		Add(newdarts, 
		[Position(C,[labdarts[i][1][1],h]), Position(C,[labdarts[i][1][2],g*h])]);
		Add(newlabels,labdarts[i][2]);
	fi;
	if Size(labdarts[i][1]) = 1 then
		#call this dart (u to u) 
		#want a new dart (u,h) to (v,gh)
		Add(newdarts, 
		[Position(C,[labdarts[i][1][1],h]), Position(C,[labdarts[i][1][1],g*h])]);
		Add(newlabels,labdarts[i][2]);
	fi;
	od;
	od;
	return EdgeLabeledGraphFromEdges([1..S],newdarts,newlabels);

	end);





InstallMethod(ViewGraph,
[IsEdgeLabeledGraph, IsString],
function(g,s)
local SE, extra, ans, verts, eds, labs, bad, i, j, A;
verts:=Vertices(g);
if s = "Mathematica" or s = "mathematica" or s = "MATHEMATICA" then
ans:="Mathematica Code: GraphPlot[{";

extra:=Size(verts)+1;
eds:=Edges(g);
labs:=Labels(g);
for i in [1..Size(eds)-1] do
if Size(eds[i]) =2 then
ans:=Concatenation(ans,"{", String( eds[i][1]), " ->",  String(eds[i][2]), " , " , String(labs[i]), " },");
elif Size(eds[i]) =1 then
ans:=Concatenation(ans,"{", String( eds[i][1]), " ->",  String(extra), " , " , String(labs[i]), " },");
extra:=extra+1;
fi;
od;
i:=Size(eds);
if Size(eds[i]) =2 then
ans:=Concatenation(ans,"{", String( eds[i][1]), " ->",  String(eds[i][2]), " , " , String(labs[i]), " }},");
elif Size(eds[i]) =1 then
ans:=Concatenation(ans,"{", String( eds[i][1]), " ->",  String(extra), " , " , String(labs[i]), " }},");
extra:=extra+1;
fi;
ans:=Concatenation(ans, "VertexLabels -> Placed[Automatic, Center], MultiedgeStyle -> True,");
if Size(SemiEdges(g)) = 0 then
ans:=Concatenation(ans,"VertexSize -> .5] ");
else
ans:=Concatenation(ans,"VertexSize -> {");
for i in [1..Size(verts)] do
ans:=Concatenation(ans,  String(verts[i]), "->.5 ,");
od;
for i in [(Size(verts)+1)..(extra-2)] do
ans:=Concatenation(ans,  String(i), "->0 ,");
od;
ans:=Concatenation(ans,  String(extra-1), "->0 }]");
fi;
return ans;
elif s = "Sage" or s = "sage" or s = "SAGE" then
 extra:=Size(verts)+1;
 ans:="";
 SE:=LabeledSemiEdges(g);
 verts:=Vertices(g);
 ans:=Concatenation(ans,"G= Graph({");
 for i in [1..Size(verts)-1] do
 A:= LabeledAdjacentVertices( g, i );;
 ans:=Concatenation(ans,String(verts[i]));
 ans:=Concatenation(ans,":{");
 if Size(SE[1]) > 0 then
 for j in [1..Size(SE[1])] do
  if i in SE[1][j] then
 ans:=Concatenation(ans,String(extra));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(SE[2][j]));
 ans:=Concatenation(ans,"', ");
  extra:=extra+1;
 fi;
od;
 fi;

 for j in [1..Size(A[1])-1] do
 ans:=Concatenation(ans,String(A[1][j]));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(A[2][j]));
 ans:=Concatenation(ans,"', ");
 od;
 ans:=Concatenation(ans,String(A[1][Size(A[1])]));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(A[2][Size(A[1])]));
 ans:=Concatenation(ans," ' },");
 od;

 ans:=Concatenation(ans,String(verts[Size(verts)]));
 ans:=Concatenation(ans,":{");

 if Size(SE[1]) > 0 then
 for j in [1..Size(SE[1])] do
  if verts[Size(verts)] in SE[1][j] then
 ans:=Concatenation(ans,String(extra));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(SE[2][j]));
 ans:=Concatenation(ans,"', ");
  extra:=extra+1;
 fi;
od;
fi;


 A:= LabeledAdjacentVertices( g, verts[Size(verts)] );
 for j in [1..Size(A[1])-1] do
 ans:=Concatenation(ans,String(A[1][j]));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(A[2][j]));
 ans:=Concatenation(ans,"' ,");
 od;
 ans:=Concatenation(ans,String(A[1][Size(A[1])]));
 ans:=Concatenation(ans,": ' ");
 ans:=Concatenation(ans,String(A[2][Size(A[1])]));

 ans:=Concatenation(ans,"' }})");
 Print( "Sage Code:");
if Size(SE[1]) > 0 then
Print( " (SemiEdges shown with red placeholder vertices):"   );
fi;
	
Print("\n");

 Print(ans);
 Print(" \n");
 Print("G.show(edge_labels=True");
 if Size(SE[1]) > 0 then
 Print(", vertex_colors={'red': [ ");
 for i in [(Size(verts)+1)..(extra-2)] do
 Print(String(i));
 Print(",");
 od;
 Print(String(extra-1));
 Print("]}");
 fi;
 Print(")"); 
 return;

else
bad:="That graph visualization is not supported yet. Currently Sage and Mathematica are supported.";
return bad;
fi;
 end);


InstallOtherMethod(ViewGraph,
[IsEdgeLabeledGraph],
function(g)
return ViewGraph(g,"Mathematica");
end);




InstallMethod(ViewGraph,
[IsObject, IsString],
function(g,s)
local ans, eds, verts, A, i, j,bad;
if not IsGraph(g) then
return "Not a graph";
fi;
if s = "Sage" or s = "sage" or s = "SAGE" then
 ans:="";
 verts:=Vertices(g);
 ans:=Concatenation(ans,"G= Graph({");
 for i in [1..Size(verts)-1] do
 A:=Adjacency( g, i );;
 ans:=Concatenation(ans,String(verts[i]));
 ans:=Concatenation(ans,":[");
 for j in [1..Size(A)-1] do
 ans:=Concatenation(ans,String(A[j]));
 ans:=Concatenation(ans,",");
 od;
 if Size(A) > 0 then
 ans:=Concatenation(ans,String(A[Size(A)]));
 fi;
 ans:=Concatenation(ans,"],");
 od;
 ans:=Concatenation(ans,String(verts[Size(verts)]));
 ans:=Concatenation(ans,":[");
 A:=Adjacency( g, verts[Size(verts)] );
 for j in [1..Size(A)-1] do
 ans:=Concatenation(ans,String(A[j]));
 ans:=Concatenation(ans,",");
 od;
 if Size(A) > 0 then
 ans:=Concatenation(ans,String(A[Size(A)]));
 fi;
 ans:=Concatenation(ans,"]})");
 Print( "Sage Code:  Follow by P= G.plot();  P.show() \n" );
 Print(ans);
 Print(" \n");
Print("P= G.plot()  \n");
Print("P.show() 	\n");
## IN SAGE Follow with:
##  P= G.plot()
##  P.show() 
return;
##OUTPUT IS CODE TO COPY INTO MATHEMATICA.
elif s = "Mathematica" or s = "mathematica" or s = "MATHEMATICA" then
ans:= "GraphPlot3D[{";
verts:=Vertices(g);
eds:=UndirectedEdges(UnderlyingGraph(g));
for i in [1..Size(eds)-1] do
if Size(eds[i]) =2 then
ans:=Concatenation(ans, String( eds[i][1]), " ->",  String(eds[i][2]),   " ,");
elif Size(eds[i]) =1 then
ans:=Concatenation(ans, String( eds[i][1]), " ->",  String(eds[i][1]),   " ,");
fi;
od;
i:=Size(eds);
if Size(eds[i]) =2 then
ans:=Concatenation(ans, String( eds[i][1]), " ->",  String(eds[i][2]),  " },");
elif Size(eds[i]) =1 then
ans:=Concatenation(ans, String( eds[i][1]), " ->",  String(eds[i][1]),  " },");
fi;
ans:=Concatenation(ans, "VertexLabels -> Placed[Automatic, Center], VertexSize -> .5, MultiedgeStyle -> True] ");
Print( "Mathematica code: \n" );
return ans;
else
bad:="That graph visualization is not supported yet. Currently Sage and Mathematica are supported.";
return bad;
fi;
 end);

##  P= G.plot()
##  P.show() 


InstallOtherMethod(ViewGraph,
[IsObject],
function(g)
return ViewGraph(g,"Mathematica");
end);



InstallMethod(ConnectionGroup,
	[IsEdgeLabeledGraph],
	function(F)
	local rank, gens, i, labed, ed;
	rank:=Size(Set(Labels(F)));
	gens:=[];
	for i in [1..rank] do
	gens[i]:=();
	od;
	labed:=LabeledEdges(F);
	for ed in labed do
	if Size(ed[1]) = 2 and (ed[1][1] < ed[1][2]) then
		gens[ed[2]+1]:=gens[ed[2]+1]*( ed[1][1] , ed[1][2]);
	fi;
	od;
	return Group(gens);
	end);

