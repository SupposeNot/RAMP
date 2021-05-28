### RAMP -- Research Assistant for Maniplexes and Polytopes ###

# TODO
# Fix DualPolytopes, or let AbstractRegularPolytope take tietze words again.
# Write AutomorphismGroup for arbitrary polytopes via connection group
# Write fvector for arbitrary polytopes
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

# Returns the universal string Coxeter Group given by sym.
# For example, UniversalSggi([4,4]) is the group denoted [4, 4].
InstallOtherMethod(UniversalSggi,
	[IsList],
	function(sym)
	local i, j, f, g, rels, gens, n;
	n := Size(sym)+1;
	g := UniversalSggi(n);
	gens := FreeGeneratorsOfFpGroup(g);
	rels := [];
	for i in [1..n-1] do
		if sym[i] <> infinity then
			Add(rels, (gens[i]*gens[i+1])^sym[i]);
		fi;
	od;
	return FactorGroupFpGroupByRels(g, rels);
	end);
	
# Returns a list of relators (as Tietze words) that are necessary to
# define the automorphism group of p as a quotient of the string
# Coxeter group implied by its Schlafli Symbol.
InstallMethod(ExtraRelators,
	[IsAbstractRegularPolytope],
	function(p)
	local g, rels, type_rels, sym, i;
	g := AutomorphismGroup(p);
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



# Takes an abstract word in the generators of some free group and returns the corresponding
# abstract word in the generators of f.
TranslateWord := function(word, f)
	local tw;
	tw := TietzeWordAbstractWord(word);
	return AbstractWordTietzeWord(tw, GeneratorsOfGroup(f));
	end;
	
# This is a bit of a hack.
# GAP has a built-in way to parse group presentations, so that if you take the quotient of,
# say, <a, b, c> by the string "a^5 = b^3 = c^2 = 1", then it does what you expect.
# I want to use this to do something similar with sggis. But the built-in GAP method
# only allows single-letter generators. So I translate r0 -> a, r1 -> b, etc, and
# then back again.	
ParseStringCRels := function(rels, w)
	local n, f, old_names, new_names, i, parsed_rels, trans_rels, f2;
	n := Size(GeneratorsOfGroup(w));
	if n > 9 then Error("Only works for n < 10"); fi;
	f := FreeGroupOfFpGroup(w);

	old_names := List([0..n-1], i -> Concatenation("r", String(i)));
	new_names := ["a","b","c","d","e","f","g","h","i"]{[1..n]};
	for i in [1..n] do
		rels := ReplacedString(rels, old_names[i], new_names[i]);
	od;
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	return trans_rels;
	end;
	
IsSameRank := function(f1, f2)
	return f1!.rank = f2!.rank;
	end;

# Given a finitely presented group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it.
InstallMethod(AbstractRegularPolytope,
	[IsFpGroup],
	function(autgp)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(autgp));
	fam := NewFamily(Concatenation("Abstract Regular ", String(n), "-Polytope"), IsAbstractRegularPolytope);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankPolytope(p, n);
	SetAutomorphismGroup(p, autgp);
	return p;
	end);
	
# Given any group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it. So you could pass in a
# permutation group, matrix group, or anything else.
InstallMethod(AbstractRegularPolytope,
	[IsGroup],
	function(autgp)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(autgp));
	fam := NewFamily(Concatenation("Abstract Regular ", String(n), "-Polytope"), IsAbstractRegularPolytope);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithoutRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankPolytope(p, n);
	SetAutomorphismGroup(p, autgp);
	return p;
	end);
	
# Usage: AbstractRegularPolytope([4,6], "(r0r1r2)^6 = r0(r1r2)^5 = 1");
InstallOtherMethod(AbstractRegularPolytope,
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
	
	fam := NewFamily(Concatenation("Abstract Regular ", String(n), "-Polytope"), IsAbstractRegularPolytope);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankPolytope(p, n);
	SetAutomorphismGroup(p, autgp);
	return p;
	end);

