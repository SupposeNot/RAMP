
InstallMethod(AutomorphismGroup, 
	[IsManiplex and IsManiplexConnGpRep],
	M -> Centralizer(SymmetricGroup(Size(M)), ConnectionGroup(M)));
	
InstallMethod(AutomorphismGroup, 
	[IsManiplex and IsReflexibleManiplexAutGpRep],
	M -> M!.aut_gp);

# BROKEN
# Need to find another approach.
InstallMethod(AutomorphismGroup,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local n, gens, f, g, h, i, rels, h2, genr;
	
	# The strategy is to add a new generator r0 that acts as conjugation by
	# r0 should. If this works, then we have a rotation group of an orientably
	# regular polytope. If not, then we have a chiral polytope, and the automorphism
	# group is just the rotation group.
	
	n := Rank(M);
	g := RotationGroup(M);
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
		return h2;
	else
		# We have a chiral polytope
		SetIsReflexible(M, false);
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
	[IsReflexibleManiplex],
	function(M)
	local g;
	g := AutomorphismGroup(M);
	return Image(RegularActionHomomorphism(g));
	end);
	
InstallMethod(ConnectionGroup,
	[IsRotaryManiplex],
	function(M)
	local g, n, w, wgens, wpgens, wp, hom, ker, ker2;
	g := AutomorphismGroup(M);
	if IsReflexible(M) then
		return Image(RegularActionHomomorphism(g));
	else
		# A chiral polytope has a flag-stabilizer K that is normal in W+ but not W.
		# So we find the flag-stabilizer, and then use it to build the connection group.
		n := Rank(M);
		w := UniversalSggi(n);
		wgens := GeneratorsOfGroup(w);
		wpgens := List([1..n-1], i -> wgens[i]*wgens[i+1]);
		wp := Subgroup(w, wpgens);
		hom := GroupHomomorphismByImagesNC(wp, g, wpgens, GeneratorsOfGroup(g));
		ker := Kernel(hom);
		ker2 := Core(w, ker);
		return w / ker2;
	fi;	
	end);
InstallMethod(ConnectionGroup,
	[IsManiplex and IsManiplexConnGpRep],
	function(M)
	return M!.conn_gp;
	end);
InstallMethod(ConnectionGroup,
	[IsManiplex and IsManiplexQuotientRep],
	function(M)
	local g, h, c;
	g := AutomorphismGroup(M!.parent);
	h := M!.subgroup;
	c := Core(g, h);
	return g / c;	
	end);
InstallMethod(ConnectionGroup,
	[IsManiplex and IsManiplexInstructionsRep],
	function(M)
	return ComputeAttr(M, ConnectionGroup);
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
		return IsSubset(Intersection(vfig, facet), medial);
	fi;
	end);

