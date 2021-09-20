
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
	local p;
	if n < 2 then
		Error("Number of sides must be at least 2.\n");
		return fail;
	fi;
	p := AbstractRegularPolytope(UniversalSggi([n]));
	SetString(p, Concatenation("Pgon(", String(n), ")"));
	SetSchlafliSymbol(p, [n]);
	SetSize(p, 2*n);
	SetExtraRelators(p, []);
	return p;
	end);	

InstallMethod(Cube,
	[IsInt],
	function(n)
	local sym, p, g;
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
	p := AbstractRegularPolytope(g);
	SetSchlafliSymbol(p, sym);
	SetString(p, Concatenation("Cube(", String(n), ")"));
	SetExtraRelators(p, []);
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
	local sym, p, g;
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
	p := AbstractRegularPolytope(g);
	SetSchlafliSymbol(p, sym);
	SetString(p, Concatenation("CrossPolytope(", String(n), ")"));
	SetExtraRelators(p, []);
	return p;
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
	local sym, p, g;
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
	p := AbstractRegularPolytope(g);
	SetString(p, Concatenation("Simplex(", String(n), ")"));
	SetSchlafliSymbol(p, sym);
	SetExtraRelators(p, []);
	return p;
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
	p := AbstractRegularPolytope(g);
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
	p := AbstractRegularPolytope(g);
	SetString(p, "Dodecahedron()");
	SetSchlafliSymbol(p, [5,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(HemiDodecahedron,
	[],
	function()
	return AbstractRegularPolytope("{5,3}_5" : set_schlafli);
	end);
InstallMethod(Icosahedron,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,5]);
	p := AbstractRegularPolytope(g);
	SetString(p, "Icosahedron()");
	SetSchlafliSymbol(p, [3,5]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return AbstractRegularPolytope("{3,5}_5" : set_schlafli);
	end);
InstallMethod(24Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,4,3]);
	p := AbstractRegularPolytope(g);
	SetString(p, "24Cell");
	SetSchlafliSymbol(p, [3,4,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi24Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,4,3}_6" : set_schlafli);
	end);
InstallMethod(120Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([5,3,3]);
	p := AbstractRegularPolytope(g);
	SetString(p, "120Cell()");
	SetSchlafliSymbol(p, [5,3,3]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi120Cell,
	[],
	function()
	return AbstractRegularPolytope("{5,3,3}_15" : set_schlafli);
	end);
InstallMethod(600Cell,
	[],
	function()
	local g, p;
	g := UniversalSggi([3,3,5]);
	p := AbstractRegularPolytope(g);
	SetString(p, "600Cell()");
	SetSchlafliSymbol(p, [3,3,5]);
	SetExtraRelators(p, []);
	return p;
	end);
InstallMethod(Hemi600Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,3,5}_15" : set_schlafli);
	end);

InstallMethod(BrucknerSphere,
	[],
	function()
	return PosetFromAtomicList([ [ 1, 2, 3, 4 ], [ 1, 2, 3, 7 ], [ 1, 2, 6, 7 ], [ 1, 3, 4, 7 ], [ 1, 5, 6, 7 ], [ 2, 3, 4, 5 ],  [ 2, 3, 6, 7 ], [ 3, 4, 6, 7 ], [ 3, 4, 5, 6 ], [ 4, 5, 6, 7 ], [ 2, 3, 5, 8 ], [ 2, 3, 6, 8 ],  [ 3, 5, 6, 8 ], [ 1, 2, 6, 8 ], [ 1, 5, 6, 8 ], [ 1, 2, 4, 8 ], [ 2, 4, 5, 8 ], [ 1, 4, 7, 8 ], [ 1, 5, 7, 8 ], [ 4, 5, 7, 8 ] ]);
	end);