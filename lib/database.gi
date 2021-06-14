
# I used this at some point to save some polytopes to a file.
# Keeping it here in case we want to crib off it later.
#SavePolytopes := function(polys, filename)
#	local stream, i, j, p, F, rels, datastring, id, flats, sym, g, s1, s2, nonflats, pd, pp, invars, duals, done, pdp, ppd, pdpd;
#	stream := OutputTextFile(filename, false);
#	done := NewDictionary(polys[1], false, polys);
#
#	# First, write all the parameters for flat orientable polyhedra
#	flats := Filtered(polys, p -> IsTight(p) and IsOrientable(p));
#	WriteAll(stream, "flats\n");
#	for p in flats do
#		# Find the relation s2^-1 * s1 = s1^i s2^j that holds.
#		sym := SchlafliSymbol(p);
#		g := AutomorphismGroup(p);
#		for i in [1..sym[1]] do
#			for j in [1..sym[2]] do
#				s1 := g.1*g.2;
#				s2 := g.2*g.3;
#				if s2^-1*s1 = s1^i*s2^j then
#					WriteAll(stream, Concatenation(String(sym[1]), ",", String(sym[2]), ",", String(i), ",", String(j), "\n"));
#				fi;
#			od;
#		od;
#	od;
#
#	nonflats := Filtered(polys, p -> not(IsTight(p) and IsOrientable(p)));
#	WriteAll(stream, "nonflats\n");
#	for p in nonflats do
#		g := AutomorphismGroup(p);
#		
#		WriteAll(stream, String(SchlafliSymbol(p)));
#		WriteAll(stream, ", ");
#		WriteAll(stream, String(PetrieLength(p)));
#		WriteAll(stream, ", ");
#		WriteAll(stream, String(Size(p)));
#		WriteAll(stream, ", ");
#		rels := ExtraRelators(p);
#		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(UniversalSggi(3))));
#		WriteAll(stream, String(rels));
#		WriteAll(stream, "\n");
#		# And write some other stuff
#	od;
#
#	CloseStream(stream);
#	end;

InstallMethod(DegeneratePolyhedra,
	[IsInt],
	function(maxsize)
	local polys, k, p;
	polys := [];
	if maxsize >= 8 then
		p := AbstractRegularPolytope([2,2]);
		SetSize(p, 8);
		Add(polys, p);
	fi;
	k := 3;
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

InstallMethod(FlatRegularPolyhedra,
	[IsInt],
	function(maxsize)
	local polys, p, q, k, r, poly, D, rampPath, filename, stream, params, flatpolystr;
	polys := [];

	# If p and q are even, then FlatRegularPolyhedron(p, q, -1, 1) works.
	# (from Minimal Equivelar Polytopes Thm. 6.3)
	p := 4;
	while 8*p <= maxsize do
		q := 4;
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
			if 2*p*q <= maxsize then
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

	k := 1;
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
		r := 3;
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
			Add(polys, poly);
		else
			break;
		fi;
		params := ReadLine(stream);
	od;
	
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

# TODO: Split flat polyhedra into a separate file, and add an option to exclude them if desired.
# TODO: Optimize the handling of flat polyhedra. There are some choices of i and j that always work, so I don't
#	really need to store these - I can easily make them on the fly.
# WARNING: The exact interface (arguments and their order etc) may change as we figure out
# better ways to store and query the data...
InstallMethod(SmallRegularPolyhedra,
	[IsInt],
	function(maxsize)
	local polys, stream, desc, params, flatpolystr, paramlist, sym, petrie, flagnum, rels, p, paramstr, filename, rampPath, toobig, degens;
	rampPath := DirectoriesLibrary("pkg/ramp/lib");
	filename := Filename(rampPath, "regularPolyhedra.txt");
	stream := InputTextFile(filename);
	polys := [];
	toobig := false;
	
	if ValueOption("nondegenerate") <> true and ValueOption("nonflat") <> true then
		polys := DegeneratePolyhedra(maxsize);
	fi;

	if ValueOption("nonflat") <> true then
		Append(polys, FlatRegularPolyhedra(maxsize));
	fi;
	
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
		else
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
