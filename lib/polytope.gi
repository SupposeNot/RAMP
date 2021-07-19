### RAMP -- Research Assistant for Maniplexes and Polytopes ###

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
	function(M)
	local ispoly;
	ispoly := IsStringC(AutomorphismGroup(M));
	if HasDual(M) then
		SetIsPolytopal(Dual(M), ispoly);
	fi;
	return ispoly;
	end);

# Currently assumes "nice" maniplexes
InstallMethod(IsPolytopal,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local ispoly;
	ispoly := IsStringCPlus(RotationGroup(M));
	if HasDual(M) then
		SetIsPolytopal(Dual(M), ispoly);
	fi;
	return ispoly;
	end);

# Given any group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it. So you could pass in a
# permutation group, matrix group, or anything else.
# NOTE: This does not check whether autgp is an sggi.
InstallMethod(ReflexibleManiplex,
	[IsGroup],
	function(autgp)
	local n, p;
	n := Size(GeneratorsOfGroup(autgp));

	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsReflexibleManiplexAutGpRep), rec( aut_gp := autgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankManiplex(p, n);
	SetAutomorphismGroup(p, autgp);
	if IsFpGroup(autgp) then
		SetAutomorphismGroupFpGroup(p, autgp);
	elif IsPermGroup(autgp) then
		SetAutomorphismGroupPermGroup(p, autgp);
	fi;
	SetIsReflexible(p, true);

	return p;
	end);
	
# The universal maniplex with the given Schlafli symbol.
# Requires every entry of the symbol to be at least 2.
InstallMethod(ReflexibleManiplex,
	[IsList],
	function(sym)
	local n, w, p;
	if ForAny(sym, x -> not(IsInt(x) or x = infinity) or x < 2) then
		Error("Each entry of the Schlafli symbol must be a positive integer at least 2.");
	fi;
	n := Size(sym)+1;

	if n = 1 then
		return UniversalPolytope(1);
	elif n = 2 then 
		return Pgon(sym[1]); 
	elif ForAll(sym, i -> i = 3) then
		return Simplex(n);
	elif sym[1] = 4 and ForAll(sym{[2..n-1]}, i -> i = 3) then
		return Cube(n);
	elif sym[n-1] = 4 and ForAll(sym{[1..n-2]}, i -> i = 3) then
		return CrossPolytope(n);
	elif sym[1] = 4 and sym[n-1] = 4 and ForAll(sym{[2..n-2]}, i -> i = 3) then
		return CubicTiling(n-1);
	elif sym = [3,5] then
		return Icosahedron();
	elif sym = [5,3] then
		return Dodecahedron();
	elif sym = [3,4,3] then
		return 24Cell();
	elif sym = [5,3,3] then
		return 120Cell();
	elif sym = [3,3,5] then
		return 600Cell();
	fi;

	w := UniversalSggi(sym);
	p := ReflexibleManiplex(w);
	SetSchlafliSymbol(p, sym);
	SetSize(p, Size(w));
	SetExtraRelators(p, []);
	SetIsPolytopal(p, true);
	SetString(p, Concatenation("AbstractRegularPolytope(", String(sym), ")"));
	return p;
	end);

# Usage: ReflexibleManiplex([4,6], "(r0r1r2)^6 = r0(r1r2)^5 = 1");
InstallMethod(ReflexibleManiplex,
	[IsList, IsList],
	function(sym, rels)
	local n, w, autgp, fam, p, newrels, desc;
	n := Size(sym)+1;
	w := UniversalSggi(sym);
	if IsString(rels) then
		newrels := ParseStringCRels(rels, w);
		desc := Concatenation("ReflexibleManiplex(", String(sym), ", \"", String(rels), "\")");
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
		desc := Concatenation("ReflexibleManiplex(", String(sym), ", ", String(rels), ")");
	fi;
	autgp := FactorGroupFpGroupByRels(w, newrels);
	p := ReflexibleManiplex(autgp);
	SetExtraRelators(p, newrels);
	if ValueOption("set_schlafli") = true then
		SetSchlafliSymbol(p, sym);
	fi;

	SetString(p, desc);
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

	SetString(p, Concatenation("ReflexibleManiplex(", name, ")"));
	
	return p;
	end);
	
# Given a permutation group (sggi), builds a maniplex with that as its connection group.	
InstallMethod(Maniplex,
	[IsPermGroup],
	function(g)
	local n, fam, p;
	n := Size(GeneratorsOfGroup(g));
	
	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsManiplexConnGpRep), rec( conn_gp := g, fvec := List([1..n], i -> fail) ));
	
	SetSize(p, NrMovedPoints(g));
	SetRankManiplex(p, n);
	SetConnectionGroup(p, g);
	return p;
	end);
	
InstallMethod(Maniplex,
	[IsReflexibleManiplex, IsGroup],
	function(M, G)
	local n, M2, fam;
	
	n := Rank(M);
	if not(IsSubgroup(AutomorphismGroup(M), G)) then
		Error("The given group is not a subgroup of AutomorphismGroup(M).");
	fi;
	
	M2 := Objectify( NewType( ManiplexFamily, IsManiplex and IsManiplexQuotientRep), rec( parent := M, subgroup := G ));
	
	SetRankManiplex(M2, n);
	return M2;
	end);
	
