
InstallMethod(IsGgi,
	[IsGroup],
	function(g)
	return ForAll(GeneratorsOfGroup(g), x -> Order(x) <= 2);
	end);

InstallMethod(IsStringy,
	[IsGroup],
	function(g)
	local gens, i, j;
	
	gens := GeneratorsOfGroup(g);
	for i in [1..Size(gens)-2] do
		for j in [i+2..Size(gens)] do
			if gens[i]*gens[j] <> gens[j]*gens[i] then return false; fi;
		od;
	od;
	return true;
	end);

InstallMethod(IsSggi,
	[IsGroup],
	function(g)
	return IsGgi(g) and IsStringy(g);
	end);
	
# TODO: Currently will fail for infinite groups.
# I started coding something for this, but Intersection(g,h) where g is infinite
# doesn't appear to work. Requires more thought...
InstallMethod(IsStringC,
	[IsGroup],
	function(g)
	local d, vfig, facet, medial;
	d := Size(GeneratorsOfGroup(g));
	if d = 1 then
		return (Order(g) = 2);
	elif not(IsSggi(g)) then
		return false;
	fi;
	vfig := Subgroup(g, GeneratorsOfGroup(g){[2..d]});
	facet := Subgroup(g, GeneratorsOfGroup(g){[1..d-1]});
	medial := Subgroup(g, GeneratorsOfGroup(g){[2..d-1]});
	if not(IsStringC(vfig)) then return false; fi;
	if not(IsStringC(facet)) then return false; fi;
	if HasIsFinite(vfig) and IsFinite(vfig) and HasIsFinite(facet) and IsFinite(facet) and HasIsFinite(medial) and IsFinite(medial) then
		return (Size(medial) = Size(Intersection(vfig, facet)));
	else
		return IsSubset(medial, Intersection(vfig, facet));
	fi;
	end);

# TODO: Currently will fail for infinite groups.
# I started coding something for this, but Intersection(g,h) where g is infinite
# doesn't appear to work. Requires more thought...
# TODO: Currently assumes g is a string rotation group
InstallMethod(IsStringCPlus,
	[IsGroup],
	function(g)
	local n, facetGroup, vfigGroup, i, h, h2;
	n := Size(GeneratorsOfGroup(g));
	if n <= 1 then
		return true;
	elif n = 2 then
		facetGroup := Subgroup(g, GeneratorsOfGroup(g){[1]});
		vfigGroup := Subgroup(g, GeneratorsOfGroup(g){[2]});
		return (Size(Intersection(facetGroup, vfigGroup)) = 1);
	else
		facetGroup := Subgroup(g, GeneratorsOfGroup(g){[1..n-1]});
		if not(IsStringCPlus(facetGroup)) then
			return false;
		else
			for i in [2..n-1] do
				h := Subgroup(g, GeneratorsOfGroup(g){[i..n]});
				h2 := Subgroup(g, GeneratorsOfGroup(g){[i..n-1]});
				if not(IsSubset(h2, Intersection(facetGroup, h))) then
					return false;
				fi;
			od;
		fi;
		return true;
	fi;
	end);

	
	
InstallMethod(SggiElement,
	[IsGroup, IsString],
	function(g, str)
	local w, x, hom;
	
	if not(IsSggi(g)) then
		Error("SggiElement is only defined when g IsSggi.");
	fi;
	
	if str = "" then
		return Identity(g);
	fi;
	
	w := UniversalSggi(Size(GeneratorsOfGroup(g)));
	x := ParseStringCRels(str, w)[1];
	hom := GroupHomomorphismByImagesNC(FreeGroupOfFpGroup(w), g);
	return Image(hom, x);
	end);
	
InstallOtherMethod(SggiElement,
	[IsManiplex, IsString],
	function(M, str)
	
	if not(IsReflexible(M)) then
		Error("SggiElement is only defined for reflexible maniplexes.\n");
	fi;
	
	return SggiElement(AutomorphismGroup(M), str);
	end);

InstallMethod(IsRelationOfReflexibleManiplex,
	[IsManiplex, IsString],
	function(M, rel)
	local w, x, hom;
	
	if not(IsReflexible(M)) then
		Error("IsRelationOfReflexibleManiplex is only defined for reflexible maniplexes.");
	fi;
	
	return SggiElement(M, rel) = SggiElement(M, "");
	end);
	
	
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
	SetIsSggi(g, true);
	return g;
	end);

InstallGlobalFunction(COXETER_GROUP_SIZES,
	function(sym)
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
	end);

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
	SetIsSggi(h, true);
	return h;
	end);
	
InstallOtherMethod(Sggi,
	[IsList],
	function(sym)
	return UniversalSggi(sym);
	end);
	
InstallMethod(Sggi,
	[IsList, IsList],
	function(sym, rels)
	local w, newrels, g;
	w := UniversalSggi(sym);
	if IsString(rels) then
		newrels := ParseStringCRels(rels, w);
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	g := FactorGroupFpGroupByRels(w, newrels);
	SetIsSggi(g, true);
	return g;
	end);
	

InstallMethod(SggiFamily,
	[IsGroup, IsList],
	function(parent, wordList)
	local f, n;
	n := Size(wordList);
	
	f := function(orders)
		local rels, i, rel, g;
		rels := [];
		for i in [1..n] do
			rel := Concatenation("(", wordList[i], ")^", String(orders[i]));
			Add(rels, rel);
		od;
		g := FactorGroupFpGroupByRels(parent, ParseStringCRels(JoinStringsWithSeparator(rels), parent));
		g!.parentGroup := parent;
		g!.wordOrders := orders;
		SetIsSggi(g, true);
		return g;
		end;
		
	return f;
	end);
	
	
InstallOtherMethod(SchlafliSymbol,
	[IsGroup],
	function(g)
	local i, gens, ans;
 	if not IsSggi(g) then
		Error("Group must be a string group generated by involutions"); 
	fi;
	gens := GeneratorsOfGroup(g);
	ans:=[];
	for i in [1..Size(gens)-1] do
		Add(ans,Order(gens[i]*gens[i+1]));
	od;
	return ans;
	end);
	
InstallMethod(IsCConnected,
	[IsManiplex],
	m->IsStringC(ConnectionGroup(m)));