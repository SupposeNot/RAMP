
WriteManiplexesToFile := function(maniplexes, filename, attributeNames)
	local databaseFile, M, attributes;
	databaseFile := OutputTextFile(Filename(RampDataPath, filename), false);

	WriteLine(databaseFile, JoinStringsWithSeparator(attributeNames));
	attributes := List(attributeNames, EvalString);
	for M in maniplexes do
		WriteLine(databaseFile, DatabaseString(M, attributes));
	od;

	CloseStream(databaseFile);
	end;

ManiplexesFromFile := function(filename)
	local databaseFile, maniplexes, maniplexString, attributeNames, attributes;
	databaseFile := InputTextFile(Filename(RampDataPath, filename));
	maniplexes := [];

	attributeNames := SplitString(ReadLine(databaseFile), ",");
	attributes := List(attributeNames, EvalString);
	maniplexString := ReadLine(databaseFile);
	repeat
		Add(maniplexes, ManiplexFromDatabaseString(maniplexString, attributes));
		maniplexString := ReadLine(databaseFile);
	until IsEndOfStream(databaseFile);

	CloseStream(databaseFile);
	return maniplexes;
	end;

BindGlobal("MINSIZE_FROM_SIZERANGE",
	function(sizerange)
	if IsInt(sizerange) then return 1;
	elif IsEmpty(sizerange) then return 0;
	else return First(sizerange);
	fi;
	end);
	
BindGlobal("MAXSIZE_FROM_SIZERANGE",
	function(sizerange)
	if IsInt(sizerange) then return sizerange;
	elif IsEmpty(sizerange) then return 0;
	else return Last(sizerange);
	fi;
	end);

InstallGlobalFunction(DegeneratePolyhedra,
	function(sizerange)
	local polys, k, p, minsize, maxsize;

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	polys := [];
	if minsize <= 8 and maxsize >= 8 then
		Add(polys, AbstractRegularPolytopeNC([2,2]));
	fi;

	k := 3;
	while 4*k <= maxsize do
		if 4*k >= minsize then
			Add(polys, AbstractRegularPolytopeNC([2,k]));
			Add(polys, AbstractRegularPolytopeNC([k,2]));
		fi;
		k := k + 1;
	od;
	return polys;
	end);

