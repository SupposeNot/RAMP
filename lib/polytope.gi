### RAMP -- Research Assistant for Maniplexes and Polytopes ###


# Given any group (which should be a sggi), builds the regular
# polytope (well, maniplex) out of it. So you could pass in a
# permutation group, matrix group, or anything else.
# NOTE: This does not check whether autgp is an sggi.
InstallMethod(ReflexibleManiplexNC,
	[IsGroup],
	function(autgp)
	local n, p;
	n := Size(GeneratorsOfGroup(autgp));

	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsReflexibleManiplexAutGpRep), rec( aut_gp := autgp, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true) ));
	
	if HasSize(autgp) then SetSize(p, Size(autgp)); fi;
	SetRankManiplex(p, n);
	SetAutomorphismGroup(p, autgp);
	if IsFpGroup(autgp) then
		SetAutomorphismGroupFpGroup(p, autgp);
	elif IsPermGroup(autgp) then
		SetAutomorphismGroupPermGroup(p, autgp);
	fi;
	SetIsReflexible(p, true);
	if HasSchlafliSymbol(autgp) then SetSchlafliSymbol(p, SchlafliSymbol(autgp)); fi;

	return p;
	end);

InstallMethod(ReflexibleManiplex,
	[IsGroup],
	function(autgp)
	if ValueOption("no_check") = true or IsSggi(autgp) then
		return ReflexibleManiplexNC(autgp);
	else
		Error("The given group is not an Sggi.");
	fi;
	end);
	
# The universal maniplex with the given Schlafli symbol.
# Requires every entry of the symbol to be at least 2.
InstallMethod(ReflexibleManiplex,
	[IsList],
	function(sym)
	local n, w, p;
	#if ForAny(sym, x -> not(IsInt(x) or x = infinity) or x < 2) then
	#	Error("Each entry of the Schlafli symbol must be a positive integer at least 2.");
	#fi;
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
	
	if n = 3 and sym[1] = 2 then
		SetPetrieLength(p, Lcm(2, sym[2]));
	elif n = 3 and sym[2] = 2 then
		SetPetrieLength(p, Lcm(2, sym[1]));	
	fi;
	
	if not(1 in sym) then
		SetIsPolytopal(p, true);
		SetString(p, Concatenation("AbstractRegularPolytope(", String(sym), ")"));
	else
		SetIsPolytopal(p, false);
		SetString(p, Concatenation("ReflexibleManiplex(", String(sym), ")"));
	fi;
	return p;
	end);

# Usage: ReflexibleManiplex([4,6], "(r0r1r2)^6 = r0(r1r2)^5 = 1");
InstallMethod(ReflexibleManiplex,
	[IsList, IsList],
	function(sym, rels)
	local n, w, autgp, fam, p, newrels, desc;
	if rels = [] then return AbstractRegularPolytope(sym); fi;
	n := Size(sym)+1;
	w := UniversalSggi(sym);

	if ValueOption("polytopal") = true then
		desc := "AbstractRegularPolytope(";
	else
		desc := "ReflexibleManiplex(";
	fi;

	if IsString(rels) then
		rels := InterpolatedString(rels);
		newrels := ParseStringCRels(rels, w);
		desc := Concatenation(desc, String(sym), ", \"", String(rels), "\")");
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
		desc := Concatenation(desc, String(sym), ", ", String(rels), ")");
	fi;
	autgp := FactorGroupFpGroupByRels(w, newrels);
	p := ReflexibleManiplexNC(autgp);
	SetExtraRelators(p, newrels);
	if ValueOption("set_schlafli") = true then
		SetSchlafliSymbol(p, sym);
	else
		SetPseudoSchlafliSymbol(p, sym);
	fi;

	if ValueOption("polytopal") = true then
		SetIsPolytopal(p, true);
	fi;

	SetString(p, desc);
	return p;
	end);

InstallMethod(ReflexibleManiplex,
	[IsList, IsList, IsList],
	function(sym, words, orders)
	local new_words, relstr;
	new_words := List([1..Size(words)], i -> Concatenation("(", words[i], ")^", String(orders[i])));
	relstr := JoinStringsWithSeparator(new_words, ",");
	return ReflexibleManiplex(sym, relstr);
	end);

