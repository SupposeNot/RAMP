# Return the Toroidal Map {4,4}_u,v.
# Accepts both a single argument (for the regular / chiral toroids) and two arguments.
# Currently assumes that at least one of the vectors has nonnegative components.
InstallGlobalFunction(ToroidalMap44,
	function(u, arg...)
	local v, x,y, min_x, max_x, num_sq, r0, r1, r2, a, b, c, d, InRegion, TranslateUp, TranslateRight, squares, coords, i, n, n_h, n_v, u_angle, v_angle, swap, w;
	if Size(arg) = 0 then
		if u[2] = 0 then
			v := [0, u[1]];
		else
			v := [-u[2], u[1]];
		fi;
	else
		v := arg[1];
	fi;
	
	# Make both vectors have a non-negative y-coordinate
	if u[2] < 0 then u := -u; fi;
	if v[2] < 0 then v := -v; fi;
	
	# If y-coordinate is 0, make x-coordinate positive
	if u[2] = 0 then u[1] := AbsoluteValue(u[1]); fi;
	if v[2] = 0 then v[1] := AbsoluteValue(v[1]); fi;
	
	# We assume later that u is in the first quadrant and has a smaller angle than v.
	swap := false;
	if u[1] = 0 then
		if v[1] > 0 then
			swap := true;
		fi;
	elif v[1] = 0 then
		if u[1] < 0 then
			swap := true;
		fi;
	else
		u_angle := Atan(Float(u[2]/u[1]));
		v_angle := Atan(Float(v[2]/v[1]));
		if u_angle > v_angle and v[1] > 0 then
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
	
	# Tests whether the point (x,y) lies in the region.
	# The lower two boundaries are included in the region, and the upper two excluded.
	# The corners on the upper boundaries are excluded.
	InRegion := function(x,y)
		if a*y < b*x then
			return false;
		elif a*y >= b*x + a*d - b*c then
			return false;
		elif d*x < c*y then
			return false;
		elif d*x >= c*y + a*d - b*c then
			return false;
		else
			return true;
		fi;
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
		local co, x, y;
		co := coords[n];
		x := co[1]; y := co[2];
		
		# Now add one to x and see if we land outside the region.
		x := x + 1;
		if not(InRegion(x,y)) then
			# One of the following must give us a point in the region
			if InRegion(x-a, y-b) then
				x := x-a; y := y-b;
			elif InRegion(x+c, y+d) then
				x := x+c; y := y+d;
			else
				Error("Couldn't get a point in the fundamental region!");
			fi;
		fi;
		
		return LookupDictionary(squares, [x, y]);
		end;
	
	# Given a square number n, returns the number of the square that is directly above.
	TranslateUp := function(n)
		local co, x, y;
		co := coords[n];
		x := co[1]; y := co[2];
		
		# Now add one to y and see if we land outside the region.
		y := y + 1;
		if not(InRegion(x,y)) then
			# One of the following must give us a point in the region
			if InRegion(x+a, y+b) then
				x := x+a; y := y+b;
			elif InRegion(x-a, y-b) then
				x := x-a; y := y-b;
			elif InRegion(x-c, y-d) then
				x := x-c; y := y-d;
			elif InRegion(x-a-c, y-b-d) then
				x := x-a-c; y := y-b-d;
			elif InRegion(x+a-c, y+b-d) then
				x := x+a-c; y := y+b-d;
			else
				Error("Couldn't get a point in the fundamental region!");
			fi;
		fi;
		
		return LookupDictionary(squares, [x, y]);
		end;
		
	r2 := ();
	for i in [1..num_sq] do
		n := 8*(i-1);
		n_h := 8*(TranslateRight(i)-1);
		n_v := 8*(TranslateUp(i)-1);
		r2 := r2 * (n+1, n_h+6) * (n+2, n_h+5) * (n+3, n_v+8) * (n+4, n_v+7);
	od;
	
	return Maniplex(Group([r0,r1,r2]));
	end);

