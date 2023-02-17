
InstallMethod(Vertex,
	[],
	function()
	return UniversalPolytope(0);
	end);	

InstallMethod(Edge,
	[],
	function()
	return UniversalPolytope(1);
	end);	

InstallMethod(Pgon,
	[IsInt],
	function(n)
	local p, r0, r1;
	if n < 2 then
		Error("Number of sides must be at least 2.\n");
		return fail;
	fi;
	p := AbstractRegularPolytopeNC(UniversalSggi([n]));
	SetString(p, Concatenation("Pgon(", String(n), ")"));
	SetSchlafliSymbol(p, [n]);
	SetSize(p, 2*n);
	SetExtraRelators(p, []);
	
	r0 := PermFromRange((1,2), (2*n-1, 2*n));
	r1 := (1, 2*n) * PermFromRange((2,3), (2*n-2, 2*n-1));
	SetConnectionGroup(p, Group(r0,r1));
	
	return p;
	end);	

InstallMethod(Cube,
	[IsInt],
	function(n)
	local sym, p, g, perms;
	if n < 0 then
		Error("n must be at least 0.\n");
		return fail;
	elif n = 0 then
		return UniversalPolytope(0);
	elif n = 1 then
		return UniversalPolytope(1);
	elif n = 2 then
		return Pgon(4);
	fi;
	
	sym := List([1..n-1], i -> 3);
	sym[1] := 4;
	g := UniversalSggi(sym);
	p := AbstractRegularPolytopeNC(g);
	SetSchlafliSymbol(p, sym);
	SetString(p, Concatenation("Cube(", String(n), ")"));
	SetExtraRelators(p, []);

	perms := [(n, n+1)];
	Append(perms, List([1..n-1], i -> (n-i, n-i+1)(n+i, n+i+1)));
	SetAutomorphismGroupPermGroup(p, Group(perms));
	return p;
	end);
	
