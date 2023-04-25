
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
	if IsString(sym) then
		return ReflexibleManiplexFromName(sym);
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

InstallMethod(ReflexibleManiplexFromName,
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
	elif not(IsTransitive(g)) then
		Error("g must act transitively!");
	else
		return ManiplexNC(g);
	fi;
	end);
	
InstallMethod(ManiplexNC,
	[IsPermGroup],
	function(g)
	local n, p;

	if not(IsFixedPointFreeSggi(g)) then
		Info(InfoRamp, 1, "The given Sggi defines a pre-maniplex but not a maniplex.");		
		return PremaniplexNC(g);
	fi;
	
	n := Size(GeneratorsOfGroup(g));
	
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
	local g,M,n;

	g := ConnectionGroup(x);
	
	if not(IsTransitive(g)) then
		Error("Flag graph must be connected!");
	fi;

	if not(IsFixedPointFreeSggi(g)) then
		Info(InfoRamp, 1, "The given graph defines a pre-maniplex but not a maniplex.");		
		return Premaniplex(x);
	fi;
	
	n:=Size(Set(Labels(x)));
	M := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsManiplexFlagGraphRep), rec(fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true))); 
	SetRankManiplex(M, Size(Set(Labels(x))));
	SetConnectionGroup(M, ConnectionGroup(x));
	SetSize(M, Size(Vertices(x)));
	return M;
	end);
	
InstallMethod(Premaniplex,
	[IsGroup],
	function(g)
	if not(IsSggi(g)) then
		Error("g must be an Sggi!");
	else
		return PremaniplexNC(g);
	fi;
	end);


InstallMethod(PremaniplexNC,
	[IsGroup],
	function(g)
	local pm;
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexConnGpRep),  	    rec(conn_gp:=g, flags:=MovedPoints(g), rank:=Size(GeneratorsOfGroup(g)), attr_computers := NewDictionary(Size, true)));
	SetConnectionGroup(pm,g);
	SetRankManiplex(pm, pm!.rank);	
	SetSize(pm, NrMovedPoints(g));
	return(pm);
	end);


InstallMethod(Premaniplex,
	[IsEdgeLabeledGraph],
	function(g)
	local pm, c;
	c:=ConnectionGroup(g);
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexGraphRep),  	    rec(conn_gp:=c, flags:=Vertices(g), rank:=Size(Set(Labels(g))), attr_computers := NewDictionary(Size, true)));
	SetConnectionGroup(pm,c);
	SetRankManiplex(pm, pm!.rank);	
	if NrMovedPoints(c) = 0 then
		SetSize(pm, 1);
	else
		SetSize(pm, NrMovedPoints(c));
	fi;
	return(pm);
	end);

InstallMethod(ReflexiblePremaniplexNC,
	[IsGroup],
	function(autgp)
	local n, p;
	n := Size(GeneratorsOfGroup(autgp));

	p := Objectify( NewType( PremaniplexFamily, IsPremaniplex and IsReflexibleManiplexAutGpRep), rec( aut_gp := autgp, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true) ));
	
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

InstallMethod(ReflexiblePremaniplex,
	[IsGroup],
	function(autgp)
	if ValueOption("no_check") = true or IsSggi(autgp) then
		return ReflexiblePremaniplexNC(autgp);
	else
		Error("The given group is not an Sggi.");
	fi;
	end);
	
	

# Given an abstract rotation group, builds the rotary (regular or chiral)
# polytope with that group as its rotation group.
InstallMethod(RotaryManiplexNC,
	[IsGroup],
	function(rotgp)
	local n, p;
	n := 1 + Size(GeneratorsOfGroup(rotgp));

	p := Objectify( NewType( ManiplexFamily, IsManiplex and IsPremaniplex and IsRotaryManiplexRotGpRep), rec( rot_gp := rotgp, fvec := List([1..n], i -> fail), attr_computers := NewDictionary(Size, true) ));
	
	if HasSize(rotgp) then SetSize(p, 2*Size(rotgp)); fi;
	SetRankManiplex(p, n);
	SetRotationGroup(p, rotgp);
	SetIsOrientable(p, true);
	SetIsRotary(p, true);

	return p;
	end);

InstallMethod(RotaryManiplex,
	[IsGroup],
	function(rotgp)
	if ValueOption("no_check") = true or IsStringRotationGroup(rotgp) then
		return RotaryManiplexNC(rotgp);
	else
		Error("The given group is not a String Rotation Group.");
	fi;
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
		rels := InterpolatedString(rels);
		desc := Concatenation(desc, String(sym), ", \"", String(rels), "\")");
		rels := ParseRotGpRels(rels, w);
	else # it's a "Tietze word" like [1, 2, -1, 2, 2]
		desc := Concatenation(desc, String(sym), ", ", String(rels), ")");
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	rotgp := FactorGroupFpGroupByRels(w, rels);
	p := RotaryManiplexNC(rotgp);
	if ValueOption("set_schlafli") = true then
		SetSchlafliSymbol(p, sym);
	else
		SetPseudoSchlafliSymbol(p, sym);
	fi;
	SetString(p, desc);
	if ValueOption("polytopal") = true then
		SetIsPolytopal(p, true);
	fi;

	SetRotationGroupFpGroup(p, rotgp);
	
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
	[IsManiplex],
	function(M)
	local rotgp, n, standardRels, rels, extraRels, newrels, rel, newrel, i, M2, relstr, polytopal;
	
	if IsReflexible(M) then 
		return M; 
	elif IsChiral(M) then
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
	else
		Error("EnantiomorphicForm is only defined for rotary maniplexes.");
	fi;
	
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

TwoOrbit3ManiplexClass2_1 := function(sym, rels)
	local f, w, v, old_names, new_names, i, parsed_rels, trans_rels, autgp, M, standard_rels, f2, wp, hom, ker, connectionGroup, new_rels;
	
	old_names := ["r1", "a010", "a20"];
	f := FreeGroup(old_names);
	
	new_names := ["a","b","c"];
	new_rels := rels;
	for i in [1..3] do
		new_rels := ReplacedString(new_rels, old_names[i], new_names[i]);
	od;

	trans_rels := [];
	
	standard_rels := ParseRelators(GeneratorsOfGroup(f2), Concatenation("a^2, b^2, c^2, (ab)^", String(sym[1]/2), ", (acbc)^", String(sym[2]/2)));	
	Append(trans_rels, List(standard_rels, r -> TranslateWord(r, f)));

	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), new_rels);
	Append(trans_rels, List(parsed_rels, r -> TranslateWord(r, f)));	
	
	autgp := FactorGroupFpGroupByRels(f, trans_rels);
	
	w := UniversalSggi(3);
	wp := Subgroup(w, [w.2, w.1*w.2*w.1, w.1*w.3]);
	hom := GroupHomomorphismByImagesNC(wp, autgp, GeneratorsOfGroup(wp), GeneratorsOfGroup(autgp));
	ker := Kernel(hom);
	connectionGroup := Image(FactorCosetAction(w, ker));
	
	M := Maniplex(connectionGroup);
	SetAutomorphismGroup(M, autgp);
	
	SetString(M, Concatenation("TwoOrbit3ManiplexClass2_1(", String(sym), ", \" ", rels, "\")"));
	
	return M;
	end;
		