# Given an abstract regular polytope where we don't have a presentation for
# the automorphism group yet, we attempt to find a presentation.
# TODO: Prune out extra rels -- the usual sggi rels appear twice
InstallMethod(FindRels,
	[IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithoutRels],
	function(p)
	local g, fp, w, rels;
	g := AutomorphismGroup(p);
	fp := Image(IsomorphismFpGroupByGeneratorsNC(g, GeneratorsOfGroup(g), "Q"));
	# This is a silly hack, but I want the generators to be the usual r0 etc.
	w := UniversalSggi(RankPolytope(p));
	rels := RelatorsOfFpGroup(fp);
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fp := FactorGroupFpGroupByRels(w, rels);
	return AbstractRegularPolytope(fp);
	end);
	
# Given a finitely presented group, builds the rotary (regular or chiral)
# polytope with that group as its rotation group.
InstallMethod(AbstractRotaryPolytope,
	[IsFpGroup],
	function(rotgp)
	local n, fam, p;
	n := 1+Size(GeneratorsOfGroup(rotgp));
	fam := NewFamily(Concatenation("Abstract Rotary ", String(n), "-Polytope"), IsAbstractRotaryPolytope);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsAbstractRotaryPolytope and IsAbstractRotaryPolytopeRep), rec( rot_gp := rotgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(rotgp) then SetSize(p, 2*Size(rotgp)); fi;
	SetRankPolytope(p, n);
	SetRotationGroup(p, rotgp);
	SetIsOrientable(p, true);
	return p;
	end);

# Given a permutation group (sggi), builds a polytope with that as its connection group.	
InstallMethod(AbstractPolytope,
	[IsPermGroup],
	function(g)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(g));
	fam := NewFamily(Concatenation("Abstract ", String(n), "-Polytope"), IsAbstractPolytope);
	fam!.rank := n;
	
	p := Objectify( NewType( fam, IsAbstractPolytope and IsAbstractPolytopeConnGpRep), rec( conn_gp := g, fvec := List([1..n], i -> fail) ));
	
	SetSize(p, NrMovedPoints(g));
	SetRankPolytope(p, n);
	SetConnectionGroup(p, g);
	return p;
	end);
	
InstallMethod(AutomorphismGroup, 
	"for abstract polytopes",
	[IsAbstractPolytope],
	p -> Centralizer(SymmetricGroup(Size(p)), ConnectionGroup(p)));
	
InstallOtherMethod(AutomorphismGroup, 
	"for abstract regular polytopes",
	[IsAbstractRegularPolytope],
	p -> p!.aut_gp);

InstallMethod(RotationGroup,
	"for abstract rotary polytopes",
	[IsAbstractRotaryPolytope and IsAbstractRotaryPolytopeRep],
	p -> p!.rot_gp);
InstallMethod(RotationGroup,
	"for abstract regular polytopes",
	[IsAbstractRegularPolytope],
	function(p)
	local gens, n, i, new_gens;
	gens := GeneratorsOfGroup(AutomorphismGroup(p));
	n := RankPolytope(p);
	new_gens := [];
	for i in [1..n-1] do
		Add(new_gens, gens[i]*gens[i+1]);
	od;
	return Group(new_gens);
	end);

InstallOtherMethod(Size,
	"for abstract regular polytopes",
	[IsAbstractRegularPolytope],
	p -> Size(AutomorphismGroup(p)));

InstallOtherMethod(RankPolytope,
	"for abstract regular polytopes",
	[IsAbstractRegularPolytope],
	p -> Size(GeneratorsOfGroup(AutomorphismGroup(p))));
	
InstallMethod(SchlafliSymbol,
	[IsAbstractRegularPolytope],
	function(p)
	local gens, n, i, sym;
	if IsBound(p!.schlafli_symbol) then return p!.schlafli_symbol; fi;
	return ComputeSchlafliSymbol(p);
	end);
	
InstallMethod(ComputeSchlafliSymbol,
	[IsAbstractRegularPolytope],
	function(p)
	local gens, n, i, sym;
	gens := GeneratorsOfGroup(AutomorphismGroup(p));
	n := RankPolytope(p);
	sym := [];
	for i in [1..n-1] do
		Add(sym, Order(gens[i]*gens[i+1]));
	od;
	return sym;
	end);

InstallMethod(IsTight,
	[IsAbstractRotaryPolytope],
	function(p)
	return (Size(p) = 2*Product(SchlafliSymbol(p)));
	end);
	
