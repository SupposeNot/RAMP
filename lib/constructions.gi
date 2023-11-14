######## COMMON POLYTOPE CONSTRUCTORS ########

# This should probably be split into more files...
	
# Returns the Universal Polytope of rank n.
InstallMethod( UniversalPolytope,
	[IsInt],
	function(n)
	local g, fam, p;
	g := UniversalSggi(n);
	p := AbstractRegularPolytopeNC(g);
	
	if n = 0 then
		SetSize(p, 1);
		SetFvector(p, []);
		SetSchlafliSymbol(p, []);
	elif n = 1 then
		SetSize(p, 2);
		SetFvector(p, [2]);
		SetSchlafliSymbol(p, []);
	elif n > 1 then
		SetSize(p, infinity);
		SetFvector(p, List([1..n], i -> infinity));
		SetSchlafliSymbol(p, List([1..n-1], i -> infinity));
	fi;
	SetString(p, Concatenation("UniversalPolytope(", String(n), ")"));
	return p;
	end);
	
InstallMethod(UniversalExtension,
	[IsManiplex],
	function(p)
	local g, n, rels, f2, g2, p2, sym;
	if not(IsReflexible(p)) then
		Error("UniversalExtension is only defined for reflexible maniplexes.\n");
	fi;
	g := AutomorphismGroupFpGroup(p);
	n := Rank(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	p2 := ReflexibleManiplexNC(g2);
	
	SetSize(p2, infinity);
	sym := ShallowCopy(SchlafliSymbol(p));
	Add(sym, infinity);
	p2!.schlafli_symbol := sym;
	SetSchlafliSymbol(p2, sym);

	if HasIsPolytopal(p) then
		SetIsPolytopal(p2, IsPolytopal(p));
	fi;

	return p2;
	end);

InstallMethod(UniversalExtension,
	[IsManiplex, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	if not(IsReflexible(p)) then
		Error("UniversalExtension is only defined for reflexible maniplexes.\n");
	fi;
	g := AutomorphismGroupFpGroup(p);
	n := Rank(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	Add(rels, List([0..2*k-1], i -> n+(i mod 2)));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	SetIsSggi(g2, true);
	p2 := ReflexibleManiplexNC(g2);

	# TODO: Handle other exceptional cases
	if k = infinity then
		SetSize(p2, infinity);
	elif k = 2 and HasSize(p) then
		SetSize(p2, 2*Size(p));
	fi;
	
	if HasSchlafliSymbol(p) then
		sym := ShallowCopy(SchlafliSymbol(p));
		Add(sym, k);
		p2!.schlafli_symbol := sym;
		SetSchlafliSymbol(p2, sym);
	fi;

	if HasIsPolytopal(p) then
		SetIsPolytopal(p2, IsPolytopal(p));
	fi;
	
	return p2;
	end);
	
InstallMethod(TrivialExtension,
	[IsManiplex],
	function(M)
	local ext;
	
	if HasIsReflexible(M) and IsReflexible(M) then
		return UniversalExtension(M,2);
	fi;
	
	ext := Maniplex(TrivialExtension, [M]);
	ext!.base := M;

	SetRankManiplex(ext, Rank(M) + 1);
	SetFacets(ext, [M]);
	SetString(ext, Concatenation("TrivialExtension(", String(M), ")"));

	AddAttrComputer(ext, Size, M -> 2*Size(M!.base) : prereqs := [Size]);
	AddAttrComputer(ext, IsPolytopal, M -> IsPolytopal(M!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(ext, SchlafliSymbol, M -> Concatenation(SchlafliSymbol(M!.base), [2]) : prereqs := [SchlafliSymbol]);
	AddAttrComputer(ext, Fvector, M -> Concatenation(Fvector(M!.base), [2]) : prereqs := [Fvector]);
	AddAttrComputer(ext, VertexFigures, M -> List(VertexFigures(M!.base), TrivialExtension) : prereqs := [VertexFigures]);
	AddAttrComputer(ext, ConnectionGroup, 
		function(M)
		local c, cgens, N, r, newgens;
		c := ConnectionGroup(M!.base);
		cgens := GeneratorsOfGroup(c);
		N := NrMovedPoints(c);
		r := MultPerm((1,N+1), N, 1);
		newgens := List(cgens, x -> MultPerm(x, 2, N));
		Add(newgens, r);
		return Group(newgens);
		end);
		
	return ext;
	end);

# TODO: Enforce that last entry of SchlafliSymbol(p) is even.
# Actually, I need an even stronger restriction...
InstallMethod(FlatExtension,
	[IsManiplex, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	
	if not(IsReflexible(p)) then
		Error("FlatExtension is currently only defined for reflexible maniplexes.\n");
	fi;
	
	g := AutomorphismGroup(p);
	n := Rank(p);
	p2 := ReflexibleQuotientManiplex(UniversalExtension(p, k), [[n-1, n, n+1, n, n+1, n-1, n+1, n, n+1, n]]);

	if HasSize(p) then SetSize(p2, k*Size(p)); fi;

	if HasSchlafliSymbol(p) then
		sym := ShallowCopy(SchlafliSymbol(p));
		Add(sym, k);
		p2!.schlafli_symbol := sym;
		SetSchlafliSymbol(p2, sym);
	fi;
	return p2;
	end);

# TODO: Check for compatibility.
# Results not guaranteed to be correct for incompatible polytopes
InstallMethod(Amalgamate, 
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	local a, g, h, n, rels, q_rels, f2, g2, sym;

	n := Rank(p);
	if Rank(q) <> n then
		Error("p and q must be the same rank.\n");
	fi;
	
	
	if HasIsReflexible(p) and IsReflexible(p) and HasIsReflexible(q) and IsReflexible(q) then
		g := AutomorphismGroupFpGroup(p);
		h := AutomorphismGroupFpGroup(q);
		f2 := UniversalSggi(n+1);
		
	elif ForAll([p,q], x -> HasIsRotary(x) and IsRotary(x) and IsOrientable(x)) then
		g := RotationGroupFpGroup(p);
		h := RotationGroupFpGroup(q);
		f2 := UniversalRotationGroup(n+1);
		
		rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
		q_rels := List(RelatorsOfFpGroup(RotationGroupFpGroup(q)), r -> TietzeWordAbstractWord(r));
		# shift the relations of q "right" by one
		q_rels := List(q_rels, r -> List(r, i -> SignInt(i)*(AbsInt(i)+1)));
		Append(rels, q_rels);
		rels := Unique(rels);
		f2 := UniversalRotationGroup(n+1);
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2)));
		rels := Difference(rels, RelatorsOfFpGroup(f2));
		g2 := FactorGroupFpGroupByRels(f2, rels);
		a := RotaryManiplex(g2);
			
	else
		Error("Amalgamate is not currently defined for non-rotary maniplexes.\n");
	fi;
	
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	q_rels := List(RelatorsOfFpGroup(h), r -> TietzeWordAbstractWord(r));
	# shift the relations of q "right" by one
	q_rels := List(q_rels, r -> List(r, i -> SignInt(i)*(AbsInt(i)+1)));
	Append(rels, q_rels);
	rels := Unique(rels);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2)));
	rels := Difference(rels, RelatorsOfFpGroup(f2));
	g2 := FactorGroupFpGroupByRels(f2, rels);
	
	if HasIsSggi(f2) and IsSggi(f2) then
		a := ReflexibleManiplexNC(g2);
	elif HasIsStringRotationGroup(f2) and IsStringRotationGroup(f2) then
		a := RotaryManiplexNC(g2);
	else
		Error("f2 was somehow neither an sggi nor a string rotation group!");
	fi;
	
	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) then
		sym := ShallowCopy(SchlafliSymbol(p));
		Add(sym, SchlafliSymbol(q)[n-1]);
		SetSchlafliSymbol(a, sym);
	fi;
	
	return a;
	end);
	
