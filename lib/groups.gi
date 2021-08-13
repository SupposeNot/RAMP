
InstallMethod(AutomorphismGroup, 
	[IsManiplex],
	function(M)
	local c, stab, norm;
	c := ConnectionGroup(M);
	stab := Stabilizer(c,1);
	norm := Normalizer(c, stab);
	return norm/stab;
	end);

InstallMethod(AutomorphismGroup, 
	[IsManiplex and IsReflexibleManiplexAutGpRep],
	M -> M!.aut_gp);

InstallMethod(AutomorphismGroup,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local n, gens, f, g, h, i, rels, h2, genr;
	
	# The strategy is to add a new generator r0 that acts as conjugation by
	# r0 should. If this works, then we have a rotation group of an orientably
	# regular polytope. If not, then we have a chiral polytope, and the automorphism
	# group is just the rotation group.
	
	n := Rank(M);
	g := Image(IsomorphismFpGroup(RotationGroup(M)));
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
	
	if Size(h2) = 2 * Size(g) then
		# We have an orientably regular polytope
		SetIsReflexible(M, true);
		SetIsChiral(M, false);
		return StandardizeSggi(h2);
	else
		# We have a chiral polytope
		SetIsReflexible(M, false);
		SetIsChiral(M, true);
		return g;
	fi;
	
	end);

# TODO: Currently we always rewrite this as a quotient of a universal Coxeter group.
# Is that what we actually want for non-reflexible maniplexes?
InstallMethod(AutomorphismGroupFpGroup, 
	[IsManiplex],
	function(M)
	local g, fp, w, rels;
	g := AutomorphismGroup(M);
	if IsFpGroup(g) then
		return g;
	else
		fp := Image(IsomorphismFpGroupByGeneratorsNC(g, GeneratorsOfGroup(g), "Q"));
		
		# Retranslate everything in terms of r0, r1, etc.
		w := UniversalSggi(Rank(M));
		rels := RelatorsOfFpGroup(fp);
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
		fp := FactorGroupFpGroupByRels(w, rels);
		return fp;
	fi;
	end);

InstallMethod(AutomorphismGroupPermGroup, 
	[IsManiplex],
	function(M)
	local g;
	g := AutomorphismGroup(M);
	if IsPermGroup(g) then
		return g;
	else
		return Image(IsomorphismPermGroup(g));
	fi;
	end);
	
InstallMethod(AutomorphismGroupOnFlags, 
	[IsManiplex],
	function(M)
	local N, c, stab, norm, orb, auts, i, w, aut, notMoved, j, x, plist, agf, cggens, gens;
	N := Size(M);
	c := ConnectionGroup(M);
	stab := Stabilizer(c, 1);
	norm := Normalizer(c, stab);
	orb := Difference(Orbit(norm, 1), [1]);
	auts := [];
	
	while not(IsEmpty(orb)) do
		i := First(orb);
		plist := [i];
		for j in [2..N] do
			x := RepresentativeAction(c, 1, j);
			plist[j] := i^x;
		od;
		Add(auts, PermList(plist));
		orb := Difference(orb, Orbit(Group(auts), 1));
	od;
	agf := Group(auts);
	if IsReflexibleManiplexAutGpRep(M) then
		cggens := GeneratorsOfGroup(ConnectionGroup(M));
		gens := List([1..Rank(M)], i -> RepresentativeAction(agf, 1, 1^cggens[i]));
		agf := Group(gens);
	fi;
	return agf;
	end);
	
AgOnFlags := function(M)
	local N, c, stab, norm, orb, auts, i, w, aut, notMoved, j, x, plist;
	N := Size(M);
	c := ConnectionGroup(M);
	stab := Stabilizer(c, 1);
	norm := Normalizer(c, stab);
	orb := Difference(Orbit(norm, 1), [1]);
	auts := [];
	
	for i in orb do
		plist := [i];
		for j in [2..N] do
			x := RepresentativeAction(c, 1, j);
			plist[j] := i^x;
		od;
		Add(auts, PermList(plist));
	od;
	return Group(auts);
	end;
	
InstallMethod(RotationGroup,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	M -> M!.rot_gp);
	
InstallMethod(RotationGroup,
	[IsManiplex],
	function(M)
	local gens, n, i, new_gens;
	gens := GeneratorsOfGroup(AutomorphismGroup(M));
	n := Rank(M);
	new_gens := [];
	for i in [1..n-1] do
		Add(new_gens, gens[i]*gens[i+1]);
	od;
	return Group(new_gens);
	end);

InstallMethod(ConnectionGroup,
	[IsManiplex],
	function(M)
	local connectionGroup, g, h, w, wgens, wpgens, wp, hom, ker;
	
	connectionGroup := ComputeAttr(M, ConnectionGroup);
	if connectionGroup = fail then
		if IsReflexibleManiplexAutGpRep(M) or IsRotaryManiplexRotGpRep(M) and IsReflexible(M) then
			if Size(AutomorphismGroup(M)) = infinity then
				connectionGroup := fail;
			else
				connectionGroup := Action(AutomorphismGroup(M), AutomorphismGroup(M), OnLeftInverse, "surjective");
			fi;
		elif IsManiplexPosetRep(M) then
			connectionGroup := ConnectionGroup(M!.poset);
		elif IsManiplexConnGpRep(M) then
			connectionGroup := M!.conn_gp;
		elif IsManiplexQuotientRep(M) then
			g := AutomorphismGroup(M!.parent);
			h := M!.subgroup;
			connectionGroup := Image(FactorCosetAction(g, h));
		elif IsRotaryManiplexRotGpRep(M) then
			g := AutomorphismGroup(M);
			if Size(g) = infinity then
				connectionGroup := fail;
			else
				# A chiral polytope has a flag-stabilizer K that is normal in W+ but not W.
				# So we find the flag-stabilizer, and then use it to build the connection group.
				w := UniversalSggi(Rank(M));
				wgens := GeneratorsOfGroup(w);
				wpgens := List([1..Rank(M)-1], i -> wgens[i]*wgens[i+1]);
				wp := Subgroup(w, wpgens);
				hom := GroupHomomorphismByImagesNC(wp, g, wpgens, GeneratorsOfGroup(g));
				ker := Kernel(hom);
				connectionGroup := Image(FactorCosetAction(w, ker));
			fi;
		fi;
	fi;
	
	return connectionGroup;
	end);

