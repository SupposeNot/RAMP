
InstallMethod(AutomorphismGroupOnChains,
	[IsManiplex, IsSet],
	function(M, I)
	local g, h, gens, ranks, chains;
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	ranks := Difference([1..Rank(M)], I+1);
	h := Subgroup(g, gens{ranks});
	chains := List(Orbits(h), AsSet);
	
	return Action(AutomorphismGroupOnFlags(M), AsSet(chains), OnSets);
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
	
