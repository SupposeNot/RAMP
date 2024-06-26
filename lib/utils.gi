
SetInfoLevel(InfoRamp, 1);

TEST_RAMP := function()
	local test_files, filename;
	test_files := DirectoryContents(DirectoriesPackageLibrary("ramp", "tst")[1]);
	test_files := Filtered(test_files, w -> "tst" in SplitString(w,"."));
	for filename in test_files do
		Test(Filename(DirectoriesPackageLibrary("ramp", "tst"), filename));
	od;
	end;

BindGlobal("RampPath", DirectoriesPackageLibrary("ramp")[1]);
BindGlobal("RampDataPath", DirectoriesPackageLibrary("ramp", "data")[1]);

BindGlobal("TestRamp", 
	function(filename)
	local testFile;
	testFile := Filename(DirectoriesPackageLibrary("ramp", "tst"), filename);
	Test(testFile);
	end);

InstallGlobalFunction(AbstractPolytope,
	function(args...)
	local p;
	p := CallFuncList(Maniplex, args);
	if not(IsPolytopal(p)) then
		Error("The given input does not define a polytope.");
	fi;
	return p;
	end);

InstallGlobalFunction(AbstractPolytopeNC,
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
	if ValueOption("no_check") <> true then
		if not(IsPolytopal(p)) then
			Error("The given input does not define a polytope.");
		fi;
	else
		SetIsPolytopal(p, true);
	fi;
	if HasString(p) then
		p!.String := ReplacedString(String(p), "ReflexibleManiplex", "AbstractRegularPolytope");
	fi;
	return p;
	end);

InstallGlobalFunction(AbstractRegularPolytopeNC,
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
	if ValueOption("no_check") <> true then
		if not(IsPolytopal(p)) then
			Error("The given input does not define a polytope.");
		fi;
	else
		SetIsPolytopal(p, true);
	fi;
	if HasString(p) then
		p!.String := ReplacedString(String(p), "RotaryManiplex", "AbstractRotaryPolytope");
	fi;
	return p;
	end);

InstallGlobalFunction(AbstractRotaryPolytopeNC,
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
	local src, dest;
	src := MovedPoints(perm)+k;
	dest := List(MovedPoints(perm), i -> i^perm + k);
	return MappingPermListList(src, dest);
	end);

# Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), ..., with multiplier terms.	
InstallGlobalFunction(MultPerm,
	function(perm, multiplier, offset)
	local newperm, k, i, perms;

	if multiplier = 0 then
		return ();
	else
		perms := List([0, offset..(multiplier-1)*offset], i -> TranslatePerm(perm, i));
		return Product(perms);
	fi;

	end);
	
InstallMethod(PermFromRange,
	[IsPerm, IsPerm, IsPerm],
	function(perm1, perm2, perm3)
	local multiplier, offset;
	offset := SmallestMovedPoint(perm2) - SmallestMovedPoint(perm1);
	multiplier := 1 + (SmallestMovedPoint(perm3) - SmallestMovedPoint(perm1)) / offset;
	return MultPerm(perm1, multiplier, offset);
	end);
	
