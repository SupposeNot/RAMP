
InstallMethod(Flags,
	[IsPremaniplex],
	function(M)
	return MovedPoints(ConnectionGroup(M));
	end);

InstallMethod(BaseFlag,
	[IsPremaniplex],
	function(M)
	if HasConnectionGroup(M) then
		return SmallestMovedPoint(ConnectionGroup(M));
	else
		return 1;
	fi;
	end);
	
InstallMethod(SymmetryTypeGraph,
	[IsPremaniplex],
	function(m)
	local r, gens, c, stab, norm, stg, vertnew, edgesnew, labelsnew, i, j ;
	c:=ConnectionGroup(m);
	stab := Stabilizer(c, BaseFlag(m));
	norm := Normalizer(c, stab);
	stg := Image(FactorCosetAction(c,norm));
		if Size(stg) = 1 then
			vertnew:=[1];
			edgesnew:=[];
			labelsnew:=[];
			for r in [1..Rank(m)] do
				Add(edgesnew, [1]);
				Add(labelsnew,r-1);
				# Labels go from 0 to r-1
			od;
			return EdgeLabeledGraphFromEdges([1], edgesnew,labelsnew);
		fi;
	gens:=GeneratorsOfGroup(stg);
	vertnew:=MovedPoints(stg);
	edgesnew:=[];
	labelsnew:=[];
	for r in [1..Rank(m)] do
	for i in vertnew do
		j:=i^gens[r];
		if j < i then
			Add(edgesnew,[j,i]);			
			Add(labelsnew,r-1);
			# Labels go from 0 to r-1

		
		elif j = i then
			Add(edgesnew, [i]);
			Add(labelsnew,r-1);
			# Labels go from 0 to r-1
		fi;
	od;
	od;
	return EdgeLabeledGraphFromEdges(vertnew, edgesnew,labelsnew);
end);


InstallOtherMethod(SymmetryTypeGraph,
	[IsPremaniplex,IsGroup],
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

InstallMethod(NumberOfFlagOrbits,
	[IsPremaniplex],
	function(M)
	local numberOfFlagOrbits, g, h, n;
	
	numberOfFlagOrbits := ComputeAttr(M, NumberOfFlagOrbits);
	if numberOfFlagOrbits = fail then
		if HasIsReflexible(M) and IsReflexible(M) then 
			numberOfFlagOrbits := 1; 
		elif IsManiplexQuotientRep(M) then
			g := AutomorphismGroup(M!.parent);
			h := M!.subgroup;
			n := Normalizer(g, h);
			numberOfFlagOrbits := Index(g, n);
		elif HasSize(M) and Size(M) < infinity then
			numberOfFlagOrbits :=  Size(M) / Size(AutomorphismGroup(M));
		else
			numberOfFlagOrbits := Size(Vertices(SymmetryTypeGraph(M)));
		fi;
	fi;
	
	return numberOfFlagOrbits;
	end);

InstallMethod(FlagOrbitRepresentatives,
	[IsPremaniplex],
	function(M)
	local c, reps, norm, stab, flags, i;
	if HasIsReflexible(M) and IsReflexible(M) then
		return [BaseFlag(M)];
	else
		c := ConnectionGroup(M);
		reps := [];
		flags := MovedPoints(c);
		while not(IsEmpty(flags)) do
			i := First(flags);
			Add(reps, i);
			stab := Stabilizer(c, i);
			norm := Normalizer(c, stab);
			flags := Difference(flags, Orbit(norm, i));
		od;
		return reps;
	fi;
	end);

InstallMethod(FlagOrbitsStabilizer,
	[IsPremaniplex],
	function(M)
	local c, a, orbs, s;
	c:=ConnectionGroup(M); a:=AutomorphismGroupOnFlags(M);
	orbs:=List(Orbits(a),AsSet);
	s:=Intersection(List(orbs,x->Stabilizer(c,x,OnSets)));
	return s;
	end);

InstallMethod(IsReflexible,
	[IsPremaniplex],
	function(M)
	local val;
	val := (NumberOfFlagOrbits(M) = 1);
	return val;
	end);

InstallOtherMethod(IsRegular,
	[IsPremaniplex],
	function(M)
	return IsReflexible(M);
	end);

InstallMethod(IsChiral,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local n, gens, f, g, h, i, rels, h2, genr;
	
	if HasIsReflexible(M) and IsReflexible(M) then
		return false;
	fi;
	
	# The strategy is to add a new generator r0 that acts as conjugation by
	# r0 should. If this works, then we have a rotation group of an orientably
	# regular polytope. If not, then we have a chiral polytope.
	
	n := Rank(M);
	g := Image(IsomorphismFpGroupByGenerators(RotationGroup(M), GeneratorsOfGroup(RotationGroup(M))));
	gens := List([1..n-1], i -> Concatenation("s", String(i)));
	Add(gens, "r0");
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r, FreeGeneratorsOfFpGroup(g)));

	# The new generator r0 is an involution and should satisfy:
	# r0 s1 r0 s1 = 1.
	# r0 s2 r0 s1 s2 s1^-1 = 1.
	# r0 si r0 si^-1 = 1 for i >= 3.
	f := FreeGroup(gens);
	Add(rels, [n, n]);
	Add(rels, [n, 1, n, 1]);
	if n > 2 then
		Add(rels, [n, 2, n, 1, 2, -1]);
	fi;
	for i in [3..n-1] do
		Add(rels, [n, i, n, -i]);
	od;
	
	rels := List(rels, r -> AbstractWordTietzeWord(r, GeneratorsOfGroup(f)));
	h := f / rels;
	
	# Now rearrange the generators to be the usual r0, r1, etc.
	
	genr := function(k)
		if k = 0 then
			return GeneratorsOfGroup(h)[n];
		else
			return genr(k-1) * GeneratorsOfGroup(h)[k];
		fi;
		end;
	
	h2 := Group(List([0..n-1], i -> genr(i)));

	return Size(h2) <> 2*Size(g);
	end);

InstallMethod(IsChiral,
	[IsPremaniplex],
	function(M)
	local stg, val;
	stg := SymmetryTypeGraph(M);
	val := Size(Vertices(stg)) = 2 and ForAll(Edges(stg), e -> Size(e) = 2);
	return val;
	end);

InstallMethod(IsTotallyChiral,
	[IsPremaniplex],
	function(M)
	local g, g1, g2;
	
	if not(IsChiral(M)) then
		return false;
	else
		g1 := RotationGroup(M);
		g2 := RotationGroup(EnantiomorphicForm(M));
		g := Comix(g1,g2);
		return Size(g) = 1;
	fi;
	
	end);

InstallMethod(IsRotary,
	[IsPremaniplex],
	function(M)
	local val;
	val := IsReflexible(M) or IsChiral(M);
	return val;
	end);
	

InstallMethod(FlagOrbits,
	[IsPremaniplex],
	function(M)
	local reps, c, flags, orbits, i, stab, norm;
		reps:= FlagOrbitRepresentatives(M);
		c := ConnectionGroup(M);
		flags := [1..Size(M)];
                orbits:=[];
		for i in reps do
			stab := Stabilizer(c, i);
			norm := Normalizer(c, stab);
			Add(orbits, Orbit(norm, i));
		od;
		return orbits;
	end);


