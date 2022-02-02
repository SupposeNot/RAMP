
InstallImmediateMethod(IsMapOnSurface, IsManiplex and Tester(RankManiplex),	
	function(m)
	return Rank(m)=3;
	end);

# InstallMethod(Truncation,
# 	[IsManiplex],
# 	function(m)
# 	local c, g, r0, r1, r2, s0, s1, s2;
# # 	c:=ConnectionGroup(m);
# 	r0:=c.1; r1:=c.2; r2:=c.3;
# 	s0:=[(),[r1,r1,r0]];
# 	s1:=[(2,3),[r2,(),()]];
# 	s2:=[(1,2),[(),(),r2]];
# 	return ChunkGeneratedGroup([s0,s1,s2],c);
# 	end);

# InstallMethod(Truncation,
# 	[IsManiplex],
# 	function(m)
# 	local c, len, r0, r1, r2, s0, s1, s2, s0List, s1List, s2List, points, newpoints;
# # 	c:=ConnectionGroup(m);
# 	points:=MovedPoints(c);
# 	len:=Length(points);
# 	# Possible issues if it turns out that moved points might not be [1..n]
# 	r0:=c.1*TranslatePerm(c.1,len)*TranslatePerm(c.1,2*len);
# 	r1:=c.2*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len); 
# 	r2:=c.3*TranslatePerm(c.3,len)*TranslatePerm(c.3,2*len); 
# 	s0List:= Concatenation(List([1..len],x->x^r1), List([len+1..2*len],x->x^r1), List([2*len+1..3*len],x->x^r0));
# 	s0:=PermListList([1..3*len],s0List);
# 	s1List:= Concatenation( List([1..len],x->x^r2), List([len+1..2*len],x->x+len), List([2*len+1..3*len],x->x-len));
# 	s1:=PermListList([1..3*len],s1List);
# 	s2List:= Concatenation( List([1..len],x->x+len), List([len+1..2*len],x->x-len), List([2*len+1..3*len],x->x^r2));
# 	s2:=PermListList([1..3*len],s2List);
# 	newpoints:=[1..Length(points)*3];
# 	return Maniplex(Group([s0,s1,s2]));
# 	end);

InstallMethod(Snub,
	[IsMapOnSurface],
	m->Dual(Gyro(m)));
		
# InstallMethod(Snub,
# 	[IsManiplex],
# 	function(m)
# 	local c, len, r01, r12, r01i, r12i, s0, s1, s2, s0List, s1List, s2List, points, k;
# # 	if IsOrientable(m)<>true then Error("Not an orientable map."); fi;
#     c:=ConnectionGroup(m);
#     if Order(c.2*c.3)<>3 then Error("Not defined for maps with vertex degree>3."); fi;
# 	points:=Orbits(Group([c.1*c.2,c.2*c.3]))[1];
# 	len:=Length(MovedPoints(c));
# 	s0List:=[1..len*10]; s1List:=[1..len*10]; s2List:=[1..len*10];
# 	r01:=c.1*c.2;
# 	r12:=c.2*c.3;
# 	r01i:=Inverse(r01);
# 	r12i:=Inverse(r12);
# 	for k in points do
# 		s0List[k]:=k+len; 
# 		s0List[k+len]:=k; 
# 		s0List[k+2*len]:=k+3*len; 
# 		s0List[k+3*len]:=k+2*len;
# 		s0List[k+4*len]:=(k^(r12i*r01i)+6*len); 
# 		s0List[k+5*len]:=(k^(r12i*r01i)+7*len);
# 		s0List[k+6*len]:=(k^(r12i*r01i)+4*len);
# 		s0List[k+7*len]:=(k^(r12i*r01i)+5*len);
# 		s0List[k+8*len]:=(k^(r12i*r01i*r01i)+9*len);
# 		s0List[k+9*len]:=(k^(r01*r01*r12)+8*len);
# 		s1List[k]:=(k^r01i+len);
# 		s1List[k+len]:=(k^r01); 
# 		s1List[k+2*len]:=(k+4*len);
# 		s1List[k+3*len]:=(k+5*len);
# 		s1List[k+4*len]:=(k+2*len); 
# 		s1List[k+5*len]:=(k+3*len);
# 		s1List[k+6*len]:=(k+7*len);
# 		s1List[k+7*len]:=(k+6*len);
# 		s1List[k+8*len]:=(k+9*len);
# 		s1List[k+9*len]:=(k+8*len);
# 		s2List[k]:=(k+2*len);
# 		s2List[k+len]:=(k+3*len); 
# 		s2List[k+2*len]:=(k);
# 		s2List[k+3*len]:=(k+len);
# 		s2List[k+4*len]:=(k+6*len); 
# 		s2List[k+5*len]:=(k+8*len);
# 		s2List[k+6*len]:=(k+4*len);
# 		s2List[k+7*len]:=(k^r01i+9*len);
# 		s2List[k+8*len]:=(k+5*len);
# 		s2List[k+9*len]:=(k^r01+7*len);
# 		od;
# 	s0:=PermList(s0List); s1:=PermList(s1List); s2:=PermList(s2List);
# 	return Maniplex(Group([s0,s1,s2]));
# 	end);

