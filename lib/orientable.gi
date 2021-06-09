
InstallMethod(IsOrientable,
	[IsReflexibleManiplex],
	function(p)
	local rels;
	rels := ExtraRelators(p);
	return ForAll(rels, r -> Length(r) mod 2 = 0);
	end);

InstallMethod(IsIOrientable,
	[IsReflexibleManiplex, IsList],
	function(p, I)
	local rels;
	rels := RelatorsOfFpGroup(AutomorphismGroup(p));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	# Translate I since tietze words are 1-based instead of 0-based
	I := List(I, i -> i+1);
	return ForAll(rels, r -> Number(r, i -> i in I) mod 2 = 0);
	end);

InstallMethod(IsVertexBipartite,
	[IsReflexibleManiplex],
	function(p)
	return IsIOrientable(p, [0]);
	end);
	
InstallMethod(IsFacetBipartite,
	[IsReflexibleManiplex],
	function(p)
	return IsIOrientable(p, [Rank(p)-1]);
	end);
	
