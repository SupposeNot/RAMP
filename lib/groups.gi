
InstallMethod(AutomorphismGroup, 
	[IsManiplex and IsManiplexConnGpRep],
	M -> Centralizer(SymmetricGroup(Size(M)), ConnectionGroup(M)));
	
InstallOtherMethod(AutomorphismGroup, 
	[IsManiplex and IsReflexibleManiplexAutGpRep],
	M -> M!.aut_gp);

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
	[IsReflexibleManiplex],
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
	[IsManiplex and IsManiplexConnGpRep],
	function(M)
	return M!.conn_gp;
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

	
# Returns a list of relators (as Tietze words) that are necessary to
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