InstallGlobalFunction(FlatRegularPolyhedra,
	function(sizerange)
	local polys, p, q, k, r, poly, D, rampPath, filename, stream, params, flatpolystr, minsize, maxsize;
	polys := [];

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	if maxsize > 4000 then
		Info(InfoRamp, 1, "The list of flat regular polyhedra with more than 4000 flags is incomplete.");
	fi;

	
	# If p and q are even, then FlatRegularPolyhedron(p, q, -1, 1) works.
	# (from Minimal Equivelar Polytopes Thm. 6.3)

	# we restrict q <= p
	# So for a given p, the largest we make is size 2p^2
	# so we want 2p^2 >= minsize
	# p^2 >= minsize/2
	# p >= sqrt(minsize/2)
	p := Maximum(4, RootInt(Int(minsize/2)));
	if not(IsEvenInt(p)) then p := p + 1; fi;
	
	while 8*p <= maxsize do
		# 2pq >= minsize
		# q >= minsize/2p
		# and q must be even...
		# set q/2 = Int(minsize/(4*p))
		q := Maximum(4, 2 * (1 + Int((minsize-1)/(4*p))));
		while q <= p and 2*p*q <= maxsize do
			Add(polys, FlatOrientablyRegularPolyhedronNC(p,q,-1,1));
			if q <> p then
				Add(polys, FlatOrientablyRegularPolyhedronNC(q,p,-1,1));
			fi;
			q := q + 2;
		od;
		p := p + 2;
	od;
	
	# Now populate p odd, q even div of 2p, (p, q, -1, -3) and the dual (q, p, 3, 1).
	# This always works; see Tight Orientably Regular Polytopes Thm. 3.1.
	p := 3;
	while 12*p <= maxsize do
		for q in Filtered(DivisorsInt(2*p), n -> IsEvenInt(n) and n > 2) do
			if 2*p*q <= maxsize and minsize <= 2*p*q then
				Add(polys, FlatOrientablyRegularPolyhedronNC(p, q, -1, -3));
				Add(polys, FlatOrientablyRegularPolyhedronNC(q, p, 3, 1));
			fi;
		od;
		p := p + 2;
	od;

	# Nonorientable tight polyhedra
	# Let Delta(p, q)_ijab = [p,q] / (s2^-1 s1 = s1^i r1 s2^j, s2^-2 s1 = s1^a s2^b).
	# Then Theorems 5.8-5.10 in Classification of Tight Regular Polyhedra establish that 
	# the tight nonorientably regular polyhedra have groups:
	# Delta(4, 3k)_(2, 1, 3, 2)
	# Delta(4, 6k)_(2, 1+3k/2, 3, 2)
	# Delta(4r, 6k)_(i, 1+3k, 1+2r, 2), where r > 1 odd, k odd, and where
	# 	i = r-1 if r = 3 (mod 4) and i = 3r-1 if r = 1 (mod 4).
	# and the duals of these.

	D := function(p,q,i,j,a,b)
		local w, relstr, poly;
		w := UniversalSggi(3);
		relstr := Concatenation("r2 r1 r0 r1 = (r0 r1)^", String(i), " r1 (r1 r2)^", String(j), ", r2 r1 r2 r1 r0 r1 = (r0 r1)^", String(a), " (r1 r2)^", String(b));
		poly := AbstractRegularPolytopeNC([p,q], relstr);
		SetSize(poly, 2*p*q);
		SetSize(AutomorphismGroup(poly), 2*p*q);
		SetSchlafliSymbol(poly, [p,q]);
		return poly;
		end;

	k := 1 + Int((minsize-1)/24);
	while 24*k <= maxsize do
		poly := D(4, 3*k, 2, 1, 3, 2);
		Add(polys, poly);
		Add(polys, Dual(poly));
		if IsEvenInt(k) then
			poly := D(4, 3*k, 2, 1+3*k/2, 3, 2);
			Add(polys, poly);
			Add(polys, Dual(poly));
		fi;
		k := k + 1;
	od;
	
	k := 1;
	while 48*k <= maxsize do
		r := Maximum(3, 1 + Int((minsize-1)/(48*k)));
		# 48rk >= minsize
		# r >= minsize/(48*k)
		# r := 1 + Int((minsize-1)/(48*k));
		while 48*r*k <= maxsize do
			if (r mod 4) = 1 then
				poly := D(4*r, 6*k, 3*r-1, 1+3*k, 1+2*r, 2);
			else
				poly := D(4*r, 6*k, r-1, 1+3*k, 1+2*r, 2);
			fi;
			Add(polys, poly);
			Add(polys, Dual(poly));
			r := r + 2;
		od;
		k := k + 2;
	od;

	# Grab the rest from a file.
	# In principle, we know all of the flat regular polyhedra of a given type from theory.
	# But I'm too lazy to code it right now, so we read from a file.
	# rampPath := DirectoriesLibrary("pkg/ramp/lib");
	filename := Filename(RampDataPath, "flatRegularPolyhedra.txt");
	stream := InputTextFile(filename);
	
	params := ReadLine(stream);
	while params <> fail do
		flatpolystr := Concatenation("FlatOrientablyRegularPolyhedronNC(", params, ")");
		poly := EvalString(flatpolystr);
		if Size(poly) <= maxsize then
			if Size(poly) >= minsize then Add(polys, poly); fi;
		else
			break;
		fi;
		params := ReadLine(stream);
	od;
	
	if ValueOption("nondegenerate") <> true then
		Append(polys, DegeneratePolyhedra(sizerange));
	fi;

	SortBy(polys, Size);

	return polys;
	end);

InstallGlobalFunction(RegularToroidalPolyhedra44,
	function(sizerange)
	local polys, minsize, maxsize, t, p;
	polys := [];

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);
	
	# ARP([4,4], "h2^t") is {4,4}_(t,0), with 8t^2 flags.
	# ARP([4,4], "z1^2t") is {4,4}_(t,t), with 16t^2 flags.
	t := 2;
	while 8*t^2 <= maxsize do
		if 8*t^2 >= minsize then
			Add(polys, ARP([4,4], Concatenation("(r0 r1 r2 r1)^", String(t))));
		fi;
		if 16*t^2 >= minsize and 16*t^2 <= maxsize then
			Add(polys, ARP([4,4], Concatenation("(r0 r1 r2)^", String(2*t))));
		fi;
		t := t + 1;
	od;
	
	return polys;
	end);

