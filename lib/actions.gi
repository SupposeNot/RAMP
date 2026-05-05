
InstallMethod(AutomorphismGroupOnChains,
	[IsReflexibleManiplex, IsCollection],
	function(M, I)
	local g, h, gens, ranks, chains, n;
	
	n := Rank(M);

	if not(IsSubset([0..n-1], I)) then
		Error("I must be a subset of [0, ..., n-1]");
	fi;
	
	g := AutomorphismGroup(M);
	gens := GeneratorsOfGroup(g);
	ranks := Difference([1..n], I+1);
	h := Subgroup(g, gens{ranks});
	
	return ActionByGenerators(g, RightCosets(g,h), OnRight);
	end);

InstallMethod(AutomorphismGroupOnChains,
	[IsManiplex, IsCollection],
	function(M, I)
	local g, h, gens, ranks, chains, n;
	
	n := Rank(M);

	if not(IsSubset([0..n-1], I)) then
		Error("I must be a subset of [0, ..., n-1]");
	fi;
	
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	ranks := Difference([1..n], I+1);
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
	
# We need to add NumberOfChains(M,I) - NrMovedPoints(g) because otherwise
# singleton orbits are not counted (since the set a permutation acts on
# is implicit).
InstallMethod(NumberOfChainOrbits,
	[IsManiplex, IsCollection],
	function(M, I)
	local g, n;
	n := Rank(M);

	if not(IsSubset([0..n-1], I)) then
		Error("I must be a subset of [0, ..., n-1]");
	fi;
	
	if (HasIsReflexible(M) and IsReflexible(M)) then
		return 1;
	elif (HasIsChiral(M) and IsChiral(M)) then
		if Size(M) < n then
			return 1;
		else
			return 2;
		fi;
	else
		g := AutomorphismGroupOnChains(M, I);
		return Size(Orbits(g)) + NumberOfChains(M,I) - NrMovedPoints(g);
	fi;
	end);

InstallMethod(NumberOfIFaceOrbits,
	[IsManiplex, IsInt],
	function(M, i)
	return NumberOfChainOrbits(M, [i]);
	end);

InstallMethod(NumberOfVertexOrbits,
	[IsManiplex],
	function(M)
	return NumberOfIFaceOrbits(M,0);
	end);
	
InstallMethod(NumberOfEdgeOrbits,
	[IsManiplex],
	function(M)
	return NumberOfIFaceOrbits(M,1);
	end);
	
InstallMethod(NumberOfFacetOrbits,
	[IsManiplex],
	function(M)
	return NumberOfIFaceOrbits(M,Rank(M)-1);
	end);


InstallMethod(IsChainTransitive,
	[IsManiplex, IsCollection],
	function(M, I)
	return (NumberOfChainOrbits(M, I) = 1);
	end);
	
InstallMethod(IsIFaceTransitive,
	[IsManiplex, IsInt],
	function(M, i)
	return (NumberOfIFaceOrbits(M, i) = 1);
	end);
	
InstallMethod(IsVertexTransitive,
	[IsManiplex],
	function(M)
	return (NumberOfVertexOrbits(M) = 1);
	end);
	
InstallMethod(IsEdgeTransitive,
	[IsManiplex],
	function(M)
	return (NumberOfEdgeOrbits(M) = 1);
	end);
	
InstallMethod(IsFacetTransitive,
	[IsManiplex],
	function(M)
	return (NumberOfFacetOrbits(M) = 1);
	end);
	
InstallMethod(IsFullyTransitive,
	[IsManiplex],
	function(M)
	return ForAll([0..Rank(M)-1], i -> IsIFaceTransitive(M, i));
	end);
	
InstallMethod(IsVertexFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;
	
	if IsReflexible(p) then
		g := AutomorphismGroup(p);
		if Factorial(NumberOfVertices(p)) < Size(g) then
			return false;
		fi;
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
	[IsReflexibleManiplex],
	function(p)
		return ReflexibleManiplex(AutomorphismGroupOnVertices(p));
	end);
	
InstallMethod(IsFacetFaithful,
	[IsManiplex],
	function(p)
	local g, h, c, n, gens;

	if IsReflexible(p) then
		g := AutomorphismGroup(p);
		if Factorial(NumberOfFacets(p)) < Size(g) then
			return false;
		fi;
		n := Rank(p);
		gens := GeneratorsOfGroup(g){[1..n-1]};
		h := Subgroup(g, gens);
		c := Core(g,h);
		return (Size(c) = 1);
	else
		return IsFacetTransitive(p) and (Size(AutomorphismGroupOnFacets(p)) = Size(AutomorphismGroup(p)));
	fi;	
	end);

InstallMethod(MaxFacetFaithfulQuotient,
	[IsReflexibleManiplex],
	function(p)
		return ReflexibleManiplex(AutomorphismGroupOnFacets(p));
	end);
	


InstallMethod(IFaceStabilizer,
	[IsReflexibleManiplex, IsInt],
	function(M, i)
	local g, n, gens;
	
	g := AutomorphismGroup(M);
	n := Rank(M);
	gens := List([1..i], j -> g.(j));
	Append(gens, List([i+2..n], j -> g.(j)));
	return Subgroup(g, gens);
	end);

InstallMethod(VertexStabilizer,
	[IsReflexibleManiplex],
	function(M)
	return IFaceStabilizer(M,0);
	end);
	
InstallMethod(EdgeStabilizer,
	[IsReflexibleManiplex],
	function(M)
	return IFaceStabilizer(M,1);
	end);
	
InstallMethod(FacetStabilizer,
	[IsReflexibleManiplex],
	function(M)
	return IFaceStabilizer(M,Rank(M)-1);
	end);
	
InstallMethod(ChainStabilizer,
	[IsReflexibleManiplex, IsCollection],
	function(M, I)
	local g, h, i;
	
	g := AutomorphismGroup(M);
	h := g;
	for i in I do
		h := Intersection(h, IFaceStabilizer(M, i));
	od;
	return h;	
	end);
	
InstallMethod(MaxChainStabilizer,
	[IsReflexibleManiplex],
	function(M)
	return ChainStabilizer(M, [0..Rank(M)-1]);	
	end);