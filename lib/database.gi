# This saves polytopes to a file in an efficient way with lots of shortcuts.
# Not suitable for MathDataHub.
SavePolytopes := function(polys, filename)
	local stream, i, j, p, F, rels, datastring, id, flats, sym, g, s1, s2, nonflats, pd, pp, invars, duals, done, pdp, ppd, pdpd;
	stream := OutputTextFile(filename, false);
	done := NewDictionary(polys[1], false, polys);

	# First, write all the parameters for flat orientable polyhedra
	flats := Filtered(polys, p -> IsTight(p) and IsOrientable(p));
	WriteAll(stream, "flats\n");
	for p in flats do
		# Find the relation s2^-1 * s1 = s1^i s2^j that holds.
		sym := SchlafliSymbol(p);
		g := AutomorphismGroup(p);
		for i in [1..sym[1]] do
			for j in [1..sym[2]] do
				s1 := g.1*g.2;
				s2 := g.2*g.3;
				if s2^-1*s1 = s1^i*s2^j then
					WriteAll(stream, Concatenation(String(sym[1]), ",", String(sym[2]), ",", String(i), ",", String(j), "\n"));
				fi;
			od;
		od;
	od;

	nonflats := Filtered(polys, p -> not(IsTight(p) and IsOrientable(p)));
	WriteAll(stream, "nonflats\n");
	for p in nonflats do
		g := AutomorphismGroup(p);
		
		WriteAll(stream, String(SchlafliSymbol(p)));
		WriteAll(stream, ", ");
		WriteAll(stream, String(PetrieLength(p)));
		WriteAll(stream, ", ");
		WriteAll(stream, String(Size(p)));
		WriteAll(stream, ", ");
		rels := ExtraRelators(p);
		rels := List(rels, r -> AbstractWordTietzeWord(r, FreeGeneratorsOfFpGroup(UniversalSggi(3))));
		WriteAll(stream, String(rels));
		WriteAll(stream, "\n");
		# And write some other stuff
	od;

	CloseStream(stream);
	end;

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
	
	if ValueOption("nondegenerate") <> true then
		polys := DegeneratePolyhedra(maxsize);
	fi;
	
	desc := ReadLine(stream);
	if desc = "flats\n" then
		# start reading in data on flat polytopes
		params := ReadLine(stream);
		while params <> "nonflats\n" do
			if not(toobig) then
				flatpolystr := Concatenation("FlatRegularPolyhedron(", params, ")");
				p := EvalString(flatpolystr);
				if Size(p) <= maxsize then
					Add(polys, EvalString(flatpolystr));
				else
					toobig := true;
				fi;
			fi;
			params := ReadLine(stream);
		od;
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
