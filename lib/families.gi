
InstallMethod(Pgon,
	[IsInt],
	function(n)
	return UniversalPolytope([n]);
	end);	

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
	
InstallMethod(HemiCube,
	[IsInt],
	function(n)
	local p;
	p := QuotientPolytope(Cube(n), PetrieRelation(n, n));
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
	p := UniversalPolytope(sym);
	SetSize(p, 2^n * Factorial(n));
	return p;
	end);

InstallMethod(HemiCrossPolytope,
	[IsInt],
	function(n)
	local p;
	p := QuotientPolytope(CrossPolytope(n), PetrieRelation(n, n));
	SetSize(p, 2^(n-1) * Factorial(n));
	SetSize(AutomorphismGroup(p), Size(p));
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
	
InstallMethod(Dodecahedron,
	[],
	function()
	return UniversalPolytope([5,3]);
	end);
InstallMethod(HemiDodecahedron,
	[],
	function()
	return QuotientPolytope(Dodecahedron(), PetrieRelation(3,5));
	end);
InstallMethod(Icosahedron,
	[],
	function()
	return UniversalPolytope([3,5]);
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return QuotientPolytope(Icosahedron(), PetrieRelation(3,5));
	end);
InstallMethod(24Cell,
	[],
	function()
	return UniversalPolytope([3,4,3]);
	end);
InstallMethod(Hemi24Cell,
	[],
	function()
	return QuotientPolytope(24Cell(), PetrieRelation(4,6));
	end);
InstallMethod(120Cell,
	[],
	function()
	return UniversalPolytope([5,3,3]);
	end);
InstallMethod(Hemi120Cell,
	[],
	function()
	return QuotientPolytope(120Cell(), PetrieRelation(4,15));
	end);
InstallMethod(600Cell,
	[],
	function()
	return UniversalPolytope([3,3,5]);
	end);
InstallMethod(HemiIcosahedron,
	[],
	function()
	return QuotientPolytope(600Cell(), PetrieRelation(4,15));
	end);
