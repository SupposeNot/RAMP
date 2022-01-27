
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