InstallOtherMethod(PermFromRange,
	[IsPerm, IsPerm],
	function(perm1, perm2)
	local multiplier, offset;
	offset := 1 + LargestMovedPoint(perm1) - SmallestMovedPoint(perm1);
	multiplier := 1 + (SmallestMovedPoint(perm2) - SmallestMovedPoint(perm1)) / offset;
	return MultPerm(perm1, multiplier, offset);
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
InstallGlobalFunction(ParseGgiRels,
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

InstallGlobalFunction(WrappedPosetOperation,
	function(posetOp)
	local f;
	f := function(arg)
		local posets, p, cg, M;
		posets := List(arg, PosetFromManiplex);
		p := CallFuncList(posetOp, posets);	
		M := Maniplex(f, arg);
		M!.poset := p;
		
		SetRankManiplex(M, Rank(p));
		
		AddAttrComputer(M, ConnectionGroup,
			function(x)
			return ConnectionGroup(x!.poset);
			end);

		return M;
		end;
	return f;
	end);

InstallGlobalFunction(InvolutionListList,
	function(list1, list2)
	return MappingPermListList(Concatenation(list1,list2),Concatenation(list2,list1));
	end);

InstallMethod(MarkAsPolytopal,
	[IsManiplex],
	function(M)
	SetIsPolytopal(M, true);
	
	# If M was not previously set as non-polytopal, then we now
	# change the string description as necessary
	if IsPolytopal(M) and HasString(M) then
		if StartsWith(String(M), "ReflexibleManiplex") then
			M!.String := ReplacedString(String(M), "ReflexibleManiplex", "AbstractRegularPolytope");
		elif StartsWith(String(M), "RotaryManiplex") then
			M!.String := ReplacedString(String(M), "RotaryManiplex", "AbstractRotaryPolytope");
		fi;
	fi;
	
	return;
	
	end);


InstallMethod(ReallyNaturalHomomorphismByNormalSubgroup,
	[IsGroup,IsGroup],
	function(G,N)
	local phi,gens,qgens;
	phi:=NaturalHomomorphismByNormalSubgroup(G,N);
	gens:=GeneratorsOfGroup(G);
	qgens:=List(gens,x->Image(phi,x));
	return GroupHomomorphismByImages(G,Image(phi),gens,qgens);
	end);	

InstallGlobalFunction(ActionByGenerators, function(G, S, act)
	local hom, gens;
	hom := ActionHomomorphism(G, S, act);
	gens := List(GeneratorsOfGroup(G), x -> Image(hom,x));
	return Group(gens);
	end);
	
InstallGlobalFunction(ActionOnBlocks, function(G, S, seed)
	return ActionByGenerators(G, Blocks(G,S,seed), OnSets);
	end);
	
InstallGlobalFunction(VerifyProperties, function(M)
	local M2, prop, attr, mismatches, prop_str, stored_value, real_value, mismatch, attr_str;
	
	M2 := Maniplex(ConnectionGroup(M));
	
	mismatches := [];
	
	for prop_str in KnownPropertiesOfObject(M) do
		prop := EvalString(prop_str);
		stored_value := prop(M);
		real_value := prop(M2);
		if stored_value <> real_value then
			Add(mismatches, [prop_str, stored_value, real_value]);
		fi;
	od;
	
	# Checking attributes is harder -- we can't check all of them because not every attribute
	# has a canonical form (e.g. automorphism group)...
	# So we restrict ourselves to some basic combinatorial information:
	# Size, NumberOfFlagOrbits, SchlafliSymbol, Fvector. Maybe more later.

	for attr_str in ["Size", "NumberOfFlagOrbits", "SchlafliSymbol", "Fvector"] do
		attr := EvalString(attr_str);
		if Tester(attr)(M) then
			stored_value := attr(M);
			real_value := attr(M2);
			if stored_value <> real_value then
				Add(mismatches, [attr_str, stored_value, real_value]);
			fi;
		fi;
	od;
	
	if Size(mismatches) = 0 then
		Print("All properties and basic numeric attributes verified.\n");
	else
		for mismatch in mismatches do
			Print("Value mismatch in ");
			Print(mismatch[1]);
			Print(": stored value is ");
			Print(String(mismatch[2]));
			Print(" and real value is ");
			Print(String(mismatch[3]));
			Print("\n");
		od;
	fi;
	
	return (Size(mismatches) = 0);
	end);


InstallMethod(XORLists,
	[IsList, IsList],
	function(list1, list2)
	local xorList, i;
    	# Ensure both lists are of the same length
    	if Length(list1) <> Length(list2) then
        	Error("Lists must be of the same length");
    	fi;

    	xorList := [];
    	for i in [1..Length(list1)] do
        	Add(xorList, (list1[i] + list2[i]) mod 2);
    	od;
    	return xorList;
	end);



InstallMethod(ConvertToBinaryList,
	[IsInt,IsInt],
	function(number, length)
    local binaryList, index;
    binaryList := [];
    for index in [1..length] do
        Add(binaryList, 0);
    od;
    index := length;
    while number > 0 do
        if index = 0 then
            break;
        fi;
        binaryList[index] := number mod 2;
        number := QuoInt(number, 2);
        index := index - 1;
    od;
    return binaryList;
end);


InstallMethod(BinaryListToInteger,
	[IsList],
	function(binaryList)
    local number, length, index;
    number := 0;
    length := Length(binaryList);
    for index in [1..length] do
        number := number + binaryList[index] * 2^(length - index);
    od;
    return number;
end);


