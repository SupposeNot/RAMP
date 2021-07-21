# A note about the f-vector...
# For most polytopes, the f-vector starts out blank.
# Any time we compute the number of i-faces of a polytope, we store it
# in the internal f-vector.
# Eventually, if the user asks for the f-vector, we compute the number
# of i-faces for each i that hasn't already been computed.
# TODO: I think I can handle this more gracefully - see GAP ch. 85 "Function-Operation-Attribute triples"

##### NUMBER OF FACES, FVECTOR, ETC #####

InstallMethod(NumberOfIFaces,
	[IsManiplex, IsInt],
	function(p,i)
	local g, n, ranks, MP, fvec;
	n:=Rank(p);
	if i = -1 or i = n then
		return 1;
	elif i < 0 or i > n-1 then 
		Error("<i> must be between -1 and n"); 
	fi;
	
	if IsBound(p!.fvec) and p!.fvec[i+1] <> fail then
		return p!.fvec[i+1];
	fi;

	# For maniplexes built out of others, we can try computing the fvector.
	# This is typically less expensive then using the connection group.
	if IsManiplexInstructionsRep(p) then
		fvec := ComputeAttr(p, Fvector);
		if fvec <> fail then 
			p!.fvec := fvec;
			SetFvector(p, fvec);
			return fvec[i+1];
		fi;
	fi;


	ranks:=[1..n];
	Remove(ranks,i+1);
	g:=ConnectionGroup(p);
	MP:=Subgroup(g, GeneratorsOfGroup(g){ranks});
	return Size(Orbits(MP));
	end);  	
	
InstallOtherMethod(NumberOfIFaces,
	[IsReflexibleManiplex, IsInt],
	function(p, i)
	local g, h, sym, n, J, num;
	n := Rank(p);
	if i = -1 or i = n then
		return 1;
	elif i < 0 or i > n-1 then 
		Error("<i> must be between -1 and n"); 
	fi;
	
	if p!.fvec[i+1] <> fail then
		return p!.fvec[i+1];
	fi;

	g := AutomorphismGroup(p);
	if n = 3 and HasSize(p) and i = 1 then
		num := Size(p)/4;	
	elif n = 3 and HasSize(p) and i = 0 and SchlafliSymbol(p)[2] <> infinity then
		num := Size(p) / (2*SchlafliSymbol(p)[2]);
	elif n = 3 and HasSize(p) and i = 2 and SchlafliSymbol(p)[1] <> infinity then
		num := Size(p) / (2*SchlafliSymbol(p)[1]);
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
	function(M)
	local fvec, i, n;
	if IsManiplexInstructionsRep(M) then
		fvec := ComputeAttr(M, Fvector);
		if fvec <> fail then return fvec; fi;
	fi;
	
	n := Rank(M);
	fvec := [];
	for i in [0..n-1] do
		Add(fvec, NumberOfIFaces(M,i));
	od;
	return fvec;
	end);



##### FACETS, VERTEX-FIGURES, AND SECTIONS #####



InstallMethod(Section,
	[IsManiplex, IsInt, IsInt, IsInt],
	function(M, j, i, k)
	local g, n, h, o, newgens, q, sym, M2, newconn;
	n := Rank(M);

	if j > n then
		Error("j must be < n+1.\n");
	elif i < -1 then
		Error("i must be > -2.\n");
	elif j <= i then
		Error("j must be > i.\n");
	fi;
	
	if j-i = 1 then
		return UniversalPolytope(0);
	elif j-i = 2 then
		return UniversalPolytope(1);
	fi;

	if IsReflexibleManiplex(M) then
		sym := SchlafliSymbol(M){[i+2..j-1]};
		
		# Universal polytopes have universal sections
		if HasExtraRelators(M) and IsEmpty(ExtraRelators(M)) then
			M2 := ReflexibleManiplex(sym);
			if HasIsPolytopal(M) and IsPolytopal(M) then
				SetIsPolytopal(M2, true);
			fi;
			return M2;
		fi;
		
		# Polytopes have polygonal rank 2 sections
		if HasIsPolytopal(M) and IsPolytopal(M) and j-i = 3 then
			return Pgon(sym[1]);
		fi;
		
		g := AutomorphismGroup(M);
		h := Subgroup(g, GeneratorsOfGroup(g){[i+2..j]});
		q := ReflexibleManiplex(h);
		if HasSchlafliSymbol(M) then
			SetSchlafliSymbol(q, SchlafliSymbol(M){[i+2..j-1]});
		fi;
		return q;
	else
		g := ConnectionGroup(M);
		h := Subgroup(g, GeneratorsOfGroup(g){[i+2..j]});
		# Get the connected component of the graph with k in it...
		o := Orbit(h, k);
		# Then restrict the permutations to only act on that orbit...
		
		# Polytopes have polygonal rank 2 sections
		if HasIsPolytopal(M) and IsPolytopal(M) and j-i = 3 then
			return Pgon(Size(o)/2);
		fi;

		newgens := List(GeneratorsOfGroup(h), x -> RestrictedPerm(x, o));
		newconn := Group(newgens);
		# Retranslate the flags to be 1..N
		newconn := Action(newconn, MovedPoints(newconn));		
		q := Maniplex(newconn);
		return q;
	fi;
	end);