InstallMethod(ReflexibleManiplex,
	[IsString],
	function(name)
	local newname, L, L2, holes, zigzags, sym, hrels, zrels, i, zlengths, symlist, hlengths, rels, M;
	RemoveCharacters(name, " ");
	L := SplitString(name, "_");
	zigzags := "";
	if Size(L) > 1 then
		zigzags := L[2];
	fi;
	newname := L[1];
	L2 := SplitString(newname, "|");
	hrels := "";
	if Size(L2) = 2 then
		holes := SplitString(L2[2], "}")[1];
		hrels := "";
		hlengths := SplitString(holes, ",");
		for i in [1..Size(hlengths)] do
			Append(hrels, Concatenation("(r0 r1 (r2 r1)^", String(i), ")^", String(hlengths[i])));
			if i <> Size(hlengths) then
				Append(hrels, ", ");
			fi;
		od;
		
	fi;
	sym := SplitString(L2[1], "{}")[2];
	
	zrels := "";
	if zigzags <> "" then
		zlengths := SplitString(zigzags, ",");
		for i in [1..Size(zlengths)] do
			Append(zrels, Concatenation("(r0 (r1 r2)^", String(i), ")^", String(zlengths[i])));
			if i <> Size(zlengths) then
				Append(zrels, ", ");
			fi;
		od;
	fi;
	
	rels := hrels;
	if hrels <> "" and zrels <> "" then
		Append(rels, ", ");
	fi;
	Append(rels, zrels);
	
	symlist := SplitString(sym, ",");
	symlist := List(symlist, Int);
	
	M := ReflexibleManiplex(symlist, rels);
	return M;
	end);

# Given a permutation group (sggi), builds a maniplex with that as its connection group.	
InstallMethod(Maniplex,
	[IsPermGroup],
	function(g)
	if not(IsSggi(g)) then
		Error("g must be an Sggi!");
	else
		return ManiplexNC(g);
	fi;
	end);
	
InstallMethod(ManiplexNC,
	[IsPermGroup],
	function(g)
	local gens, genprods, i, j, n, num_flags, fam, p;

	gens := GeneratorsOfGroup(g);
	n := Size(gens);
	num_flags := NrMovedPoints(g);
	genprods := [];
	for i in [1..n-1] do
		for j in [i+1..n] do
			Add(genprods, gens[i]*gens[j]);
		od;
	od;
		
	# If any generator or product of generators has fixed points, then return a pre-maniplex instead.
	if ForAny(gens, x -> NrMovedPoints(x) < num_flags) or ForAny(genprods, x -> NrMovedPoints(x) < num_flags) then
		Info(InfoRamp, 1, "The given Sggi defines a pre-maniplex but not a maniplex.");		
		return PremaniplexNC(g);
	fi;
	
	if n = 0 then
		return UniversalPolytope(0);
	elif n = 1 then
		return UniversalPolytope(1);
	elif n = 2 and ValueOption("no_reindexing") <> true then
		return Pgon(NrMovedPoints(g) / 2);
	fi;
	
	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexConnGpRep), rec( conn_gp := g, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true)));
	
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
	
	M2 := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexQuotientRep), rec( parent := M, subgroup := G, attr_computers := NewDictionary(Size, true) ));
	
	SetRankManiplex(M2, n);
	return M2;
	end);
	
InstallMethod(Maniplex,
	[IsFunction, IsList],
	function(oper, inputs)
	return Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexInstructionsRep), rec( operation := oper, args := inputs, attr_computers := NewDictionary(Size, true) ));
	end);

InstallMethod(Maniplex,
	[IsPoset],
	function(P)
	local M, n;
	n := Rank(P);
	M := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexPosetRep), rec( poset := P, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true))); 
	SetRankManiplex(M, n);
	return M;
	end);
	
InstallMethod(Maniplex,
	[IsEdgeLabeledGraph],
	function(x)
	local M,n;
	n:=Size(Set(Labels(x)));
	M := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexFlagGraphRep), rec(fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true))); 
	SetRankManiplex(M, Size(Set(Labels(x))));
	SetConnectionGroup(M, ConnectionGroup(x));
	SetSize(M, Size(Vertices(x)));
	return M;
	end);
	
	
