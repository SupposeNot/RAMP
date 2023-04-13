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
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexConnGpRep),  	    rec(conn_gp:=g, flags:=MovedPoints(g), rank:=Size(GeneratorsOfGroup(g)), attr_computers := NewDictionary(Size, true)));
	SetConnectionGroup(pm,g);
	SetRankManiplex(pm, pm!.rank);	
	SetSize(pm, NrMovedPoints(g));
	return(pm);
	end);


InstallMethod(Premaniplex,
	[IsEdgeLabeledGraph],
	function(g)
	local pm, c;
	c:=ConnectionGroup(g);
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexGraphRep),  	    rec(conn_gp:=c, flags:=Vertices(g), rank:=Size(Set(Labels(g))), attr_computers := NewDictionary(Size, true)));
	SetConnectionGroup(pm,c);
	SetRankManiplex(pm, pm!.rank);	
	if NrMovedPoints(c) = 0 then
		SetSize(pm, 1);
	else
		SetSize(pm, NrMovedPoints(c));
	fi;
	return(pm);
	end);

InstallMethod(ReflexiblePremaniplexNC,
	[IsGroup],
	function(autgp)
	local n, p;
	n := Size(GeneratorsOfGroup(autgp));

	p := Objectify( NewType( PremaniplexFamily, IsPremaniplex and IsReflexibleManiplexAutGpRep), rec( aut_gp := autgp, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankManiplex(p, n);
	SetAutomorphismGroup(p, autgp);
	if IsFpGroup(autgp) then
		SetAutomorphismGroupFpGroup(p, autgp);
	elif IsPermGroup(autgp) then
		SetAutomorphismGroupPermGroup(p, autgp);
	fi;
	SetIsReflexible(p, true);
	if HasSchlafliSymbol(autgp) then SetSchlafliSymbol(p, SchlafliSymbol(autgp)); fi;

	return p;
	end);

InstallMethod(ReflexiblePremaniplex,
	[IsGroup],
	function(autgp)
	if ValueOption("no_check") = true or IsSggi(autgp) then
		return ReflexiblePremaniplexNC(autgp);
	else
		Error("The given group is not an Sggi.");
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




InstallMethod(LabeledDarts,
	[IsPremaniplex],
	function(p)
	return LabeledDarts(FlagGraph(p));
	end);




InstallMethod(LabeledDart,
	[IsPremaniplex, IsInt,IsInt],
	function(P, lab, startvert)
	local LD, ans;
	LD:=LabeledDarts(P);
	ans:=Filtered(LD, i-> ( i[2] = lab and i[1][1] = startvert)); 
	if Size(ans) = 0 then
	return fail;
	else 
	return ans[1];
	fi;
	end);


