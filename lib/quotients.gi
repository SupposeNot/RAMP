
# To determine if P is a quotient of Q, if they are both just generic polytopes,
# then we try to find a homomorphism between their connection groups.
# TODO: Optimize this by checking some easy algebraic invariants first.
InstallMethod(IsQuotientOf,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	g1 := ConnectionGroup(q);
	g2 := ConnectionGroup(p);
	hom := GroupHomomorphismByImages(g1, g2);
	return (hom <> fail);
	end);

# This determines whether the regular polytope P is a quotient of the regular polytope Q,
# assuming that we have presentations for both of their groups.
InstallMethod(IsQuotientOf,
	IsSameRank,
	[IsReflexibleManiplex and IsReflexibleManiplexWithRels, IsReflexibleManiplex and IsReflexibleManiplexWithRels],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) then
		for i in [1..Rank(p)-1] do
			k1 := SchlafliSymbol(p)[i];
			k2 := SchlafliSymbol(q)[i];
			if k2 < k1 then 	# This also handles infinity
				return false;
			elif k1 < infinity and k2 < infinity and not(IsInt(k2/k1)) then
				return false;
			fi;
		od;
	fi;

	if HasSize(q) and HasSize(p) and IsFinite(q) and IsFinite(p) then
		if not(IsInt(Size(q) / Size(p))) then return false; fi;
	fi;

	# TODO: This only logically works if they have Schlafli symbols that are known and computed
	if IsSubset(ExtraRelators(q), ExtraRelators(p)) then return true; fi;
	
	if HasSize(p) and IsFinite(p) then
		# add rels from q to p...
		rels := RelatorsOfFpGroup(AutomorphismGroup(q));
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroup(p))));
		g := FactorGroupFpGroupByRels(AutomorphismGroup(p), rels);
		return (Size(g) = Size(p));
	else
		g1 := AutomorphismGroup(q);
		g2 := AutomorphismGroup(p);
		hom := GroupHomomorphismByImages(g1, g2, GeneratorsOfGroup(g1), GeneratorsOfGroup(g2));
		return (hom <> fail);
	fi;
	end);
	
InstallMethod(IsCoverOf,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotientOf(q,p);
	end);

InstallMethod(IsIsomorphicTo,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	local atts, att;
	atts := [Size, SchlafliSymbol, Fvector];
	for att in atts do
		if Tester(att)(p) and Tester(att)(q) and att(p) <> att(q) then return false; fi;
	od;
	
	if HasIsFinite(p) and HasIsFinite(q) and IsFinite(p) and IsFinite(q) then
		# At this point, we know that p and q are the same size and finite.
		return IsQuotientOf(p,q);
	else
		return IsQuotientOf(p,q) and IsCoverOf(p,q);
	fi;
	end);
	
InstallMethod( \=,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsIsomorphicTo(p,q);
	end);

InstallMethod( \<,
	IsSameRank,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotientOf(p,q);
	end);
	
InstallMethod(SmallestRegularCover,
	[IsManiplex],
	function(p)
	return ReflexibleManiplex(Image(RegularActionHomomorphism(ConnectionGroup(p))));
	end);
	
