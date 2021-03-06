
InstallGlobalFunction(ToroidalMap44,
	function(u, arg...)
	local v, x,y, min_x, max_x, num_sq, r0, r1, r2, a, b, c, d, InRegion, FundRegionRepresentative, TranslateUp, TranslateRight, squares, coords, i, n, n_h, n_v, swap, w, M, g, IsInIntegerSpan;
	if Size(arg) = 0 then
		if u[1] = 0 then
			u := [u[2], 0];
		fi;
	
		if u[2] = 0 then
			M := ReflexibleManiplex([4,4], Concatenation("(r0 r1 r2 r1)^", String(u[1])));
			SetIsPolytopal(M, AbsoluteValue(u[1]) > 1);
		elif AbsoluteValue(u[1]) = AbsoluteValue(u[2]) then
			M := ReflexibleManiplex([4,4], Concatenation("(r0 r1 r2)^", String(2*u[1])));
			SetIsPolytopal(M, AbsoluteValue(u[1]) >  1);
		else
			M := AbstractRotaryPolytope([4,4], Concatenation("(s2^-1 s1)^", String(u[1]), " (s2 s1^-1)^", String(u[2])));
			SetIsChiral(M, true);
		fi;

		M!.String := Concatenation("ToroidalMap44(", String(u), ")");
		SetSize(M, 8*(u[1]^2 + u[2]^2));
		
		return M;
	else
		v := arg[1];
	fi;
	
	# First we do a normalization of the vectors so that at least one of them is in the first quadrant
	
	# Make both vectors have a non-negative y-coordinate
	if u[2] < 0 then u := -u; fi;
	if v[2] < 0 then v := -v; fi;
	
	# If y-coordinate is 0, make x-coordinate positive
	if u[2] = 0 then u[1] := AbsoluteValue(u[1]); fi;
	if v[2] = 0 then v[1] := AbsoluteValue(v[1]); fi;

	# If both vectors are in the 2nd quadrant, rotate them 90 degrees
	if u[1] < 0 and v[1] < 0 then
		u := [u[2], -u[1]];
		v := [v[2], -v[1]];
	fi;
	
	# Now at least one of the vectors u or v is in the first quadrant.
	# We rename the vectors so that u is in the first quadrant, and if both vectors
	# are in the first quadrant, we let u be the one with minimal angle.
	swap := false;
	if u[1] <= 0 then
		swap := true;
	elif v[1] > 0 then
		if Float(u[2]/u[1]) > Float(v[2]/v[1]) then
			swap := true;
		fi;
	fi;
	
	if swap then
		w := v;
		v := u;
		u := w;
	fi;
	
	min_x := Minimum(u[1], v[1], 0);
	max_x := Maximum(u[1], v[1], u[1]+v[1]);
	num_sq := AbsoluteValue(DeterminantMat([u,v]));
	
	# To improve readability, we now define u = [a, b] and v = [c, d]
	a := u[1]; b := u[2]; c := v[1]; d := v[2];

	# Translates the point (x,y) to a point inside the fundamental region
	FundRegionRepresentative := function(x,y)
		local A, p, b1, b2;
		A := [[a, c], [b, d]];
		p := A^-1 * [[x],[y]];
		b1 := FractionModOne(p[1][1]);
		b2 := FractionModOne(p[2][1]);
		return b1*u + b2*v;
		end;
		
	# Is the vector [x,y] an integer combination of u and v?
	IsInIntegerSpan := function(x,y)
		local A, p;
		A := [[a, c], [b, d]];
		p := A^-1 * [[x],[y]];
		return IsInt(p[1][1]) and IsInt(p[2][1]);
		end;
		
	# Tests whether the point (x,y) lies in the region.
	# The lower two boundaries are included in the region, and the upper two excluded.
	# The corners on the upper boundaries are excluded.
	InRegion := function(x,y)
		return ([x,y] = FundRegionRepresentative(x,y));
		end;

	# We want to enumerate the squares in the fundamental region of the translation subgroup.
	# We iterate through points in the plane starting at (0,0), moving left-to-right and bottom-to-top.
	# Whenever a point is in the fundamental region, the square of Z^2 with that lower-left corner
	# is enumerated.
	squares := NewDictionary([1,2], true);
	coords := [];
	x := min_x; y := 0; n := 1;
	while n <= num_sq do
		if InRegion(x,y) then
			AddDictionary(squares, [x,y], n);
			Add(coords, [x,y]);
			n := n+1;
		fi;

		if x = max_x then
			x := min_x;
			y := y+1;
		else
			x := x + 1;
		fi;
	od;

	# Now we build the permutations r0, r1, and r2.
	# r0 and r1 are easy -- we just build each square face independently.
	r0 := MultPerm((1,2)(3,4)(5,6)(7,8), num_sq, 8);
	r1 := MultPerm((2,3)(4,5)(6,7)(8,1), num_sq, 8);
	
	# Given a square number n, returns the number of the square that is directly to the right.
	TranslateRight := function(n)
		local co, x, y, new_point;
		co := coords[n];
		x := co[1]; y := co[2];
		
		new_point := FundRegionRepresentative(x+1, y);
		return LookupDictionary(squares, new_point);
		end;
	
	# Given a square number n, returns the number of the square that is directly above.
	TranslateUp := function(n)
		local co, x, y, new_point;
		co := coords[n];
		x := co[1]; y := co[2];
		
		new_point := FundRegionRepresentative(x,y+1);
		return LookupDictionary(squares, new_point);
		end;
		
	r2 := ();
	for i in [1..num_sq] do
		n := 8*(i-1);
		n_h := 8*(TranslateRight(i)-1);
		n_v := 8*(TranslateUp(i)-1);
		r2 := r2 * (n+1, n_h+6) * (n+2, n_h+5) * (n+3, n_v+8) * (n+4, n_v+7);
	od;
	
	g := Group([r0,r1,r2]);
	M := Maniplex(g);
	
	if IsInIntegerSpan(1,0) or IsInIntegerSpan(0,1) or IsInIntegerSpan(1,1) or IsInIntegerSpan(-1,1) then
		SetIsPolytopal(M, false);
	else
		SetIsPolytopal(M, true);
	fi;
	
	SetString(M, Concatenation("ToroidalMap44(", String(u), ", ", String(v), ")"));
	
	return M;
	end);

