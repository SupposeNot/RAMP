InstallMethod(PyramidOver,
	[IsManiplex],
	function(p)
	local n, k, flagNum, i, j, t, r_t, perms, thisFlag, nextFlag, conn, newConn, s, q;
	conn := ConnectionGroup(p);
	n := Rank(p);
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
	q := Maniplex(newConn);
	if HasIsPolytopal(p) then
		SetIsPolytopal(q, IsPolytopal(p));
	fi;
	return q;
	end);

InstallMethod(PrismOver,
	[IsManiplex],
	function(p)
	local n, k, flagNum, i, t, r_t, d, thisFlag, perm, perms, newConn, conn, s;
	conn := ConnectionGroup(p);
	n := Rank(p);
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
	return Maniplex(newConn);
	end);
	
