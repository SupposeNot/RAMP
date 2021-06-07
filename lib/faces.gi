# A note about the f-vector...
# For most polytopes, the f-vector starts out blank.
# Any time we compute the number of i-faces of a polytope, we store it
# in the internal f-vector.
# Eventually, if the user asks for the f-vector, we compute the number
# of i-faces for each i that hasn't already been computed.

InstallMethod(NumberOfIFaces,
	[IsAbstractPolytope, IsInt],
	function(p,i)
	local g, n, ranks, MP;
	n:=RankPolytope(p);
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
	[IsAbstractRegularPolytope, IsInt],
	function(p, i)
	local g, h, sym, n, J, num;
	n := RankPolytope(p);
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
	[IsAbstractPolytope],
	function(p)
	return NumberOfIFaces(p,0);
	end);
	
InstallMethod(NumberOfEdges,
	[IsAbstractPolytope],
	function(p)
	return NumberOfIFaces(p,1);
	end);
	
InstallMethod(NumberOfFacets,
	[IsAbstractPolytope],
	function(p)
	return NumberOfIFaces(p,RankPolytope(p)-1);
	end);
	
InstallMethod(NumberOfRidges,
	[IsAbstractPolytope],
	function(p)
	return NumberOfIFaces(p,RankPolytope(p)-2);
	end);
	
InstallMethod(Fvector,
	[IsAbstractPolytope],
	function(p)
	local fvec, i, n;
	n := RankPolytope(p);
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
	[IsAbstractRegularPolytope],
	function(p)
	local n, sym, g, h, s, q;
	n := RankPolytope(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[1..n-1]});
	q := AbstractRegularPolytope(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[1..n-2]});
	fi;
	return q;
	end);
	
InstallMethod(VertexFigures,
	[IsAbstractRegularPolytope],
	function(p)
	local n, sym, g, h, s, q;
	n := RankPolytope(p);
	g := AutomorphismGroup(p);
	h := Subgroup(g, GeneratorsOfGroup(g){[2..n]});
	q := AbstractRegularPolytope(h);
	if HasSchlafliSymbol(p) then
		SetSchlafliSymbol(q, SchlafliSymbol(p){[2..n-1]});
	fi;
	return q;
	end);
	