# A regular polytope is vertex-faithful if the action
# of the automorphism group on the vertices is faithful.
InstallMethod(IsVertexFaithful,
	[IsAbstractRegularPolytope],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);
	
InstallMethod(MaxVertexFaithfulQuotient,
	[IsAbstractRegularPolytope],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return AbstractRegularPolytope(g/c);
	end);
	
InstallMethod(IsFacetFaithful,
	[IsAbstractRegularPolytope],
	function(p)
	local g, h, c, n, gens;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
	gens := GeneratorsOfGroup(g){[1..n-1]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);
	
InstallMethod(NumberOfIFaces,
	[IsAbstractPolytope, IsInt],
	function(p,i)
	local g, n, ranks, MP;
	n:=RankPolytope(p);
	if i < 0 or i > n-1 then Error("<i> must be between 0 and n-1"); fi;
	ranks:=[1..n];
	Remove(ranks,i+1);
	g:=ConnectionGroup(p);
	MP:=Subgroup(g, GeneratorsOfGroup(g){ranks});
	return Size(Orbits(MP));
	end);  	
	
# TODO: Deal more gracefully with infinite polytopes
# This should also use the schlafli symbol if it is bound.
InstallOtherMethod(NumberOfIFaces,
	[IsAbstractRegularPolytope, IsInt],
	function(p, i)
	local g, h, sym, n, J, num;
	n := RankPolytope(p);
	if i < 0 or i > n-1 then Error("<i> must be between 0 and n-1"); fi;
	if p!.fvec[i+1] <> fail then
		return p!.fvec[i+1];
	fi;

	g := AutomorphismGroup(p);
	if n = 3 and HasSize(p) and IsFinite(p) then
		if (i = 1) then
			num := Size(p)/4;
		elif (i = 0) then
			num := Size(p) / (2*SchlafliSymbol(p)[2]);
		else # i = 2
			num := Size(p) / (2*SchlafliSymbol(p)[1]);
		fi;
	else
		J := [1..n];
		Remove(J, i+1);
		h := Subgroup(g, GeneratorsOfGroup(g){J});
		num := Index(g,h);
	fi;
	
	p!.fvec[i+1] := num;
	if ForAll(p!.fvec, i -> i <> fail) then
		SetFvector(p, p!.fvec);
	fi;
	
	return num;
	end);
	
InstallMethod(Fvector,
	[IsAbstractPolytope],
	function(p)
	local fvec, i, n;
	n := RankPolytope(p);
	fvec := [];
	for i in [0..n-1] do
		Add(fvec, NumberOfIFaces(p,i));
	od;
	return fvec;
	end);
	
# To determine if P is a quotient of Q, if they are both just generic polytopes,
# then we try to find a homomorphism between their connection groups.
# TODO: Optimize this by checking some easy algebraic invariants first.
InstallMethod(IsQuotientOf,
	IsSameRank,
	[IsAbstractPolytope, IsAbstractPolytope],
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
	[IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) then
		for i in [1..RankPolytope(p)-1] do
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
	[IsAbstractPolytope, IsAbstractPolytope],
	function(p,q)
	return IsQuotientOf(q,p);
	end);

InstallMethod(IsIsomorphicTo,
	IsSameRank,
	[IsAbstractPolytope, IsAbstractPolytope],
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
	[IsAbstractPolytope, IsAbstractPolytope],
	function(p,q)
	return IsIsomorphicTo(p,q);
	end);
InstallMethod( \<,
	IsSameRank,
	[IsAbstractPolytope, IsAbstractPolytope],
	function(p,q)
	return IsQuotientOf(p,q);
	end);
	
InstallMethod( ViewObj,
	[IsAbstractPolytope],
	function(p)
	if IsAbstractRegularPolytope(p) then
		Print("regular ");
	fi;
	Print(Concatenation(String(RankPolytope(p)), "-polytope"));
	if HasSchlafliSymbol(p) then Print(Concatenation(" of type ", String(SchlafliSymbol(p)))); fi;
	if HasSize(p) then Print(Concatenation(" with ", String(Size(p)), " flags")); fi;
	end);

InstallMethod( PrintObj,
	[IsAbstractRegularPolytope],
	function(p)
	ViewObj(p);
	Print("\n");
	if IsFpGroup(AutomorphismGroup(p)) then
		Print("Defining relations: ", RelatorsOfFpGroup(AutomorphismGroup(p)));
	fi;
	end);
	
InstallMethod(ConnectionGroup,
	[IsAbstractRegularPolytope],
	function(p)
	local g, hom;
	g := AutomorphismGroup(p);
	return Image(RegularActionHomomorphism(g));
	end);
InstallMethod(ConnectionGroup,
	[IsAbstractPolytope and IsAbstractPolytopeConnGpRep],
	function(p)
	return p!.conn_gp;
	end);
	
InstallMethod(DualPolytope,
	[IsAbstractRegularPolytope],
	function(p)
	local g, rels, q, n, sym;
	n := RankPolytope(p);
	rels := ExtraRelators(p);
	sym := SchlafliSymbol(p);
	sym := Reversed(sym);
	rels := List(rels, r -> List(r, i -> n+1-i));
	q := AbstractRegularPolytope(sym, rels);
	SetSize(q, Size(p));
	SetSchlafliSymbol(q, sym);
	SetDualPolytope(q, p);
	return q;
	end);
	
InstallMethod(IsSelfDual,
	[IsAbstractRegularPolytope],
	function(p)
	return p = DualPolytope(p);
	end);

_PETRIAL_REL := function(r)
	local i, new_r;
	new_r := [];
	for i in r do
		if i = 1 then
			Append(new_r, [1,3]);
		else
			Add(new_r, i);
		fi;
	od;
	return new_r;
	end;
	
InstallMethod(PetrialPolytope,
	[IsAbstractRegularPolytope],
	function(p)
	local g, rels, q, n, sym, pet;
	g := AutomorphismGroup(p);
	sym := ShallowCopy(SchlafliSymbol(p));
	rels := ExtraRelators(p);
	Add(rels, Flat(ListWithIdenticalEntries(sym[1],[1,2])));
	pet := Order(g.1*g.2*g.3);

	sym[1] := pet;
	
	rels := List(rels, r -> _PETRIAL_REL(r));
	
	q := AbstractRegularPolytope(sym, rels);
	SetSize(q, Size(p));
	SetSchlafliSymbol(q, sym);
	SetPetrialPolytope(q, p);
	return q;
	end);
	
InstallMethod(IsOrientable,
	[IsAbstractRegularPolytope],
	function(p)
	local rels;
	rels := ExtraRelators(p);
	return ForAll(rels, r -> Length(r) mod 2 = 0);
	end);

InstallMethod(IsIOrientable,
	[IsAbstractRegularPolytope, IsList],
	function(p, I)
	local rels;
	rels := RelatorsOfFpGroup(AutomorphismGroup(p));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	# Translate I since tietze words are 1-based instead of 0-based
	I := List(I, i -> i+1);
	return ForAll(rels, r -> Number(r, i -> i in I) mod 2 = 0);
	end);

InstallMethod(IsVertexBipartite,
	[IsAbstractRegularPolytope],
	function(p)
	return IsIOrientable(p, [0]);
	end);
	
InstallMethod(IsFacetBipartite,
	[IsAbstractRegularPolytope],
	function(p)
	return IsIOrientable(p, [RankPolytope(p)-1]);
	end);
	
# TODO: Handle some special cases:
# 1. The facets of a universal coxeter group are a universal coxeter group.
# 2. If P is finite, then try guessing a presentation for the facets.
#	This will give something that might properly cover the facets -- compare size.
InstallMethod(Facets,
	[IsAbstractRegularPolytope],
	function(p)
	local n, sym, g, h, s, q;
	n := RankPolytope(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[1..n-1]});
	q := AbstractRegularPolytope(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[1..n-2]});
	fi;
	return q;
	end);
	
