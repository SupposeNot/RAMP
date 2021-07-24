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
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(p)
	local g, rels, q, n, sym, newrels, relstr, attr, attrs, gens;
	n := Rank(p);
	g := RotationGroup(p);
	
	if HasSchlafliSymbol(p) and IsFpGroup(g) then
		rels := ExtraRotRelators(p);
		sym := SchlafliSymbol(p);
		sym := Reversed(sym);
		rels := List(rels, r -> TietzeWordAbstractWord(r));

		# Change each s_i to s_{n-i}^{-1}
		newrels := List(rels, r -> List(r, i -> (n - AbsoluteValue(i)) * (-SignInt(i))));
		q := RotaryManiplex(sym, newrels);
		
		SetSchlafliSymbol(q, sym);
	else
		gens := List(GeneratorsOfGroup(g), x -> x^-1);
		q := RotaryManiplex(Group(Reversed(gens)));
	fi;

	attrs := [Size, IsPolytopal, NumberOfFlagOrbits, IsOrientable, IsTight, IsDegenerate];
	for attr in attrs do
		if Tester(attr)(p) then Setter(attr)(q, attr(p)); fi;
	od;

	SetDual(q, p);
	return q;
	end);

InstallMethod(Dual,
	[IsManiplex and IsManiplexInstructionsRep],
	function(M)
	local Md, attr, f, g;
	
	Md := Maniplex(Dual, [M]);
	Md!.base := M;
	SetRankManiplex(Md, Rank(M));
	
	# This really unusual construction is to avoid some variable scope
	# issues I was running into...
	f := attr -> (M -> attr(M!.base));
	for attr in [Size, IsPolytopal, NumberOfFlagOrbits, IsOrientable, IsTight, IsDegenerate] do
		if Tester(attr)(M) then
			Setter(attr)(Md, attr(M));
		else
			AddAttrComputer(Md, attr, f(attr));
		fi;
	od;

	g := attr -> (M -> Reversed(attr(M!.base)));
	for attr in [Fvector, SchlafliSymbol] do
		if Tester(attr)(M) then
			Setter(attr)(Md, Reversed(attr(M)));
		else
			AddAttrComputer(Md, attr, g(attr));
		fi;
	od;
	
	if HasConnectionGroup(M) then
		SetConnectionGroup(Md, Group(Reversed(GeneratorsOfGroup(ConnectionGroup(M)))));
	else
		AddAttrComputer(Md, ConnectionGroup, M -> Group(Reversed(GeneratorsOfGroup(ConnectionGroup(M!.base)))));
	fi;
	
	SetString(Md, Concatenation("Dual(", String(M), ")"));

	SetDual(Md, M);

	return Md;
	end);
	
	
InstallMethod(Dual,
	[IsManiplex],
	function(M)
	local g, gens, Md, attrs, attr;
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	Md := Maniplex(Group(Reversed(gens)));

	for attr in [Size, IsPolytopal, NumberOfFlagOrbits, IsOrientable, IsTight, IsDegenerate] do
		if Tester(attr)(M) then Setter(attr)(Md, attr(M)); fi;
	od;

	for attr in [SchlafliSymbol, Fvector] do
		if Tester(attr)(M) then Setter(attr)(Md, Reversed(attr(M))); fi;
	od;
	
	SetDual(Md, M);
	return Md;
	end);
	
InstallMethod(IsSelfDual,
	[IsManiplex],
	function(p)
	return p = Dual(p);
	end);

# WARNING: Currently only working as intended for polyhedra.
InstallMethod(Petrial,
	[IsReflexibleManiplex],
	function(p)
	local g, rels, q, n, sym, pet;
	g := AutomorphismGroup(p);
	sym := ShallowCopy(SchlafliSymbol(p));
	rels := List(ExtraRelators(p), String);
	
	pet := Order(g.1*g.2*g.3);
	rels := List(rels, r -> ReplacedString(r, "r0", "(r0 r2)"));
	Add(rels, Concatenation("z1^", String(sym[1])));
	
	sym[1] := pet;
	q := ReflexibleManiplex(sym, JoinStringsWithSeparator(rels));
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