InstallGlobalFunction(RegularToroidalPolyhedra36,
	function(sizerange)
	local polys, minsize, maxsize, t, p;
	polys := [];

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	# The smallest polyhedron of type {3, 6} has 36 flags.
	minsize := Maximum(36, minsize);
	
	# ARP([3,6], "z1^2t") is {3,6}_(t,0) with t^2 vertices and 12t^2 flags.
	# ARP([3,6], "z2^2t") is {3,6}_(t,t) with 3t^2 vertices and 36t^2 flags.
	t := 1;
	while 12*t^2 <= maxsize do
		if 12*t^2 >= minsize then
			Add(polys, ARP([3,6], Concatenation("(r0 r1 r2)^", String(2*t))));
		fi;
		if 36*t^2 >= minsize and 36*t^2 <= maxsize then
			Add(polys, ARP([3,6], Concatenation("(r0 r1 r2 r1 r2)^", String(2*t))));
		fi;
		t := t + 1;
	od;
	
	SortBy(polys, Size);
	
	return polys;
	end);

InstallGlobalFunction(SmallRegularPolyhedraFromFile,
	function(sizerange)
	local polys, stream, desc, params, paramlist, sym, petrie, flagnum, rels, p, paramstr, toobig, minsize, maxsize, toruspolys;
	stream := InputTextFile(Filename(RampDataPath, "regularPolyhedra.txt"));

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);
	polys := [];

	toobig := false;
	paramstr := ReadLine(stream);
	while not(toobig) and not(IsEndOfStream(stream)) do
		params := EvalString(Concatenation("[", paramstr, "]"));
		
		sym := params[1];
		petrie := params[2];
		flagnum := params[3];
		rels := params[4][1];
		
		if flagnum > maxsize then
			toobig := true;
		elif flagnum >= minsize then
			p := AbstractRegularPolytopeNC(sym, rels);
			SetSize(p, flagnum);
			SetSize(AutomorphismGroup(p), flagnum);
			SetPetrieLength(p, petrie);
			SetSchlafliSymbol(p, sym);
			Add(polys, p);
		fi;

		paramstr := ReadLine(stream);
	od;

	CloseStream(stream);
	return polys;
	end);

InstallGlobalFunction(SmallRegularPolyhedra,
	function(sizerange)
	local polys, stream, desc, params, paramlist, sym, petrie, flagnum, rels, p, paramstr, toobig, minsize, maxsize, toruspolys;
	stream := InputTextFile(Filename(RampDataPath, "regularPolyhedra.txt"));

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	polys := [];
	toobig := false;
	
	if maxsize > 4000 then
		Info(InfoRamp, 1, "The list of small regular polyhedra with more than 4000 flags is incomplete.");
	fi;
	
	# Note that all degenerate polyhedra are also flat. So if the "nondegenerate" option is set, that
	# is automatically passed to and handled by FlatRegularPolyhedra.
	if ValueOption("nonflat") <> true then
		Append(polys, FlatRegularPolyhedra(sizerange));
	fi;
	
	# The smallest polyhedron of type {4,4} is flat, and so already included or excluded
	# by the above. So we nudge the sizerange up a bit.
	toruspolys := Flat(List(RegularToroidalPolyhedra44([Maximum(33, minsize)..maxsize]), DirectDerivates));
	for p in toruspolys do
		SetIsPolytopal(p, true);
		p!.String := ReplacedString(p!.String, "ReflexibleManiplex", "AbstractRegularPolytope");
	od;
	Append(polys, toruspolys);
	
	# The smallest polyhedron of type {3,6} is flat, and so already included or excluded
	# by the above. Also, the next-smallest one has the cube and octahedron among its direct derivates,
	# and we want to handle those separately. So we nudge the sizerange up a bit.
	toruspolys := Flat(List(RegularToroidalPolyhedra36([Maximum(49, minsize)..maxsize]), DirectDerivates));
	toruspolys := Filtered(toruspolys, p -> not(IsTight(p)));
	for p in toruspolys do
		SetIsPolytopal(p, true);
		p!.String := ReplacedString(p!.String, "ReflexibleManiplex", "AbstractRegularPolytope");
	od;
	Append(polys, toruspolys);
	
	Append(polys, SmallRegularPolyhedraFromFile(sizerange));

	SortBy(polys, p -> Size(p));
	
	if ValueOption("nontoroidal") = true then
		polys := Filtered(polys, p -> not(SchlafliSymbol(p) in [[3,6],[6,3],[4,4]]));
	fi;
	
	return polys;
	end);


