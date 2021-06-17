InstallMethod(Dual,
	[IsReflexibleManiplex],
	function(p)
	local g, rels, q, n, sym, newrels, relstr, attr, attrs;
	n := Rank(p);
	rels := ExtraRelators(p);
	sym := SchlafliSymbol(p);
	sym := Reversed(sym);
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	
	# Since the generators are involutions, an entry of -i means the same as i in a Tietze word
	# If we don't take the absolute value here, then we get the wrong dual relator.
	newrels := List(rels, r -> List(r, i -> n+1-AbsoluteValue(i)));
	newrels := List(newrels, r -> String(AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroupFpGroup(p)))));
	relstr := JoinStringsWithSeparator(newrels, ",");
	q := ReflexibleManiplex(sym, relstr);

	attrs := [Size, IsPolytopal, NumberOfFlagOrbits, IsTight, IsDegenerate];
	for attr in attrs do
		if Tester(attr)(p) then Setter(attr)(q, attr(p)); fi;
	od;

	SetSchlafliSymbol(q, sym);
	SetDual(q, p);
	return q;
	end);
	
InstallMethod(IsSelfDual,
	[IsManiplex],
	function(p)
	return p = Dual(p);
	end);

_PETRIAL_REL := function(r)
	local i, new_r;
	new_r := [];
	for i in r do
		if i = 1 then
			Append(new_r, [1,3]);
		else
			Add(new_r, i);
		fi;
	od;
	return new_r;
	end;
	
# WARNING: Currently only working as intended for polyhedra.
InstallMethod(Petrial,
	[IsReflexibleManiplex],
	function(p)
	local g, rels, q, n, sym, pet;
	g := AutomorphismGroup(p);
	sym := ShallowCopy(SchlafliSymbol(p));
	rels := ExtraRelators(p);
	
	pet := Order(g.1*g.2*g.3);

	sym[1] := pet;
	
	rels := List(rels, r -> _PETRIAL_REL(TietzeWordAbstractWord(r)));
	Add(rels, Flat(ListWithIdenticalEntries(pet, [1, 2, 3])));
	
	q := ReflexibleManiplex(sym, rels);
	SetSize(q, Size(p));
	SetSchlafliSymbol(q, sym);
	SetPetrial(q, p);
	return q;
	end);
	
InstallMethod(IsSelfPetrial,
	[IsManiplex],
	function(p)
	return p = Petrial(p);
	end);

