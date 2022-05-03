
InstallMethod(IsOrientable,
	[IsManiplex],
	function(M)
	local isOrientable;
	isOrientable := ComputeAttr(M, IsOrientable);
	if isOrientable = fail then
		if HasIsReflexible(M) and IsReflexible(M) then
			isOrientable := ForAll(RelatorsOfFpGroup(AutomorphismGroupFpGroup(M)), r -> IsEvenInt(Length(r)));
		else
			isOrientable := IsBipartite(UnlabeledFlagGraph(M));
		fi;
	fi;
	
	return isOrientable;
	end);

InstallMethod(IsIOrientable,
	[IsReflexibleManiplex, IsList],
	function(M, I)
	local rels;
	rels := RelatorsOfFpGroup(AutomorphismGroupFpGroup(M));
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
	return(IsBipartite(QuotientByLabel(g[1], g[2], g[3], I)));
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
