InstallMethod(Dual,
	[IsManiplex],
	function(M)
	local Md, attr, MatchingAttributes, ReversedAttributes, rels, newrels, relstr, mdstr, polytopal;

	polytopal := (ValueOption("polytopal") = true);
	
	if IsReflexibleManiplexAutGpRep(M) then
		rels := ExtraRelators(M);
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		
		# Since the generators are involutions, an entry of -i means the same as i in a Tietze word
		# If we don't take the absolute value here, then we get the wrong dual relator.
		newrels := List(rels, r -> List(r, i -> Rank(M)+1-AbsoluteValue(i)));
		newrels := List(newrels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroupFpGroup(M))));
		relstr := JoinStringsWithSeparator(List(newrels, r -> String(r)));
		Md := ReflexibleManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr);
	elif IsRotaryManiplexRotGpRep(M) then
		rels := ExtraRotRelators(M);
		rels := List(rels, r -> TietzeWordAbstractWord(r));

		# Change each s_i to s_{n-i}^{-1}
		newrels := List(rels, r -> List(r, i -> (Rank(M) - AbsoluteValue(i)) * (-SignInt(i))));
		newrels := List(newrels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(RotationGroup(M))));
		relstr := JoinStringsWithSeparator(List(newrels, r -> String(r)));

		Md := RotaryManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr : polytopal);
	else
		Md := Maniplex(Dual, [M]);
		SetRankManiplex(Md, Rank(M));
		SetString(Md, Concatenation("Dual(", String(M), ")"));
	fi;

	Md!.base := M;

	AddAttrComputer(Md, Size, Md -> Size(Md!.base) : prereqs := [Size]);
	AddAttrComputer(Md, IsPolytopal, Md -> IsPolytopal(Md!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(Md, NumberOfFlagOrbits, Md -> NumberOfFlagOrbits(Md!.base) : prereqs := [NumberOfFlagOrbits]);
	AddAttrComputer(Md, IsOrientable, Md -> IsOrientable(Md!.base) : prereqs := [IsOrientable]);

	AddAttrComputer(Md, Fvector, Md -> Reversed(Fvector(Md!.base)) : prereqs := [Fvector]);
	AddAttrComputer(Md, SchlafliSymbol, Md -> Reversed(SchlafliSymbol(Md!.base)) : prereqs := [SchlafliSymbol]);
	
	AddAttrComputer(Md, ConnectionGroup, Md -> Group(Reversed(GeneratorsOfGroup(ConnectionGroup(Md!.base)))) : prereqs := [ConnectionGroup]);
	
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

InstallMethod(DirectDerivates,
	[IsManiplex],
	function(M)
	local Md, Mp, Mdp, Mpd, Mdpd;
	Md := Dual(M);
	Mp := Petrial(M);
	Mdp := Petrial(Md);
	Mpd := Dual(Mp);
	Mdpd := Dual(Mdp);
	if ValueOption("polytopal") = true then
		return Filtered(Unique([M, Md, Mp, Mdp, Mpd, Mdpd]), p -> IsPolytopal(p));
	else
		return Unique([M, Md, Mp, Mdp, Mpd, Mdpd]);
	fi;
	end);