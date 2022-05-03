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

# Returns the universal rotation group given by sym.
# For example, UniversalRotationGroup([4,4]) is the group denoted [4, 4]^+.
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
	SetSize(h, COXETER_GROUP_SIZES(sym) / 2);
	return h;
	end);
	

# Given an abstract rotation group, builds the rotary (regular or chiral)
# polytope with that group as its rotation group.
InstallMethod(RotaryManiplex,
	[IsGroup],
	function(rotgp)
	local n, p;
	n := 1 + Size(GeneratorsOfGroup(rotgp));

	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsRotaryManiplexRotGpRep), rec( rot_gp := rotgp, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true) ));
	
	if HasSize(rotgp) then SetSize(p, 2*Size(rotgp)); fi;
	SetRankManiplex(p, n);
	SetRotationGroup(p, rotgp);
	SetIsOrientable(p, true);
	SetIsRotary(p, true);

	return p;
	end);

# A rotary maniplex defined by a Schlafli Symbol is in fact reflexible.
InstallMethod(RotaryManiplex,
	[IsList],
	function(sym)
	return ReflexibleManiplex(sym);
	end);

# Usage: RotaryManiplex([4,6], "s2^-1 s1^2 = s1^5 s2^2");
InstallMethod(RotaryManiplex,
	[IsList, IsList],
	function(sym, rels)
	local n, w, rotgp, fam, p, desc;
	n := Size(sym)+1;
	w := UniversalRotationGroup(sym);
	
	if ValueOption("polytopal") = true then
		desc := "AbstractRotaryPolytope(";
	else
		desc := "RotaryManiplex(";
	fi;
	
	if IsString(rels) then
		desc := Concatenation(desc, String(sym), ", \"", String(rels), "\")");
		rels := ParseRotGpRels(rels, w);
	else # it's a "Tietze word" like [1, 2, -1, 2, 2]
		desc := Concatenation(desc, String(sym), ", ", String(rels), ")");
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	rotgp := FactorGroupFpGroupByRels(w, rels);
	p := RotaryManiplex(rotgp);
	if ValueOption("set_schlafli") = true then
		SetSchlafliSymbol(p, sym);
	else
		SetPseudoSchlafliSymbol(p, sym);
	fi;
	SetString(p, desc);
	if ValueOption("polytopal") = true then
		SetIsPolytopal(p, true);
	fi;
	
	return p;
	end);

InstallMethod(RotaryManiplex,
	[IsList, IsList, IsList],
	function(sym, words, orders)
	local new_words, relstr;
	new_words := List([1..Size(words)], i -> Concatenation("(", words[i], ")^", String(orders[i])));
	relstr := JoinStringsWithSeparator(new_words, ",");
	return RotaryManiplex(sym, relstr);
	end);


InstallMethod(EnantiomorphicForm,
	[IsRotaryManiplex],
	function(M)
	local rotgp, n, standardRels, rels, extraRels, newrels, rel, newrel, i, M2, relstr, polytopal;
	if HasIsReflexible(M) and IsReflexible(M) then return M; fi;
	
	rotgp := RotationGroupFpGroup(M);
	n := Rank(M);
	standardRels := List(RelatorsOfFpGroup(UniversalRotationGroup(SchlafliSymbol(M))), TietzeWordAbstractWord);
	rels := List(RelatorsOfFpGroup(rotgp), TietzeWordAbstractWord);
	extraRels := Difference(rels, standardRels);
	newrels := [];
	
	# Now we change the relators by conjugating by r0.
	# This changes s1 to s1^-1 and s2 to s1^2 s2, while fixing the other si.
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
		newrel := AbstractWordTietzeWord(newrel, FreeGeneratorsOfFpGroup(rotgp));
		Add(newrels, newrel);
	od;

	relstr := JoinStringsWithSeparator(List(newrels, r -> String(r)));
	
	M2 := RotaryManiplex(SchlafliSymbol(M), relstr);
	return M2;
	end);
	
	
TwoOrbit3ManiplexClass2_02 := function(sym, rels)
	local f, w, v, old_names, new_names, i, parsed_rels, trans_rels, autgp, M, standard_rels, f2, wp, hom, ker, connectionGroup;
	
	old_names := ["r0", "r2", "a101", "a121"];
	f := FreeGroup(old_names);
	
	new_names := ["a","b","c","d"];
	for i in [1..4] do
		rels := ReplacedString(rels, old_names[i], new_names[i]);
	od;
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	
	standard_rels := ParseRelators(GeneratorsOfGroup(f2), Concatenation("a^2, b^2, c^2, d^2, (ab)^2, (cd)^2, (ac)^", String(sym[1]/2), ", (bd)^", String(sym[2]/2)));
	
	Append(trans_rels, List(standard_rels, r -> TranslateWord(r, f)));
	
	autgp := FactorGroupFpGroupByRels(f, trans_rels);
	
	w := UniversalSggi(3);
	wp := Subgroup(w, [w.1, w.3, w.2*w.1*w.2, w.2*w.3*w.2]);
	hom := GroupHomomorphismByImagesNC(wp, autgp, GeneratorsOfGroup(wp), GeneratorsOfGroup(autgp));
	ker := Kernel(hom);
	connectionGroup := Image(FactorCosetAction(w, ker));
	
	M := Maniplex(connectionGroup);
	SetAutomorphismGroup(M, autgp);
	
	return M;
	end;
	
	
	
	
TwoOrbit3ManiplexClass2_0 := function(sym, rels)
	local f, w, v, old_names, new_names, i, parsed_rels, trans_rels, autgp, M, standard_rels, f2, wp, hom, ker, connectionGroup, new_rels;
	
	old_names := ["r0", "a21", "a101"];
	f := FreeGroup(old_names);
	
	new_names := ["a","b","c"];
	new_rels := rels;
	for i in [1..3] do
		new_rels := ReplacedString(new_rels, old_names[i], new_names[i]);
	od;
	
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), new_rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	
	standard_rels := ParseRelators(GeneratorsOfGroup(f2), Concatenation("a^2, c^2, ab = bc, (ac)^", String(sym[1]/2), ", b^", String(sym[2])));
	
	Append(trans_rels, List(standard_rels, r -> TranslateWord(r, f)));
	
	autgp := FactorGroupFpGroupByRels(f, trans_rels);
	
	w := UniversalSggi(3);
	wp := Subgroup(w, [w.1, w.3*w.2, w.2*w.1*w.2]);
	hom := GroupHomomorphismByImagesNC(wp, autgp, GeneratorsOfGroup(wp), GeneratorsOfGroup(autgp));
	ker := Kernel(hom);
	connectionGroup := Image(FactorCosetAction(w, ker));
	
	M := Maniplex(connectionGroup);
	SetAutomorphismGroup(M, autgp);
	
	SetString(M, Concatenation("TwoOrbit3ManiplexClass2_0(", String(sym), ", \" ", rels, "\")"));
	
	return M;
	end;
	