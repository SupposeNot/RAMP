TEST_RAMP := function()
	Read(Filename(DirectoriesLibrary("pkg/ramp/tst"), "testall.g"));
	end;

BindGlobal("RampPath", DirectoriesLibrary("pkg/ramp/lib")[1]);

BindGlobal("TestRamp", 
	function(filename)
	local testFile;
	testFile := Filename(DirectoriesLibrary("pkg/ramp/tst"), filename);
	Test(testFile);
	end);

InstallGlobalFunction(AbstractPolytope,
	function(args...)
	local p;
	p := CallFuncList(Maniplex, args);
	SetIsPolytopal(p, true);
	return p;
	end);
	
InstallGlobalFunction(AbstractRegularPolytope,
	function(args...)
	local p;
	p := CallFuncList(ReflexibleManiplex, args);
	SetIsPolytopal(p, true);
	if HasString(p) then
		p!.String := ReplacedString(String(p), "ReflexibleManiplex", "AbstractRegularPolytope");
	fi;
	return p;
	end);

InstallGlobalFunction(AbstractRotaryPolytope,
	function(args...)
	local p;
	p := CallFuncList(RotaryManiplex, args);
	SetIsPolytopal(p, true);
	if HasString(p) then
		p!.String := ReplacedString(String(p), "RotaryManiplex", "AbstractRotaryPolytope");
	fi;
	return p;
	end);

# Modifies the permutation perm by adding k to each entry.
InstallGlobalFunction(TranslatePerm,
	function(perm, k)
	local n, l, l2;
	l := ListPerm(perm);
	Apply(l, i -> i+k);
	l2 := [1..k];
	Append(l2, l);
	perm := PermList(l2);
	return perm;
	end);

# Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), ..., with multiplier terms.	
InstallGlobalFunction(MultPerm,
	function(perm, multiplier, offset)
	local MultPermAux;

	# perm is the "seed" permutations, newperm is the accumulated result so far.
	MultPermAux := function(perm, newperm, multiplier, offset)
		if (multiplier = 1) then
			return newperm;
		else
			return MultPermAux(perm, newperm*TranslatePerm(perm, offset*(multiplier-1)), multiplier-1, offset);
		fi;
		end;
		
	return MultPermAux(perm, perm, multiplier, offset);
	end);
	
# Takes an abstract word in the generators of some free group and returns the corresponding
# abstract word in the generators of f.
InstallGlobalFunction(TranslateWord,
	function(word, f)
	local tw;
	tw := TietzeWordAbstractWord(word);
	return AbstractWordTietzeWord(tw, GeneratorsOfGroup(f));
	end);
	
# This is a bit of a hack.
# GAP has a built-in way to parse group presentations, so that if you take the quotient of,
# say, <a, b, c> by the string "a^5 = b^3 = c^2 = 1", then it does what you expect.
# I want to use this to do something similar with sggis. But the built-in GAP method
# only allows single-letter generators. So I translate r0 -> a, r1 -> b, etc, and
# then back again.	
InstallGlobalFunction(ParseStringCRels,
	function(rels, w)
	local n, f, old_names, new_names, i, parsed_rels, trans_rels, f2;
	n := Size(GeneratorsOfGroup(w));
	if n > 9 then Error("Only works for n < 10"); fi;
	f := FreeGroupOfFpGroup(w);

	i := 1;
	while 's' in rels do
		rels := ReplacedString(rels, Concatenation("s", String(i)), Concatenation("(r", String(i-1), " r", String(i), ")"));
		i := i + 1;
	od;

	# We also support using zj to mean the j-zigzag.
	# For polyhedra, zj = r0 (r1 r2)^j.
	i := 1;
	while 'z' in rels do
		rels := ReplacedString(rels, Concatenation("z", String(i)), Concatenation("(r0 (r1 r2)^", String(i), ")"));
		i := i + 1;
	od;
	
	i := 1;
	while 'h' in rels do
		rels := ReplacedString(rels, Concatenation("h", String(i)), Concatenation("(r0 r1 (r2 r1)^", String(i-1), ")"));
		i := i + 1;
	od;
	
	old_names := List([0..n-1], i -> Concatenation("r", String(i)));
	new_names := ["a","b","c","d","e","f","g","h","i"]{[1..n]};
	for i in [1..n] do
		rels := ReplacedString(rels, old_names[i], new_names[i]);
	od;
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	return trans_rels;
	end);
	
InstallGlobalFunction(ParseRotGpRels,
	function(rels, w)
	local n, f, old_names, new_names, i, parsed_rels, trans_rels, f2;
	n := Size(GeneratorsOfGroup(w));
	if n > 9 then Error("Only works for n < 10"); fi;
	f := FreeGroupOfFpGroup(w);

	old_names := List([1..n], i -> Concatenation("s", String(i)));
	new_names := ["a","b","c","d","e","f","g","h","i"]{[1..n]};
	for i in [1..n] do
		rels := ReplacedString(rels, old_names[i], new_names[i]);
	od;
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	return trans_rels;
	end);
	
# Takes an sggi and converts it to an fp group, a quotient of the
# universal sggi of the appropriate rank.
InstallGlobalFunction(StandardizeSggi,
	function(g)
	local g2, rels, h;
	g2 := Image(IsomorphismFpGroupByGenerators(g, GeneratorsOfGroup(g)));
	rels := List(RelatorsOfFpGroup(g2), r -> TietzeWordAbstractWord(r));
	h := FreeGroupOfFpGroup(UniversalSggi(Size(GeneratorsOfGroup(g))));
	rels := List(rels, r -> AbstractWordTietzeWord(r, GeneratorsOfGroup(h)));
	return FactorGroupFpGroupByRels(h, rels);
	end);
	
InstallGlobalFunction(AddOrAppend,
	function(list, eltOrList)
	if IsList(eltOrList) then
		Append(list, eltOrList);
	else
		Add(list, eltOrList);
	fi;
	return;
	end);
	
PruneRelators := function(M)
	local rels, n, standardRels, ggen, fgen, i, j, order, prunedRels;
	rels := ExtraRelators(M);
	n := Rank(M);
	standardRels := [];
	ggen := GeneratorsOfGroup(AutomorphismGroup(M));
	fgen := FreeGeneratorsOfFpGroup(AutomorphismGroup(M));
	
	for i in [1..n] do
		Add(standardRels, fgen[i]*fgen[i]);
		for j in [1..n] do
			if j <> i then
				if j = i-1 then
					order := SchlafliSymbol(M)[j];
				elif j = i+1 then
					order := SchlafliSymbol(M)[i];
				else
					order := 2;
				fi;
				Add(standardRels, (fgen[i]*fgen[j])^order);
			fi;
		od;
	od;

	prunedRels := Difference(rels, standardRels);
	
	M!.ExtraRelators := prunedRels;
	M!.String := Concatenation("AbstractRegularPolytope(",
		String(SchlafliSymbol(M)), ", \"",
		JoinStringsWithSeparator(prunedRels), "\")");
	end;
