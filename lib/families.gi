
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
	p := AbstractRegularPolytope([n]);
	SetDescription(p, Concatenation(String(n), "-gon"));
	return p;
	end);	

InstallMethod(Cube,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	if Size(sym) > 0 then sym[1] := 4; fi;
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation(String(n), "-cube"));
	return p;
	end);
	
InstallMethod(HemiCube,
	[IsInt],
	function(n)
	local p;
	p := QuotientPolytope(Cube(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	return p;
	end);
	
	
InstallMethod(CrossPolytope,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	sym[n-1] := 4;
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation(String(n), "-cross-polytope"));
	return p;
	end);

InstallMethod(HemiCrossPolytope,
	[IsInt],
	function(n)
	local p;
	p := QuotientPolytope(CrossPolytope(n), PetrieRelation(n, n));
	SetIsPolytopal(p, true);
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
	return p;
	end);
	
InstallMethod(Simplex,
	[IsInt],
	function(n)
	local sym, p;
	sym := List([1..n-1], i -> 3);
	p := AbstractRegularPolytope(sym);
	SetDescription(p, Concatenation(String(n), "-simplex"));
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
	return AbstractRegularPolytope("{5,3}_5");
	end);
InstallMethod(Icosahedron,
	[],
	function()
	return AbstractRegularPolytope([3,5]);
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return AbstractRegularPolytope("{3,5}_5");
	end);
InstallMethod(24Cell,
	[],
	function()
	return AbstractRegularPolytope([3,4,3]);
	end);
InstallMethod(Hemi24Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,4,3}_6");
	end);
InstallMethod(120Cell,
	[],
	function()
	return AbstractRegularPolytope([5,3,3]);
	end);
InstallMethod(Hemi120Cell,
	[],
	function()
	return AbstractRegularPolytope("{5,3,3}_15");
	end);
InstallMethod(600Cell,
	[],
	function()
	return AbstractRegularPolytope([3,3,5]);
	end);
InstallMethod(Hemi600Cell,
	[],
	function()
	return AbstractRegularPolytope("{3,3,5}_15");
	end);
