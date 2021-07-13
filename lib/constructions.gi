######## COMMON POLYTOPE CONSTRUCTORS ########

# This should probably be split into more files...
	
# Returns the Universal Polytope of rank n.
InstallMethod( UniversalPolytope,
	[IsInt],
	function(n)
	local g, fam, p;
	g := UniversalSggi(n);
	p := AbstractRegularPolytope(g);
	
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
	return p;
	end);
	
# Accepts either a list of Tietze words like [1, 2, 3, 2]
# or a string like "(r0 r1 r2 r1)^2, (r0 r1 r2)^4"
InstallMethod(QuotientPolytope,
	[IsReflexibleManiplex, IsList],
	function(p, rels)
	local g, w, h, q;
	g := AutomorphismGroup(p);
	if IsString(rels) then
		rels := ParseStringCRels(rels, g);
	else
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	fi;
	h := FactorGroupFpGroupByRels(g, rels);
	q := ReflexibleManiplex(h);
	return q;
	end);
	
InstallMethod(UniversalExtension,
	[IsReflexibleManiplex],
	function(p)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := Rank(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	p2 := ReflexibleManiplex(g2);
	
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
	[IsReflexibleManiplex, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := Rank(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	Add(rels, List([0..2*k-1], i -> n+(i mod 2)));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	p2 := ReflexibleManiplex(g2);

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
	[IsReflexibleManiplex],
	function(p)
	return UniversalExtension(p,2);
	end);
	
InstallMethod(TrivialExtension,
	[IsManiplex],
	function(M)
	local c, cgens, N, r, newgens;
	c := ConnectionGroup(M);
	cgens := GeneratorsOfGroup(c);
	N := LargestMovedPoint(c);
	r := MultPerm((1,N+1), N, 1);
	newgens := List(cgens, x -> MultPerm(x, 2, N));
	Add(newgens, r);
	return Maniplex(Group(newgens));
	end);

# TODO: Enforce that last entry of SchlafliSymbol(p) is even.
# Actually, I need an even stronger restriction...
InstallMethod(FlatExtension,
	[IsReflexibleManiplex, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := Rank(p);
	p2 := QuotientPolytope(UniversalExtension(p, k), [[n-1, n, n+1, n, n+1, n-1, n+1, n, n+1, n]]);

	if HasSize(p) then SetSize(p2, k*Size(p)); fi;

	if HasSchlafliSymbol(p) then
		sym := ShallowCopy(SchlafliSymbol(p));
		Add(sym, k);
		p2!.schlafli_symbol := sym;
		SetSchlafliSymbol(p2, sym);
	fi;
	return p2;
	end);

# TODO: Guard against some bad function values
# Make this one not assume anything and actually compute everything;
# make an NC version that assumes well-definedness.
InstallMethod(FlatRegularPolyhedron,
	[IsInt, IsInt, IsInt, IsInt],
	function(p,q,i,j)
	local g, poly;
	
	# Normalize i and j to have small absolute value
	# This makes some later computations faster
	if i > p/2 then i := i - p; fi;
	if j > q/2 then j := j - q; fi;
	g := UniversalSggi([p,q]);
	
	# We only need one of these two relations, but having both may make some computations faster.
	g := FactorGroupFpGroupByRels(g, [g.3*g.2*g.1*g.2*(g.3*g.2)^j*(g.2*g.1)^i, g.2*g.3*g.2*g.1*(g.2*g.3)^j*(g.1*g.2)^i]);
	poly := AbstractRegularPolytope(g);
	
	# Now we assume that the values of p, q, i, j really do yield a flat polyhedron of type {p, q}.
	SetSize(poly, 2*p*q);
	SetSize(AutomorphismGroup(poly), 2*p*q);
	SetFvector(poly, [q, p*q/2, p]);
	SetSchlafliSymbol(poly, [p,q]);
	return poly;
	end);
	
# TODO: Check for compatibility.
# Results not guaranteed to be correct for incompatible polytopes
InstallMethod(Amalgamate, 
	IsSameRank,
	[IsReflexibleManiplex, IsReflexibleManiplex],
	function(p,q)
	local a, g, h, n, rels, q_rels, f2, g2, sym;
	g := AutomorphismGroup(p);
	n := Rank(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	q_rels := List(RelatorsOfFpGroup(AutomorphismGroup(q)), r -> TietzeWordAbstractWord(r));
	# shift the relations of q "right" by one
	q_rels := List(q_rels, r -> List(r, i -> SignInt(i)*(AbsInt(i)+1)));
	Append(rels, q_rels);
	rels := Unique(rels);
	f2 := UniversalSggi(n+1);
	rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2)));
	rels := Difference(rels, RelatorsOfFpGroup(f2));
	g2 := FactorGroupFpGroupByRels(f2, rels);
	a := ReflexibleManiplex(g2);
	
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
	SetDescription(Med, Concatenation("Medial(", Description(p), ")"));
	
	AddAttrComputer(Med, Size,
		function(M)
		return 2 * Size(M!.base);
		end);

	AddAttrComputer(Med, Fvector,
		function(M)
		local fvec;
		fvec := Fvector(M!.base);
		return [fvec[2], 2 * fvec[2], fvec[1] + fvec[3]];
		end);
		
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
		end);

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
		end);
	
	if HasIsPolytopal(p) and IsPolytopal(p) then SetIsPolytopal(Med, true); fi;
	
	return Med;
	end);