InstallMethod(Section,
	[IsManiplex, IsInt, IsInt],
	function(M, j, i)
	return Section(M, j, i, 1);
	end);

InstallMethod(Sections,
	[IsReflexibleManiplex, IsInt, IsInt],
	function(M, j, i)
	return [Section(M,j,i)];
	end);
	
InstallMethod(Sections,
	[IsManiplex, IsInt, IsInt],
	function(M, j, i)
	return Unique(List(FlagOrbitRepresentatives(M), k -> Section(M,j,i,k)));
	end);


	
InstallMethod(Facets,
	[IsManiplex],
	function(M)
	local n, val;
	if IsManiplexInstructionsRep(M) then
		val := ComputeAttr(M, Facets);
		if val <> fail then return val; fi;
	fi;
	n := Rank(M);
	return Sections(M, n-1, -1);
	end);
	
InstallMethod(Facet,
	[IsManiplex, IsInt],
	function(M, k)
	local n;
	n := Rank(M);
	return Section(M, n-1, -1, k);
	end);
	
# TODO: Handle some special cases:
# 2. If P is finite, then try guessing a presentation for the facets.
#	This will give something that might properly cover the facets -- compare size.
InstallMethod(Facet,
	[IsManiplex],
	function(M)
	return Facet(M, 1);
	end);
	
InstallMethod(VertexFigures,
	[IsManiplex],
	function(M)
	local n;
	n := Rank(M);
	return Sections(M, n, 0);
	end);
	
InstallMethod(VertexFigure,
	[IsManiplex, IsInt],
	function(M, k)
	local n;
	n := Rank(M);
	return Section(M, n, 0, k);
	end);
	
InstallMethod(VertexFigure,
	[IsManiplex],
	function(M)
	return VertexFigure(M, 1);
	end);




##### FLATNESS #####


InstallMethod(IsFlat,
	[IsManiplex, IsInt, IsInt],
	function(M, i, j)
	local g;
	g := LayerGraph(M, i, j);
	
	# M is (i,j)-flat if the layer graph is a complete bipartite
	# graph, which is true iff it has diameter <= 2.
	return (Diameter(g) <= 2);
	end);

InstallMethod(IsFlat,
	[IsManiplex],
	M -> IsFlat(M, 0, Rank(M)-1));




##### SCHLAFLI SYMBOL #####

	
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
	gens := GeneratorsOfGroup(RotationGroup(M));
	n := Rank(M);
	sym := List(gens, x -> Order(x));
	if HasDual(M) then
		SetSchlafliSymbol(Dual(M), Reversed(sym));
	fi;
	return sym;
	end);
	
# This assumes that the connection group really does act on flags.
# It appears to work for IsManiplexQuotientRep too, but I'm not
# sure if I can guarantee that.
InstallMethod(SchlafliSymbol,
	[IsManiplex],
	function(M)
	local n, g, i, sym, gens, h, orbs, sections;
	
	if IsManiplexInstructionsRep(M) then
		sym := ComputeAttr(M, SchlafliSymbol);
		if sym <> fail then return sym; fi;
	fi;
	
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