InstallMethod(Maniplex,
	[IsFunction, IsList],
	function(oper, inputs)
	return Objectify( NewType( ManiplexFamily, IsManiplex and IsManiplexInstructionsRep), rec( operation := oper, args := inputs, attr_computers := NewDictionary(Size, true) ));
	end);

InstallMethod(Maniplex,
	[IsPoset],
	function(P)
	local M, n;
	n := Rank(P);
	M := Objectify( NewType( ManiplexFamily, IsManiplex and IsManiplexPosetRep), rec( poset := P, fvec := List([1..n], i -> fail))); 
	SetRankManiplex(M, n);
	return M;
	end);
	
InstallOtherMethod(Size,
	[IsReflexibleManiplex],
	function(M)
	local val;
	val := Size(AutomorphismGroup(M));
	if HasDual(M) then
		SetSize(Dual(M), val);
	fi;
	return val;
	end);
	
InstallOtherMethod(Size,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local val;
	val := 2 * Size(RotationGroup(M));
	if HasDual(M) then
		SetSize(Dual(M), val);
	fi;
	return val;
	end);
	
InstallOtherMethod(Size,
	[IsManiplex and IsManiplexQuotientRep],
	function(M)
	local val;
	val := Index(AutomorphismGroup(M!.parent), M!.subgroup);
	if HasDual(M) then
		SetSize(Dual(M), val);
	fi;
	return val;
	end);

InstallMethod(Size,
	[IsManiplex],
	function(M)
	local val;
	if IsManiplexInstructionsRep(M) then
		val := ComputeAttr(M, Size);
		if val <> fail then return val; fi;
	fi;
	
	val := LargestMovedPoint(ConnectionGroup(M));
	if HasDual(M) then
		SetSize(Dual(M), val);
	fi;
	return val;
	end);
	
InstallMethod(RankManiplex,
	[IsReflexibleManiplex],
	M -> Size(GeneratorsOfGroup(AutomorphismGroup(M))));

InstallMethod(RankManiplex,
	[IsManiplex and IsManiplexConnGpRep],
	M -> Size(GeneratorsOfGroup(ConnectionGroup(M))));

InstallMethod(RankManiplex,
	[IsManiplex and IsManiplexQuotientRep],
	M -> Rank(M!.parent));

InstallMethod(Rank, [IsManiplex], RankManiplex);
	
InstallMethod(IsDegenerate,
	[IsReflexibleManiplex],
	function(M)
	local val;
	val := (2 in SchlafliSymbol(M));
	if HasDual(M) then
		SetIsDegenerate(Dual(M), val);
	fi;
	return val;
	end);

InstallMethod(IsTight,
	[IsManiplex and IsEquivelar and HasIsPolytopal and IsPolytopal],
	function(M)
	local val;
	val := (Size(M) = 2*Product(SchlafliSymbol(M)));
	if HasDual(M) then
		SetIsTight(Dual(M), val);
	fi;
	return val;
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

InstallGlobalFunction(MANIPLEX_STRING,
	function(p)
	local str;
	str := "";
	if IsReflexibleManiplex(p) then
		if HasIsPolytopal(p) and IsPolytopal(p) then
			Append(str, "regular ");
		else
			Append(str, "reflexible ");
		fi;
	fi;
	
	if HasIsPolytopal(p) and not(IsPolytopal(p)) then
		Append(str, "nonpolytopal ");
	fi;
	
	Append(str, String(Rank(p)));
	if HasIsPolytopal(p) and IsPolytopal(p) then
		Append(str, "-polytope");
	else
		Append(str, "-maniplex");
	fi;
	if HasSchlafliSymbol(p) then 
		Append(str, Concatenation(" of type ", String(SchlafliSymbol(p))));
	fi;
	if HasSize(p) then 
		Append(str, Concatenation(" with ", String(Size(p)), " flags")); 
	fi;
	return str;
	end);
	
InstallMethod(DisplayString,
	[IsManiplex],
	function(p)
	return MANIPLEX_STRING(p);
	end);
	
	
InstallMethod(String,
	[IsManiplex],
	function(M)
	return MANIPLEX_STRING(M);
	end);
	
# TODO: This is currently broken for rotary maniplexes
# I really want orbs to be the action of the automorphism
# group on the _flags_.
# Wait until graph code is done
InstallMethod(SymmetryTypeGraph,
	[IsManiplex],
	function(p)
	local ag, cg, orbs, k, perms, i, r, rp, orb, new_orb;
	if IsReflexibleManiplex(p) then
		return List([1..Rank(p)], i -> ());
	fi;
	
	ag := AutomorphismGroupPermGroup(p);
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
		n := LargestMovedPoint(Group(SymmetryTypeGraph(M)));
		if n = 0 then n := 1; fi;
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
	local val;
	val := ForAll(SymmetryTypeGraph(M), r -> r = (1,2));
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
