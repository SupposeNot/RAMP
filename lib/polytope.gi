### RAMP -- Research Assistant for Maniplexes and Polytopes ###

# TODO
# Write AutomorphismGroup for arbitrary polytopes via connection group
# If we later learn that a polytope is regular, then do we need to promote it?
# Fix print so that it works for WithoutRels rep
# Store petrie rel

# For many purposes, it is useful for sggis to have the same (not just isomorphic) underlying
# free group. So the first time we create one in a given rank, we save it and use it again later.
InstallValue(UNIVERSAL_SGGI_FREE_GROUPS, []);

# Returns the universal string Coxeter Group of rank n.
InstallMethod(UniversalSggi,
	[IsInt],
	function(n)
	local i, j, f, rels, gens, g;
	if n = 0 then
		return FreeGroup([]);
	fi;
	
	if not(IsBound(UNIVERSAL_SGGI_FREE_GROUPS[n])) then
		UNIVERSAL_SGGI_FREE_GROUPS[n] := FreeGroup(List([0..n-1], i -> Concatenation("r", String(i))));	
	fi;
	f := UNIVERSAL_SGGI_FREE_GROUPS[n];
	gens := GeneratorsOfGroup(f);
	rels := [];
	for i in [1..n] do
		Add(rels, gens[i]*gens[i]);
	od;
	for i in [1..n-2] do
		for j in [i+2..n] do
			Add(rels, gens[i]*gens[j]*gens[i]*gens[j]);
		od;
	od;
	g := FactorGroupFpGroupByRels(f, rels);
	if (n >= 2) then SetSize(g, infinity); fi;
	return g;
	end);

COXETER_GROUP_SIZES := function(sym)
	local dict, n, k;
	
	dict := NewDictionary([], true);
	AddDictionary(dict, [3,5], 120);
	AddDictionary(dict, [5,3], 120);
	AddDictionary(dict, [3,4,3], 1152);
	AddDictionary(dict, [5,3,3], 14400);
	AddDictionary(dict, [3,3,5], 14400);

	n := Size(sym)+1;
	
	if n = 1 then
		return 2;
	elif n = 2 then
		return 2 * sym[1];
	elif KnowsDictionary(dict, sym) then
		return LookupDictionary(dict, sym);
	elif ForAll(sym, i -> i = 3) then
		return Factorial(n+1);
	elif sym[1] = 4 and ForAll(sym{[2..n-1]}, i -> i = 3) then
		return 2^n * Factorial(n);
	elif sym[n-1] = 4 and ForAll(sym{[1..n-2]}, i -> i = 3) then
		return 2^n * Factorial(n);
	elif 2 in sym then
		k := Position(sym, 2);
		return COXETER_GROUP_SIZES(sym{[1..k-1]}) * COXETER_GROUP_SIZES(sym{[k+1..n-1]});
	else
		return infinity;
	fi;
	end;

