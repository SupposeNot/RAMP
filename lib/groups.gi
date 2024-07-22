
InstallMethod(AutomorphismGroup, 
	[IsPremaniplex],
	function(M)
	local c, stab, norm;
	c := ConnectionGroup(M);
	stab := Stabilizer(c,BaseFlag(M));
	norm := Normalizer(c, stab);
	return norm/stab;
	end);

InstallMethod(AutomorphismGroup, 
	[IsManiplex and IsReflexibleManiplexAutGpRep],
	M -> M!.aut_gp);

InstallMethod(AutomorphismGroup,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local n, gens, f, g, h, i, rels, h2, genr;
	
	# The strategy is to add a new generator r0 that acts as conjugation by
	# r0 should. If this works, then we have a rotation group of an orientably
	# regular polytope. If not, then we have a chiral polytope, and the automorphism
	# group is just the rotation group.
	
	n := Rank(M);
	g := Image(IsomorphismFpGroupByGenerators(RotationGroup(M), GeneratorsOfGroup(RotationGroup(M))));
	gens := List([1..n-1], i -> Concatenation("s", String(i)));
	Add(gens, "r0");
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r, FreeGeneratorsOfFpGroup(g)));

	# The new generator r0 is an involution and should satisfy:
	# r0 s1 r0 s1 = 1.
	# r0 s2 r0 s1 s2 s1^-1 = 1.
	# r0 si r0 si^-1 = 1 for i >= 3.
	f := FreeGroup(gens);
	Add(rels, [n, n]);
	Add(rels, [n, 1, n, 1]);
	if n > 2 then
		Add(rels, [n, 2, n, 1, 2, -1]);
	fi;
	for i in [3..n-1] do
		Add(rels, [n, i, n, -i]);
	od;
	
	rels := List(rels, r -> AbstractWordTietzeWord(r, GeneratorsOfGroup(f)));
	h := f / rels;
	
	# Now rearrange the generators to be the usual r0, r1, etc.
	
	genr := function(k)
		if k = 0 then
			return GeneratorsOfGroup(h)[n];
		else
			return genr(k-1) * GeneratorsOfGroup(h)[k];
		fi;
		end;
	
	h2 := Group(List([0..n-1], i -> genr(i)));
	
	if Size(h2) = 2 * Size(g) then
		# We have an orientably regular polytope
		SetIsReflexible(M, true);
		SetIsChiral(M, false);
		return StandardizeSggi(h2);
	else
		# We have a chiral polytope
		SetIsReflexible(M, false);
		SetIsChiral(M, true);
		return g;
	fi;
	
	end);

InstallMethod(AutomorphismGroupFpGroup, 
	[IsManiplex],
	function(M)
	local g, fp, w, rels, w_rels;
	g := AutomorphismGroup(M);
	
	if HasIsChiral(M) and IsChiral(M) then
		return RotationGroupFpGroup(M);
	else
		fp := Image(IsomorphismFpGroupByGeneratorsNC(g, GeneratorsOfGroup(g), "f"));
		
		# If M is reflexible, retranslate everything in terms of r0, r1, etc.
		if IsReflexible(M) then
			w := UniversalSggi(Rank(M));
			rels := RelatorsOfFpGroup(fp);
			rels := List(rels, r -> TietzeWordAbstractWord(r));

			# Avoid double-counting relations
			w_rels := RelatorsOfFpGroup(w);
			w_rels := List(w_rels, r -> TietzeWordAbstractWord(r));
			rels := Difference(rels, w_rels);

			rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
			
			fp := FactorGroupFpGroupByRels(w, rels);
		fi;
		
		return fp;
	fi;
	end);

InstallMethod(AutomorphismGroupPermGroup, 
	[IsManiplex],
	function(M)
	local g;
	g := AutomorphismGroup(M);
	if IsPermGroup(g) then
		return g;
	else
		return Image(IsomorphismPermGroup(g));
	fi;
	end);
	
