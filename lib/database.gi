
# I used this at some point to save some polytopes to a file.
# Keeping it here in case we want to crib off it later.
# SavePolytopes := function(polys, filename)
#	local stream, i, j, p, F, rels, datastring, id, flats, sym, g, s1, s2, nonflats, pd, pp, invars, duals, done, pdp, ppd, pdpd;
#	stream := OutputTextFile(filename, false);
#
#	for p in polys5 do
#		WriteAll(stream, String(SchlafliSymbol(p)));
#		WriteAll(stream, ", ");
#		WriteAll(stream, String(PetrieLength(p)));
#		WriteAll(stream, ", ");
#		WriteAll(stream, String(Size(p)));
#		WriteAll(stream, ", ");
#		rels := List(ExtraRelators(p), r -> String(r));
#		WriteAll(stream, String(rels));
#		if IsSelfDual(p) then
#			WriteAll(stream, ", SD");
#		else
#			WriteAll(stream, ", NSD");
#		fi;
#		if SchlafliSymbol(p)[2] = PetrieLength(p) and p = Dual(Petrial(Dual(p))) then
#			WriteAll(stream, ", SO");
#		else
#			WriteAll(stream, ", NSO");
#		fi;
#		
#		WriteAll(stream, "\n");
#		# And write some other stuff
#	od;
#
#	CloseStream(stream);
#	end;

InstallGlobalFunction(DegeneratePolyhedra,
	function(sizerange)
	local polys, k, p, minsize, maxsize;

	if IsInt(sizerange) then
		minsize := 1;
		maxsize := sizerange;
	else
		minsize := sizerange[1];
		maxsize := Last(sizerange);
	fi;

	polys := [];
	if minsize <= 8 and maxsize >= 8 then
		p := AbstractRegularPolytope([2,2]);
		SetSize(p, 8);
		Add(polys, p);
	fi;
	if minsize > 12 then
		k := Int((minsize+3)/4);
	else
		k := 3;
	fi;
	
	while 4*k <= maxsize do
		p := AbstractRegularPolytope([2,k]);
		SetSize(p, 4*k);
		Add(polys, p);
		
		p := AbstractRegularPolytope([k,2]);
		SetSize(p, 4*k);
		Add(polys, p);
		k := k + 1;
	od;
	return polys;
	end);

InstallGlobalFunction(FlatRegularPolyhedra,
	function(sizerange)
	local polys, p, q, k, r, poly, D, rampPath, filename, stream, params, flatpolystr, minsize, maxsize;
	polys := [];

	if IsInt(sizerange) then
		minsize := 1;
		maxsize := sizerange;
	elif IsEmpty(sizerange) then
		return [];
	else
		minsize := sizerange[1];
		maxsize := Last(sizerange);
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
			Add(polys, FlatRegularPolyhedron(p,q,-1,1));
			if q <> p then
				Add(polys, FlatRegularPolyhedron(q,p,-1,1));
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
				Add(polys, FlatRegularPolyhedron(p, q, -1, -3));
				Add(polys, FlatRegularPolyhedron(q, p, 3, 1));
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
		poly := AbstractRegularPolytope([p,q], relstr);
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
	rampPath := DirectoriesLibrary("pkg/ramp/lib");
	filename := Filename(rampPath, "flatRegularPolyhedra.txt");
	stream := InputTextFile(filename);
	
	params := ReadLine(stream);
	while params <> fail do
		flatpolystr := Concatenation("FlatRegularPolyhedron(", params, ")");
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

	return polys;
	end);

InstallGlobalFunction(RegularToroidalPolyhedra44,
	function(sizerange)
	local polys, minsize, maxsize, t, p;
	polys := [];

	if IsInt(sizerange) then
		minsize := 1;
		maxsize := sizerange;
	elif IsEmpty(sizerange) then
		return [];
	else
		minsize := sizerange[1];
		maxsize := Last(sizerange);
	fi;
	
	# ARP([4,4], "h2^t") is {4,4}_(t,0), with 8t^2 flags.
	# ARP([4,4], "z1^2t") is {4,4}_(t,t), with 16t^2 flags.
	t := 2;
	while 8*t^2 <= maxsize do
		if 8*t^2 >= minsize then
			Add(polys, ARP([4,4], Concatenation("h2^", String(t))));
		fi;
		if 16*t^2 >= minsize and 16*t^2 <= maxsize then
			Add(polys, ARP([4,4], Concatenation("z1^", String(2*t))));
		fi;
		t := t + 1;
	od;
	
	return polys;
	end);