InstallGlobalFunction(ToroidalMap36,
	function(u, arg...)
	local relstr, v, x,y, min_x, max_x, num_vert, r0, r1, r2, a, b, c, d, InRegion, TranslateUp, TranslateRight, squares, coords, i, n, n_h, n_v, swap, w, M, g, IsInIntegerSpan;

	IsInIntegerSpan := function(x,y)
		local A, p;
		A := [[u[1], v[1]], [u[2], v[2]]];
		p := A^-1 * [[x],[y]];
		return IsInt(p[1][1]) and IsInt(p[2][1]);
		end;
		
	# Recall that h3 denotes the element r0 r1 r2 r1 r2 r1, corresponding to the 3-holes

	if Size(arg) = 0 then
		if u[1] = 0 then
			u := [u[2], 0];
		fi;
	
		if u[2] = 0 then
			relstr := Concatenation("h3^", String(u[1]));
			M :=  ReflexibleManiplex([3,6], relstr);
			SetIsPolytopal(M, AbsoluteValue(u[1]) > 1);
			SetSize(M, 12*u[1]^2);
		elif u[1] > 0 and u[1] = u[2] then
			relstr := Concatenation("h3^", String(u[1]), " r1 h3^", String(u[2]), " r1");
			M := AbstractRegularPolytopeNC([3,6], relstr);
			SetSize(M, 36*u[1]^2);
		else
			# h3 = s1 s2^-2
			# r1 h3 r1 = r1 r0 r1 r2 r1 r2 = s1^-1 s2^2
			relstr := Concatenation("(s1 s2^-2)^", String(u[1]), " (s1^-1 s2^2)^", String(u[2]));
			M := AbstractRotaryPolytopeNC([3,6], relstr);
			SetIsChiral(M, true);
			SetSize(M, 12*(u[1]^2 + u[1]*u[2] + u[2]^2));
		fi;
		
		M!.String := Concatenation("ToroidalMap36(", String(u), ")");
		return M;
	else
		v := arg[1];
		num_vert := AbsoluteValue(DeterminantMat([u,v]));

		relstr := Concatenation("h3^", String(u[1]), " r1 h3^", String(u[2]), " r1, h3^", String(v[1]), " r1 h3^", String(v[2]), " r1"  );
		M := AbstractRegularPolytope([3,6]) / relstr;
		if IsInIntegerSpan(0,1) or IsInIntegerSpan(1,0) or IsInIntegerSpan(-1,1) then
			SetIsPolytopal(M, false);
		else
			SetIsPolytopal(M, true);
		fi;
		
		SetSize(M, 12*num_vert);
		SetString(M, Concatenation("ToroidalMap36(", String(u), ", ", String(v), ")"));
		
		return M;
	fi;

	end);