InstallMethod(HemiCube,
	[IsInt],
	function(n)
	local p;
	if n < 3 then
		Error("Rank must be at least 3.\n");
		return fail;
	fi;
	p := ReflexibleQuotientManiplex(Cube(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	SetSchlafliSymbol(p, SchlafliSymbol(Cube(n)));
	SetString(p, Concatenation("HemiCube(", String(n), ")"));
	return p;
	end);
	
	
InstallMethod(CrossPolytope,
	[IsInt],
	function(n)
	local sym, p, g, perms;
	if n < 0 then
		Error("n must be at least 0.\n");
		return fail;
	elif n = 0 then
		return UniversalPolytope(0);
	elif n = 1 then
		return UniversalPolytope(1);
	elif n = 2 then
		return Pgon(4);
	fi;
	sym := List([1..n-1], i -> 3);
	sym[n-1] := 4;
	g := UniversalSggi(sym);
	p := AbstractRegularPolytopeNC(g);
	SetSchlafliSymbol(p, sym);
	SetString(p, Concatenation("CrossPolytope(", String(n), ")"));
	SetExtraRelators(p, []);

	perms := [(n, n+1)];
	Append(perms, List([1..n-1], i -> (n-i, n-i+1)(n+i, n+i+1)));
	SetAutomorphismGroupPermGroup(p, Group(Reversed(perms)));
	return p;
	end);

InstallMethod(Octahedron,
	[],
	function()
	return CrossPolytope(3);
	end);
	
InstallMethod(HemiCrossPolytope,
	[IsInt],
	function(n)
	local p;
	if n < 3 then
		Error("Rank must be at least 3.\n");
		return fail;
	fi;
	p := ReflexibleQuotientManiplex(CrossPolytope(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	SetSchlafliSymbol(p, SchlafliSymbol(CrossPolytope(n)));
	SetString(p, Concatenation("HemiCrossPolytope(", String(n), ")"));
	return p;
	end);
	
InstallMethod(Simplex,
	[IsInt],
	function(n)
	local sym, p, g, permgp;
	sym := List([1..n-1], i -> 3);
	if n < 0 then
		Error("n must be at least 0.\n");
		return fail;
	elif n = 0 then
		return UniversalPolytope(0);
	elif n = 1 then
		return UniversalPolytope(1);
	elif n = 2 then
		return Pgon(3);
	fi;
	g := UniversalSggi(sym);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, Concatenation("Simplex(", String(n), ")"));
	SetSchlafliSymbol(p, sym);
	SetExtraRelators(p, []);
	
	permgp := Group(List([1..n], i -> (i,i+1)));
	SetAutomorphismGroupPermGroup(p, permgp);
	return p;
	end);
	
InstallMethod(Tetrahedron,
	[],
	function()
	return Simplex(3);
	end);
	
InstallMethod(CubicTiling,
	[IsInt],
	function(n)
	local sym, p, g;
	if n < 2 then
		Error("n must be 2 or more.\n");
		return fail;
	fi;
	sym := List([1..n], i -> 3);
	sym[1] := 4;
	sym[n] := 4;
	g := UniversalSggi(sym);
	p := AbstractRegularPolytopeNC(g);
	SetSchlafliSymbol(p, sym);
	SetExtraRelators(p, []);
	SetString(p, Concatenation("CubicTiling(", String(n), ")"));
	return p;
	end);
	
InstallMethod(Dodecahedron,
	[],
	function()
	local g, p;
	g := UniversalSggi([5,3]);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, "Dodecahedron()");
	SetSchlafliSymbol(p, [5,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(HemiDodecahedron,
	[],
	function()
	return AbstractRegularPolytopeNC([5,3], "z1^5" : set_schlafli);
	end);
InstallMethod(Icosahedron,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,5]);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, "Icosahedron()");
	SetSchlafliSymbol(p, [3,5]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return AbstractRegularPolytopeNC([3,5], "z1^5" : set_schlafli);
	end);
	
InstallMethod(SmallStellatedDodecahedron,
	[],
	function()
	return AbstractRegularPolytope([5,5],"(r0 r1 r2 r1)^3");
	end);

InstallMethod(24Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,4,3]);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, "24Cell");
	SetSchlafliSymbol(p, [3,4,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi24Cell,
	[],
	function()
	return AbstractRegularPolytopeNC([3,4,3], "(r0 r1 r2 r3)^6" : set_schlafli);
	end);
InstallMethod(120Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([5,3,3]);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, "120Cell()");
	SetSchlafliSymbol(p, [5,3,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi120Cell,
	[],
	function()
	return AbstractRegularPolytopeNC([5,3,3], "(r0 r1 r2 r3)^15" : set_schlafli);
	end);
InstallMethod(600Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,3,5]);
	p := AbstractRegularPolytopeNC(g);
	SetString(p, "600Cell()");
	SetSchlafliSymbol(p, [3,3,5]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi600Cell,
	[],
	function()
	return AbstractRegularPolytopeNC([3,3,5], "(r0 r1 r2 r3)^15" : set_schlafli);
	end);

InstallMethod(BrucknerSphere,
	[],
	function()
	return PosetFromAtomicList([ [ 1, 2, 3, 4 ], [ 1, 2, 3, 7 ], [ 1, 2, 6, 7 ], [ 1, 3, 4, 7 ], [ 1, 5, 6, 7 ], [ 2, 3, 4, 5 ],  [ 2, 3, 6, 7 ], [ 3, 4, 6, 7 ], [ 3, 4, 5, 6 ], [ 4, 5, 6, 7 ], [ 2, 3, 5, 8 ], [ 2, 3, 6, 8 ],  [ 3, 5, 6, 8 ], [ 1, 2, 6, 8 ], [ 1, 5, 6, 8 ], [ 1, 2, 4, 8 ], [ 2, 4, 5, 8 ], [ 1, 4, 7, 8 ], [ 1, 5, 7, 8 ], [ 4, 5, 7, 8 ] ]);
	end);
	
InstallMethod(InternallySelfDualPolyhedron1,
	[IsInt],
	function(p)
	local r0, r1, r2;
	if p < 7 then
		Error("This family of polyhedra is only defined for p >= 7.");
	fi;
	if IsEvenInt(p) then
		r0 := MultPerm((1,2), p/2, 2);
		r1 := MultPerm((2,3), (p-2)/2, 2);
		r2 := (1,5)(2,6)(3,4) * MultPerm((7,8), (p/2)-3, 2);
	else
		r0 := MultPerm((1,2), (p-1)/2, 2);
		r1 := MultPerm((2,3), (p-1)/2, 2);
		r2 := (1,5)(2,6)(3,4) * MultPerm((7,8), ((p-1)/2)-3, 2);
	fi;
	return ReflexibleManiplex(Group(r0,r1,r2));
	end);
	
InstallMethod(InternallySelfDualPolyhedron2,
	[IsInt, IsInt],
	function(p, k)
	local r0, r1, r2, N;
	if not(IsEvenInt(p)) or p < 6 then
		Error("This family of polyhedra is only defined when p is even and p >= 6.");
	elif IsEvenInt(k) then
		Error("This family of polyhedra is only defined when k is odd.");
	fi;
	
	r0 := PermFromRange((2,3), (p-6,p-5)) * (p-4, p-2)(p-3, p-1);
	r1 := PermFromRange((1,2), (p-5, p-4)) * PermFromRange((p-1, p), (2*p-7, 2*p-6));
	r2 := PermFromRange((p-4, p-3), (2*p-8, 2*p-7));

	N := k*(p-4);
	
	r0 := MultPerm(r0, N, 2*p-6);
	r1 := MultPerm(r1, N, 2*p-6) * MultPerm((p-2, p-3+2*p-6), N-1, 2*p-6) * (p-2 + (N-1)*(2*p-6), p-3);
	r2 := MultPerm(r2, N, 2*p-6);

	# (i, j) --> i + (j-1)*(2p-6)
	# connect (p-2, j) to (p-3, j+1) --> p-2+(j-1)*N to p-3+j*N
	# (p-2, p-3+N)

	return ReflexibleManiplex(Group(r0,r1,r2));
	end);

InstallMethod(GrandAntiprism,
	[],
	function()
	local GA, r0, r1, r2, r3;
	GA := InputTextFile(Filename(RampDataPath, "GrandAntiprism.txt"));
	r0 := EvalString(ReadLine(GA));
	r1 := EvalString(ReadLine(GA));
	r2 := EvalString(ReadLine(GA));
	r3 := EvalString(ReadLine(GA));
	CloseStream(GA);
	return Maniplex(Group(r0,r1,r2,r3));
	end);