InstallGlobalFunction(SmallDegenerateRegular4Polytopes,
	function(sizerange)
	local minsize, maxsize, maniplexes, p, q, r, polyhedra, extensions;

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	if maxsize > 8000 then
		Info(InfoRamp, 1, "The list of small degenerate regular 4-polytopes with more than 8000 flags is incomplete.");
	fi;
	
	maniplexes := [];

	# First we add all polytopes of type [p, 2, r], with size 4pr
	for p in [3..Int(maxsize/8)] do
		if 4*p^2 > maxsize then break; fi;
		if 4*p^2 >= minsize then Add(maniplexes, ARP([p,2,p])); fi;
		for r in [p+1..Int(maxsize/(4*p))] do
			if minsize <= 4*p*r and 4*p*r <= maxsize then
				Add(maniplexes, ARP([p,2,r]));
				Add(maniplexes, ARP([r,2,p]));
			fi;
		od;
	od;

	# Add ones of type [2, q, 2]
	for q in [3..Int(maxsize/8)] do
		if 8*q >= minsize then Add(maniplexes, ARP([2,q,2])); fi;
	od;
	
	# Now we add trivial extensions of all small nondegenerate regular polyhedra, and their duals
	polyhedra := SmallRegularPolyhedra([Int((minsize+1)/2)..Int(maxsize/2)] : nondegenerate);
	extensions := List(polyhedra, TrivialExtension);
	Append(maniplexes, extensions);
	Append(maniplexes, List(extensions, Dual));
	
	return maniplexes;
	end);


InstallGlobalFunction(SmallRegular4Polytopes,
	function(sizerange)
	local databaseFile, minsize, maxsize, maniplexes, maniplexString, maniplex, attributeNames, attributes;

	databaseFile := InputTextFile(Filename(RampDataPath, "Regular4PolytopesUpTo4000.txt"));

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	if maxsize > 4000 then
		Info(InfoRamp, 1, "The list of small regular 4-polytopes with more than 4000 flags is incomplete.");
	fi;
	
	maniplexes := [];

	attributeNames := SplitString(ReadLine(databaseFile), ",");
	attributes := List(attributeNames, EvalString);
	maniplexString := ReadLine(databaseFile);
	repeat
		maniplex := ManiplexFromDatabaseString(maniplexString, attributes);
		SetSchlafliSymbol(maniplex, PseudoSchlafliSymbol(maniplex));
		if Size(maniplex) > maxsize then
			break;
		elif Size(maniplex) >= minsize then
			Add(maniplexes, maniplex);
		fi;
		maniplexString := ReadLine(databaseFile);
	until IsEndOfStream(databaseFile);

	CloseStream(databaseFile);

	if ValueOption("nondegenerate") <> true then
		Append(maniplexes, SmallDegenerateRegular4Polytopes([minsize..maxsize]));
	fi;
	
	SortBy(maniplexes, Size);

	return maniplexes;
	end);

InstallGlobalFunction(ReadChiralPolytopesFromFile,
	function(sizerange, filename)
	local databaseFile, minsize, maxsize, maniplexes, maniplexString, maniplex;

	databaseFile := InputTextFile(Filename(RampDataPath, filename));

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	if maxsize > 4000 then
		Info(InfoRamp, 1, "The list of small chiral polytopes with more than 4000 flags is incomplete.");
	fi;

	maniplexes := [];

	maniplexString := ReadLine(databaseFile);
	repeat
		maniplex := ManiplexFromDatabaseString(maniplexString);
		SetSchlafliSymbol(maniplex, PseudoSchlafliSymbol(maniplex));
		SetIsChiral(maniplex, true);
		if Size(maniplex) > maxsize then
			break;
		elif Size(maniplex) >= minsize then
			Add(maniplexes, maniplex);
		fi;
		maniplexString := ReadLine(databaseFile);
	until IsEndOfStream(databaseFile);

	CloseStream(databaseFile);
	
	return maniplexes;
	end);

InstallGlobalFunction(SmallChiralPolyhedra,
	function(sizerange)
	return ReadChiralPolytopesFromFile(sizerange, "ChiralPolyhedraUpTo4000.txt");
	end);


InstallGlobalFunction(SmallChiral4Polytopes,
	function(sizerange)
	return ReadChiralPolytopesFromFile(sizerange, "Chiral4PolytopesUpTo4000.txt");
	end);