InstallMethod(VertexFigures,
	[IsAbstractRegularPolytope],
	function(p)
	local n, sym, g, h, s, q;
	n := RankPolytope(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[2..n]});
	q := AbstractRegularPolytope(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[2..n-1]});
	fi;
	return q;
	end);
	
InstallMethod(PetrieLength,
	[IsAbstractRegularPolytope],
	function(p)
	local g;
	g := AutomorphismGroup(p);
	return Order(g.1*g.2*g.3);
	end);

InstallMethod(HoleLength,
	[IsAbstractRegularPolytope],
	function(p)
	local g;
	g := AutomorphismGroup(p);
	return Order(g.1*g.2*g.3*g.2);
	end);
	
# This saves polytopes to a file in an efficient way with lots of shortcuts.
# Not suitable for MathDataHub.
SavePolytopes := function(polys, filename)
	local stream, i, j, p, F, rels, datastring, id, flats, sym, g, s1, s2, nonflats, pd, pp, invars, duals, done, pdp, ppd, pdpd;
	stream := OutputTextFile(filename, false);
	done := NewDictionary(polys[1], false, polys);

	# First, write all the parameters for flat orientable polyhedra
	flats := Filtered(polys, p -> IsTight(p) and IsOrientable(p));
	WriteAll(stream, "flats\n");
	for p in flats do
		# Find the relation s2^-1 * s1 = s1^i s2^j that holds.
		sym := SchlafliSymbol(p);
		g := AutomorphismGroup(p);
		for i in [1..sym[1]] do
			for j in [1..sym[2]] do
				s1 := g.1*g.2;
				s2 := g.2*g.3;
				if s2^-1*s1 = s1^i*s2^j then
					WriteAll(stream, Concatenation(String(sym[1]), ",", String(sym[2]), ",", String(i), ",", String(j), "\n"));
				fi;
			od;
		od;
	od;

	nonflats := Filtered(polys, p -> not(IsTight(p) and IsOrientable(p)));
	WriteAll(stream, "nonflats\n");
	for p in nonflats do
		g := AutomorphismGroup(p);
		
		WriteAll(stream, String(SchlafliSymbol(p)));
		WriteAll(stream, ", ");
		WriteAll(stream, String(PetrieLength(p)));
		WriteAll(stream, ", ");
		WriteAll(stream, String(Size(p)));
		WriteAll(stream, ", ");
		rels := ExtraRelators(p);
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(UniversalSggi(3))));
		WriteAll(stream, String(rels));
		WriteAll(stream, "\n");
		# And write some other stuff
	od;

	CloseStream(stream);
	end;

