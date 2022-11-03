# A note about the f-vector...
# For most polytopes, the f-vector starts out blank.
# Any time we compute the number of i-faces of a polytope, we store it
# in the internal f-vector.
# Eventually, if the user asks for the f-vector, we compute the number
# of i-faces for each i that hasn't already been computed.

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
	local fvector, i, n;
	fvector := ComputeAttr(M, Fvector);
	if fvector = fail then
		fvector := List([0..Rank(M)-1], i -> NumberOfIFaces(M,i));
	fi;
	
	return fvector;	
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

	if IsReflexible(M) and ValueOption("no_reindexing") <> true then
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
		if HasIsPolytopal(M) and IsPolytopal(M) and j-i = 3 and ValueOption("no_reindexing") <> true then
			return Pgon(Size(o)/2);
		fi;

		newgens := List(GeneratorsOfGroup(h), x -> RestrictedPerm(x, o));
		newconn := Group(newgens);
		
		if ValueOption("no_reindexing") <> true then
			# Retranslate the flags to be 1..N
			newconn := Action(newconn, MovedPoints(newconn));		
		fi;
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
	[IsManiplex, IsInt, IsInt],
	function(M, j, i)
	return Unique(List(FlagOrbitRepresentatives(M), k -> Section(M,j,i,k)));
	end);

#InstallMethod(SectionList,
#	[IsManiplex, IsInt, IsInt],
#	function(M, j, i)
#	local g, h;
#	g := ConnectionGroup(M);
#	h := Subgroup(g, GeneratorsOfGroup(g){[i+2..j]});
#	return Orbits...
#	end);


	
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
	local n, val;
	if IsManiplexInstructionsRep(M) then
		val := ComputeAttr(M, VertexFigures);
		if val <> fail then return val; fi;
	fi;
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

# THIS IS WRONG
InstallMethod(VertDegrees,
	[IsManiplex],
	function(M)
	local g, verts;
	
	g := Skeleton(M);
	verts := Vertices(g);
	return Collected(List(verts, v -> VertexDegree(g,v)));
	end);
	
InstallMethod(FaceSizes,
	[IsManiplex],
	function(M)
	local g, n, faces, mult, L;
	
	g := ConnectionGroup(M);
	n := Size(GeneratorsOfGroup(g));
	if n = 3 then
		faces := OrbitLengths(Subgroup(g, [g.1,g.2]));
	else
		mult := Size(Subgroup(g, GeneratorsOfGroup(g){[4..n]}));
		L := [1,2];
		Append(L, [4..n]);
		faces := OrbitLengths(Subgroup(g, GeneratorsOfGroup(g){L}));
		faces := List(faces, x -> x/mult);
	fi;
	faces := List(faces, x -> x/2);
	return Collected(faces);
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
	function(M)
	
	# Optimization from theory
	if Rank(M) = 3 and HasIsEquivelar(M) and IsEquivelar(M) and HasIsPolytopal(M) and IsPolytopal(M) then
		return IsTight(M);
	else
		return IsFlat(M, 0, Rank(M)-1);
	fi;
	end);



##### SCHLAFLI SYMBOL #####

InstallMethod(SchlafliSymbol,
	[IsManiplex],
	function(M)
	local schlafliSymbol, gens, g, i, h, orbs, sections;
	
	schlafliSymbol := ComputeAttr(M, SchlafliSymbol);
	if schlafliSymbol = fail then 
		if IsReflexible(M) then
			gens := GeneratorsOfGroup(AutomorphismGroup(M));
			schlafliSymbol := List([1..Rank(M)-1], i -> Order(gens[i]*gens[i+1]));
		elif IsRotaryManiplexRotGpRep(M) then
			gens := GeneratorsOfGroup(RotationGroup(M));
			schlafliSymbol := List(gens, Order);
		else
			schlafliSymbol := [];
			g := ConnectionGroup(M);
			gens := GeneratorsOfGroup(g);
			for i in [1..Rank(M)-1] do
				# Look at the orbits under <ri-1, ri>.
				# An orbit of size k indicates a (k/2)-gon section.
				h := Subgroup(g, [gens[i], gens[i+1]]);
				orbs := OrbitLengths(h);
				sections := Set(List(orbs, k -> k/2));
				if Size(sections) = 1 then
					Add(schlafliSymbol, sections[1]);
				else
					Add(schlafliSymbol, sections);
				fi;
			od;
		
		fi;
	fi;

	M!.PseudoSchlafliSymbol := schlafliSymbol;
	
	return schlafliSymbol;
	end);
	
# Some constructors will set the pseudo-Schlafli symbol
# of an object. Otherwise, we just compute the actual
# Schlafli symbol.
InstallMethod(PseudoSchlafliSymbol,
	[IsManiplex],
	function(M)
	return SchlafliSymbol(M);
	end);
	
InstallMethod(IsEquivelar,
	[IsManiplex],
	function(M)
	return ForAll(SchlafliSymbol(M), x -> IsInt(x));
	end);
	
# Every reflexible and rotary maniplex is equivelar
InstallTrueMethod(IsEquivelar, IsReflexible);
InstallTrueMethod(IsEquivelar, IsRotary);


InstallMethod(IsDegenerate,
	[IsManiplex],
	function(M)
	return (2 in Flat(SchlafliSymbol(M)));
	end);

InstallMethod(IsTight,
	[IsManiplex],
	function(M)
	local val;
	if not(IsEquivelar(M)) or not(IsPolytopal(M)) then
		Error("Tightness is only well-defined for equivelar polytopes.\n");
	fi;
	val := (Size(M) = 2*Product(SchlafliSymbol(M)));
	return val;
	end);
	
InstallMethod(EulerCharacteristic,
	[IsManiplex],
	function(M)
	local fv;
	if HasIsFinite(M) and not(IsFinite(M)) then
		return fail;
	else
		fv := List([0..Rank(M)-1], i -> NumberOfIFaces(M,i) * (-1)^i);
		return Sum(fv);
	fi;
	end);
	
InstallMethod(Genus,
	[IsManiplex],
	function(M)
	local char;
	if IsMapOnSurface(M)=false then 
# 	if Rank(M) <> 3 then
		Error("Genus is only defined for maniplexes of rank 3.");
	fi;
	char := EulerCharacteristic(M);
	if IsOrientable(M) then
		return (2-char)/2;
	else
		return 2-char;
	fi;
	end);
	
InstallMethod(IsSpherical,
	[IsManiplex],
	function(M)
	if Rank(M) <> 3 then
		Error("IsSpherical is only supported for maniplexes of rank 3.");
	fi;
	return EulerCharacteristic(M) = 2;
	end);
	
InstallMethod(IsLocallySpherical,
	[IsManiplex],
	function(M)
	return ForAll(Facets(M), IsSpherical) and ForAll(VertexFigures(M), IsSpherical);
	end);	
	
InstallMethod(IsToroidal,
	[IsManiplex],
	function(M)
	if Rank(M) <> 3 then
		Error("IsToroidal is only supported for maniplexes of rank 3.");
	fi;
	return EulerCharacteristic(M) = 0;
	end);
	
InstallMethod(IsLocallyToroidal,
	[IsManiplex],
	function(M)
	local facets, vfigs;
	facets := Facets(M);
	vfigs := VertexFigures(M);
	if not(ForAny(facets, IsToroidal)) and not(ForAny(vfigs, IsToroidal)) then
		return false;
	else
		return ForAll(facets, F -> IsSpherical(F) or IsToroidal(F)) and ForAll(vfigs, v -> IsSpherical(v) or IsToroidal(v));
	fi;
	end);	
	
	