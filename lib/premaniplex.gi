InstallMethod(Premaniplex,
	[IsGroup],
	function(g)
	if not(IsSggi(g)) then
		Error("g must be an Sggi!");
	else
		return PremaniplexNC(g);
	fi;
	end);


InstallMethod(PremaniplexNC,
	[IsGroup],
	function(g)
	local pm;
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexConnGpRep),  	    rec(conn_gp:=g, flags:=MovedPoints(g), rank:=Size(GeneratorsOfGroup(g))));
	SetConnectionGroup(pm,g);
	SetSize(pm, NrMovedPoints(g));
	return(pm);
	end);


InstallMethod(Premaniplex,
	[IsEdgeLabeledGraph],
	function(g)
	local pm, c;
	c:=ConnectionGroup(g);
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexGraphRep),  	    rec(conn_gp:=c, flags:=Vertices(g), rank:=Size(Set(Labels(g)))));
	SetConnectionGroup(pm,c);
	SetSize(pm, NrMovedPoints(c));
	return(pm);
	end);



InstallMethod( ViewObj,
	[IsPremaniplex],
	function(pm)
	if Size(pm!.flags) = 1 then
	Print(Concatenation("Premaniplex of rank ", String(pm!.rank), " with ", String(Size(pm!.flags)), " flag"));
	else
		Print(Concatenation("Premaniplex of rank ", String(pm!.rank), " with ", String(Size(pm!.flags)), " flags"));
	fi;
	end);



InstallMethod(STG1,
	[IsInt],
	function(n)
	local labedges, i;
	labedges:=[];
	for i in [0..n-1] do
		Add(labedges,[[1],i]);
	od;
	return Premaniplex(EdgeLabeledGraphFromLabeledEdges(labedges));
	end);


InstallMethod(STG2,
	[IsInt,IsList],
	function(n,l)
	local labedges, i;
	labedges:=[];
	for i in [0..n-1] do
		if i in l then
		Add(labedges,[[1],i]);
		Add(labedges,[[2],i]);
		else
		Add(labedges,[[1,2],i]);
		fi;
	od;
	return Premaniplex(EdgeLabeledGraphFromLabeledEdges(labedges));
	end);


InstallMethod(STG3,
	[IsInt,IsInt],
	function(n,i)
	local labedges,l;
	labedges:=[];
	Add(labedges,[[1,2], i]);
	Add(labedges,[[2,3], i+1]);
	Add(labedges,[[2,3], i-1]);
	Add(labedges,[[1], i-1]);
	Add(labedges,[[1], i+1]);
	Add(labedges,[[3], i]);
	for l in [0..n-1] do
		if (l <> i) and (l<> (i+1)) and (l<> (i-1)) then
			Add(labedges,[[1],l]);
			Add(labedges,[[2],l]);
			Add(labedges,[[3],l]);
		fi;
	od;
	return Premaniplex(EdgeLabeledGraphFromLabeledEdges(labedges));
	end);


InstallMethod(STG3,
	[IsInt, IsInt, IsInt],
	function(n,i,j)	
	local labedges, l;
	if j <> i+1 then
	return fail;
	fi;
	labedges:=[];
	Add(labedges,[[1,2], i]);
	Add(labedges,[[2,3], i+1]);
	Add(labedges,[[1], i+1]);
	Add(labedges,[[3], i]);
	for l in [0..n-1] do
		if (l <> i) and (l<> (i+1)) then
			Add(labedges,[[1],l]);
			Add(labedges,[[2],l]);
			Add(labedges,[[3],l]);
		fi;
	od;
	return Premaniplex(EdgeLabeledGraphFromLabeledEdges(labedges));
	end);





InstallMethod(FlagGraph,
	[IsPremaniplex],
	function(m)
	local c, gens, V, labedges, i, j,g;
	c:=ConnectionGroup(m);
	gens:=GeneratorsOfGroup(c);
	V:=MovedPoints(c);
	labedges:=[];
	if Size(V) = 0 then
	for j in [1..Size(gens)] do
		Add(labedges,[[1],j-1]);
	od;
	else
	for i in V do
	for j in [1..Size(gens)] do
		g:=gens[j];
		if i^g = i then
		Add(labedges,[[i],j-1]);
		elif i<i^g then
		Add(labedges,[[i,i^g],j-1]);
		fi;
	od;
	od;
	fi;
	return EdgeLabeledGraphFromLabeledEdges(labedges);
	end);