InstallMethod(Size,
	[IsManiplex],
	function(M)
	local size;
	size := ComputeAttr(M, Size);
	if size <> fail then return size; fi;

	if HasIsReflexible(M) and IsReflexible(M) then
		return Size(AutomorphismGroup(M));
	elif IsRotaryManiplexRotGpRep(M) then
		return 2*Size(RotationGroup(M));
	elif IsManiplexQuotientRep(M) then
		return Index(AutomorphismGroup(M!.parent), M!.subgroup);
	else
		return NrMovedPoints(ConnectionGroup(M));
	fi;
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

InstallMethod(Rank, [IsPremaniplex], RankManiplex);
	
InstallMethod(IsVertexFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;
	
	if not(IsReflexible(p)) then
		Error("IsVertexFaithful is only defined for reflexible maniplexes");
	fi;
	
	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);
	
InstallMethod(MaxVertexFaithfulQuotient,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;

	if not(IsReflexible(p)) then
		Error("MaxVertexFaithfulQuotient is only defined for reflexible maniplexes");
	fi;
	
	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[2..n]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return ReflexibleManiplex(g/c);
	end);
	
InstallMethod(IsFacetFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;

	if not(IsReflexible(p)) then
		Error("IsFacetFaithful is only defined for reflexible maniplexes");
	fi;	

	g := AutomorphismGroup(p);
	n := Rank(p);
	gens := GeneratorsOfGroup(g){[1..n-1]};
	h := Subgroup(g, gens);
	c := Core(g,h);
	return (Size(c) = 1);
	end);

InstallMethod(IsPolytopal,
	[IsManiplex],
	function(M)
	local isPolytopal;
	
	isPolytopal := ComputeAttr(M, IsPolytopal);
	if isPolytopal = fail then
		if HasIsEquivelar(M) and IsEquivelar(M) and Size(M) < 2*Product(SchlafliSymbol(M)) then
			isPolytopal := false;
		elif HasIsReflexible(M) and IsReflexible(M) then
			isPolytopal := IsStringC(AutomorphismGroup(M));
			if isPolytopal and IsBound(M!.String) then M!.String := ReplacedString(M!.String, "ReflexibleManiplex", "AbstractRegularPolytope"); fi;
		elif IsRotaryManiplexRotGpRep(M) then
			isPolytopal := IsStringCPlus(RotationGroup(M));
			if isPolytopal and IsBound(M!.String) then M!.String := ReplacedString(M!.String, "RotaryManiplex", "AbstractRotaryPolytope"); fi;
		else
			isPolytopal := SatisfiesWeakPathIntersectionProperty(M);
		fi;
	fi;
	
	return isPolytopal;
	end);
	
	
InstallMethod(SatisfiesWeakPathIntersectionProperty,
	[IsManiplex],
	function(m)
	local c, N, r, gens, v, u, i ,j, A, B, C, orbA, orbB, orbC;
	c:=ConnectionGroup(m);
	N:=Size(MovedPoints(c));
	r:=Rank(m);
	gens:=GeneratorsOfGroup(c);
	if not IsTransitive(c) then
		return false;
	fi;
	for v in [1..N] do
		for i in [1..r-1] do
			for j in [i+1..r] do
				A := [i+1..r];
				B := [1..j-1];
				C := [i+1..j-1];
				orbA := Orbit(Group(gens{A}), v);
				orbB := Orbit(Group(gens{B}), v);
				if IsEmpty(C) then
					orbC := [v];
				else
					orbC := Orbit(Group(gens{C}), v);
				fi;
				if AsSet(Intersection(orbA, orbB)) <> AsSet(orbC) then 
					return false;
				fi;
			od;
		od;
	od;
	return true;
	end);

InstallMethod(IsFaithful,
	[IsManiplex],
	function(m)
	#for each flag we will test if the intersection of all the i faces containing it 
	# is just the flag itself.  If not, it isn't faithful.
	local c, gens, M, f, i, ind, Ci, test;
	c:=ConnectionGroup(m);
	gens:=GeneratorsOfGroup(c);	
	M:=MovedPoints(c);
	for f in M do 
	test:=ShallowCopy(M);
	for i in [1..Size(gens)] do
	ind:=[1..Size(gens)];
	Remove(ind,i);
	Ci:=Group(List(ind, j-> gens[j]));	
	test:=Intersection(Orbit(Ci,f),test);
	od;
	if Size(test) <> 1 then 
	return false;
	fi;
	od;
	return true;
	end);
	