# TODO: This is a work in progress!	
# TODO: Incorporate the degenerate polyhedra [p, 2] and [2, q]
# TODO: Make the filename handling easier. (Right now I have to use an absolute path)
# TODO: Optimize the handling of flat polyhedra. There are some choices of i and j that always work, so I don't
#	really need to store these - I can easily make them on the fly.
ReadPolytopes := function(filename)
	local polys, stream, desc, params, flatpolystr, paramlist, sym, petrie, flagnum, rels, p, paramstr;
	stream := InputTextFile(filename);
	polys := [];
	desc := ReadLine(stream);
	if desc = "flats\n" then
		# start reading in data on flat polytopes
		params := ReadLine(stream);
		while params <> "nonflats\n" do
			flatpolystr := Concatenation("FlatRegularPolyhedron(", params, ")");
			Add(polys, EvalString(flatpolystr));
			params := ReadLine(stream);
		od;
	fi;

	paramstr := ReadLine(stream);
	while not(IsEndOfStream(stream)) do
		params := EvalString(Concatenation("[", paramstr, "]"));
		
		sym := params[1];
		petrie := params[2];
		flagnum := params[3];
		rels := params[4][1];
		
		p := AbstractRegularPolytope(sym, rels);
		SetSize(p, flagnum);
		SetPetrieLength(p, petrie);
		SetSchlafliSymbol(p, sym);
		Add(polys, p);

		paramstr := ReadLine(stream);
	od;
	
	CloseStream(stream);
	return polys;
	end;

InstallMethod(SymmetryTypeGraph,
	[IsAbstractPolytope],
	function(p)
	local ag, cg, orbs, k, perms, i, r, rp, orb, new_orb;
	if IsAbstractRegularPolytope(p) then
		return List([1..RankPolytope(p)], i -> ());
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
	[IsAbstractPolytope],
	function(p)
	local n;
	if IsAbstractRegularPolytope(p) then return 1; fi;
	n := LargestMovedPoint(Group(SymmetryTypeGraph(p)));
	if n = 0 then n := 1; fi;
	return n;
	end);
