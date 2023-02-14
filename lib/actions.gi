
InstallMethod(AutomorphismGroupOnChains,
	[IsReflexibleManiplex, IsCollection],
	function(M, I)
	local g, h, gens, ranks, chains;
	g := AutomorphismGroup(M);
	gens := GeneratorsOfGroup(g);
	ranks := Difference([1..Rank(M)], I+1);
	h := Subgroup(g, gens{ranks});
	
	return ActionByGenerators(g, RightCosets(g,h), OnRight);
	end);

InstallMethod(AutomorphismGroupOnChains,
	[IsManiplex, IsCollection],
	function(M, I)
	local g, h, gens, ranks, chains;
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	ranks := Difference([1..Rank(M)], I+1);
	h := Subgroup(g, gens{ranks});
	chains := List(Orbits(h), AsSet);
	
	return ActionByGenerators(AutomorphismGroupOnFlags(M), AsSet(chains), OnSets);
	end);

InstallMethod(AutomorphismGroupOnIFaces,
	[IsManiplex, IsInt],
	function(M, i)
	return AutomorphismGroupOnChains(M, [i]);
	end);
	
InstallMethod(AutomorphismGroupOnVertices,
	[IsManiplex],
	function(M)
	return AutomorphismGroupOnIFaces(M, 0);
	end);
	
InstallMethod(AutomorphismGroupOnEdges,
	[IsManiplex],
	function(M)
	return AutomorphismGroupOnIFaces(M, 1);
	end);
	
InstallMethod(AutomorphismGroupOnFacets,
	[IsManiplex],
	function(M)
	return AutomorphismGroupOnIFaces(M, Rank(M)-1);
	end);
	

InstallMethod(NumberOfChainOrbits,
	[IsManiplex, IsCollection],
	function(M, I)
	local g;
	g := AutomorphismGroupOnChains(M, I);
	return Size(Orbits(g)) + LargestMovedPoint(g) - NrMovedPoints(g);
	end);

InstallMethod(NumberOfIFaceOrbits,
	[IsManiplex, IsInt],
	function(M, i)
	local g;
	g := AutomorphismGroupOnIFaces(M, i);
	return Size(Orbits(g)) + LargestMovedPoint(g) - NrMovedPoints(g);
	end);

InstallMethod(NumberOfVertexOrbits,
	[IsManiplex],
	function(M)
	local g;
	g := AutomorphismGroupOnVertices(M);
	return Size(Orbits(g)) + LargestMovedPoint(g) - NrMovedPoints(g);
	end);
	
InstallMethod(NumberOfEdgeOrbits,
	[IsManiplex],
	function(M)
	local g;
	g := AutomorphismGroupOnEdges(M);
	return Size(Orbits(g)) + LargestMovedPoint(g) - NrMovedPoints(g);
	end);
	
InstallMethod(NumberOfFacetOrbits,
	[IsManiplex],
	function(M)
	local g;
	g := AutomorphismGroupOnFacets(M);
	return Size(Orbits(g)) + LargestMovedPoint(g) - NrMovedPoints(g);
	end);


InstallMethod(IsChainTransitive,
	[IsManiplex, IsCollection],
	function(M, I)
	return (NumberOfChainOrbits(M, I) = 1);
	end);
	
InstallMethod(IsIFaceTransitive,
	[IsManiplex, IsInt],
	function(M, i)
	if (HasIsReflexible(M) and IsReflexible(M)) or (HasIsChiral(M) and IsChiral(M)) then
		return true;
	else
		return (NumberOfIFaceOrbits(M, i) = 1);
	fi;
	end);
	
InstallMethod(IsVertexTransitive,
	[IsManiplex],
	function(M)
	if (HasIsReflexible(M) and IsReflexible(M)) or (HasIsChiral(M) and IsChiral(M)) then
		return true;
	else
		return (NumberOfVertexOrbits(M) = 1);
	fi;
	end);
	
InstallMethod(IsEdgeTransitive,
	[IsManiplex],
	function(M)
	if (HasIsReflexible(M) and IsReflexible(M)) or (HasIsChiral(M) and IsChiral(M)) then
		return true;
	else
		return (NumberOfEdgeOrbits(M) = 1);
	fi;
	end);
	
InstallMethod(IsFacetTransitive,
	[IsManiplex],
	function(M)
	if (HasIsReflexible(M) and IsReflexible(M)) or (HasIsChiral(M) and IsChiral(M)) then
		return true;
	else
		return (NumberOfFacetOrbits(M) = 1);
	fi;
	end);
	
InstallMethod(IsFullyTransitive,
	[IsManiplex],
	function(M)
	if (HasIsReflexible(M) and IsReflexible(M)) or (HasIsChiral(M) and IsChiral(M)) then
		return true;
	else
		return ForAll([0..Rank(M)-1], i -> IsIFaceTransitive(M, i));
	fi;
	end);
	
InstallMethod(IsVertexFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;
	
	if IsReflexible(p) then
		g := AutomorphismGroup(p);
		n := Rank(p);
		gens := GeneratorsOfGroup(g){[2..n]};
		h := Subgroup(g, gens);
		c := Core(g,h);
		return (Size(c) = 1);
	else
		return IsVertexTransitive(p) and (Size(AutomorphismGroupOnVertices(p)) = Size(AutomorphismGroup(p)));
	fi;	
	end);
	
InstallMethod(MaxVertexFaithfulQuotient,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;

	if not(IsReflexible(p)) then
		Error("MaxVertexFaithfulQuotient is only defined for reflexible maniplexes");
	else
		return ReflexibleManiplex(AutomorphismGroupOnVertices(p));
	fi;
	
	# g := AutomorphismGroup(p);
	# n := Rank(p);
	# gens := GeneratorsOfGroup(g){[2..n]};
	# h := Subgroup(g, gens);
	# c := Core(g,h);
	# return ReflexibleManiplex(g/c);
	end);
	
InstallMethod(IsFacetFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;

	if IsReflexible(p) then
		g := AutomorphismGroup(p);
		n := Rank(p);
		gens := GeneratorsOfGroup(g){[1..n-1]};
		h := Subgroup(g, gens);
		c := Core(g,h);
		return (Size(c) = 1);
	else
		return IsFacetTransitive(p) and (Size(AutomorphismGroupOnFacets(p)) = Size(AutomorphismGroup(p)));
	fi;	
	end);

