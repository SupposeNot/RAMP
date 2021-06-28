# A note about the f-vector...
# For most polytopes, the f-vector starts out blank.
# Any time we compute the number of i-faces of a polytope, we store it
# in the internal f-vector.
# Eventually, if the user asks for the f-vector, we compute the number
# of i-faces for each i that hasn't already been computed.

InstallMethod(NumberOfIFaces,
	[IsManiplex, IsInt],
	function(p,i)
	local g, n, ranks, MP;
	n:=Rank(p);
	if i < 0 or i > n-1 then Error("<i> must be between 0 and n-1"); fi;
	ranks:=[1..n];
	Remove(ranks,i+1);
	g:=ConnectionGroup(p);
	MP:=Subgroup(g, GeneratorsOfGroup(g){ranks});
	return Size(Orbits(MP));
	end);  	
	
# TODO: Deal more gracefully with infinite polytopes
# This should also use the schlafli symbol if it is bound.
InstallOtherMethod(NumberOfIFaces,
	[IsReflexibleManiplex, IsInt],
	function(p, i)
	local g, h, sym, n, J, num;
	n := Rank(p);
	if i < 0 or i > n-1 then Error("<i> must be between 0 and n-1"); fi;
	if p!.fvec[i+1] <> fail then
		return p!.fvec[i+1];
	fi;

	g := AutomorphismGroup(p);
	if n = 3 and HasSize(p) and IsFinite(p) then
		if (i = 1) then
			num := Size(p)/4;
		elif (i = 0) then
			num := Size(p) / (2*SchlafliSymbol(p)[2]);
		else # i = 2
			num := Size(p) / (2*SchlafliSymbol(p)[1]);
		fi;
	else
		J := [1..n];
		Remove(J, i+1);
		h := Subgroup(g, GeneratorsOfGroup(g){J});
		num := Index(g,h);
	fi;
	
	p!.fvec[i+1] := num;
	if ForAll(p!.fvec, i -> i <> fail) then
		SetFvector(p, p!.fvec);
	fi;
	
	return num;
	end);

InstallMethod(NumberOfVertices,
	[IsManiplex],
	function(p)
	return NumberOfIFaces(p,0);
	end);
	
InstallMethod(NumberOfEdges,
	[IsManiplex],
	function(p)
	return NumberOfIFaces(p,1);
	end);
	
InstallMethod(NumberOfFacets,
	[IsManiplex],
	function(p)
	return NumberOfIFaces(p,Rank(p)-1);
	end);
	
InstallMethod(NumberOfRidges,
	[IsManiplex],
	function(p)
	return NumberOfIFaces(p,Rank(p)-2);
	end);
	
InstallMethod(Fvector,
	[IsManiplex],
	function(p)
	local fvec, i, n;
	n := Rank(p);
	fvec := [];
	for i in [0..n-1] do
		Add(fvec, NumberOfIFaces(p,i));
	od;
	return fvec;
	end);
	
# TODO: Handle some special cases:
# 1. The facets of a universal coxeter group are a universal coxeter group.
# 2. If P is finite, then try guessing a presentation for the facets.
#	This will give something that might properly cover the facets -- compare size.
InstallMethod(Facets,
	[IsReflexibleManiplex],
	function(p)
	local n, sym, g, h, s, q;
	n := Rank(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[1..n-1]});
	q := ReflexibleManiplex(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[1..n-2]});
	fi;
	return q;
	end);
	
InstallMethod(VertexFigures,
	[IsReflexibleManiplex],
	function(p)
	local n, sym, g, h, s, q;
	n := Rank(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[2..n]});
	q := ReflexibleManiplex(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[2..n-1]});
	fi;
	return q;
	end);
	
InstallMethod(SchlafliSymbol,
	[IsReflexibleManiplex],
	function(M)
	local gens, n, sym;
	gens := GeneratorsOfGroup(AutomorphismGroup(M));
	n := Rank(M);
	sym := [];
	sym := List([1..n-1], i -> Order(gens[i]*gens[i+1]));
	if HasDual(M) then
		SetSchlafliSymbol(Dual(M), Reversed(sym));
	fi;
	return sym;
	end);
	
InstallMethod(SchlafliSymbol,
	[IsManiplex and IsRotaryManiplexRotGpRep],
	function(M)
	local gens, n, sym;
	gens := GeneratorsOfGroup(AutomorphismGroup(M));
	n := Rank(M);
	sym := List(gens, x -> Order(x));
	if HasDual(M) then
		SetSchlafliSymbol(Dual(M), Reversed(sym));
	fi;
	return sym;
	end);
	
# This assumes that the connection group really does act on flags.
# It should work for IsManiplexQuotientRep too.
InstallMethod(SchlafliSymbol,
	[IsManiplex],
	function(M)
	local n, g, i, sym, gens, h, orbs, sections;
	sym := [];
	n := Rank(M);
	g := ConnectionGroup(M);
	gens := GeneratorsOfGroup(g);
	for i in [1..n-1] do
		# Look at the orbits under <ri-1, ri>.
		# An orbit of size k indicates a (k/2)-gon section.
		h := Subgroup(g, [gens[i], gens[i+1]]);
		orbs := OrbitLengths(h);
		sections := Set(List(orbs, k -> k/2));
		if Size(sections) = 1 then
			Add(sym, sections[1]);
		else
			Add(sym, sections);
		fi;
	od;

	if HasDual(M) then
		SetSchlafliSymbol(Dual(M), Reversed(sym));
	fi;
	return sym;
	end);
	
InstallMethod(IsEquivelar,
	[IsManiplex],
	function(M)
	return ForAll(SchlafliSymbol(M), x -> IsInt(x));
	end);
	
# Every reflexible and rotary maniplex is equivelar
InstallTrueMethod(IsEquivelar, IsReflexible);
InstallTrueMethod(IsEquivelar, IsRotary);