InstallMethod(Chamfer,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
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

InstallMethod(Subdivision1,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0List:=[1..len*2]; s1List:=[1..len*2]; s2List:=[1..len*2];
	s0:=PermList(Concatenation(List([1..len],x->x+len),List([len+1..2*len],x->x-len)));
	s1:=c.2*TranslatePerm(c.1,len);
	s2:=MultPerm(c.3,2,len);
	return Maniplex(Group([s0,s1,s2]));
	end);
	

InstallMethod(Subdivision2,
	[IsMapOnSurface],
	function(m)
	return Dual(Truncation(Dual(m)));
	end);

InstallMethod(BarycentricSubdivision,
	[IsMapOnSurface],
	function(m)
	return Subdivision2(Subdivision1(m));
	end);
	
InstallMethod(Leapfrog,
	[IsMapOnSurface],
	function(m)
	return Truncation(Dual(m));
	end);	

InstallMethod(CombinatorialMap,
	[IsMapOnSurface],
	function(m)
	return Dual(BarycentricSubdivision(m));
	end);	

InstallMethod(Reflection,
	[IsManiplex],
	function(m) local c, nc;
	c:=ConnectionGroup(m);
	nc:=ConjugateGroup(c,c.1);
	return Maniplex(nc);
	end);
	
InstallMethod(Angle,
	[IsMapOnSurface],
	function(m)
	return Dual(Medial(m));
	end);		
	
InstallMethod(Gothic,
	[IsMapOnSurface],
	function(m)
	return Dual(Medial(Truncation(m)));
	end);		

InstallMethod(Kis,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0:=c.1* PermList(Concatenation([1..len], List([1..len],x->x+2*len), List([1..len],x->x+len)));
	s1:=PermList( Concatenation(List([1..len],x->x+len), [1..len])) * TranslatePerm(c.1,2*len);
	s2:=c.3*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Needle,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0:=PermList(Concatenation([len+1..2*len],[1..len]))*TranslatePerm(c.3,2*len);
	s1:=c.3*PermList(Concatenation([1..len],[2*len+1..3*len],[len+1..2*len]));
	s2:=c.2*TranslatePerm(c.2,len)*TranslatePerm(c.1,2*len);
	return Maniplex(Group([s0,s1,s2]));
	end);
	
InstallMethod(Zip,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0:=c.3*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len);
	s1:=PermList(Concatenation([len+1..2*len],[1..len]))*TranslatePerm(c.1,2*len);
	s2:=c.1*PermList(Concatenation([1..len],[2*len+1..3*len],[len+1..2*len]));
	return Maniplex(Group([s0,s1,s2]));#[c,Group([s0,s1,s2])];
	end);
	
InstallMethod(Truncation,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	s0:=c.1*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len);
	s1:=PermList(Concatenation([len+1..2*len],[1..len]))*TranslatePerm(c.3,2*len);
	s2:=c.3*PermList(Concatenation([1..len],[2*len+1..3*len],[len+1..2*len]));
	return Maniplex(Group([s0,s1,s2]));
	end);


