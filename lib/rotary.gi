# For many purposes, it is useful for sggis to have the same (not just isomorphic) underlying
# free group. So the first time we create one in a given rank, we save it and use it again later.
InstallValue(UNIVERSAL_ROT_FREE_GROUPS, []);

# Returns the rotation subgroup of the universal string Coxeter Group of rank n.
InstallMethod(UniversalRotationGroup,
	[IsInt],
	function(n)
	local i, j, f, rels, gens, g, tau;
	if not(IsBound(UNIVERSAL_ROT_FREE_GROUPS[n])) then
		UNIVERSAL_ROT_FREE_GROUPS[n] := FreeGroup(List([1..n-1], i -> Concatenation("s", String(i))));	
	fi;
	f := UNIVERSAL_ROT_FREE_GROUPS[n];
	gens := GeneratorsOfGroup(f);
	rels := [];
	
	tau := function(i,j)
		return Product(List([i..j], k -> gens[k]));
		end;
		
	for i in [1..n-2] do
		for j in [i+1..n-1] do
			Add(rels, tau(i,j)^2);
		od;
	od;
	
	g := FactorGroupFpGroupByRels(f, rels);
	if (n >= 2) then SetSize(g, infinity); fi;
	return g;
	end);

ROT_GROUP_SIZES := function(sym)
	local dict, n, k;
	
	dict := NewDictionary([], true);
	AddDictionary(dict, [3,5], 60);
	AddDictionary(dict, [5,3], 60);
	AddDictionary(dict, [3,4,3], 576);
	AddDictionary(dict, [5,3,3], 7200);
	AddDictionary(dict, [3,3,5], 7200);

	n := Size(sym)+1;
	
	if n = 1 then
		return 1;
	elif n = 2 then
		return sym[1];
	elif KnowsDictionary(dict, sym) then
		return LookupDictionary(dict, sym);
	elif ForAll(sym, i -> i = 3) then
		return Factorial(n+1) / 2;
	elif sym[1] = 4 and ForAll(sym{[2..n-1]}, i -> i = 3) then
		return 2^(n-1) * Factorial(n);
	elif sym[n-1] = 4 and ForAll(sym{[1..n-2]}, i -> i = 3) then
		return 2^(n-1) * Factorial(n);
	elif 2 in sym then
		k := Position(sym, 2);
		return ROT_GROUP_SIZES(sym{[1..k-1]}) * ROT_GROUP_SIZES(sym{[k+1..n-1]}) / 2;
	else
		return infinity;
	fi;
	end;

# Returns the universal string Coxeter Group given by sym.
# For example, UniversalSggi([4,4]) is the group denoted [4, 4].
InstallOtherMethod(UniversalRotationGroup,
	[IsList],
	function(sym)
	local i, j, f, g, rels, gens, n, h;
	n := Size(sym)+1;
	g := UniversalRotationGroup(n);
	gens := FreeGeneratorsOfFpGroup(g);
	rels := [];
	for i in [1..n-1] do
		if sym[i] <> infinity then
			Add(rels, gens[i]^sym[i]);
		fi;
	od;
	h := FactorGroupFpGroupByRels(g, rels);
	SetSize(h, ROT_GROUP_SIZES(sym));
	return h;
	end);
	

# Given an abstract rotation group, builds the rotary (regular or chiral)
# polytope with that group as its rotation group.
InstallMethod(RotaryManiplex,
	[IsGroup],
	function(rotgp)
	local n, p;
	n := 1 + Size(GeneratorsOfGroup(rotgp));

	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsRotaryManiplexRotGpRep), rec( rot_gp := rotgp, fvec := List([1..n], i -> fail) ));
	
	if HasSize(rotgp) then SetSize(p, 2*Size(rotgp)); fi;
	SetRankManiplex(p, n);
	SetRotationGroup(p, rotgp);
#	if IsFpGroup(autgp) then
#		SetAutomorphismGroupFpGroup(p, autgp);
#	elif IsPermGroup(autgp) then
#		SetAutomorphismGroupPermGroup(p, autgp);
#	fi;
	SetIsOrientable(p, true);
	SetIsRotary(p, true);

	return p;
	end);

InstallMethod(RotaryManiplex,
	[IsList],
	function(sym)
	local n, w, p;
	n := Size(sym)+1;
	w := UniversalRotationGroup(sym);
	p := RotaryManiplex(w);
	SetSchlafliSymbol(p, sym);
	SetSize(p, 2*Size(w));
	SetExtraRelators(p, []);
	SetString(p, Concatenation("RotaryManiplex(", String(sym), ")"));
	return p;
	end);

# Usage: RotaryManiplex([4,6], "s2^-1 s1^2 = s1^5 s2^2");
InstallMethod(RotaryManiplex,
	[IsList, IsList],
	function(sym, rels)
	local n, w, rotgp, fam, p, desc;
	n := Size(sym)+1;
	w := UniversalRotationGroup(sym);
	if IsString(rels) then
		desc := Concatenation("RotaryManiplex(", String(sym), ", \"", String(rels), "\")");
		rels := ParseRotGpRels(rels, w);
	else # it's a "Tietze word" like [1, 2, -1, 2, 2]
		desc := Concatenation("RotaryManiplex(", String(sym), ", ", String(rels), ")");
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	rotgp := FactorGroupFpGroupByRels(w, rels);
	p := RotaryManiplex(rotgp);
	if ValueOption("set_schlafli") = true then
		SetSchlafliSymbol(p, sym);
	fi;
	SetString(p, desc);
	
	return p;
	end);

InstallMethod(EnantiomorphicForm,
	[IsRotaryManiplex],
	function(M)
	local rotgp, n, standardRels, rels, extraRels, newrels, rel, newrel, i, M2;
	if HasIsReflexible(M) and IsReflexible(M) then return M; fi;
	
	rotgp := RotationGroup(M);
	n := Rank(M);
	standardRels := RelatorsOfFpGroup(UniversalRotationGroup(SchlafliSymbol(M)));
	rels := RelatorsOfFpGroup(rotgp);
	extraRels := Difference(rels, standardRels);
	
	# Now we change the relators by conjugating by r0.
	# This changes s1 to s1^-1 and s2 to s1^2 s2, while fixing the other si.
	Apply(extraRels, r -> TietzeWordAbstractWord(r));
	newrels := [];
	
	for rel in extraRels do
		newrel := [];
		for i in rel do
			if AbsoluteValue(i) = 1 then
				Add(newrel, -i);
			elif i = 2 then
				Append(newrel, [1, 1, 2]);
			elif i = -2 then
				Append(newrel, [-2, -1, -1]);
			else
				Add(newrel, i);
			fi;
		od;
		Add(newrels, newrel);
	od;
	
	M2 := RotaryManiplex(SchlafliSymbol(M), newrels);
	return M2;
	end);