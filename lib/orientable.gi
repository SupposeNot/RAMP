
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
	val := IsBipartite(UnlabeledFlagGraph(M));
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
	I := I+1;
	return ForAll(rels, r -> Number(r, i -> i in I) mod 2 = 0);
	end);

InstallMethod(IsIOrientable,
	[IsManiplex, IsList],
	function(M, I)
	local g;
	g := FlagGraphWithLabels(M);

	# QuotientByLabel has edge labels that are offset by 1.
	return(IsBipartite(QuotientByLabel(g[1], g[2], g[3], I+1)));
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
	return IsBipartite(CoSkeleton(M));
	end);

BindGlobal("MinimalIOrientableManiplex",
	function(I, n)
	local generators;
	
	generators := List([0..n-1],
					function(i)
					if i in I then return (1,2);
					else return ();
					fi;
					end);
					
	return ReflexibleManiplex(Group(generators));
	end);

InstallMethod(IOrientableCover,
	[IsReflexibleManiplex, IsList],
	function(M, I)
	return Mix(M, MinimalIOrientableManiplex(I, Rank(M)));
	end);
	
InstallMethod(IOrientableCover,
	[IsManiplex, IsList],
	function(M, I)
	return FlagMix(M, MinimalIOrientableManiplex(I, Rank(M)));
	end);
	
InstallMethod(OrientableCover,
	[IsManiplex],
	function(M)
	return IOrientableCover(M, [0..Rank(M)-1]);
	end);
