
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
	
InstallMethod(IsFixedPointFreeSggi,
	[IsGroup],
	function(g)
	local gens, n, num_flags, genprods, i, j;
	if not(IsSggi(g)) then
		return false;
	else
		gens := GeneratorsOfGroup(g);
		n := Size(gens);
		num_flags := NrMovedPoints(g);
		genprods := [];
		for i in [1..n-1] do
			for j in [i+1..n] do
				Add(genprods, gens[i]*gens[j]);
			od;
		od;
		
		return not(ForAny(gens, x -> NrMovedPoints(x) < num_flags) or ForAny(genprods, x -> NrMovedPoints(x) < num_flags));
		
	fi;
	end);
	
InstallMethod(IsStringRotationGroup,
	[IsGroup],
	function(g)
	local gens, n, tau, i, j;
	gens := GeneratorsOfGroup(g);
	n := Size(gens);
	
	tau := function(i,j)
		return Product(List([i..j], k -> gens[k]));
		end;
		
	for i in [1..n-1] do
		for j in [i+1..n] do
			if tau(i,j)^2 <> Identity(g) then
				return false;
			fi;
		od;
	od;
	
	return true;
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
	elif d = 2 then
		return (Order(g) = 2*Order(g.1*g.2));
	fi;
	vfig := VertexFigureSubgroup(g);
	facet := FacetSubgroup(g);
	medial := SectionSubgroup(g, [1..d-2]);
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
InstallMethod(IsStringCPlus,
	[IsGroup],
	function(g)
	local n, facetGroup, vfigGroup, i, h, h2;
	n := Size(GeneratorsOfGroup(g));
	if not(IsStringRotationGroup(g)) then
		return false;
	elif n <= 1 then
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
	
	if str = "" or UppercaseString(str) = "ID" then
		return Identity(g);
	fi;

	str := InterpolatedString(str);
	
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

InstallMethod(SimplifiedSggiElement,
	[IsGroup, IsString],
	function(g, str)
	if IsFpGroup(g) then SetReducedMultiplication(g); fi;
	return SggiElement(g, str);
	end);
	
InstallOtherMethod(SimplifiedSggiElement,
	[IsManiplex, IsString],
	function(M, str)
	
	if not(IsReflexible(M)) then
		Error("SimplifiedSggiElement is only defined for reflexible maniplexes.\n");
	fi;
	
	return SimplifiedSggiElement(AutomorphismGroup(M), str);
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
	SetIsStringC(g, true);
	SetSchlafliSymbol(g, List([1..n-1], i -> infinity));
	return g;
	end);

InstallGlobalFunction(COXETER_GROUP_SIZES,
	function(symbol)
	local dict, n, k, sym;
	
	# This is so that we can modify sym later if necessary
	sym := ShallowCopy(symbol);
	
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
	elif 1 in sym then
		k := Position(sym, 1);
		if k > 1 then sym[k-1] := Gcd(sym[k-1], 2); fi;
		if k < n-1 then sym[k+1] := Gcd(sym[k+1], 2); fi;
		return COXETER_GROUP_SIZES(sym{[1..k-1]}) * COXETER_GROUP_SIZES(sym{[k+1..n-1]}) / 2;
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
	if ForAll(sym, x -> x <> 1) then
		SetIsStringC(h, true);
	fi;
	SetSchlafliSymbol(h, sym);
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
		rels := InterpolatedString(rels);
		newrels := ParseStringCRels(rels, w);
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	g := FactorGroupFpGroupByRels(w, newrels);
	SetIsSggi(g, true);
	return g;
	end);

InstallMethod(Sggi,
	[IsList, IsList, IsList],
	function(sym, words, orders)
	local new_words, relstr;
	new_words := List([1..Size(words)], i -> Concatenation("(", words[i], ")^", String(orders[i])));
	relstr := JoinStringsWithSeparator(new_words, ",");
	return Sggi(sym, relstr);
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
	
InstallMethod(SectionSubgroup,
	[IsGroup, IsList],
	function(g, I)
	local n, h, old_I, new_I;
	if not IsSggi(g) then
		Error("SectionSubgroup is currently only implemented for sggis!");
	fi;
	n := Size(GeneratorsOfGroup(g));
	
	# If g is already a subgroup of an sggi, we go back to that parent group and just take a more
	# restricted subgroup of it.
	if HasParent(g) then
		# First we need to grab the value of I from before
		# We translate each generator ri to the integer i first
		old_I := List(GeneratorsOfGroup(g), x -> Int([String(x)[2]]));
		new_I := (old_I+1){I+1};
		h := Subgroup(Parent(g), GeneratorsOfGroup(Parent(g)){new_I});
	else
		h := Subgroup(g, GeneratorsOfGroup(g){I+1});
	fi;
	
	# Precompute the size in some special cases
	if Size(I) = 1 then
		SetSize(h, Order(h.1));
	elif Size(I) = 2 then
		if Order(h.1) = 1 then
			SetSize(h, Order(h.2));
		elif Order(h.2) = 1 then
			SetSize(h, 2);
		else
			SetSize(h, 2*Order(h.1*h.2));
		fi;
	fi;
	
	if HasIsStringC(g) and IsStringC(g) then
		SetIsStringC(h, true);
	fi;
	
	# If I is a range [i, i+1, ..., j], then we inherit the SchlafliSymbol
	if HasSchlafliSymbol(g) and IsRange(I) and Size(I) > 1 and I[2]-I[1] = 1 then
		SetSchlafliSymbol(h, SchlafliSymbol(g){[1+I[1]..I[Size(I)]]});
	fi;
	
	return h;
	end);
	
InstallMethod(VertexFigureSubgroup,
	[IsGroup],
	function(g)
	local n;
	n := Size(GeneratorsOfGroup(g));
	return SectionSubgroup(g, [1..n-1]);
	end);
	
InstallMethod(FacetSubgroup,
	[IsGroup],
	function(g)
	local n;
	n := Size(GeneratorsOfGroup(g));
	return SectionSubgroup(g, [0..n-2]);
	end);

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
	
