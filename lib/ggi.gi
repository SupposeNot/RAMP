InstallMethod(UniversalGgi,
	[IsInt],
	function(n)
	local i, j, f, rels, gens, g;
	if n = 0 then
		return FreeGroup([]);
	fi;

	f := FreeGroup(List([0..n-1], i -> Concatenation("r", String(i))));
	gens := GeneratorsOfGroup(f);
	rels := [];
	for i in [1..n] do
		Add(rels, gens[i]*gens[i]);
	od;
	g := FactorGroupFpGroupByRels(f, rels);
	if (n >= 2) then SetSize(g, infinity); fi;
	SetIsGgi(g, true);
	return g;
	end);

# Returns the Ggi with the given labels on the Coxeter diagram.
# The labels should be in lexicographic order, e.g. the order of r0 r1, r0 r2, ..., r0 rn-1, r1 r2, etc.
InstallOtherMethod(UniversalGgi,
	[IsList],
	function(cox)
	local i, j, k, f, g, rels, gens, n, h;
	
	# For now we assume that the rank is 10 or less
	for i in [2..10] do
		if Size(cox) = i*(i-1)/2 then
			n := i;
			break;
		fi;
	od;
	
	g := UniversalGgi(n);
	gens := FreeGeneratorsOfFpGroup(g);
	rels := [];
	k := 1;
	for i in [1..n] do
		for j in [i+1..n] do
			if cox[k] <> infinity then
				Add(rels, (gens[i]*gens[j])^cox[k]);
			fi;
			k := k+1;
		od;
	od;

	h := FactorGroupFpGroupByRels(g, rels);
	SetIsGgi(h, true);
	return h;
	end);
	
InstallOtherMethod(Ggi,
	[IsList],
	function(cox)
	return UniversalGgi(cox);
	end);
	
InstallMethod(Ggi,
	[IsList, IsList],
	function(cox, rels)
	local w, newrels, g;
	w := UniversalGgi(cox);
	if IsString(rels) then
		rels := InterpolatedString(rels);
		newrels := ParseStringCRels(rels, w);
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	g := FactorGroupFpGroupByRels(w, newrels);
	SetIsGgi(g, true);
	return g;
	end);

InstallMethod(Ggi,
	[IsList, IsList, IsList],
	function(cox, words, orders)
	local new_words, relstr;
	new_words := List([1..Size(words)], i -> Concatenation("(", words[i], ")^", String(orders[i])));
	relstr := JoinStringsWithSeparator(new_words, ",");
	return Ggi(cox, relstr);
	end);
	
InstallOtherMethod(CyclicGgi,
	[IsList],
	function(orders)
	local n, cox, i, j;
	
	n := Size(orders);
	cox := [];
	
	Add(cox, orders[1]);
	for j in [3..n-1] do
		Add(cox, 2);
	od;
	Add(cox, orders[n]);

	for i in [2..n-1] do
		Add(cox, orders[i]);
		for j in [i+2..n] do
			Add(cox, 2);
		od;
	od;

	return Ggi(cox);
	end);

InstallMethod(CyclicGgi,
	[IsList, IsList],
	function(orders, rels)
	local w, newrels, g;
	w := CyclicGgi(orders);
	if IsString(rels) then
		rels := InterpolatedString(rels);
		newrels := ParseStringCRels(rels, w);
	else
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
	fi;
	g := FactorGroupFpGroupByRels(w, newrels);
	SetIsGgi(g, true);
	return g;
	end);

InstallMethod(GgiElement,
	[IsGroup, IsString],
	function(g, str)
	local w, x, hom;
	
	if str = "" or UppercaseString(str) = "ID" then
		return Identity(g);
	fi;

	str := InterpolatedString(str);
	
	w := UniversalGgi(Size(GeneratorsOfGroup(g)));
	x := ParseStringCRels(str, w)[1];
	hom := GroupHomomorphismByImagesNC(FreeGroupOfFpGroup(w), g);
	return Image(hom, x);
	end);

InstallMethod(SimplifiedGgiElement,
	[IsGroup, IsString],
	function(g, str)
	if IsFpGroup(g) then SetReducedMultiplication(g); fi;
	return GgiElement(g, str);
	end);
