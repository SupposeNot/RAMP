# For reflexible maniplexes, we first try to use a presentation of the automorphism
# group and just dualize the relators. But since finding isomorphisms to
# fpGroups can be expensive, we only use this approach if the fpGroup is
# already there. Otherwise, we just reverse the generators of the
# automorphism group.
InstallMethod(Dual,
	[IsManiplex and IsReflexibleManiplexAutGpRep],
	function(p)
	local g, rels, q, n, sym, newrels, relstr, attr, attrs, gens;
	n := Rank(p);
	
	if HasSchlafliSymbol(p) and HasAutomorphismGroupFpGroup(p) then
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
		
		SetSchlafliSymbol(q, sym);
	else
		gens := GeneratorsOfGroup(AutomorphismGroup(p));
		q := ReflexibleManiplex(Group(Reversed(gens)));
	fi;

	attrs := [Size, IsPolytopal, NumberOfFlagOrbits, IsOrientable, IsTight, IsDegenerate];
	for attr in attrs do
		if Tester(attr)(p) then Setter(attr)(q, attr(p)); fi;
	od;

	SetDual(q, p);
	return q;
	end);

InstallMethod(Dual,
	[IsManiplex],
	function(M)
	local g, gens, Md, attrs, attr;
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	Md := Maniplex(Group(Reversed(gens)));

	attrs := [Size, IsPolytopal, NumberOfFlagOrbits, IsTight, IsDegenerate];
	for attr in attrs do
		if Tester(attr)(M) then Setter(attr)(Md, attr(M)); fi;
	od;
	
	SetDual(Md, M);
	return Md;
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
	rels := List(rels, r -> _PETRIAL_REL(TietzeWordAbstractWord(r)));
	Add(rels, Flat(ListWithIdenticalEntries(sym[1], [1, 2, 3])));
	
	sym[1] := pet;
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

