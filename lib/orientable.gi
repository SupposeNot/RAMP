
InstallMethod(IsOrientable,
	[IsReflexibleManiplex],
	function(M)
	local rels, val;
	rels := ExtraRelators(M);
	val := ForAll(rels, r -> Length(r) mod 2 = 0);
	if HasDual(M) then
		SetIsOrientable(Dual(M), val);
	fi;
	return val;
	end);

InstallMethod(IsOrientable,
	[IsManiplex],
	function(M)
	local val;
	val := ConnectionGroup(M) <> EvenConnectionGroup(M);
	if HasDual(M) then
		SetIsOrientable(Dual(M), val);
	fi;
	return val;
	end);

InstallMethod(IsIOrientable,
	[IsReflexibleManiplex, IsList],
	function(M, I)
	local rels;
	rels := RelatorsOfFpGroup(AutomorphismGroup(M));
	rels := List(rels, r -> TietzeWordAbstractWord(r));
	# Translate I since tietze words are 1-based instead of 0-based
	I := List(I, i -> i+1);
	return ForAll(rels, r -> Number(r, i -> i in I) mod 2 = 0);
	end);

InstallMethod(IsVertexBipartite,
	[IsReflexibleManiplex],
	function(M)
	return IsIOrientable(M, [0]);
	end);
	
InstallMethod(IsVertexBipartite,
	[IsManiplex],
	function(M)
	return IsBipartite(Skeleton(M));
	end);
	
InstallMethod(IsFacetBipartite,
	[IsReflexibleManiplex],
	function(M)
	return IsIOrientable(M, [Rank(M)-1]);
	end);
	
InstallMethod(IsFacetBipartite,
	[IsManiplex],
	function(M)
	return IsBipartite(Skeleton(Dual(M)));
	end);
