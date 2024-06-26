

InstallMethod(FlatOrientablyRegularPolyhedron,
	[IsInt, IsInt, IsInt, IsInt],
	function(p,q,i,j)
	local relstr, poly;
	
	# Normalize i and j to have small absolute value
	# This makes some later computations faster
	if i > p/2 then i := i - p; fi;
	if j > q/2 then j := j - q; fi;

	# From "Classification of Tight Regular Polyhedra" Prop 3.2, we know that
	# s2 commutes with s1^i+1 and s1 commutes with s2^j-1.
	# Then we can show that s1^2 and s2^2 commute:
	#s1^2 s2^2 s1^-2 s2^-2 = 
	#s1^2 s2 (s2 s1^-1) s1^-1 s2^-2 =
	#s1^2 s2 (s1^-i s2^-j) s1^-1 s2^-2 =
	#s1^2 s2 s1^-i-1 s1 s2^-j s1^-1 s2^-2 =
	#s1^2 s1^-i-1 s2 s1 s2^-j s1^-1 s2^-2 =
	#s1^-i+1 s1^-1 s2^-1 s2^-j s1^-1 s2^-2 =
	#s1^-i s2^-j-1 s1^-1 s2^-2 =
	#s1^-i s2^-2 s2^-j+1 s1^-1 s2^-2 =
	#s1^-i s2^-2 s1^-1 s2^-j+1 s2^-2 =
	#s1^-i s2^-1 (s2^-1 s1^-1) s2^-j-1 =
	#s1^-i s2^-1 s1 s2 s2^-j-1 =
	#s1^-i (s2^-1 s1) s2^-j =
	#s1^-i s1^i s2^j s2^-j =
	#1

	# So we include that relation to make computations much faster.
	relstr := Concatenation("r2 r1 r0 r1 (r2 r1)^", String(j), " (r1 r0)^", String(i), ", (r0 r1)^2 (r1 r2)^2 = (r1 r2)^2 (r0 r1)^2");
	poly := AbstractRegularPolytopeNC([p,q], relstr);
	
	if ValueOption("checkSize") <> false and Size(AutomorphismGroup(poly)) <> 2*p*q then
		Info(InfoRamp, 1, "The given values of p, q, i, and j do not define a flat orientably regular polyhedron.");
		return fail;
	else
		SetSize(poly, 2*p*q);
		SetFvector(poly, [q, p*q/2, p]);
		SetSchlafliSymbol(poly, [p,q]);
		SetIsFlat(poly, true);
		
		# We can show that s1^2 and s2^2 commute in this group, and from that we can compute the Petrie length
		SetPetrieLength(poly, 2*Lcm(p/Gcd(p,2), q/Gcd(q,2)));
		poly!.String := Concatenation("FlatOrientablyRegularPolyhedron(", String(p), ",", String(q), ",", String(i), ",", String(j), ")");
		return poly;	
	fi;
	end);

InstallMethod(FlatOrientablyRegularPolyhedronNC,
	[IsInt, IsInt, IsInt, IsInt],
	function(p,q,i,j)
	return FlatOrientablyRegularPolyhedron(p, q, i, j : checkSize := false);
	end);

InstallMethod(FlatOrientablyRegularPolyhedraOfType,
	[IsList],
	function(sym)
	local p, q, polys, i, j, g, relstr;
	polys := [];
	p := sym[1];
	q := sym[2];
	
	if IsOddInt(p) then
		if IsOddInt(q) then
			return [];
		elif (2*p mod q) <> 0 then
			return [];
		else
			return [FlatOrientablyRegularPolyhedronNC(p,q,-1,-3)];
		fi;
	elif IsOddInt(q) then
		if (2*q mod p) <> 0 then
			return [];
		else
			return [FlatOrientablyRegularPolyhedronNC(p,q,3,1)];
		fi;
	else
		for i in [1, 3 .. p-1] do
			for j in [1, 3 .. q-1] do
				relstr := Concatenation("r2 r1 r0 r1 (r2 r1)^", String(j), " (r1 r0)^", String(i), ", r1 r2 r1 r0 (r1 r2)^", String(j), " (r0 r1)^", String(i));
				g := Sggi([p,q], relstr);
				if Size(g) = 2*p*q then
					Add(polys, FlatOrientablyRegularPolyhedronNC(p,q,i,j));
				fi;
			od;
		od;
	fi;
	return polys;
	end);
	
InstallMethod(TightOrientablyRegularPolytopesOfType,
	[IsList],
	function(sym)
	local n, polys, facets, vfigs, f, amalgs, p;
	n := Size(sym);
	if n = 2 then
		return FlatOrientablyRegularPolyhedraOfType(sym);
	else
		polys := [];
		facets := TightOrientablyRegularPolytopesOfType(sym{[1..n-1]});
		vfigs := TightOrientablyRegularPolytopesOfType(sym{[2..n]});
		for f in facets do
			amalgs := List(vfigs, v -> Amalgamate(f, v));
			amalgs := Filtered(amalgs, a -> Size(a) = 2*Product(sym));
			Append(polys, amalgs);
		od;
		for p in polys do
			SetIsPolytopal(p, true);
		od;
		return polys;
	fi;
	end);
	