# Currently only well-defined for rank 3
InstallMethod(Medial,
	[IsManiplex],
	function(p)
	local dict, Med;
	
	if Rank(p) <> 3 then Error("Medial only defined for rank 3."); fi;

	Med := Maniplex(Medial, [p]);
	Med!.base := p;

	SetRankManiplex(Med, 3);
	SetString(Med, Concatenation("Medial(", String(p), ")"));

	AddAttrComputer(Med, Size, M -> 2*Size(M!.base) : prereqs := [Size]);
	AddAttrComputer(Med, IsPolytopal, M -> IsPolytopal(M!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(Med, Fvector, 
		function(M)
		local fvec;
		fvec := Fvector(M!.base);
		return [fvec[2], 2 * fvec[2], fvec[1] + fvec[3]];
		end :
		prereqs := [Fvector]);
	AddAttrComputer(Med, SchlafliSymbol, 
		function(M)
		local sch, pset;
		sch := SchlafliSymbol(M!.base);
		pset := [];
		AddOrAppend(pset, sch[1]);
		AddOrAppend(pset, sch[2]);
		pset := Set(pset);
		if Size(pset) = 1 then pset := pset[1]; fi;
		return [pset, 4];
		end :
		prereqs := [SchlafliSymbol]);
	AddAttrComputer(Med, ConnectionGroup, 
		function(M)
		local cg, n, r0, r1, r2, s0, s1, s2;
		cg := ConnectionGroup(M!.base);
		n := Size(M!.base);
		
		r0 := cg.1;
		r1 := cg.2;
		r2 := cg.3;

		# The flags of the medial of P are of the form (Phi, 0) and (Phi, 2).
		# If P has flags 1, ..., N, then we define flag j+N to be (j, 2).
		
		# s0 acts like r1 on the first component, fixing the second component.
		s0 := MultPerm(r1, 2, n);
		
		# s1 acts like r2 on (Phi, 0) and like r0 on (Phi, 2), fixing the second component.
		s1 := r2 * TranslatePerm(r0, n);
		
		# s2 fixes the first component while switching the second component.
		s2 := MultPerm((1,n+1), n, 1);

		return Group([s0,s1,s2]);
		end :
		prereqs := [ConnectionGroup]);

	return Med;
	end);