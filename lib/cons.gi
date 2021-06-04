######## COMMON POLYTOPE CONSTRUCTORS ########

## TODO ##
# Have simplex etc add some combinatorial information
# Put some tests here

	
# Helper function for UniversalPolytope below.	
_IS_SPHERICAL := function(sym)
	local prefix, suffix, k, n;
	n := 1+Size(sym);
	if n <= 1 then return true; fi;
	if ForAny(sym, i -> i = 2) then
		k := First([1..n-1], i -> sym[i] = 2);
		prefix := sym{[1..k-1]};
		suffix := sym{[k+1..n-1]};
		return _IS_SPHERICAL(prefix) and _IS_SPHERICAL(suffix);
	elif n = 2 then
		return sym[1] <> infinity;
	elif n = 3 then
		if sym in [[3,3], [3,4], [3,5], [4,3], [5,3]] then return true; else return false; fi;
	elif n = 4 then
		if sym in [[3,3,3], [3,3,4], [3,3,5], [3,4,3], [4,3,3], [5,3,3]] then return true; else return false; fi;
	else # n >= 5
		if ForAll(sym, i -> i = 3) then
			return true;
		elif sym[1] = 4 and ForAll(sym{[2..n-1]}, i -> i = 3) then
			return true;
		elif sym[n-1] = 4 and ForAll(sym{[1..n-2]}, i -> i = 3) then
			return true;
		else
			return false;
		fi;
	fi;
	end;

# Returns the Universal Polytope of rank n.
InstallMethod( UniversalPolytope,
	[IsInt],
	function(n)
	local g, fam, p;
	g := UniversalSggi(n);
	fam := NewFamily(Concatenation("Abstract Regular ", String(n), "-Polytope"), IsAbstractRegularPolytope);
	fam!.rank := n;
	p := Objectify( NewType( fam, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels), rec( aut_gp := g, rank := n, schlafli_symbol := List([1..n-1], i -> infinity)));
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
		SetSchlafliSymbol(p, p!.schlafli_symbol);
	fi;
	return p;
	end);
	
# Returns the Universal polytope with the given Schlafli symbol
InstallOtherMethod( UniversalPolytope,
	[IsList],
	function(sym)
	local g, n, fam, p, w, gens, rels, i;
	n := 1+Size(sym);
	w := UniversalSggi(n);
	gens := FreeGeneratorsOfFpGroup(w);
	rels := [];
	for i in [1..n-1] do
		if sym[i] <> infinity then
			Add(rels, (gens[i]*gens[i+1])^sym[i]);
		fi;
	od;
	g := FactorGroupFpGroupByRels(w, rels);
	fam := NewFamily(Concatenation("Abstract Regular ", String(n), "-Polytope"), IsAbstractRegularPolytope);
	fam!.rank := n;

	p := Objectify( NewType( fam, IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithRels), rec( aut_gp := g, rank := n, schlafli_symbol := sym, fvec := List([1..n], i -> fail)));
	
	if not(_IS_SPHERICAL(sym)) then
		SetSize(p, infinity);
	fi;
	
	SetSchlafliSymbol(p, sym);
	
	return p;
	end);

InstallMethod(Pgon,
	[IsInt],
	function(n)
	return UniversalPolytope([n]);
	end);
	
InstallMethod(QuotientPolytope,
	[IsAbstractRegularPolytope, IsList],
	function(p, rels)
	local g, h, q;
	g := AutomorphismGroup(p);
	h := FactorGroupFpGroupByRels(g, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g))));
	q := AbstractRegularPolytope(h);
	return q;
	end);
	
InstallMethod(UniversalExtension,
	[IsAbstractRegularPolytope],
	function(p)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	p2 := AbstractRegularPolytope(g2);
	
	SetSize(p2, infinity);
	sym := ShallowCopy(SchlafliSymbol(p));
	Add(sym, infinity);
	p2!.schlafli_symbol := sym;
	SetSchlafliSymbol(p2, sym);

	return p2;
	end);

InstallOtherMethod(UniversalExtension,
	[IsAbstractRegularPolytope, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
	rels := List(RelatorsOfFpGroup(g), r -> TietzeWordAbstractWord(r));
	Add(rels, List([0..2*k-1], i -> n+(i mod 2)));
	f2 := UniversalSggi(n+1);
	g2 := FactorGroupFpGroupByRels(f2, List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(f2))));
	p2 := AbstractRegularPolytope(g2);

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

	return p2;
	end);
	
InstallMethod(TrivialExtension,
	[IsAbstractRegularPolytope],
	function(p)
	return UniversalExtension(p,2);
	end);

# TODO: Enforce that last entry of SchlafliSymbol(p) is even.
# Actually, I need an even stronger restriction...
InstallMethod(FlatExtension,
	[IsAbstractRegularPolytope, IsInt],
	function(p, k)
	local g, n, rels, f2, g2, p2, sym;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
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

# Calculate the petrie length. Find the rels that define g as a quotient of [p,q]_r.
# Look for 2-holes next. (order of r0 r1 r2 r1)
# STUB - not finished yet
_STANDARDIZE_RELS := function(p)
	local g;
	end;

InstallMethod(Cube,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	sym[1] := 4;
	p := UniversalPolytope(sym);
	SetSize(p, 2^n * Factorial(n));
	return p;
	end);
	
#This REALLY needs to be crosspolytope	
InstallMethod(Orthotope,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	sym[n-1] := 4;
	p := UniversalPolytope(sym);
	SetSize(p, 2^n * Factorial(n));
	return p;
	end);
	
InstallMethod(Simplex,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	p := UniversalPolytope(sym);
	SetSize(p, Factorial(n+1));
	return p;
	end);
	
InstallMethod(CubicTiling,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	sym[1] := 4;
	sym[n-1] := 4;
	p := UniversalPolytope(sym);
	SetSize(p, infinity);
	return p;
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
	[IsAbstractRegularPolytope, IsAbstractRegularPolytope],
	function(p,q)
	local a, g, h, n, rels, q_rels, f2, g2, sym;
	g := AutomorphismGroup(p);
	n := RankPolytope(p);
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
	a := AbstractRegularPolytope(g2);
	
	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) then
		sym := ShallowCopy(SchlafliSymbol(p));
		Add(sym, SchlafliSymbol(q)[n-1]);
		SetSchlafliSymbol(a, sym);
	fi;
	
	return a;
	end);
	
# Currently only well-defined for polyhedra
InstallMethod(Medial,
	[IsAbstractPolytope],
	function(p)
	local cg, n, r0, r1, r2, s0, s1, s2;
	
	if RankPolytope(p) <> 3 then Error("Medial only defined for polyhedra."); fi;
	
	cg := ConnectionGroup(p);
	n := Size(p);
	
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

	return AbstractPolytope(Group([s0,s1,s2]));
	end);