InstallMethod(AutomorphismGroupOnFlags, 
	[IsManiplex],
	function(M)
	local N, c, base, stab, norm, orb, auts, i, w, aut, notMoved, j, x, plist, agf, cggens, gens, flags;
	N := Size(M);
	base := BaseFlag(M);
	c := ConnectionGroup(M);
	stab := Stabilizer(c, base);
	norm := Normalizer(c, stab);
	orb := Difference(Orbit(norm, base), [base]);
	auts := [];
	
	while not(IsEmpty(orb)) do
		i := Minimum(orb);
		
		# Let's find the automorphism alpha that sends the base flag to i
		plist := [i];
		flags := Difference(Flags(M), [base]);

		# Idea: For a generic flag Psi, there is a connection x such that Psi alpha = (x Phi) alpha = x (Phi alpha) = x i.
		# So, find the connection x that sends Phi to Psi, and then apply it to i
		for j in [1..N-1] do
			x := RepresentativeAction(c, base, flags[j]);
			Add(plist, i^x);
		od;
		Add(auts, MappingPermListList(Flags(M), plist));
		orb := Difference(orb, Orbit(Group(auts), base));
	od;
	
	# We need to invert the auts to account for the difference between left actions and right actions
	auts := List(auts, x -> x^-1);
	agf := Group(auts);
	if IsReflexible(M) then
		cggens := GeneratorsOfGroup(ConnectionGroup(M));
		gens := List([1..Rank(M)], i -> RepresentativeAction(agf, base, base^cggens[i]));
		agf := Group(gens);
	fi;
	return agf;
	end);
	
InstallMethod(RotationGroup,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	M -> M!.rot_gp);
	
InstallMethod(RotationGroup,
	[IsManiplex],
	function(M)
	local gens, n, i, new_gens;
	if IsChiral(M) then
		return AutomorphismGroup(M);
	elif IsReflexible(M) then
		gens := GeneratorsOfGroup(AutomorphismGroup(M));
		n := Rank(M);
		new_gens := [];
		for i in [1..n-1] do
			Add(new_gens, gens[i]*gens[i+1]);
		od;
		return Group(new_gens);
	else
		Error("RotationGroup is currently only defined for rotary maniplexes.");
	fi;
	end);
	
InstallMethod(RotationGroupFpGroup,
	[IsManiplex],
	function(M)
	local n, w, phi, g, gens, cgens, i, psi, x, fp;

	if not(IsRotary(M)) then
		Error("RotationGroupFpGroup is only defined for rotary maniplexes.");
	fi;

	# If the stored rotation group already looks like the right form, just send it back
	if IsFpGroup(RotationGroup(M)) and String(GeneratorsOfGroup(RotationGroup(M))[1]) = "s1" then
		return RotationGroup(M);
	fi;

	n := Rank(M);
	w := UniversalRotationGroup(n);

	phi := BaseFlag(M);
	g := AutomorphismGroupOnFlags(M);
	gens := [];
	cgens := GeneratorsOfGroup(ConnectionGroup(M));
	for i in [1..n-1] do
		psi := (phi^cgens[i+1])^cgens[i];
		x := RepresentativeAction(g, phi, psi);
		Add(gens, x);
	od;

	# hom := GroupHomomorphismByImagesNC(w, Group(gens));
	fp := Image(IsomorphismFpGroupByGeneratorsNC(Group(gens), gens, "s"));

# Maybe add this back later if necessary
	# Retranslate everything in terms of s1, s2, etc.
#	rels := RelatorsOfFpGroup(fp);
#	rels := List(rels, r -> TietzeWordAbstractWord(r));
#	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
#	fp := FactorGroupFpGroupByRels(w, rels);
	return fp;
	end);

#InstallMethod(RotationGroupFpGroup,
#	[IsManiplex],
#	function(M)
#	local g, fp, w, rels;
#
#	if not(IsRotary(M)) then
#		Error("RotationGroupFpGroup is currently only defined for rotary maniplexes.");
#	else		
#		g := RotationGroup(M);
#		if IsFpGroup(g) then
#			return g;
#		else
#			fp := Image(IsomorphismFpGroupByGenerators(g, GeneratorsOfGroup(g)));
#			
#			# Retranslate everything in terms of s1, s2, etc.
#			w := UniversalRotationGroup(Rank(M));
#			rels := RelatorsOfFpGroup(fp);
#			rels := List(rels, r -> TietzeWordAbstractWord(r));
#			rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(w)));
#			fp := FactorGroupFpGroupByRels(w, rels);
#			return fp;
#		fi;
#	fi;
#	end);

InstallMethod(RotationGroupPermGroup, 
	[IsManiplex],
	function(M)
	local g;
	g := RotationGroup(M);
	if IsPermGroup(g) then
		return g;
	else
		return Image(IsomorphismPermGroup(g));
	fi;
	end);
	