InstallGlobalFunction(ToroidalMap63,
	function(arg...)
	local M, M2, arg_string;
	M := CallFuncList(ToroidalMap36, arg);
	M2 := Dual(M);
	arg_string := JoinStringsWithSeparator(List(arg, String), ",");
	M2!.String := Concatenation("ToroidalMap63(", arg_string, ")");
	return M2;
	end);

InstallMethod(CubicToroid,
	[IsInt,IsInt,IsInt],
	function(s,k,n)
	local i, l, m;
	if not (k in [1,2,n]) then Print("The value of k should be 1 or 2 or n.\n"); return fail;fi;
	l:="(r0";
	for i in [1..n] do
		Append(l," r"); Append(l, String(i));
		od;
	for i in Reversed([k..n-1]) do
		Append(l, " r"); Append(l, String(i));
		od;
	Append(l,")^");
	Append(l,String(s*k));
	m:=ReflexibleQuotientManiplex(CubicTiling(n),l);
	if k=1 then SetSize(m,(2*s)^n*Factorial(n));
		elif k=2 then SetSize(m,2^(n+1)*s^n*Factorial(n));
		else SetSize(m,2^(2*n-1)*s^n*Factorial(n)); fi;
	if s>=2 then SetIsPolytopal(m,true);
		else SetIsPolytopal(m,false); fi;
	return m;
	end);
	
InstallMethod(CubicToroid,
	[IsInt, IsList],
	function(n, vecs)
	local M, gens, x, i, basis, vec_words, translate_vector;
	
	if Size(vecs) < n then
		Error("vecs must have at least n vectors to generate an n-dimensional translation group.");
	fi;
	
	M := CubicTiling(n);

	gens := GeneratorsOfGroup(AutomorphismGroup(M));
	x := Product(gens) * Product(Reversed(gens{[2..n]}));
	basis := [x];
	for i in [2..n] do
		Add(basis, Last(basis)^gens[i]);
	od;
	
	translate_vector := function(v)
		local word;
		word := basis[1]^0;
		for i in [1..Size(v)] do
			word := word * basis[i]^v[i];
		od;
		return word;
		end;
	
	vec_words := List(vecs, translate_vector);
	
	return Maniplex(M, Group(vec_words));
	end);

InstallMethod(3343Toroid,
	[IsInt,IsInt],
	function(s,k)
	local i, l, m, sigma, tau;
	if not (k in [1,2]) then Print("The value of k should be 1 or 2.\n"); return fail;fi;
	sigma:=" r1 r2 r3 r2 r1";
	tau:=" r4 r3 r2 r3 r4";
	l:="(r0";
	if k=1 then
		Append(l, sigma);
		Append(l, tau);
		Append(l, sigma);
		Append(l,")^");
		Append(l,String(s));
	else Append(l, sigma);
		Append(l, tau);
		Append(l, ")^");
		Append(l, String(2*s));
	fi;
	m:=ReflexibleManiplex([3,3,4,3],l);
	if k=1 then SetSize(m,1152*s^4);
		else SetSize(m,4608*s^4);
		fi;
	if s>=2 then SetIsPolytopal(m,true);
		else SetIsPolytopal(m,false); fi;
	return m;
	end);

InstallMethod(24CellToroid,
	[IsInt,IsInt],
	function(s,k)
	return Dual(3343Toroid(s,k));
	end);