InstallGlobalFunction(RegularToroidalPolyhedra36,
	function(sizerange)
	local polys, minsize, maxsize, t, p;
	polys := [];

	if IsInt(sizerange) then
		minsize := 1;
		maxsize := sizerange;
	elif IsEmpty(sizerange) then
		return [];
	else
		minsize := sizerange[1];
		maxsize := Last(sizerange);
	fi;

	# The smallest polyhedron of type {3, 6} has 36 flags.
	minsize := Maximum(36, minsize);
	
	# ARP([3,6], "z1^2t") is {3,6}_(t,0) with t^2 vertices and 12t^2 flags.
	# ARP([3,6], "z2^2t") is {3,6}_(t,t) with 3t^2 vertices and 36t^2 flags.
	t := 1;
	while 12*t^2 <= maxsize do
		if 12*t^2 >= minsize then
			Add(polys, ARP([3,6], Concatenation("z1^", String(2*t))));
		fi;
		if 36*t^2 >= minsize and 36*t^2 <= maxsize then
			Add(polys, ARP([3,6], Concatenation("z2^", String(2*t))));
		fi;
		t := t + 1;
	od;
	
	SortBy(polys, Size);
	
	return polys;
	end);

# Keeping this here for now in case I need to crib off of it later
# Rewrite := function()
#	local p, q, i, j, f1, f2, rampPath, filename, desc, paramstr, params, sym, petrie, flagnum, rels;
#	rampPath := DirectoriesLibrary("pkg/ramp/lib");
#	filename := Filename(rampPath, "regularPolyhedra.txt");
#	f1 := InputTextFile(filename);
#	f2 := OutputTextFile(Filename(rampPath, "regularPolyhedra2.txt"), false);
#
#	paramstr := ReadLine(f1);
#	while not(IsEndOfStream(f1)) do
#		params := EvalString(Concatenation("[", paramstr, "]"));
#		
#		sym := params[1];
#		petrie := params[2];
#		flagnum := params[3];
#		rels := params[4][1];
#
#		if flagnum <> 2*sym[1]*sym[2] then
#			WriteAll(f2, paramstr);
#		fi;
#		paramstr := ReadLine(f1);
#	od;
#
#	CloseStream(f1);
#	CloseStream(f2);
#	return;
#	end;

# WARNING: The exact interface (arguments and their order etc) may change as we figure out
# better ways to store and query the data...
InstallGlobalFunction(SmallRegularPolyhedra,
	function(sizerange)
	local polys, stream, desc, params, flatpolystr, paramlist, sym, petrie, flagnum, rels, p, paramstr, filename, rampPath, toobig, degens, minsize, maxsize, toruspolys;
	rampPath := DirectoriesLibrary("pkg/ramp/lib");
	filename := Filename(rampPath, "regularPolyhedra.txt");
	stream := InputTextFile(filename);
	if IsInt(sizerange) then
		minsize := 1;
		maxsize := sizerange;
	elif IsEmpty(sizerange) then
		return [];
	else
		minsize := sizerange[1];
		maxsize := Last(sizerange);
	fi;
	polys := [];
	toobig := false;
	
	#if ValueOption("nondegenerate") <> true and ValueOption("nonflat") <> true then
	#	polys := DegeneratePolyhedra(sizerange);
	#fi;

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
			p := AbstractRegularPolytope(sym, rels);
			SetSize(p, flagnum);
			SetSize(AutomorphismGroup(p), flagnum);
			SetPetrieLength(p, petrie);
			SetSchlafliSymbol(p, sym);
			Add(polys, p);
		fi;

		paramstr := ReadLine(stream);
	od;

	CloseStream(stream);

	SortBy(polys, p -> Size(p));
	return polys;
	end);