# Returns the universal string Coxeter Group given by sym.
# For example, UniversalSggi([4,4]) is the group denoted [4, 4].
InstallOtherMethod(UniversalSggi,
	[IsList],
	function(sym)
	local i, j, f, g, rels, gens, n, h;
	n := Size(sym)+1;
	g := UniversalSggi(n);
	gens := FreeGeneratorsOfFpGroup(g);
	rels := [];
	for i in [1..n-1] do
		if sym[i] <> infinity then
			Add(rels, (gens[i]*gens[i+1])^sym[i]);
		fi;
	od;
	h := FactorGroupFpGroupByRels(g, rels);
	SetSize(h, COXETER_GROUP_SIZES(sym));
	return h;
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

InstallMethod(IsPolytopal,
	[IsReflexibleManiplex],
	function(m)
	return IsStringC(AutomorphismGroup(m));
	end);

BuildReflexibleManiplex := function(autgp, hasrels)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(autgp));

	fam := NewFamily(Concatenation("Reflexible ", String(n), "-Maniplex"), IsReflexibleManiplex);
	fam!.rank := n;
	if hasrels then
		p := Objectify( NewType( fam, IsReflexibleManiplex and IsReflexibleManiplexWithRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	else
		p := Objectify( NewType( fam, IsReflexibleManiplex and IsReflexibleManiplexWithoutRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));		
	fi;
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankManiplex(p, n);
	SetAutomorphismGroup(p, autgp);
	return p;
	end;

# Given a finitely presented group (which should be a sggi), builds the 
# reflexible maniplex out of it.
# NOTE: This does not check whether autgp is an sggi.
InstallMethod(ReflexibleManiplex,
	[IsFpGroup],
	function(autgp)
	return BuildReflexibleManiplex(autgp, true);
	end);

# Given any group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it. So you could pass in a
# permutation group, matrix group, or anything else.
InstallMethod(ReflexibleManiplex,
	[IsGroup],
	function(autgp)
	return BuildReflexibleManiplex(autgp, false);
	end);
	
# The universal maniplex with the given Schlafli symbol.
# Requires every entry of the symbol to be at least 2.
InstallMethod(ReflexibleManiplex,
	[IsList],
	function(sym)
	local n, w, p;
	n := Size(sym)+1;
	w := UniversalSggi(sym);
	p := ReflexibleManiplex(w);
	SetSchlafliSymbol(p, sym);
	SetSize(p, Size(w));
	return p;
	end);

# Usage: ReflexibleManiplex([4,6], "(r0r1r2)^6 = r0(r1r2)^5 = 1");
InstallMethod(ReflexibleManiplex,
	[IsList, IsList],
	function(sym, rels)
	local n, w, autgp, fam, p;
	n := Size(sym)+1;
	w := UniversalSggi(sym);
	if IsString(rels) then
		rels := ParseStringCRels(rels, w);
	else
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	autgp := FactorGroupFpGroupByRels(w, rels);
	return ReflexibleManiplex(autgp);
	end);

# Returns the regular polytope with the given symbolic name.
# Examples:
# ReflexibleManiplex("{3,3,3}");
# ReflexibleManiplex("{4,3}_3");
InstallOtherMethod(ReflexibleManiplex,
	[IsString],
	function(name)
	local sym, p, nameparts, petrie, n, petrie_word, symname;
	
	# HACK: If something calls ReflexibleManiplex([]) wanting the universal 1-polytope,
	# then we end up here because [] is the same as the empty string. So we
	# handle that case specially.
	if name = [] then
		return UniversalPolytope(1);
	fi;
	
	if name[1] = '{' and name[Size(name)] = '}' then
		sym := SplitString(name{[2..Size(name)-1]}, ',');
		sym := List(sym, str -> Int(str));
		p := ReflexibleManiplex(sym);
	elif '_' in name then
		nameparts := SplitString(name, '_');
		symname := nameparts[1];
		if symname[1] = '{' and symname[Size(symname)] = '}' then
			sym := SplitString(symname{[2..Size(symname)-1]}, ',');
			sym := List(sym, str -> Int(str));
			petrie := Int(nameparts[2]);
			n := 1 + Size(sym);
			p := ReflexibleManiplex(sym, PetrieRelation(n, petrie));
		else
			Error("Cannot parse name.");
		fi;
	else
		Error("Cannot parse name.");
	fi;
	
	return p;
	end);
	
# Given a finitely presented group, builds the rotary (regular or chiral)
# polytope with that group as its rotation group.
InstallMethod(RotaryManiplex,
	[IsFpGroup],
	function(rotgp)
	local n, fam, p;
	n := 1+Size(GeneratorsOfGroup(rotgp));
	fam := NewFamily(Concatenation("Rotary ", String(n), "-maniplex"), IsRotaryManiplex);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsRotaryManiplex and IsRotaryManiplexRep), rec( rot_gp := rotgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(rotgp) then SetSize(p, 2*Size(rotgp)); fi;
	SetRankManiplex(p, n);
	SetRotationGroup(p, rotgp);
	SetIsOrientable(p, true);
	return p;
	end);

# Given a permutation group (sggi), builds a maniplex with that as its connection group.	
InstallMethod(Maniplex,
	[IsPermGroup],
	function(g)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(g));
	fam := NewFamily(Concatenation(String(n), "-maniplex"), IsManiplex);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsManiplex and IsManiplexConnGpRep), rec( conn_gp := g, fvec := List([1..n], i -> fail) ));
	
	SetSize(p, NrMovedPoints(g));
	SetRankManiplex(p, n);
	SetConnectionGroup(p, g);
	if (ValueOption("polytopal") = true) then
		SetIsPolytopal(p, true);
	fi;
	return p;
	end);
	
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

