
InstallMethod(Dual,
	[IsManiplex],
	function(M)
	local Md, attr, MatchingAttributes, ReversedAttributes, rels, newrels, relstr, mdstr, polytopal;

	# polytopal := (ValueOption("polytopal") = true);
	
	if IsReflexible(M) then
		rels := ExtraRelators(M);
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		
		# Since the generators are involutions, an entry of -i means the same as i in a Tietze word
		# If we don't take the absolute value here, then we get the wrong dual relator.
		newrels := List(rels, r -> List(r, i -> Rank(M)+1-AbsoluteValue(i)));
		newrels := List(newrels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroupFpGroup(M))));
		relstr := JoinStringsWithSeparator(List(newrels, r -> String(r)));
		# Md := ReflexibleManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr : polytopal);
		Md := ReflexibleManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr);
	elif IsRotaryManiplexRotGpRep(M) then
		rels := ExtraRotRelators(M);
		rels := List(rels, r -> TietzeWordAbstractWord(r));

		# Change each s_i to s_{n-i}^{-1}
		newrels := List(rels, r -> List(r, i -> (Rank(M) - AbsoluteValue(i)) * (-SignInt(i))));
		newrels := List(newrels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(RotationGroup(M))));
		relstr := JoinStringsWithSeparator(List(newrels, r -> String(r)));

		# Md := RotaryManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr : polytopal);
		Md := RotaryManiplex(Reversed(PseudoSchlafliSymbol(M)), relstr);
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

InstallMethod(IsInternallySelfDual,
	[IsManiplex],
	function(M)
	local g, n, x, gens;
	
	if not(IsReflexible(M)) then
		Error("IsInternallySelfDual is only defined for reflexible maniplexes.\n");
	fi;

	g := AutomorphismGroup(M);
	n := Rank(M);
	gens := GeneratorsOfGroup(g);
	
	for x in g do
		if ForAll([1..n], i -> gens[i]^x = gens[n-i+1]) then
			return true;
		fi;
	od;
	return false;
	end);

InstallOtherMethod(IsInternallySelfDual,
	[IsManiplex, IsObject],
	function(M, x)
	local g, n, gens;
	
	if not(IsReflexible(M)) then
		Error("IsInternallySelfDual is only defined for reflexible maniplexes.\n");
	fi;	
	
	g := AutomorphismGroup(M);
	n := Rank(M);
	gens := GeneratorsOfGroup(g);
	
	if ForAll([1..n], i -> gens[i]^x = gens[n-i+1]) then
		return true;
	else
		return IsInternallySelfDual(M);
	fi;
	end);

	
InstallMethod(IsExternallySelfDual,
	[IsManiplex],
	function(M)
	
	if not(IsReflexible(M)) then
		Error("IsExternallySelfDual is only defined for reflexible maniplexes.\n");
	fi;
	
	return IsSelfDual(M) and not(IsInternallySelfDual(M));
	end);

InstallMethod(Petrial,
	[IsManiplex],
	function(M)
	local g, sym, rels, pet, Mp;

	if IsReflexible(M) and Rank(M) = 3 then
		g := AutomorphismGroupFpGroup(M);
		sym := ShallowCopy(SchlafliSymbol(M));
		rels := List(ExtraRelators(M), String);
		
		pet := Order(g.1*g.2*g.3);
		rels := List(rels, r -> ReplacedString(r, "r0", "(r0 r2)"));
		Add(rels, Concatenation("(r0 r1 r2)^", String(sym[1])));
		
		sym[1] := pet;
		Mp := ReflexibleManiplex(sym, JoinStringsWithSeparator(rels));
	else
		Mp := Maniplex(Petrial, [M]);
		SetRankManiplex(Mp, Rank(M));
		SetString(Mp, Concatenation("Petrial(", String(M), ")"));
	fi;

	Mp!.base := M;

	AddAttrComputer(Mp, Size, Mp -> Size(Mp!.base) : prereqs := [Size]);
	AddAttrComputer(Mp, NumberOfFlagOrbits, Mp -> NumberOfFlagOrbits(Mp!.base) : prereqs := [NumberOfFlagOrbits]);

	AddAttrComputer(Mp, ConnectionGroup, 
		function(Mp)
		local cg, gens, n;
		cg := ConnectionGroup(Mp!.base);
		gens := ShallowCopy(GeneratorsOfGroup(cg));
		n := Rank(Mp);
		gens[n-2] := gens[n-2] * gens[n];
		return Group(gens);
		end :
		prereqs := [ConnectionGroup]);
	
	SetPetrial(Mp, M);
	return Mp;
	end);
	
InstallMethod(IsSelfPetrial,
	[IsManiplex],
	function(p)
	return p = Petrial(p);
	end);

InstallMethod(DirectDerivates,
	[IsManiplex],
	function(M)
	local Md, Mp, Mdp, Mpd, Mdpd, maniplexes;
	Md := Dual(M);
	Mp := Petrial(M);
	Mdp := Petrial(Md);
	Mpd := Dual(Mp);
	Mdpd := Dual(Mdp);
	maniplexes := [M, Md, Mp, Mdp, Mpd, Mdpd];
	if Rank(M) > 3 then
		Append(maniplexes, [Petrial(Mpd), Petrial(Mdpd)]);
	fi;

	if ValueOption("polytopal") = true then
		return Filtered(Unique(maniplexes), p -> IsPolytopal(p));
	else
		return Unique(maniplexes);
	fi;
	end);