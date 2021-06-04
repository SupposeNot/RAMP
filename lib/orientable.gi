
InstallMethod(IsOrientable,
	[IsAbstractRegularPolytope],
	function(p)
	local rels;
	rels := ExtraRelators(p);
	return ForAll(rels, r -> Length(r) mod 2 = 0);
	end);

InstallMethod(IsIOrientable,
	[IsAbstractRegularPolytope, IsList],
	function(p, I)
	local rels;
	rels := RelatorsOfFpGroup(AutomorphismGroup(p));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	# Translate I since tietze words are 1-based instead of 0-based
	I := List(I, i -> i+1);
	return ForAll(rels, r -> Number(r, i -> i in I) mod 2 = 0);
	end);

InstallMethod(IsVertexBipartite,
	[IsAbstractRegularPolytope],
	function(p)
	return IsIOrientable(p, [0]);
	end);
	
InstallMethod(IsFacetBipartite,
	[IsAbstractRegularPolytope],
	function(p)
	return IsIOrientable(p, [RankPolytope(p)-1]);
	end);
	
