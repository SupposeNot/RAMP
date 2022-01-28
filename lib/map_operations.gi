
InstallMethod(IsMapOnSurface,
	[IsManiplex],
	function(m)
	return Rank(m)=3;
	end);
	

# InstallMethod(MapTruncation,
# 	[IsManiplex],
# 	function(m)
# 	local c, g, r0, r1, r2, s0, s1, s2;
# 	if IsMapOnSurface(m)<>true then Error("Not a map on a surface."); fi;
# 	c:=ConnectionGroup(m);
# 	r0:=c.1; r1:=c.2; r2:=c.3;
# 	s0:=[(),[r1,r1,r0]];
# 	s1:=[(2,3),[r2,(),()]];
# 	s2:=[(1,2),[(),(),r2]];
# 	return ChunkGeneratedGroup([s0,s1,s2],c);
# 	end);

InstallMethod(MapTruncation,
	[IsManiplex],
	function(m)
	local c, len, r0, r1, r2, s0, s1, s2, s0List, s1List, s2List, points, newpoints;
	if IsMapOnSurface(m)<>true then Error("Not a map on a surface."); fi;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(points);
	# Possible issues if it turns out that moved points might not be [1..n]
	r0:=c.1*TranslatePerm(c.1,len)*TranslatePerm(c.1,2*len);
	r1:=c.2*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len); 
	r2:=c.3*TranslatePerm(c.3,len)*TranslatePerm(c.3,2*len); 
	s0List:= Concatenation(List([1..len],x->x^r1), List([len+1..2*len],x->x^r1), List([2*len+1..3*len],x->x^r0));
	s0:=PermListList([1..3*len],s0List);
	s1List:= Concatenation( List([1..len],x->x^r2), List([len+1..2*len],x->x+len), List([2*len+1..3*len],x->x-len));
	s1:=PermListList([1..3*len],s1List);
	s2List:= Concatenation( List([1..len],x->x+len), List([len+1..2*len],x->x-len), List([2*len+1..3*len],x->x^r2));
	s2:=PermListList([1..3*len],s2List);
	newpoints:=[1..Length(points)*3];
	return Maniplex(Group([s0,s1,s2]));
	end);
	
InstallMethod(MapSnub,
	[IsManiplex],
	function(m)
	local c, len, r01, r12, r01i, r12i, s0, s1, s2, s0List, s1List, s2List, points, k;
	if IsMapOnSurface(m)<>true then Error("Not a map on a surface."); fi;
	if IsOrientable(m)<>true then Error("Not an orientable map."); fi;
    c:=ConnectionGroup(m);
    if Order(c.2*c.3)<>3 then Error("Not defined for maps with vertex degree>3."); fi;
	points:=Orbits(Group([c.1*c.2,c.2*c.3]))[1];
	len:=Length(MovedPoints(c));
	s0List:=[1..len*10]; s1List:=[1..len*10]; s2List:=[1..len*10];
	r01:=c.1*c.2;
	r12:=c.2*c.3;
	r01i:=Inverse(r01);
	r12i:=Inverse(r12);
	for k in points do
		s0List[k]:=k+len; 
		s0List[k+len]:=k; 
		s0List[k+2*len]:=k+3*len; 
		s0List[k+3*len]:=k+2*len;
		s0List[k+4*len]:=(k^(r12i*r01i)+6*len); 
		s0List[k+5*len]:=(k^(r12i*r01i)+7*len);
		s0List[k+6*len]:=(k^(r12i*r01i)+4*len);
		s0List[k+7*len]:=(k^(r12i*r01i)+5*len);
		s0List[k+8*len]:=(k^(r12i*r01i*r01i)+9*len);
		s0List[k+9*len]:=(k^(r01*r01*r12)+8*len);
		s1List[k]:=(k^r01i+len);
		s1List[k+len]:=(k^r01); 
		s1List[k+2*len]:=(k+4*len);
		s1List[k+3*len]:=(k+5*len);
		s1List[k+4*len]:=(k+2*len); 
		s1List[k+5*len]:=(k+3*len);
		s1List[k+6*len]:=(k+7*len);
		s1List[k+7*len]:=(k+6*len);
		s1List[k+8*len]:=(k+9*len);
		s1List[k+9*len]:=(k+8*len);
		s2List[k]:=(k+2*len);
		s2List[k+len]:=(k+3*len); 
		s2List[k+2*len]:=(k);
		s2List[k+3*len]:=(k+len);
		s2List[k+4*len]:=(k+6*len); 
		s2List[k+5*len]:=(k+8*len);
		s2List[k+6*len]:=(k+4*len);
		s2List[k+7*len]:=(k^r01i+9*len);
		s2List[k+8*len]:=(k+5*len);
		s2List[k+9*len]:=(k^r01+7*len);
		od;
	s0:=PermList(s0List); s1:=PermList(s1List); s2:=PermList(s2List);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(MapChamfer,
	[IsManiplex],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	if IsMapOnSurface(m)<>true then Error("Not a map on a surface."); fi;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0List:=[1..len*4]; s1List:=[1..len*4]; s2List:=[1..len*4];
	for k in points do
		s0List[k+2*len]:=k+3*len;
		s0List[k+3*len]:=k+2*len;
		s1List[k+len]:=k+2*len;
		s1List[k+2*len]:=k+len;
		s2List[k]:=k+len;
		s2List[k+len]:=k;
		od;
	s0:=c.1*TranslatePerm(c.1,len)*PermList(s0List);
	s1:=c.2*TranslatePerm(c.3,3*len)*PermList(s1List);
	s2:=PermList(s2List)*TranslatePerm(c.2,2*len)*TranslatePerm(c.2,3*len);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(MapSubdivision1,
	[IsManiplex],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	if IsMapOnSurface(m)<>true then Error("Not a map on a surface."); fi;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0List:=[1..len*2]; s1List:=[1..len*2]; s2List:=[1..len*2];
	s0:=PermList(Concatenation(List([1..len],x->x+len),List([len+1..2*len],x->x-len)));
	s1:=c.2*TranslatePerm(c.1,len);
	s2:=MultPerm(c.3,2,len);
	return Maniplex(Group([s0,s1,s2]));
	end);
	

InstallMethod(MapSubdivision2,
	[IsManiplex],
	function(m)
	return Dual(MapTruncation(Dual(m)));
	end);

InstallMethod(MapBarycentricSubdivision,
	[IsManiplex],
	function(m)
	return MapSubdivision2(MapSubdivision1(m));
	end);