InstallMethod(EvenConnectionGroup,
	[IsManiplex],
	function(M)
	local c, gens, newgens;
	c := ConnectionGroup(M);
	gens := GeneratorsOfGroup(c);
	newgens := List([1..Size(gens)-1], i -> gens[i] * gens[i+1]);
	return Group(newgens);
	end);

InstallMethod(ChiralityGroup,
	[IsRotaryManiplex],
	function(M)
	local g, M2, extra_rels, h;
	if IsReflexible(M) then return TrivialGroup(IsFpGroup); fi;
	g := RotationGroup(M);
	M2 := EnantiomorphicForm(M);
	extra_rels := ExtraRotRelators(M2);
	extra_rels := List(extra_rels, r -> ElementOfFpGroup(FamilyObj(g.1), r));
	h := Subgroup(g, extra_rels);
	return h;
	end);

	
# Returns a list of relators that are necessary to
# define the automorphism group of M as a quotient of the string
# Coxeter group implied by its Schlafli Symbol.
InstallMethod(ExtraRelators,
	[IsReflexibleManiplex],
	function(M)
	local g, rels, type_rels, sym, i;
	g := AutomorphismGroupFpGroup(M);
	sym := SchlafliSymbol(M);
	rels := List(RelatorsOfFpGroup(g));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	type_rels := RelatorsOfFpGroup(UniversalSggi(SchlafliSymbol(M)));
	type_rels := List(type_rels, r -> TietzeWordAbstractWord(r));
	for i in [1..Size(sym)] do
		Add(type_rels, Flat(ListWithIdenticalEntries(sym[i], [i+1, i])));
	od;
	rels := Difference(rels, type_rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	return rels;
	end);
	
InstallMethod(ExtraRotRelators,
	[IsRotaryManiplex],
	function(M)
	local g, rels, type_rels, sym, i;
	g := RotationGroup(M);
	g := Image(IsomorphismFpGroupByGenerators(g, GeneratorsOfGroup(g)));
	sym := SchlafliSymbol(M);
	rels := List(RelatorsOfFpGroup(g));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	type_rels := RelatorsOfFpGroup(UniversalRotationGroup(SchlafliSymbol(M)));
	type_rels := List(type_rels, r -> TietzeWordAbstractWord(r));
	rels := Difference(rels, type_rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	return rels;
	end);
	
# TODO: Currently will fail for infinite groups.
# I started coding something for this, but Intersection(g,h) where g is infinite
# doesn't appear to work. Requires more thought...
# TODO: Currently assumes g is an sggi
InstallMethod(IsStringC,
	[IsGroup],
	function(g)
	local d, vfig, facet, medial;
	d := Size(GeneratorsOfGroup(g));
	if d = 1 then
		return (Order(g) = 2);
	fi;
	vfig := Subgroup(g, GeneratorsOfGroup(g){[2..d]});
	facet := Subgroup(g, GeneratorsOfGroup(g){[1..d-1]});
	medial := Subgroup(g, GeneratorsOfGroup(g){[2..d-1]});
	if not(IsStringC(vfig)) then return false; fi;
	if not(IsStringC(facet)) then return false; fi;
	if HasIsFinite(vfig) and IsFinite(vfig) and HasIsFinite(facet) and IsFinite(facet) and HasIsFinite(medial) and IsFinite(medial) then
		return (Size(medial) = Size(Intersection(vfig, facet)));
	else
		return IsSubset(medial, Intersection(vfig, facet));
	fi;
	end);

# TODO: Currently will fail for infinite groups.
# I started coding something for this, but Intersection(g,h) where g is infinite
# doesn't appear to work. Requires more thought...
# TODO: Currently assumes g is a string rotation group
InstallMethod(IsStringCPlus,
	[IsGroup],
	function(g)
	local n, facetGroup, vfigGroup, i, h, h2;
	n := Size(GeneratorsOfGroup(g));
	if n <= 1 then
		return true;
	elif n = 2 then
		facetGroup := Subgroup(g, GeneratorsOfGroup(g){[1]});
		vfigGroup := Subgroup(g, GeneratorsOfGroup(g){[2]});
		return (Size(Intersection(facetGroup, vfigGroup)) = 1);
	else
		facetGroup := Subgroup(g, GeneratorsOfGroup(g){[1..n-1]});
		if not(IsStringCPlus(facetGroup)) then
			return false;
		else
			for i in [2..n-1] do
				h := Subgroup(g, GeneratorsOfGroup(g){[i..n]});
				h2 := Subgroup(g, GeneratorsOfGroup(g){[i..n-1]});
				if not(IsSubset(h2, Intersection(facetGroup, h))) then
					return false;
				fi;
			od;
		fi;
		return true;
	fi;
	end);

