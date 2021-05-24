
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

# I think this is correct, but would love a second set of eyes.
Tomotope := function()
	local g,h;
	g := Group([
(1, 49)(2, 50)(3, 51)(4, 52)(5, 53)(6, 54)(7, 55)(8, 56)(9, 97)(10, 98)(11, 99)(12, 100)(13, 101)(14, 
    102)(15, 103)(16, 104)(17, 145)(18, 146)(19, 147)(20, 148)(21, 149)(22, 150)(23, 151)(24, 152)(25, 
    113)(26, 114)(27, 115)(28, 116)(29, 117)(30, 118)(31, 119)(32, 120)(33, 161)(34, 162)(35, 163)(36, 
    164)(37, 165)(38, 166)(39, 167)(40, 168)(41, 81)(42, 82)(43, 83)(44, 84)(45, 85)(46, 86)(47, 87)(48, 
    88)(57, 105)(58, 106)(59, 107)(60, 108)(61, 109)(62, 110)(63, 111)(64, 112)(65, 153)(66, 154)(67, 
    155)(68, 156)(69, 157)(70, 158)(71, 159)(72, 160)(73, 121)(74, 122)(75, 123)(76, 124)(77, 125)(78, 
    126)(79, 127)(80, 128)(89, 177)(90, 178)(91, 179)(92, 180)(93, 181)(94, 182)(95, 183)(96, 184)(129, 
    169)(130, 170)(131, 171)(132, 172)(133, 173)(134, 174)(135, 175)(136, 176)(137, 185)(138, 186)(139, 
    187)(140, 188)(141, 189)(142, 190)(143, 191)(144, 192)
,
(1, 9)(2, 10)(3, 17)(4, 18)(5, 25)(6, 26)(7, 33)(8, 34)(11, 19)(12, 20)(13, 41)(14, 42)(15, 37)(16, 38)(21, 
    45)(22, 46)(23, 31)(24, 32)(27, 35)(28, 36)(29, 43)(30, 44)(39, 47)(40, 48)(49, 57)(50, 58)(51, 65)(52, 
    66)(53, 73)(54, 74)(55, 89)(56, 90)(59, 67)(60, 68)(61, 83)(62, 84)(63, 95)(64, 96)(69, 87)(70, 88)(71, 
    79)(72, 80)(75, 81)(76, 82)(77, 93)(78, 94)(85, 91)(86, 92)(97, 105)(98, 106)(99, 129)(100, 130)(101, 
    123)(102, 124)(103, 137)(104, 138)(107, 131)(108, 132)(109, 117)(110, 118)(111, 139)(112, 140)(113, 
    121)(114, 122)(115, 133)(116, 134)(119, 141)(120, 142)(125, 135)(126, 136)(127, 143)(128, 144)(145, 
    153)(146, 154)(147, 169)(148, 170)(149, 179)(150, 180)(151, 189)(152, 190)(155, 171)(156, 172)(157, 
    167)(158, 168)(159, 191)(160, 192)(161, 177)(162, 178)(163, 173)(164, 174)(165, 185)(166, 186)(175, 
    181)(176, 182)(183, 187)(184, 188)
,
(1, 3)(2, 6)(4, 8)(5, 7)(9, 11)(10, 14)(12, 16)(13, 15)(17, 19)(18, 22)(20, 24)(21, 23)(25, 27)(26, 30)(28, 
    32)(29, 31)(33, 35)(34, 40)(36, 38)(37, 39)(41, 47)(42, 44)(43, 45)(46, 48)(49, 51)(50, 54)(52, 56)(53, 
    55)(57, 59)(58, 62)(60, 64)(61, 63)(65, 67)(66, 70)(68, 72)(69, 71)(73, 77)(74, 76)(75, 79)(78, 80)(81, 
    87)(82, 84)(83, 85)(86, 88)(89, 93)(90, 92)(91, 95)(94, 96)(97, 99)(98, 102)(100, 104)(101, 103)(105, 
    107)(106, 110)(108, 112)(109, 111)(113, 115)(114, 118)(116, 120)(117, 119)(121, 125)(122, 124)(123, 
    127)(126, 128)(129, 131)(130, 134)(132, 136)(133, 135)(137, 143)(138, 142)(139, 141)(140, 144)(145, 
    147)(146, 150)(148, 152)(149, 151)(153, 155)(154, 158)(156, 160)(157, 159)(161, 163)(162, 168)(164, 
    166)(165, 167)(169, 171)(170, 174)(172, 176)(173, 175)(177, 181)(178, 180)(179, 183)(182, 184)(185, 
    191)(186, 190)(187, 189)(188, 192)
,
(1, 2)(3, 4)(5, 6)(7, 8)(9, 10)(11, 12)(13, 14)(15, 16)(17, 18)(19, 20)(21, 22)(23, 24)(25, 26)(27, 28)(29, 
    30)(31, 32)(33, 34)(35, 36)(37, 38)(39, 40)(41, 42)(43, 44)(45, 46)(47, 48)(49, 50)(51, 52)(53, 54)(55, 
    56)(57, 58)(59, 60)(61, 62)(63, 64)(65, 66)(67, 68)(69, 70)(71, 72)(73, 74)(75, 76)(77, 78)(79, 80)(81, 
    82)(83, 84)(85, 86)(87, 88)(89, 90)(91, 92)(93, 94)(95, 96)(97, 98)(99, 100)(101, 102)(103, 104)(105, 
    106)(107, 108)(109, 110)(111, 112)(113, 114)(115, 116)(117, 118)(119, 120)(121, 122)(123, 124)(125, 
    126)(127, 128)(129, 130)(131, 132)(133, 134)(135, 136)(137, 138)(139, 140)(141, 142)(143, 144)(145, 
    146)(147, 148)(149, 150)(151, 152)(153, 154)(155, 156)(157, 158)(159, 160)(161, 162)(163, 164)(165, 
    166)(167, 168)(169, 170)(171, 172)(173, 174)(175, 176)(177, 178)(179, 180)(181, 182)(183, 184)(185, 
    186)(187, 188)(189, 190)(191, 192)
]);
	return AbstractPolytope(g);
	end;

	