InstallOtherMethod(Size,
	[IsReflexibleManiplex],
	p -> Size(AutomorphismGroup(p)));

InstallMethod(RankManiplex,
	[IsReflexibleManiplex],
	p -> Size(GeneratorsOfGroup(AutomorphismGroup(p))));

InstallMethod(RankManiplex,
	[IsManiplex],
	p -> Size(GeneratorsOfGroup(ConnectionGroup(p))));

InstallMethod(Rank, [IsManiplex], RankManiplex);
	
InstallMethod(SchlafliSymbol,
	[IsReflexibleManiplex],
	function(p)
	local gens, n, i, sym;
	if IsBound(p!.schlafli_symbol) then return p!.schlafli_symbol; fi;
	return ComputeSchlafliSymbol(p);
	end);
	
InstallMethod(ComputeSchlafliSymbol,
	[IsReflexibleManiplex],
	function(p)
	local gens, n, i, sym;
	gens := GeneratorsOfGroup(AutomorphismGroup(p));
	n := Rank(p);
	sym := [];
	for i in [1..n-1] do
		Add(sym, Order(gens[i]*gens[i+1]));
	od;
	return sym;
	end);
	
InstallMethod(IsDegenerate,
	[IsReflexibleManiplex],
	function(p)
	return (2 in SchlafliSymbol(p));
	end);

InstallMethod(IsTight,
	[IsReflexibleManiplex and HasIsPolytopal and IsPolytopal],
	function(p)
	return (Size(p) = 2*Product(SchlafliSymbol(p)));
	end);
	
# A regular polytope is vertex-faithful if the action
# of the automorphism group on the vertices is faithful.
InstallMethod(IsVertexFaithful,
	[IsReflexibleManiplex],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);
	
InstallMethod(MaxVertexFaithfulQuotient,
	[IsReflexibleManiplex],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return ReflexibleManiplex(g/c);
	end);
	
InstallMethod(IsFacetFaithful,
	[IsReflexibleManiplex],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[1..n-1]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);
	
# To determine if P is a quotient of Q, if they are both just generic polytopes,
# then we try to find a homomorphism between their connection groups.
# TODO: Optimize this by checking some easy algebraic invariants first.
InstallMethod(IsQuotientOf,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	g1 := ConnectionGroup(q);
	g2 := ConnectionGroup(p);
	hom := GroupHomomorphismByImages(g1, g2);
	return (hom <> fail);
	end);

# This determines whether the regular polytope P is a quotient of the regular polytope Q,
# assuming that we have presentations for both of their groups.
InstallMethod(IsQuotientOf,
	IsSameRank,
	[IsReflexibleManiplex and IsReflexibleManiplexWithRels, IsReflexibleManiplex and IsReflexibleManiplexWithRels],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) then
		for i in [1..Rank(p)-1] do
			k1 := SchlafliSymbol(p)[i];
			k2 := SchlafliSymbol(q)[i];
			if k2 < k1 then 	# This also handles infinity
				return false;
			elif k1 < infinity and k2 < infinity and not(IsInt(k2/k1)) then
				return false;
			fi;
		od;
	fi;

	if HasSize(q) and HasSize(p) and IsFinite(q) and IsFinite(p) then
		if not(IsInt(Size(q) / Size(p))) then return false; fi;
	fi;

	# TODO: This only logically works if they have Schlafli symbols that are known and computed
	if IsSubset(ExtraRelators(q), ExtraRelators(p)) then return true; fi;
	
	if HasSize(p) and IsFinite(p) then
		# add rels from q to p...
		rels := RelatorsOfFpGroup(AutomorphismGroup(q));
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroup(p))));
		g := FactorGroupFpGroupByRels(AutomorphismGroup(p), rels);
		return (Size(g) = Size(p));
	else
		g1 := AutomorphismGroup(q);
		g2 := AutomorphismGroup(p);
		hom := GroupHomomorphismByImages(g1, g2, GeneratorsOfGroup(g1), GeneratorsOfGroup(g2));
		return (hom <> fail);
	fi;
	end);
	
