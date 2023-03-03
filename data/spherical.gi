
InstallMethod(ReflectionMatrix, 
	[IsVector],
	function(vec)
	local m,e,dim,newVec;
	dim:=Length(vec);
	newVec:=(1/Sqrt(vec*vec))*vec;
	e:=List([1..dim],x->List([1..dim],x->0));
	for i in [1..dim] do e[i,i]:=1;od;
	m:=[1..dim];
	for i in [1..dim] do 
		m[i]:=e[i]-(2*e[i]*newVec) * newVec;
		od;
	return m;
	end);



# InstallMethod(IsStringy,
# 	[IsGroup],
# 	function(g)
# 	local gens, i, j;
# 	
# 	gens := GeneratorsOfGroup(g);
# 	for i in [1..Size(gens)-2] do
# 		for j in [i+2..Size(gens)] do
# 			if gens[i]*gens[j] <> gens[j]*gens[i] then return false; fi;
# 		od;
# 	od;
# 	return true;
# 	end);

InstallMethod(RotationMatrix,
	[IsInt],
	function(p)
	local m,c,s;
	c:=RealPart(E(p));
	s:=ImaginaryPart(E(p));
	m:=[[c,-s,0],[s,c,0],[0,0,1]];
	return m;
	end);
	