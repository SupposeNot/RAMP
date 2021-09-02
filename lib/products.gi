
InstallMethod(PyramidOver,
	[IsManiplex],
	function(p)
	local n, pyr;
	n := Rank(p);

	if n = 0 then
		return UniversalPolytope(1);
	elif n = 1 then
		return Pgon(3);
	elif p = Simplex(n) then
		return Simplex(n+1);
	fi;

	pyr := Maniplex(PyramidOver, [p]);
	pyr!.base := p;

	SetRankManiplex(pyr, n+1);
	if n = 2 and IsEvenInt(Size(p)) and Size(p) >= 4 and p = Pgon(Size(p)/2) then
		SetString(pyr, Concatenation("Pyramid(", String(Size(p)/2), ")"));
	else
		SetString(pyr, Concatenation("PyramidOver(", String(p), ")"));	
	fi;

	AddAttrComputer(pyr, Size, M -> Size(M!.base) * (1+Rank(M)) : prereqs := [Size, RankManiplex]);
	AddAttrComputer(pyr, IsPolytopal, M -> IsPolytopal(M!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(pyr, ConnectionGroup, 
		function(M)
		local flagNum, perms, s, t, r_t, i, j, k, thisFlag, nextFlag, conn;
		
		# The number of flags in the pyramid over P, where P is an n-polytope with k flags,
		# is (n+2)*k. These flags naturally occur in n+2 "layers" in the pyramid.
		# We will use j as the layer number (from -1 to n) and i as the flag number
		# within that layer. (In the view of a pyramid as a product, j records when we
		# increment the second flag instead of the first one.)
		# This function lets us translate from this logical division of flags to a
		# flag number from 1 to (n+2)*k.
		flagNum := function(i, j)
			return (i-1)*(n+2) + j+2;
			end;
		perms := [];
		conn := ConnectionGroup(M!.base);
		k := Size(M!.base);
		
		for t in [0..n] do
			r_t := ();
			
			# We go through every flag and see where r_t should send it, building r_t as we go.
			for i in [1..k] do
				for j in [-1..n] do
					thisFlag := flagNum(i,j);
					if (thisFlag^r_t = thisFlag) then
						# We haven't matched thisFlag yet.
						# What flag is t-adjacent to (i, j)?
						if (t < j) then
							s := GeneratorsOfGroup(conn)[t+1];
							nextFlag := flagNum(i^s,j);
						elif (t = j) then
							nextFlag := flagNum(i, j-1);
						elif (t = j+1) then
							nextFlag := flagNum(i, j+1);
						else
							s := GeneratorsOfGroup(conn)[t];
							nextFlag := flagNum(i^s,j);
						fi;
						r_t := r_t * (thisFlag, nextFlag);
					fi;
				od;
			od;
			perms[t+1] := r_t;	# Indices are off by one because GAP lists are 1-indexed.
		od;
		return Group(perms);
		end :
		prereqs := [ConnectionGroup]);

	AddAttrComputer(pyr, Facets, 
		function(M)
		local facs;
		facs := List(Facets(M!.base), F -> PyramidOver(F));
		Add(facs, M!.base);
		return Unique(facs);
		end :
		prereqs := [Facets]);
		
	AddAttrComputer(pyr, VertexFigures, 
		function(M)
		local vfigs;
		vfigs := List(VertexFigures(M!.base), F -> PyramidOver(F));
		Add(vfigs, M!.base);
		return Unique(vfigs);
		end :
		prereqs := [VertexFigures]);
		
	return pyr;
	end);

InstallMethod(Pyramid,
	[IsInt],
	k -> PyramidOver(Pgon(k)));

InstallMethod(PrismOver,
	[IsManiplex],
	function(p)
	local n, prism;
	n := Rank(p);

	if n = 0 then
		return UniversalPolytope(1);
	elif n = 1 then
		return Pgon(4);
	elif p = Cube(n) then
		return Cube(n+1);
	fi;

	prism := Maniplex(PrismOver, [p]);
	prism!.base := p;

	SetRankManiplex(prism, n+1);
	if n = 2 and IsEvenInt(Size(p)) and Size(p) >= 4 and p = Pgon(Size(p)/2) then
		SetString(prism, Concatenation("Prism(", String(Size(p)/2), ")"));
	else
		SetString(prism, Concatenation("PrismOver(", String(p), ")"));	
	fi;

	AddAttrComputer(prism, Size, M -> 2 * Size(M!.base) * Rank(M) : prereqs := [Size, RankManiplex]);
	AddAttrComputer(prism, IsPolytopal, M -> IsPolytopal(M!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(prism, ConnectionGroup,
		function(M)
		local n, k, flagNum, i, t, r_t, d, thisFlag, perm, perms, conn, s, q;
		conn := ConnectionGroup(M!.base);
		n := Rank(M!.base);
		k := Size(M!.base);
		flagNum := function(i, j, d, k)
			return i + j*k + (d-1)*2*k;
			end;
		perms := [];
		for t in [0..n] do
			r_t := ();
			for i in [1..k] do
				for d in [1..n+1] do
					thisFlag := flagNum(i, 0, d, k);
					# Only add a new perm if thisFlag isn't already matched
					if (thisFlag^(r_t) = thisFlag) then
						if (t < d-1) then
							s := GeneratorsOfGroup(conn)[t+1];
							r_t := r_t * (flagNum(i,0,d,k), flagNum(i^s, 0, d, k));
							r_t := r_t * (flagNum(i,1,d,k), flagNum(i^s, 1, d, k));
						fi;
						if (t > d) then
							s := GeneratorsOfGroup(conn)[t];
							r_t := r_t * (flagNum(i,0,d,k), flagNum(i^s, 0, d, k));
							r_t := r_t * (flagNum(i,1,d,k), flagNum(i^s, 1, d, k));
						fi;
						if (t = d-1 and t = 0) then
							r_t := r_t * (flagNum(i,0,d,k), flagNum(i,1,d,k));
						fi;
						if (t = d-1 and t > 0) then
							r_t := r_t * (flagNum(i,0,d,k), flagNum(i,0,d-1,k));
							r_t := r_t * (flagNum(i,1,d,k), flagNum(i,1,d-1,k));
						fi;
					fi;
				od;
			od;
			perms[t+1] := r_t;
		od;
		return Group(perms);
		end :
		prereqs := [ConnectionGroup]);

	AddAttrComputer(prism, Facets, 
		function(M)
		local facs;
		facs := List(Facets(M!.base), F -> PrismOver(F));
		Add(facs, M!.base);
		return Unique(facs);
		end :
		prereqs := [Facets]);

	AddAttrComputer(prism, VertexFigures, M -> List(VertexFigures(M!.base), F -> PyramidOver(F)) : prereqs := [VertexFigures]);
	
	return prism;
	end);
	
InstallMethod(Prism,
	[IsInt],
	k -> PrismOver(Pgon(k)));


InstallMethod(Antiprism,
	[IsManiplex],
	function(M)
	local n, antiprism;
	n := Rank(M);

	antiprism := Maniplex(Antiprism, [M]);
	antiprism!.base := M;

	SetRankManiplex(antiprism, n+1);
	SetString(antiprism, Concatenation("Antiprism(", String(M), ")"));

	AddAttrComputer(antiprism, ConnectionGroup,
		function(p)
		return ConnectionGroup(Antiprism(PosetFromManiplex(p!.base)));
		end);
		
	AddAttrComputer(antiprism, IsPolytopal, M -> IsPolytopal(M!.base) : prereqs := [IsPolytopal]);
	AddAttrComputer(antiprism, Size, M -> Size(M!.base) * 2^(Rank(M)) : prereqs := [Size, RankManiplex]);
	
	return antiprism;
	end);

InstallMethod(Antiprism,
	[IsInt],
	k -> Antiprism(Pgon(k)));

InstallMethod(JoinProduct,
	[IsManiplex, IsManiplex],
	function(M1, M2)
	local n, prod;
	n := Rank(M1) + Rank(M2) + 1;

	prod := Maniplex(JoinProduct, [M1, M2]);
	prod!.bases := [M1, M2];

	SetRankManiplex(prod, n);
	SetString(prod, Concatenation("JoinProduct(", String(M1), ", ", String(M2), ")"));

	AddAttrComputer(prod, ConnectionGroup,
		function(p)
		return ConnectionGroup(JoinProduct(PosetFromManiplex(p!.bases[1]), PosetFromManiplex(p!.bases[2])));
		end);
		
	return prod;
	end);

InstallMethod(CartesianProduct,
	[IsManiplex, IsManiplex],
	function(M1, M2)
	local n, prod;
	n := Rank(M1) + Rank(M2);

	prod := Maniplex(CartesianProduct, [M1, M2]);
	prod!.bases := [M1, M2];

	SetRankManiplex(prod, n);
	SetString(prod, Concatenation("CartesianProduct(", String(M1), ", ", String(M2), ")"));

	AddAttrComputer(prod, ConnectionGroup,
		function(p)
		return ConnectionGroup(CartesianProduct(PosetFromManiplex(p!.bases[1]), PosetFromManiplex(p!.bases[2])));
		end);
		
	return prod;
	end);

InstallMethod(DirectSumOfManiplexes,
	[IsManiplex, IsManiplex],
	function(M1, M2)
	local n, prod;
	n := Rank(M1) + Rank(M2);

	prod := Maniplex(DirectSum, [M1, M2]);
	prod!.bases := [M1, M2];

	SetRankManiplex(prod, n);
	SetString(prod, Concatenation("DirectSum(", String(M1), ", ", String(M2), ")"));

	AddAttrComputer(prod, ConnectionGroup,
		function(p)
		return ConnectionGroup(DirectSumOfPosets(PosetFromManiplex(p!.bases[1]), PosetFromManiplex(p!.bases[2])));
		end);
		
	return prod;
	end);

InstallMethod(TopologicalProduct,
	[IsManiplex, IsManiplex],
	function(M1, M2)
	local n, prod;
	n := Rank(M1) + Rank(M2) - 1;

	prod := Maniplex(TopologicalProduct, [M1, M2]);
	prod!.bases := [M1, M2];

	SetRankManiplex(prod, n);
	SetString(prod, Concatenation("TopologicalProduct(", String(M1), ", ", String(M2), ")"));

	AddAttrComputer(prod, ConnectionGroup,
		function(p)
		return ConnectionGroup(TopologicalProduct(PosetFromManiplex(p!.bases[1]), PosetFromManiplex(p!.bases[2])));
		end);
		
	return prod;
	end);
