# This checks some easily-calculated combinatorial properties
# for whether p could be a function of q.
InstallGlobalFunction(CouldBeQuotientOf,
	function(p,q)
	local i, k1, k2;
	if Rank(p) <> Rank(q) then return false; fi;

	if HasSize(p) and HasSize(q) then
		if not(IsFinite(p)) and IsFinite(q) then
			return false;
		elif IsFinite(p) and not(IsInt(Size(q) / Size(p))) then
			return false;
		fi;
	fi;

	if HasIsOrientable(p) and IsOrientable(p) and HasIsOrientable(q) and not(IsOrientable(q)) then
		return false;
	fi;

	if HasSchlafliSymbol(p) and HasSchlafliSymbol(q) and IsEquivelar(p) and IsEquivelar(q) then
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

	# To add later...
	# fvec p | fvec q? (Does this actually work??)
	# facets p are quo of facets q?
	
	return true;
	end);
	

# To determine if P is a quotient of Q, if they are both just generic polytopes,
# then we try to find a homomorphism between their connection groups.
# TODO: This is broken! We want something more like an action homomorphism...
InstallMethod(IsQuotientOf,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	if not(CouldBeQuotientOf(p,q)) then return false; fi;
	g1 := ConnectionGroup(q);
	g2 := ConnectionGroup(p);
	hom := GroupHomomorphismByImages(g1, g2);
	return (hom <> fail);
	end);

InstallMethod(IsQuotientOf,
	ReturnTrue,
	[IsManiplex and IsManiplexQuotientRep, IsManiplex and IsManiplexQuotientRep],
	function(p,q)
	if not(CouldBeQuotientOf(p,q)) then return false; fi;
	if (p!.parent = q!.parent) and IsSubset(q!.subgroup, p!.subgroup) then
		return true;
	else
		TryNextMethod();
	fi;
	end);
	
# This determines whether the regular polytope P is a quotient of the regular polytope Q,
# assuming that we have presentations for both of their groups.
InstallMethod(IsQuotientOf,
	ReturnTrue,
	[IsReflexibleManiplex, IsReflexibleManiplex],
	function(p,q)
	local g, rels, g1, g2, hom, k1, k2, i;
	if not(CouldBeQuotientOf(p,q)) then return false; fi;

	# TODO: This only logically works if they have Schlafli symbols that are known and computed
	if IsSubset(ExtraRelators(q), ExtraRelators(p)) then return true; fi;
	
	if HasSize(p) and IsFinite(p) then
		# add rels from q to p...
		rels := RelatorsOfFpGroup(AutomorphismGroupFpGroup(q));
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(AutomorphismGroupFpGroup(p))));
		g := FactorGroupFpGroupByRels(AutomorphismGroupFpGroup(p), rels);
		return (Size(g) = Size(p));
	else
		g1 := AutomorphismGroup(q);
		g2 := AutomorphismGroup(p);
		hom := GroupHomomorphismByImages(g1, g2, GeneratorsOfGroup(g1), GeneratorsOfGroup(g2));
		return (hom <> fail);
	fi;
	end);
	
InstallMethod(IsQuotientOf,
	ReturnTrue,
	[IsManiplex and IsRotaryManiplexRotGpRep, IsManiplex and IsRotaryManiplexRotGpRep],
	function(p,q)
	local g, rels, newrels, p2, g1, g2, g3, hom1, hom2, k1, k2, i;
	if not(CouldBeQuotientOf(p,q)) then return false; fi;

	# TODO: This only logically works if they have Schlafli symbols that are known and computed
	if IsSubset(ExtraRotRelators(q), ExtraRotRelators(p)) then return true; fi;
	
	# We have to check both p and the enantiomorphic form of p
	p2 := EnantiomorphicForm(p);
	
	if HasSize(p) and IsFinite(p) then
		# add rels from q to p...
		rels := RelatorsOfFpGroup(RotationGroup(q));
		rels := List(rels, r -> TietzeWordAbstractWord(r));
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(RotationGroup(p))));
		g := FactorGroupFpGroupByRels(RotationGroup(p), newrels);
		if Size(g) = Size(RotationGroup(p)) then
			return true;
		fi;
		
		# Now try the enantiomorphic form
		newrels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(RotationGroup(p2))));
		g := FactorGroupFpGroupByRels(RotationGroup(p2), rels);
		return (Size(g) = Size(RotationGroup(p2)));
	else
		g1 := RotationGroup(q);
		g2 := RotationGroup(p);
		g3 := RotationGroup(p2);
		hom1 := GroupHomomorphismByImages(g1, g2, GeneratorsOfGroup(g1), GeneratorsOfGroup(g2));
		hom2 := GroupHomomorphismByImages(g1, g3, GeneratorsOfGroup(g1), GeneratorsOfGroup(g3));
		return (hom1 <> fail or hom2 <> fail);
	fi;
	end);
	
InstallMethod(IsCoverOf,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotientOf(q,p);
	end);

InstallMethod(IsIsomorphicTo,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	local atts, att, val, prop;
	atts := [Size, SchlafliSymbol, Fvector];
	for att in atts do
		if Tester(att)(p) and Tester(att)(q) and att(p) <> att(q) then return false; fi;
	od;
	
	# This optimization is disabled until IsQuotientOf is fixed...
	#if HasIsFinite(p) and HasIsFinite(q) and IsFinite(p) and IsFinite(q) then
		# At this point, we know that p and q are the same size and finite.
	#	val := IsQuotientOf(p,q);
	#else
	#	val := (IsQuotientOf(p,q) and IsCoverOf(p,q));
	#fi;
	val := (IsQuotientOf(p,q) and IsCoverOf(p,q));

	
	if val then
		# p and q might have different knowledge about their properties --
		# sync them up!
		for prop in KnownPropertiesOfObject(p) do
			prop := EvalString(prop);
			Setter(prop)(q, prop(p));
		od;
		for prop in KnownPropertiesOfObject(q) do
			prop := EvalString(prop);
			Setter(prop)(p, prop(q));
		od;
		for att in KnownAttributesOfObject(p) do
			att := EvalString(att);
			Setter(att)(q, att(p));
		od;
		for att in KnownAttributesOfObject(q) do
			att := EvalString(att);
			Setter(att)(p, att(q));
		od;
	fi;
	
	return val;
	end);
	
InstallMethod( \=,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsIsomorphicTo(p,q);
	end);

InstallMethod(SmallestRegularCover,
	[IsManiplex],
	function(p)
	return ReflexibleManiplex(Image(RegularActionHomomorphism(ConnectionGroup(p))));
	end);
	
