
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
	