InstallMethod(IsCoverOf,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotientOf(q,p);
	end);

InstallMethod(IsIsomorphicTo,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	local atts, att;
	atts := [Size, SchlafliSymbol, Fvector];
	for att in atts do
		if Tester(att)(p) and Tester(att)(q) and att(p) <> att(q) then return false; fi;
	od;
	
	if HasIsFinite(p) and HasIsFinite(q) and IsFinite(p) and IsFinite(q) then
		# At this point, we know that p and q are the same size and finite.
		return IsQuotientOf(p,q);
	else
		return IsQuotientOf(p,q) and IsCoverOf(p,q);
	fi;
	end);
InstallMethod( \=,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsIsomorphicTo(p,q);
	end);
InstallMethod( \<,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotientOf(p,q);
	end);
	
InstallMethod( ViewObj,
	[IsManiplex],
	function(p)
	if IsReflexibleManiplex(p) then
		if HasIsPolytopal(p) and IsPolytopal(p) then
			Print("Regular ");
		else
			Print("Reflexible ");
		fi;
	fi;
	
	if HasIsPolytopal(p) and not(IsPolytopal(p)) then
		Print("nonpolytopal ");
	fi;
	
	Print(String(Rank(p)));
	if HasIsPolytopal(p) and IsPolytopal(p) then
		Print("-polytope");
	else
		Print("-maniplex");
	fi;
	if HasSchlafliSymbol(p) then Print(Concatenation(" of type ", String(SchlafliSymbol(p)))); fi;
	if HasSize(p) then Print(Concatenation(" with ", String(Size(p)), " flags")); fi;
	end);

InstallMethod( PrintObj,
	[IsReflexibleManiplex],
	function(p)
	ViewObj(p);
	Print("\n");
	if IsFpGroup(AutomorphismGroup(p)) then
		Print("Defining relations: ", RelatorsOfFpGroup(AutomorphismGroup(p)));
	fi;
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
	
InstallMethod(PetrieRelation,
	[IsInt, IsInt],
	function(n, k)
	local L, petrie_word;
	L := [0..n-1];
	L := List(L, i -> Concatenation("r", String(i)));
	petrie_word := Concatenation(L);
	return Concatenation("(", petrie_word, ")^", String(k));
	end);
	
InstallMethod(PetrieLength,
	[IsReflexibleManiplex],
	function(p)
	local g;
	g := AutomorphismGroup(p);
	return Order(Product(GeneratorsOfGroup(g)));
	end);

InstallMethod(HoleLength,
	[IsReflexibleManiplex],
	function(p)
	local g;
	g := AutomorphismGroup(p);
	return Order(g.1*g.2*g.3*g.2);
	end);
	
InstallMethod(SymmetryTypeGraph,
	[IsManiplex],
	function(p)
	local ag, cg, orbs, k, perms, i, r, rp, orb, new_orb;
	if IsReflexibleManiplex(p) then
		return List([1..Rank(p)], i -> ());
	fi;
	
	ag := AutomorphismGroup(p);
	orbs := List(Orbits(ag), o -> Set(o));
	k := Size(orbs);
	cg := ConnectionGroup(p);
	perms := [];
	
	# There is probably a built-in way to get this, but I'm not finding it today
	for r in GeneratorsOfGroup(cg) do
		rp := ();
		for i in [1..k] do
			# Next line prevents me from adding (a, b) and (b, a) to rp, which would cancel out.
			if i^rp = i then
				orb := orbs[i];
				new_orb := OnSets(orb, r);
				if new_orb <> orb then
					rp := rp * (i, Position(orbs, new_orb));
				fi;
			fi;
		od;
		Add(perms, rp);
	od;

	return perms;
	
	end);
	
InstallMethod(NumberOfFlagOrbits,
	[IsManiplex],
	function(p)
	local n;
	if IsReflexibleManiplex(p) then return 1; fi;
	n := LargestMovedPoint(Group(SymmetryTypeGraph(p)));
	if n = 0 then n := 1; fi;
	return n;
	end);

InstallMethod(SmallestRegularCover,
	[IsManiplex],
	function(p)
	return ReflexibleManiplex(Image(RegularActionHomomorphism(ConnectionGroup(p))));
	end);
	
