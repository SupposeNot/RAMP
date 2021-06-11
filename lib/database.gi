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

# TODO: This is a work in progress!	
# TODO: Incorporate the degenerate polyhedra [p, 2] and [2, q]
# TODO: Make the filename handling easier. (Right now I have to use an absolute path)
# TODO: Optimize the handling of flat polyhedra. There are some choices of i and j that always work, so I don't
#	really need to store these - I can easily make them on the fly.
ReadPolytopes := function()
	local polys, stream, desc, params, flatpolystr, paramlist, sym, petrie, flagnum, rels, p, paramstr, filename, rampPath;
	rampPath := DirectoriesLibrary("pkg/ramp/lib");
	filename := Filename(rampPath, "polys.txt");
	stream := InputTextFile(filename);
	polys := [];
	desc := ReadLine(stream);
	if desc = "flats\n" then
		# start reading in data on flat polytopes
		params := ReadLine(stream);
		while params <> "nonflats\n" do
			flatpolystr := Concatenation("FlatRegularPolyhedron(", params, ")");
			Add(polys, EvalString(flatpolystr));
			params := ReadLine(stream);
		od;
	fi;

	paramstr := ReadLine(stream);
	while not(IsEndOfStream(stream)) do
		params := EvalString(Concatenation("[", paramstr, "]"));
		
		sym := params[1];
		petrie := params[2];
		flagnum := params[3];
		rels := params[4][1];
		
		p := AbstractRegularPolytope(sym, rels);
		SetSize(p, flagnum);
		SetSize(AutomorphismGroup(p), flagnum);
		SetPetrieLength(p, petrie);
		SetSchlafliSymbol(p, sym);
		Add(polys, p);

		paramstr := ReadLine(stream);
	od;
	
	CloseStream(stream);
	return polys;
	end;

