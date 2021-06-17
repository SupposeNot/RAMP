### RAMP -- Research Assistant for Maniplexes and Polytopes ###

# TODO
# If we later learn that a polytope is regular, then do we need to promote it?
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
	
InstallMethod(IsPolytopal,
	[IsReflexibleManiplex],
	function(m)
	return IsStringC(AutomorphismGroup(m));
	end);

# Given any group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it. So you could pass in a
# permutation group, matrix group, or anything else.
# NOTE: This does not check whether autgp is an sggi.
InstallMethod(ReflexibleManiplex,
	[IsGroup],
	function(autgp)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(autgp));

	fam := NewFamily(Concatenation("Reflexible ", String(n), "-Maniplex"), IsReflexibleManiplex);
	fam!.rank := n;
	p := Objectify( NewType( fam, IsReflexibleManiplex and IsReflexibleManiplexWithRels), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankManiplex(p, n);
	SetAutomorphismGroup(p, autgp);

	return p;
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
	SetExtraRelators(p, []);
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
	p := ReflexibleManiplex(autgp);
	SetExtraRelators(p, rels);
	return p;
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
	
InstallMethod( ViewObj,
	[IsManiplex],
	function(p)
	if HasDescription(p) then
		Print(Description(p));
		Print("\n");
	fi;
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