InstallGlobalFunction(SmallReflexible3Maniplexes,
	function(sizerange)
	local manis, minsize, maxsize, L, wilsons, k, l, M, BMaps;
	
	manis := [];

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	if maxsize > 2000 then
		Info(InfoRamp, 1, "The list of reflexible maniplexes with more than 2000 flags is incomplete.");
	fi;
	
	# Get the polyhedra unless nonpolytopal option is set
	if ValueOption("nonpolytopal") <> true then
		Append(manis, SmallRegularPolyhedra(sizerange));
	fi;
	
	# Get the Steve Wilson maps
	wilsons := [];
	
	#Deltak, Mk, and MkPrime are all size 4k
	for k in [1..Int(maxsize/4)] do
		if 4*k >= minsize then
			M := Deltak(k);
			if k > 1 then
				Append(wilsons, [M, Dual(M)]); 
				Add(wilsons, Mk(k));
			else
				Add(wilsons, M); #Deltak(1) is self-dual
				# Mk(1) is a pre-maniplex only, so we skip it
			fi;
			
			if k > 2 then
				# MkPrime(1) is not a maniplex
				# MkPrime(2) = ARP([2,2]), which will be included elsewhere
				Add(wilsons, MkPrime(k));
			fi;
		fi;
	od;
	
	# BMaps := [];
	# According to Steve's paper, these are all equal to maps in other classes (Mk etc):
	# Bk2l(k,1) k even
	# Bk2lStar(k,1) k odd
	# Bk2lStar(1,l)
	# Bk2l(2,l)
	# Bk2lStar(2,l) l even. This is MkPrime(2l,l+1) which I am currently not building - maybe I should.
	# So... 
	# 1. Don't want k = 1 in Bk2lStar. (Can't have it in Bk2l anyway). So start at k = 2.
	# 2. Don't want k = 2 in Bk2l
	# 4. Don't want l = 1 in either	
	#for k in [2..Int(maxsize/4)] do
	#	for l in [2..Int(maxsize/(4*k))] do
	#		if 4*k*l >= minsize then
	#			if IsEvenInt(k) then
	#				if k > 2 then
	#					Append(BMaps, Unique([Bk2l(k,l), Dual(Bk2l(k,l))]));
	#				fi;
	#				if IsEvenInt(l) and (k > 2 or l > 2) then # Bk2lStar(2,2) = ARP([4,2])
	#					Append(BMaps, Unique([Bk2lStar(k,l), Dual(Bk2lStar(k,l))]));
	#				fi;
	#			elif IsOddInt(l) then
	#				Append(BMaps, Unique([Bk2lStar(k,l), Dual(Bk2lStar(k,l))]));
	#			fi;
	#		fi;
	#	od;
	#od;

	# Later I should try to be cleverer about preventing duplicates, because this can take a lot of time
	#Append(wilsons, Filtered(BMaps, M -> not(IsPolytopal(M))));
	# We force computation of Schlafli Symbols here to speed up isomorphism testing
	# for M in wilsons do
	#	SchlafliSymbol(M);
	# od;
	# Append(manis, Unique(wilsons));
	
	Append(manis, wilsons);

	# Get the rest from a file
	L := ManiplexesFromFile("Reflexible3ManiplexesNonPolytopal.txt");
	Append(manis, Filtered(L, M -> minsize <= Size(M) and Size(M) <= maxsize));
	
	return manis;
	end);
	
InstallGlobalFunction(SRP,
	function(minsize, maxsize, arg...)
	local L, i;
	L := SmallRegularPolyhedra([minsize, maxsize]);
	for i in [1..Size(arg)/2] do
		L := Filtered(L, x -> arg[2*i-1](x) = arg[2*i]);
	od;
	return L;
	end);

#! @Arguments I, sizerange
#! @Returns IsList
#! @Description Gives all two-orbit 3-maniplexes in class $2_I$ with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 1000 or less.
InstallGlobalFunction(SmallTwoOrbit3Maniplexes,
	function(class, sizerange)
	local databaseFile, minsize, maxsize, maniplexes, maniplexString, maniplex, filename, attributeNames, attributes;

	if class = [0] then
		filename := "Rank3AG_2_0.txt";
	else
		Error("No data available for that class");
	fi;

	databaseFile := InputTextFile(Filename(RampDataPath, filename));

	minsize := MINSIZE_FROM_SIZERANGE(sizerange);
	maxsize := MAXSIZE_FROM_SIZERANGE(sizerange);

	maniplexes := [];
	
	attributeNames := SplitString(ReadLine(databaseFile), ",");
	attributes := List(attributeNames, EvalString);
	maniplexString := ReadLine(databaseFile);
	repeat
		maniplex := ManiplexFromDatabaseString(maniplexString, attributes);
		SetSchlafliSymbol(maniplex, PseudoSchlafliSymbol(maniplex));
		if Size(maniplex) > maxsize then
			break;
		elif Size(maniplex) >= minsize then
			Add(maniplexes, maniplex);
		fi;
		maniplexString := ReadLine(databaseFile);
	until IsEndOfStream(databaseFile);

	CloseStream(databaseFile);
	
	return maniplexes;
	end);
