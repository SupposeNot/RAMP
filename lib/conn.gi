
# Modifies the permutation perm by adding k to each entry.
TranslatePerm := function(perm, k)
	local n, l, l2;
	l := ListPerm(perm);
	Apply(l, i -> i+k);
	l2 := [1..k];
	Append(l2, l);
	perm := PermList(l2);
	return perm;
	end;

# Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), ..., with multiplier terms.	
MultPerm := function(perm, multiplier, offset)
	local MultPermAux;

	# perm is the "seed" permutations, newperm is the accumulated result so far.
	MultPermAux := function(perm, newperm, multiplier, offset)
		if (multiplier = 1) then
			return newperm;
		else
			return MultPermAux(perm, newperm*TranslatePerm(perm, offset*(multiplier-1)), multiplier-1, offset);
		fi;
		end;
		
	return MultPermAux(perm, perm, multiplier, offset);
	end;
	
# TODO: This should eventually return a maniplex, not a polytope
InstallMethod(RegularCover,
	[IsAbstractPolytope],
	function(p)
	return AbstractPolytope(Image(RegularActionHomomorphism(ConnectionGroup(p))));
	end);
	
InstallMethod(PyramidOver,
	[IsAbstractPolytope],
	function(p)
	local n, k, flagNum, i, j, t, r_t, perms, thisFlag, nextFlag, conn, newConn, s;
	conn := ConnectionGroup(p);
	n := RankPolytope(p);
	k := Size(p);

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
	newConn := Group(perms);
	return AbstractPolytope(newConn);
	end);

InstallMethod(PrismOver,
	[IsAbstractPolytope],
	function(p)
	local n, k, flagNum, i, t, r_t, d, thisFlag, perm, perms, newConn, conn, s;
	conn := ConnectionGroup(p);
	n := RankPolytope(p);
	k := Size(p);
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
	newConn := Group(perms);
	return AbstractPolytope(newConn);
	end);
	
# Return the Toroidal Map {4,4}_u,v.
# Accepts both a single argument (for the regular / chiral toroids) and two arguments.
# Currently assumes that at least one of the vectors has nonnegative components.
ToroidalMap44 := function(u, arg...)
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
	
	return AbstractPolytope(Group([r0,r1,r2]));
	end;

	