InstallMethod(Ortho,
	[IsMapOnSurface],
	m->MapJoin(MapJoin(m))
	);

InstallMethod(Expand,
	[IsMapOnSurface],
	m->Ambo(Ambo(m))
	);

InstallMethod(Gyro,
	[IsMapOnSurface],
	function(m)
	local c, len, r01, r12, r10, r21, s0, s1, s2, s0List, s1List, s2List, points, k,x;
	if IsOrientable(m)<>true then Error("Not an orientable map."); fi;
    c:=ConnectionGroup(m);
	points:=Orbits(Group([c.1*c.2,c.2*c.3]))[1];
	len:=Length(points);
	s0List:=[1..len*10]; s1List:=[1..len*10]; s2List:=[1..len*10];
	r01:=c.1*c.2;
	r12:=c.2*c.3;
	r10:=Inverse(r01);
	r21:=Inverse(r12);
	k:=[1..len];
	s0:= PermList( Concatenation( k+len, k, k+3*len, k+2*len, k+5*len, k+4*len, k+7*len, k+6*len, k+9*len, k+8*len));
	s1:=PermList( Concatenation( k+9*len, k+2*len, k+1*len, k+4*len, k+3*len, k+6*len, k+5*len, k+8*len, k+7*len, k));
	s2:=PermList(Concatenation(
	List(k,x->Position(points,points[x]^r21))+9*len,#0
	List(k,x->Position(points,points[x]^r21))+8*len,#1
	List(k,x->Position(points,points[x]^r01))+5*len,#2
	List(k,x->Position(points,points[x]^r01))+4*len, #3
	List(k,x->Position(points,points[x]^r10))+3*len, #4
	List(k,x->Position(points,points[x]^r10))+2*len, #5
	List(k,x->Position(points,points[x]^(r12*r01)))+7*len, #6
	List(k,x->Position(points,points[x]^(r12*r01)))+6*len, 
	List(k,x->Position(points,points[x]^r12))+len, #8
	List(k,x->Position(points,points[x]^r12)) #9
	));
	return Maniplex(Group([s0,s1,s2]));
	end);
	#Should be the case that gyro(dual(m))=EnantiomorphicForm(gyro(enantioMorphicform(m))). Is it?

InstallMethod(Meta,
	[IsMapOnSurface],
	m->Kis(MapJoin(m)));

InstallMethod(Bevel,
	[IsMapOnSurface],
	m->Truncation(Ambo(m)));

InstallMethod(Subdivide,
	[IsMapOnSurface],
	function(m)
	local c, l, r01, r12, r10, r21, s0, s1, s2, s0List, s1List, s2List, points, k,x;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(points);
	k:=[1..l];
	s0:=PermList(Concatenation(k+l,k))*TranslatePerm(c.2,2*l)*TranslatePerm(c.2,3*l);
	s1:=c.2*MappingPermListList(k+2*l,k+l)*TranslatePerm(c.1,3*l);
	s2:=c.3*TranslatePerm(c.3,l)*MappingPermListList(k+3*l,k+2*l);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Propeller,
	[IsMapOnSurface],
	function(m)
	local c, len, r01, r12, r10, r21, s0, s1, s2, s0List, s1List, s2List, points, k,x;
	c:=ConnectionGroup(m);
	points:=Orbits(Group([c.1*c.2,c.2*c.3]))[1];
	len:=Length(points);
	r01:=c.1*c.2;
	r12:=c.2*c.3;
	r10:=Inverse(r01);
	r21:=Inverse(r12);
	k:=[1..len];
	s0:=PermList( Concatenation( k+len, k, k+3*len, k+2*len, k+5*len, k+4*len, k+7*len, k+6*len, k+9*len, k+8*len));
	s1:=PermList(Concatenation(k+7*len, k+2*len, k+len, k+4*len, k+3*len, k+6*len, k+5*len, k, 
	List(k,x->Position(points,points[x]^r01))+9*len,
	List(k,x->Position(points,points[x]^r10))+8*len
	));
	s2:=PermList(Concatenation(
	List(k,x->Position(points,points[x]^r21))+7*len, #0
	List(k,x->Position(points,points[x]^r21))+6*len, #1
	k+8*len, #2
	k+9*len, #3
	List(k,x->Position(points,points[x]^(r12*r01)))+5*len, #4
	List(k,x->Position(points,points[x]^(r12*r01)))+4*len, #5
	List(k,x->Position(points,points[x]^r12))+1*len, #6
	List(k,x->Position(points,points[x]^r12))+0*len, #7
	k+2*len, k+3*len
	));
	return Maniplex(Group([s0,s1,s2]));
	end);
	
