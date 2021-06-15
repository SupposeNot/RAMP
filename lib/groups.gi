
InstallMethod(AutomorphismGroup, 
	[IsManiplex],
	p -> Centralizer(SymmetricGroup(Size(p)), ConnectionGroup(p)));
	
InstallOtherMethod(AutomorphismGroup, 
	[IsReflexibleManiplex],
	p -> p!.aut_gp);

InstallMethod(AutomorphismGroupFpGroup, 
	[IsManiplex],
	function(p)
	local g, fp, w, rels;
	g := AutomorphismGroup(p);
	if IsFpGroup(g) then
		return g;
	else
		fp := Image(IsomorphismFpGroupByGeneratorsNC(g, GeneratorsOfGroup(g), "Q"));
		
		# Retranslate everything in terms of r0, r1, etc.
		w := UniversalSggi(Rank(p));
		rels := RelatorsOfFpGroup(fp);
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
		fp := FactorGroupFpGroupByRels(w, rels);
		return fp;
	fi;
	end);

InstallMethod(AutomorphismGroupPermGroup, 
	[IsManiplex],
	function(p)
	local g;
	g := AutomorphismGroup(p);
	if IsPermGroup(g) then
		return g;
	else
		return Image(IsomorphismPermGroup(g));
	fi;
	end);
	
InstallMethod(RotationGroup,
	[IsRotaryManiplex and IsRotaryManiplexRep],
	p -> p!.rot_gp);
InstallMethod(RotationGroup,
	[IsReflexibleManiplex],
	function(p)
	local gens, n, i, new_gens;
	gens := GeneratorsOfGroup(AutomorphismGroup(p));
	n := Rank(p);
	new_gens := [];
	for i in [1..n-1] do
		Add(new_gens, gens[i]*gens[i+1]);
	od;
	return Group(new_gens);
	end);

InstallMethod(ConnectionGroup,
	[IsReflexibleManiplex],
	function(p)
	local g, hom;
	g := AutomorphismGroup(p);
	return Image(RegularActionHomomorphism(g));
	end);
InstallMethod(ConnectionGroup,
	[IsManiplex and IsManiplexConnGpRep],
	function(p)
	return p!.conn_gp;
	end);
	
# Returns a list of relators (as Tietze words) that are necessary to
# define the automorphism group of p as a quotient of the string
# Coxeter group implied by its Schlafli Symbol.
InstallMethod(ExtraRelators,
	[IsReflexibleManiplex],
	function(p)
	local g, rels, type_rels, sym, i;
	g := AutomorphismGroupFpGroup(p);
	sym := SchlafliSymbol(p);
	rels := List(RelatorsOfFpGroup(g));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	type_rels := RelatorsOfFpGroup(UniversalSggi(SchlafliSymbol(p)));
	type_rels := List(type_rels, r -> TietzeWordAbstractWord(r));
	for i in [1..Size(sym)] do
		Add(type_rels, Flat(ListWithIdenticalEntries(sym[i], [i+1, i])));
	od;
	rels := Difference(rels, type_rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	return rels;
	end);
	
# TODO: Currently will fail for infinite groups.
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
	return IsStringC(vfig) and IsStringC(facet) and (Size(medial) = Size(Intersection(vfig, facet)));
	end);

