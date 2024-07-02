	
InstallMethod(Size,
	[IsPremaniplex],
	function(M)
	local size;
	size := ComputeAttr(M, Size);
	if size <> fail then return size; fi;

	if IsReflexibleManiplexAutGpRep(M) then
		return Size(AutomorphismGroup(M));
	elif IsRotaryManiplexRotGpRep(M) then
		return 2*Size(RotationGroup(M));
	elif IsManiplexQuotientRep(M) then
		return Index(AutomorphismGroup(M!.parent), M!.subgroup);
	else
		return NrMovedPoints(ConnectionGroup(M));
	fi;
	end);
	
InstallMethod(RankManiplex,
	[IsReflexibleManiplex],
	M -> Size(GeneratorsOfGroup(AutomorphismGroup(M))));

InstallMethod(RankManiplex,
	[IsManiplex and IsManiplexConnGpRep],
	M -> Size(GeneratorsOfGroup(ConnectionGroup(M))));

InstallMethod(RankManiplex,
	[IsManiplex and IsManiplexQuotientRep],
	M -> Rank(M!.parent));

InstallMethod(Rank, [IsPremaniplex], RankManiplex);
	
InstallMethod(IsPolytopal,
	[IsManiplex],
	function(M)
	local isPolytopal;
	
	isPolytopal := ComputeAttr(M, IsPolytopal);
	if isPolytopal = fail then
		if HasIsEquivelar(M) and IsEquivelar(M) and Size(M) < 2*Product(SchlafliSymbol(M)) then
			isPolytopal := false;
		elif HasIsReflexible(M) and IsReflexible(M) then
			isPolytopal := IsStringC(AutomorphismGroup(M));
			if isPolytopal and IsBound(M!.String) then M!.String := ReplacedString(M!.String, "ReflexibleManiplex", "AbstractRegularPolytope"); fi;
		elif IsRotaryManiplexRotGpRep(M) then
			isPolytopal := IsStringCPlus(RotationGroup(M));
			if isPolytopal and IsBound(M!.String) then M!.String := ReplacedString(M!.String, "RotaryManiplex", "AbstractRotaryPolytope"); fi;
		else
			isPolytopal := SatisfiesPathIntersectionProperty(M);
		fi;
	fi;
	
	return isPolytopal;
	end);

InstallMethod(IsPolytopal,
	[IsPremaniplex],
	function(PM)
	local isPolytopal, M,C;
	C:=ConnectionGroup(PM);
	if IsManiplexable(C) then return IsPolytopal(Maniplex(C));
		else return false;
		fi;
	end);	
	
InstallMethod(SatisfiesPathIntersectionProperty,
	[IsManiplex],
	function(m)
	local c, N, r, gens, v, u, i ,j, A, B, C, orbA, orbB, orbC;
	c:=ConnectionGroup(m);
	N:=Size(MovedPoints(c));
	r:=Rank(m);
	gens:=GeneratorsOfGroup(c);
	if not IsTransitive(c) then
		return false;
	fi;
	for v in [1..N] do
		for i in [1..r-1] do
			for j in [i+1..r] do
				A := [i+1..r];
				B := [1..j-1];
				C := [i+1..j-1];
				orbA := Orbit(Group(gens{A}), v);
				orbB := Orbit(Group(gens{B}), v);
				if IsEmpty(C) then
					orbC := [v];
				else
					orbC := Orbit(Group(gens{C}), v);
				fi;
				if AsSet(Intersection(orbA, orbB)) <> AsSet(orbC) then 
					return false;
				fi;
			od;
		od;
	od;
	return true;
	end);

InstallMethod(IsFaithful,
	[IsReflexibleManiplex],
	function(M)
	return Size(MaxChainStabilizer(M)) = 1;
	end);

InstallMethod(IsFaithful,
	[IsManiplex],
	function(m)
	#for each flag we will test if the intersection of all the i faces containing it 
	# is just the flag itself.  If not, it isn't faithful.
	local c, gens, M, f, i, ind, Ci, test;
	c:=ConnectionGroup(m);
	gens:=GeneratorsOfGroup(c);	
	M:=MovedPoints(c);
	for f in M do 
	test:=ShallowCopy(M);
	for i in [1..Size(gens)] do
	ind:=[1..Size(gens)];
	Remove(ind,i);
	Ci:=Group(List(ind, j-> gens[j]));	
	test:=Intersection(Orbit(Ci,f),test);
	od;
	if Size(test) <> 1 then 
	return false;
	fi;
	od;
	return true;
	end);
	
InstallMethod(IsRegularPolytope,
	[IsManiplex],
	function(m)
	return IsPolytopal(m) and IsReflexible(m);
	end);
	