InstallMethod(Loft,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	k:=[1..len];
	s0:=c.1*PermList(Concatenation(k, k+2*len, k+1*len))*TranslatePerm(c.1,3*len)* TranslatePerm(c.1, 4*len);
	s1:=PermList(Concatenation(k+ len, k, k+3*len, k+2*len))*TranslatePerm(c.2,4*len);
	s2:=c.3*TranslatePerm(c.2,len)*TranslatePerm(c.2,2*len)* PermList(Concatenation([1..3*len],k+4*len, k+3*len));
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Quinto,
	[IsMapOnSurface],
	function(m)
	local c, len, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	len:=Length(MovedPoints(c));
	k:=[1..len];
	s0:=PermList(Concatenation( k+len, k, k+3*len, k+2*len))* TranslatePerm(c.2,4*len) * TranslatePerm(c.2,5*len);
	s1:=c.2*PermList(Concatenation(k,k+2*len,k+len, k+4*len, k+3*len))* TranslatePerm(c.1,5*len);
	s2:=c.3* TranslatePerm(c.3,len)* TranslatePerm(c.1,2*len)* TranslatePerm(c.1,3*len)* PermList(Concatenation([1..4*len],k+5*len, k+4*len));
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(JoinLace,
	[IsMapOnSurface],
	function(m)
	local c, l, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(MovedPoints(c));
	k:=[1..l];
	s0:=PermList(Concatenation(k+l,k,k+3*l,k+2*l))* TranslatePerm(c.2,4*l)* TranslatePerm(c.2,5*l);
	s1:=c.3*TranslatePerm(c.1,l)* TranslatePerm(c.2,2*l)* MappingPermListList(k+3*l,k+4*l)* TranslatePerm(c.1,5*l);
	s2:=PermList(Concatenation(k+2*l,k+3*l,k,k+l,k+5*l,k+4*l));
	return Maniplex(Group([s0,s1,s2]));
	end);


InstallMethod(Lace,
	[IsMapOnSurface],
	function(m)
	local c, l, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(MovedPoints(c));
	k:=[1..l];
	s0:=c.1*PermList(Concatenation( k, k+2*l, k+l, k+4*l, k+3*l))* TranslatePerm(c.2,5*l)* TranslatePerm(c.2,6*l);
	s1:=PermList(Concatenation(k+l, k, [2*l+1..4*l], k+5*l, k+4*l))* TranslatePerm(c.2,3*l)* TranslatePerm(c.1,6*l);
	s2:=c.3*PermList(Concatenation(k, k+3*l, k+4*l, k+l, k+2*l, k+6*l, k+5*l));
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Stake,
	[IsMapOnSurface],
	function(m)
	local c, l, s0, s1, s2, s0List, s1List, s2List, points, k;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(MovedPoints(c));
	k:=[1..l];
	s0:=c.1*MappingPermListList(k+2*l,k+l)* MappingPermListList(k+4*l,k+3*l)* MappingPermListList(k+6*l,k+5*l);
	s1:=PermList(Concatenation(k+l,k))* TranslatePerm(c.1,2*l)* TranslatePerm(c.2, 3*l)* MappingPermListList(k+5*l,k+4*l)* TranslatePerm(c.2,6*l);
	s2:=c.3*MappingPermListList(k+l,k+3*l)* MappingPermListList(k+4*l,k+2*l)* TranslatePerm(c.1,5*l)* TranslatePerm(c.1, 6*l);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Whirl,
	[IsMapOnSurface],
	function(m)
	local c, l, r01, r12, r10, r21, s0, s1, s2, s0List, s1List, s2List, points, k,x;
	c:=ConnectionGroup(m);
	points:=Orbits(Group([c.1*c.2,c.2*c.3]))[1];
	l:=Length(points);
	r01:=c.1*c.2;
	r12:=c.2*c.3;
	r10:=Inverse(r01);
	r21:=Inverse(r12);
	k:=[1..l];
	s0:=PermList(Concatenation(k+l,k,k+3*l, k+2*l, k+5*l, k+4*l, k+7*l, k+6*l,k+9*l, k+8*l, k+11*l, k+10*l, k+13*l, k+12*l));
	s1:=PermList(Concatenation(
	k+11*l, 
	k+2*l, k+l, 
	k+4*l, k+3*l, 
	k+6*l, k+5*l, 
	k+8*l, k+7*l, 
	k+10*l, k+9*l, 
	k, 
	List(k,x->Position(points,points[x]^r01))+13*l, 
	List(k,x->Position(points,points[x]^r10))+12*l));
	s2:=PermList(Concatenation(
	List(k,x->Position(points,points[x]^r21))+11*l, #0
	List(k,x->Position(points,points[x]^r21))+10*l, #1
	List(k,x->Position(points,points[x]^r01))+7*l, #2
	List(k,x->Position(points,points[x]^r01))+6*l, #3
	k+12*l, #4
	k+13*l, #5
	List(k,x->Position(points,points[x]^r10))+3*l, #6
	List(k,x->Position(points,points[x]^r10))+2*l, #7
	List(k,x->Position(points,points[x]^(r12*r01)))+9*l, #8
	List(k,x->Position(points,points[x]^(r12*r01)))+8*l, #9
	List(k,x->Position(points,points[x]^r12))+1*l, #10
	List(k,x->Position(points,points[x]^r12))+0*l, #11
	k+4*l, #12
	k+5*l #13
	));
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Volute,
	[IsMapOnSurface],
	m->Dual(Whirl(Dual(m))));

InstallMethod(JoinKisKis,
	[IsMapOnSurface],
	function(m)
	local c, l, r01, r12, r10, r21, s0, s1, s2, points, k,x;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(points);
	k:=[1..l];
	s0:=PermList(Concatenation(k+l,k, k+3*l,k+2*l, k+5*l,k+4*l, k+7*l,k+6*l));
	s1:=c.3*TranslatePerm(c.1,l)*MappingPermListList([2*l+1..8*l],Concatenation(
	[k+7*l, k+4*l, k+3*l, k+6*l, k+5*l, k+2*l]));
	s2:=PermList(Concatenation(k+2*l,k+3*l, k,k+l))* TranslatePerm(c.1,4*l)* TranslatePerm(c.1,5*l)* TranslatePerm(c.2,6*l)* TranslatePerm(c.2,7*l);
	return Maniplex(Group([s0,s1,s2]));
	end);

InstallMethod(Cross,
	[IsMapOnSurface],
		function(m)
	local c, l, r01, r12, r10, r21, s0, s1, s2, points, k,x;
	c:=ConnectionGroup(m);
	points:=MovedPoints(c);
	l:=Length(points);
	k:=[1..l];
	s0:=PermList(Concatenation(
	k+l,k, k+3*l,k+2*l, k+5*l,k+4*l, k+7*l,k+6*l, k+9*l,k+8*l ));
	s1:=PermList(Concatenation(
	k+5*l, k+2*l,k+1*l, k+4*l,k+3*l, k))* TranslatePerm(c.1, 6*l)* MappingPermListList(k+7*l,k+8*l)* TranslatePerm(c.1, 9*l);
	s2:=c.3* TranslatePerm(c.3,l)* MappingPermListList(k+2*l, k+6*l)* MappingPermListList(k+3*l, k+7*l)* TranslatePerm(c.2,4*l)* TranslatePerm(c.2, 5*l)* TranslatePerm(c.2,8*l)* TranslatePerm(c.2, 9*l);
	return Maniplex(Group([s0,s1,s2]));
	end);