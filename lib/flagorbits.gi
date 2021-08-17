InstallMethod(SymmetryTypeGraph,
	[IsManiplex],
	function(m)
	local r, gens, c, stab, norm, stg, vertnew, edgesnew, labelsnew, i, j ;
	c:=ConnectionGroup(m);
	stab := Stabilizer(c, 1);
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
	[IsManiplex],
	function(M)
	local numberOfFlagOrbits, g, h, n;
	
	numberOfFlagOrbits := ComputeAttr(M, NumberOfFlagOrbits);
	if numberOfFlagOrbits = fail then
		if IsReflexibleManiplexAutGpRep(M) then 
			numberOfFlagOrbits := 1; 
		elif IsManiplexQuotientRep(M) then
			g := AutomorphismGroup(M!.parent);
			h := M!.subgroup;
			n := Normalizer(g, h);
			numberOfFlagOrbits := Index(g, n);
		elif Size(M) < infinity then
			numberOfFlagOrbits :=  Size(M) / Size(AutomorphismGroup(M));
		else
			numberOfFlagOrbits := Size(Vertices(SymmetryTypeGraph(M)));
		fi;
	fi;
	
	return numberOfFlagOrbits;
	end);

InstallMethod(FlagOrbitRepresentatives,
	[IsManiplex],
	function(M)
	local c, reps, norm, stab, flags, i;
	if IsReflexibleManiplexAutGpRep(M) then
		return [1];
	else
		c := ConnectionGroup(M);
		reps := [];
		flags := [1..Size(M)];
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

InstallMethod(IsReflexible,
	[IsManiplex],
	function(M)
	local val;
	val := (NumberOfFlagOrbits(M) = 1);
	return val;
	end);

InstallMethod(IsChiral,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	return (NumberOfFlagOrbits(M) = 2);
	end);

InstallMethod(IsChiral,
	[IsManiplex],
	function(M)
	local stg, val;
	stg := SymmetryTypeGraph(M);
	val := Size(Vertices(stg)) = 2 and ForAll(Edges(stg), e -> Size(e) = 2);
	return val;
	end);

InstallMethod(IsRotary,
	[IsManiplex],
	function(M)
	local val;
	val := IsReflexible(M) or IsChiral(M);
	return val;
	end);
	
