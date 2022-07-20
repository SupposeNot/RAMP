
InstallMethod(ZigzagLength,
	[IsReflexibleManiplex, IsInt],
	function(M, j)
	local G;
	if Rank(M) <> 3 then
		Error("j-zigzags are only defined for 3-maniplexes.\n");
	fi;
	
	# This is probably faster to compute with a permutation group if we
	# have it. If not, then just use what we have.
	if HasAutomorphismGroupPermGroup(M) then
		G := AutomorphismGroupPermGroup(M);
	else
		G := AutomorphismGroup(M);
	fi;
	return Order(G.1 * (G.2 * G.3)^j);
	end);

InstallMethod(ZigzagLength,
	[IsManiplex, IsInt],
	function(M, j)
	local G, zigzag, zgp, orbs;
	if Rank(M) <> 3 then
		Error("j-zigzags are only defined for 3-maniplexes.\n");
	fi;

	G := ConnectionGroup(M);
	zigzag := G.1 * (G.2 * G.3)^j;
	zgp := Subgroup(G, [zigzag]);
	orbs := Set(OrbitLengths(zgp));
	
	if Size(orbs) = 1 then
		return orbs[1];
	else
		return orbs;
	fi;
	end);
	
	
	
InstallMethod(ZigzagVector,
	[IsManiplex],
	function(M)
	local lens, k, q;
	if Rank(M) <> 3 then
		Error("Zigzag vectors are only defined for 3-maniplexes.\n");
	fi;
	if IsInt(SchlafliSymbol(M)[2]) then
		q := SchlafliSymbol(M)[2];
	else
		q := Maximum(SchlafliSymbol(M)[2]);
	fi;
	k := Int(q / 2);
	lens := List([1..k], i -> ZigzagLength(M, i));
	return lens;
	end);
	
InstallMethod(PetrieRelation,
	[IsInt, IsInt],
	function(n, k)
	local L, petrie_word;
	L := [0..n-1];
	L := List(L, i -> Concatenation("r", String(i)));
	petrie_word := Concatenation(L);
	return Concatenation("(", petrie_word, ")^", String(k));
	end);
	
InstallMethod(PetrieLength,
	[IsReflexibleManiplex],
	function(M)
	local g;
	if HasAutomorphismGroupPermGroup(M) then
		g := AutomorphismGroupPermGroup(M);
	elif HasConnectionGroup(M) then
		g := ConnectionGroup(M);
	else
		g := AutomorphismGroup(M);
	fi;
	return Order(Product(GeneratorsOfGroup(g)));
	end);

InstallMethod(PetrieLength,
	[IsManiplex],
	function(M)
	local g, petrie, lens;
	g := ConnectionGroup(M);
	petrie := Product(GeneratorsOfGroup(g));
	lens := Set(OrbitLengths(Subgroup(g, [petrie])));
	if Size(lens) = 1 then
		return lens[1];
	else
		return lens;
	fi;
	end);
	
	
InstallMethod(HoleLength,
	[IsReflexibleManiplex, IsInt],
	function(M, j)
	local G;
	if Rank(M) <> 3 then
		Error("j-holes are only defined for 3-maniplexes.\n");
	fi;
	
	# This is probably faster to compute with a permutation group if we
	# have it. If not, then just use what we have.
	if HasAutomorphismGroupPermGroup(M) then
		G := AutomorphismGroupPermGroup(M);
	else
		G := AutomorphismGroup(M);
	fi;
	return Order(G.1 * (G.2 * G.3)^(j-1) * G.2);
	end);
	
InstallMethod(HoleLength,
	[IsManiplex, IsInt],
	function(M, j)
	local G, hole, hgp, orbs;
	if Rank(M) <> 3 then
		Error("j-holes are only defined for 3-maniplexes.\n");
	fi;

	G := ConnectionGroup(M);
	hole := G.1 * (G.2 * G.3)^(j-1) * G.2;
	hgp := Subgroup(G, [hole]);
	orbs := Set(OrbitLengths(hgp));
	
	if Size(orbs) = 1 then
		return orbs[1];
	else
		return orbs;
	fi;
	end);
	
InstallMethod(HoleVector,
	[IsManiplex],
	function(M)
	local lens, k, q;
	if Rank(M) <> 3 then
		Error("hole vectors are only defined for 3-maniplexes.\n");
	fi;
	if IsInt(SchlafliSymbol(M)[2]) then
		q := SchlafliSymbol(M)[2];
	else
		q := Maximum(SchlafliSymbol(M)[2]);
	fi;
	k := Int((q+1) / 2);
	lens := List([2..k], i -> HoleLength(M, i));
	return lens;
	end);
	