InstallMethod(ConnectionGroup,
	[IsPremaniplex],
	function(M)
	local connectionGroup, g, h, w, wgens, wpgens, wp, hom, ker;
	
	connectionGroup := ComputeAttr(M, ConnectionGroup);
	if connectionGroup = fail then
		if IsReflexibleManiplexAutGpRep(M) or IsRotaryManiplexRotGpRep(M) and HasIsReflexible(M) and IsReflexible(M) then
			if HasSize(M) and Size(M) = infinity then
				connectionGroup := fail;
			else
				connectionGroup := Action(AutomorphismGroup(M), AutomorphismGroup(M), OnLeftInverse, "surjective");
			fi;
		elif IsManiplexPosetRep(M) then
			connectionGroup := ConnectionGroup(M!.poset);
		elif IsManiplexConnGpRep(M) then
			connectionGroup := M!.conn_gp;
		elif IsManiplexQuotientRep(M) then
			g := AutomorphismGroup(M!.parent);
			h := M!.subgroup;
			connectionGroup := Image(FactorCosetAction(g, h));
		elif IsRotaryManiplexRotGpRep(M) then
			g := RotationGroup(M);
			if Size(g) = infinity then
				connectionGroup := fail;
			else
				# A chiral polytope has a flag-stabilizer K that is normal in W+ but not W.
				# So we find the flag-stabilizer, and then use it to build the connection group.
				w := UniversalSggi(Rank(M));
				wgens := GeneratorsOfGroup(w);
				wpgens := List([1..Rank(M)-1], i -> wgens[i]*wgens[i+1]);
				wp := Subgroup(w, wpgens);
				hom := GroupHomomorphismByImagesNC(wp, g, wpgens, GeneratorsOfGroup(g));
				ker := Kernel(hom);
				connectionGroup := Image(FactorCosetAction(w, ker));
			fi;
		fi;
	fi;
	
	if connectionGroup <> fail then
		SetIsSggi(connectionGroup, true);
	fi;
	return connectionGroup;
	end);

InstallMethod(EvenConnectionGroup,
	[IsManiplex],
	function(M)
	local c, gens, newgens;
	c := ConnectionGroup(M);
	gens := GeneratorsOfGroup(c);
	newgens := List([1..Size(gens)-1], i -> gens[i] * gens[i+1]);
	return Group(newgens);
	end);

InstallMethod(ChiralityGroup,
	[IsRotaryManiplex],
	function(M)
	local g, M2, extra_rels, h;
	if HasIsReflexible(M) and IsReflexible(M) then return TrivialGroup(IsFpGroup); fi;
	g := RotationGroup(M);
	M2 := EnantiomorphicForm(M);
	extra_rels := ExtraRotRelators(M2);
	extra_rels := List(extra_rels, r -> RotGpElement(g, String(r)));
	h := NormalClosure(g, Subgroup(g, extra_rels));
	return h;
	end);

InstallMethod(ExtraRelators,
	[IsFpGroup],
	function(g)
	local rels, type_rels, sym, i;
	sym := SchlafliSymbol(g);
	rels := List(RelatorsOfFpGroup(g));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	type_rels := RelatorsOfFpGroup(UniversalSggi(sym));
	type_rels := List(type_rels, r -> TietzeWordAbstractWord(r));
	Append(type_rels, List(type_rels, Reversed));
	rels := Difference(rels, type_rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	return rels;
	end);
	
	
# Returns a list of relators that are necessary to
# define the automorphism group of M as a quotient of the string
# Coxeter group implied by its Schlafli Symbol.
InstallMethod(ExtraRelators,
	[IsReflexibleManiplex],
	function(M)
	return ExtraRelators(AutomorphismGroupFpGroup(M));
	end);
	
InstallMethod(ExtraRotRelators,
	[IsRotaryManiplex],
	function(M)
	local g, rels, type_rels, sym, i;
	g := RotationGroup(M);
	g := Image(IsomorphismFpGroupByGenerators(g, GeneratorsOfGroup(g)));
	sym := SchlafliSymbol(M);
	rels := List(RelatorsOfFpGroup(g));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	type_rels := RelatorsOfFpGroup(UniversalRotationGroup(SchlafliSymbol(M)));
	type_rels := List(type_rels, r -> TietzeWordAbstractWord(r));
	rels := Difference(rels, type_rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	return rels;
	end);
	
	
InstallMethod(IsManiplexable,
	[IsPermGroup],
	function(g)
	local test, D, gens, r, i, j ;
	test:=true;
	D:=NrMovedPoints(g);
	gens:=GeneratorsOfGroup(g);
	r:=Size(gens);	
	for i in [1..r] do
	if Order(gens[i]) <> 2 or NrMovedPoints(gens[i]) < D then
	test:=false;
	fi;
	od;
	for i in [1..r-1] do
	for j in [i+1..r] do
	if NrMovedPoints(gens[i]*gens[j]) < D then
	test:=false;
	fi;
	od;
	od;
	return test;
	end);
	
	
