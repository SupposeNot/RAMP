InstallMethod(SymmetryTypeGraph,
	[IsManiplex],
	function(m)
	local c, gamma, vert, ed, lab, labnew, A, O, vertnew, ednew, trips, edfixed, labfixed, r, i ,j, k , t;
	c:=ConnectionGroup(m);
	gamma:=FlagGraph(m);
	vert:=gamma!.vertices;
	ed:=gamma!.edges;
	lab:=gamma!.labels;
	labnew:=[];
	A:=EdgeLabelPreservingAutomorphismGroup(gamma);
	O:=Orbits(A);		
	vertnew:=[1..Size(O)];
	ednew:=[];

	for r in Set(lab) do
	for i in [1..Size(O)] do
	for j in [i..Size(O)] do
		for k in [1..Size(ed)] do
			t:=ed[k];
			if (t[1] in O[i]) and (t[2] in O[j]) then
				Add(ednew,[i,j]);
				Add(labnew, lab[k]);
			fi;
		od;
	od;	
	od;
	od;
	trips:=[];
	for i in [1..Size(ednew)] do
	Add(trips,[ednew[i][1],ednew[i][2],labnew[i]]);
	od;
	trips:=Set(trips);
	edfixed:=[];
	labfixed:=[];
	for i in [1..Size(trips)] do
	Add(edfixed,[trips[i][1],trips[i][2]]);
	Add(labfixed,trips[i][3]);
	od;
	Apply(edfixed, i -> Set(i)); 
	return EdgeLabeledGraphFromEdges(vertnew,edfixed,labfixed);
end);


InstallOtherMethod(SymmetryTypeGraph,
	[IsManiplex,IsGroup],
	function(m,A)
	local c, gamma, vert, ed, lab, labnew, O, vertnew, ednew, trips, edfixed, labfixed, r, i ,j, k , t;
	c:=ConnectionGroup(m);
	gamma:=FlagGraph(m);
	vert:=gamma!.vertices;
	ed:=gamma!.edges;
	lab:=gamma!.labels;
	labnew:=[];
	O:=Orbits(A);		
	vertnew:=[1..Size(O)];
	ednew:=[];
	for r in Set(lab) do
	for i in [1..Size(O)] do
	for j in [i..Size(O)] do
		for k in [1..Size(ed)] do
			t:=ed[k];
			if (t[1] in O[i]) and (t[2] in O[j]) then
				Add(ednew,[i,j]);
				Add(labnew, lab[k]);
			fi;
		od;
	od;	
	od;
	od;
	trips:=[];
	for i in [1..Size(ednew)] do
	Add(trips,[ednew[i][1],ednew[i][2],labnew[i]]);
	od;
	trips:=Set(trips);
	edfixed:=[];
	labfixed:=[];
	for i in [1..Size(trips)] do
	Add(edfixed,[trips[i][1],trips[i][2]]);
	Add(labfixed,trips[i][3]);
	od;
	Apply(edfixed, i -> Set(i)); 
	return EdgeLabeledGraphFromEdges(vertnew,edfixed,labfixed);
end);



# TODO: This is currently broken for rotary maniplexes
# I really want orbs to be the action of the automorphism
# group on the _flags_.
# Wait until graph code is done
# InstallMethod(SymmetryTypeGraph,
#	[IsManiplex],
#	function(p)
#	local ag, cg, orbs, k, perms, i, r, rp, orb, new_orb;
#	if IsReflexibleManiplex(p) then
#		return List([1..Rank(p)], i -> ());
#	fi;
#	
#	ag := AutomorphismGroupPermGroup(p);
#	orbs := List(Orbits(ag), o -> Set(o));
#	k := Size(orbs);
#	cg := ConnectionGroup(p);
#	perms := [];
#	
#	# There is probably a built-in way to get this, but I'm not finding it today
#	for r in GeneratorsOfGroup(cg) do
#		rp := ();
#		for i in [1..k] do
#			# Next line prevents me from adding (a, b) and (b, a) to rp, which would cancel out.
#			if i^rp = i then
#				orb := orbs[i];
#				new_orb := OnSets(orb, r);
#				if new_orb <> orb then
#					rp := rp * (i, Position(orbs, new_orb));
#				fi;
#			fi;
#		od;
#		Add(perms, rp);
#	od;
#
#	return perms;
#	
#	end);

InstallMethod(NumberOfFlagOrbits,
	[IsManiplex and IsManiplexQuotientRep],
	function(M)
	local n, g, h;
	g := AutomorphismGroup(M!.parent);
	h := M!.subgroup;
	n := Normalizer(g, h);
	return Index(g, n);
	end);
	
	
# After SymmetryTypeGraph is fixed, we probably want to cut out
# the IsFinite line, since for some maniplexes, this will try to
# calculate the size, which can be time-consuming.
InstallMethod(NumberOfFlagOrbits,
	[IsManiplex],
	function(M)
	local n;
	if IsReflexibleManiplexAutGpRep(M) then 
		n := 1; 
	elif Size(M) < infinity then
		return Size(M) / Size(AutomorphismGroup(M));
	else
		n := Size(Vertices(SymmetryTypeGraph(M)));
	fi;
	
	if HasDual(M) then
		SetNumberOfFlagOrbits(Dual(M), n);
	fi;
	return n;
	end);

InstallMethod(FlagOrbitRepresentatives,
	[IsManiplex],
	function(M)
	local ag;
	if IsReflexible(M) then
		return [1];
	else
		# This should eventually just use the symmetry type graph.
		ag := AutomorphismGroupOnFlags(M);
		return List(Orbits(ag), o -> First(o));
	fi;
	end);

InstallMethod(IsReflexible,
	[IsManiplex],
	function(M)
	local val;
	val := (NumberOfFlagOrbits(M) = 1);
	if HasDual(M) then
		SetIsReflexible(Dual(M), val);
	fi;
	return val;
	end);

InstallMethod(IsChiral,
	[IsManiplex],
	function(M)
	local stg, val;
	stg := SymmetryTypeGraph(M);
	val := Size(Vertices(stg)) = 2 and ForAll(Edges(stg), e -> Size(e) = 2);
	if HasDual(M) then
		SetIsChiral(Dual(M), val);
	fi;	
	return val;
	end);

InstallMethod(IsRotary,
	[IsManiplex],
	function(M)
	local val;
	val := IsReflexible(M) or IsChiral(M);
	if HasDual(M) then
		SetIsRotary(Dual(M), val);
	fi;
	return val;
	end);
	
