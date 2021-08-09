# This checks some easily-calculated combinatorial properties
# for whether p could be a function of q.
InstallGlobalFunction(CouldBeQuotient,
	function(q,p)
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
	

InstallMethod(IsQuotient,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(q,p)
	local g1, g2, hom, s1, s2, i, flags, phi;
	if not(CouldBeQuotient(q,p)) then return false; fi;
	g1 := ConnectionGroup(q);
	g2 := ConnectionGroup(p);
	if g1 = fail or g2 = fail then return fail; fi;
	hom := GroupHomomorphismByImages(g1, g2);
	if hom = fail then
		return false;
	else
		# Now we look for flags of p and q such that the stabilizer of the flag of
		# q is contained in the stabilizer of the flag of p.
		# WLOG we can use flag 1 in q.
		flags := FlagOrbitRepresentatives(p);
		s1 := Stabilizer(g1, 1);
		for phi in flags do
			if IsSubset(PreImage(hom, Stabilizer(g2, phi)), s1) then
				return true;
			fi;
		od;
		return false;
	fi;
	end);

InstallMethod(IsQuotient,
	ReturnTrue,
	[IsManiplex and IsManiplexQuotientRep, IsManiplex and IsManiplexQuotientRep],
	function(q,p)
	if not(CouldBeQuotient(q,p)) then return false; fi;
	if (p!.parent = q!.parent) and IsSubset(q!.subgroup, p!.subgroup) then
		return true;
	else
		TryNextMethod();
	fi;
	end);
	
# This determines whether the regular polytope P is a quotient of the regular polytope Q,
# assuming that we have presentations for both of their groups.
InstallMethod(IsQuotient,
	ReturnTrue,
	[IsManiplex and IsReflexibleManiplexAutGpRep, IsManiplex and IsReflexibleManiplexAutGpRep],
	function(q,p)
	local g, rels, g1, g2, hom, k1, k2, i;
	if not(CouldBeQuotient(q,p)) then return false; fi;

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
	
InstallMethod(IsQuotient,
	ReturnTrue,
	[IsManiplex and IsRotaryManiplexRotGpRep, IsManiplex and IsRotaryManiplexRotGpRep],
	function(q,p)
	local g, rels, newrels, p2, g1, g2, g3, hom1, hom2, k1, k2, i;
	if not(CouldBeQuotient(q,p)) then return false; fi;

	# TODO: This only logically works if they have Schlafli symbols that are known and computed
	# This isn't working...
	# if IsSubset(ExtraRotRelators(q), ExtraRotRelators(p)) then return true; fi;
	
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
		g := FactorGroupFpGroupByRels(RotationGroup(p2), newrels);
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
	
InstallMethod(IsCover,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	return IsQuotient(q,p);
	end);

InstallMethod(IsIsomorphicManiplex,
	ReturnTrue,
	[IsManiplex, IsManiplex],
	function(p,q)
	local atts, att, val, prop;
	atts := [Size, SchlafliSymbol, Fvector];
	for att in atts do
		if Tester(att)(p) and Tester(att)(q) and att(p) <> att(q) then return false; fi;
	od;
	
	if HasIsFinite(p) and HasIsFinite(q) and IsFinite(p) and IsFinite(q) then
		# At this point, we know that p and q are the same size and finite.
		val := IsQuotient(p,q);
	else
		val := (IsQuotient(p,q) and IsCover(p,q));
	fi;
	
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
	return IsIsomorphicManiplex(p,q);
	end);

InstallMethod(SmallestRegularCover,
	[IsManiplex],
	function(p)
	return ReflexibleManiplex(Image(RegularActionHomomorphism(ConnectionGroup(p))));
	end);
	
InstallMethod(QuotientManiplex,
	[IsReflexibleManiplex, IsString],
	function(M, relStr)
	local g, h, rels;
	g := AutomorphismGroupFpGroup(M);
	rels := ParseStringCRels(relStr, g);
	rels := List(rels, r -> ElementOfFpGroup(FamilyObj(g.1), r));
	h := Subgroup(g, rels);
	return Maniplex(M, h);
	end);
	
InstallOtherMethod(\/,
	[IsReflexibleManiplex, IsString],
	function(M, relStr)
	return QuotientManiplex(M, relStr);
	end);
	
# Accepts either a list of Tietze words like [1, 2, 3, 2]
# or a string like "(r0 r1 r2 r1)^2, (r0 r1 r2)^4"
InstallMethod(ReflexibleQuotientManiplex,
	[IsReflexibleManiplex, IsList],
	function(p, rels)
	local g, w, h, q;
	g := AutomorphismGroup(p);
	if IsString(rels) then
		rels := ParseStringCRels(rels, g);
	else
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(g)));
	fi;
	h := FactorGroupFpGroupByRels(g, rels);
	q := ReflexibleManiplex(h);
	return q;
	end);
	
