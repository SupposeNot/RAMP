
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
	fi;
	p := AbstractRegularPolytope(UniversalSggi([n]));
	SetDescription(p, Concatenation("Pgon(", String(n), ")"));
	SetSchlafliSymbol(p, [n]);
	SetSize(p, 2*n);
	SetExtraRelators(p, []);
	return p;
	end);	

InstallMethod(Cube,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	if Size(sym) > 0 then sym[1] := 4; fi;
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation("Cube(", String(n), ")"));
	return p;
	end);
	
InstallMethod(HemiCube,
	[IsInt],
	function(n)
	local p;
	if n < 3 then
		Error("Rank must be at least 3.\n");
	fi;
	p := QuotientPolytope(Cube(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	SetSchlafliSymbol(p, SchlafliSymbol(Cube(n)));
	SetDescription(p, Concatenation("HemiCube(", String(n), ")"));
	return p;
	end);
	
	
InstallMethod(CrossPolytope,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	sym[n-1] := 4;
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation("CrossPolytope(", String(n), ")"));
	return p;
	end);

InstallMethod(HemiCrossPolytope,
	[IsInt],
	function(n)
	local p;
	if n < 3 then
		Error("Rank must be at least 3.\n");
	fi;
	p := QuotientPolytope(CrossPolytope(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	SetSchlafliSymbol(p, SchlafliSymbol(CrossPolytope(n)));
	SetDescription(p, Concatenation("HemiCrossPolytope(", String(n), ")"));
	return p;
	end);
	
InstallMethod(Simplex,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation("Simplex(", String(n), ")"));
	return p;
	end);
	
InstallMethod(CubicTiling,
	[IsInt],
	function(n)
	local sym, p;
	if n < 3 then
		Error("n must be 3 or more");
	fi;
	sym := List([1..n-1], i -> 3);
	sym[1] := 4;
	sym[n-1] := 4;
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation("CubicTiling(", String(n), ")"));
	return p;
	end);
	
InstallMethod(Dodecahedron,
	[],
	function()
	return AbstractRegularPolytope([5,3]);
	end);
InstallMethod(HemiDodecahedron,
	[],
	function()
	return AbstractRegularPolytope("{5,3}_5" : set_schlafli);
	end);
InstallMethod(Icosahedron,
	[],
	function()
	return AbstractRegularPolytope([3,5]);
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return AbstractRegularPolytope("{3,5}_5" : set_schlafli);
	end);
InstallMethod(24Cell,
	[],
	function()
	return AbstractRegularPolytope([3,4,3]);
	end);
InstallMethod(Hemi24Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,4,3}_6" : set_schlafli);
	end);
InstallMethod(120Cell,
	[],
	function()
	return AbstractRegularPolytope([5,3,3]);
	end);
InstallMethod(Hemi120Cell,
	[],
	function()
	return AbstractRegularPolytope("{5,3,3}_15" : set_schlafli);
	end);
InstallMethod(600Cell,
	[],
	function()
	return AbstractRegularPolytope([3,3,5]);
	end);
InstallMethod(Hemi600Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,3,5}_15" : set_schlafli);
	end);
