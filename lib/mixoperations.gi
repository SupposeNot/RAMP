InstallMethod(Mix,
	[IsPermGroup, IsPermGroup],
	function(gp,gq)
	local gens1, r1, gens2, r2, N1, gensnew, i, L1, L2;
	gens1:=GeneratorsOfGroup(gp);
	r1:=Size(gens1);
	gens2:=GeneratorsOfGroup(gq);
	r2:=Size(gens2);	
	N1:=Size(MovedPoints(gp));
	gensnew:=[];
	for i in [1..Maximum(r1,r2)] do	
		if i > r1 then
		L1:=[1..N1];
		else
		L1:=ListPerm(gens1[i]);
		fi;
		if i > r2 then
		L2:=[N1+1 .. N1+Size(MovedPoints(gq))];
		else
		L2:=ListPerm(gens2[i])+N1;
		fi;
		Append(L1,L2);
		Add(gensnew,PermList(L1));
	od; 
	return Group(gensnew);
	end);


InstallMethod(Mix,
	[IsFpGroup, IsFpGroup],
	function(gp,gq)
	local r1, r2, D, Dgens, gensnew, i;
	r1:=Size(GeneratorsOfGroup(gp));
	r2:=Size(GeneratorsOfGroup(gq));
	D:=DirectProduct(gp,gq);
	Dgens:=GeneratorsOfGroup(D);
	gensnew:=[];
	for i in [1..Minimum(r1,r2)] do
	Add(gensnew,Dgens[i]*Dgens[i+r1]);
	od;
	for i in [Minimum(r1,r2)+1.. Maximum(r1,r2)] do
	if r1 < r2 then
	Add(gensnew,Dgens[r1+i]);
	else
	Add(gensnew,Dgens[i]);
	fi;
	od;
	return Group(gensnew);
	end);

InstallMethod(Mix,
	[IsManiplex, IsManiplex],
	function(p,q)
	return ReflexibleManiplex(Mix(ConnectionGroup(p),ConnectionGroup(q)));
	end);

InstallMethod(Comix,
	[IsFpGroup, IsFpGroup],
	function(gp,gq)
	local g;
	g := FactorGroupFpGroupByRels(gp, List(RelatorsOfFpGroup(gq), UnderlyingElement));
	return g;
	end);

InstallMethod(Comix,
	[IsReflexibleManiplex, IsReflexibleManiplex],
	function(p,q)
	return ReflexibleManiplex(Comix(AutomorphismGroupFpGroup(p),AutomorphismGroupFpGroup(q)));
	end);

InstallMethod(CtoL,
	[IsInt,IsInt,IsInt,IsInt],
	function(a,b,N,M)
	return  a+(b-1)*N;
	end);

InstallMethod(LtoC,
	[IsInt,IsInt,IsInt],
	function(k,N,M)
  	return [k-N*(Int((k-1)/N)),Int((k-1)/N)+1];
	end);

InstallMethod(FlagMix,
	[IsManiplex, IsManiplex],
	function(p,q)
	local gp, gq, gensp , r1, gensq, r2, Np, Nq, gensnew,  i, r, j;
	gp:=ConnectionGroup(p);
	gq:=ConnectionGroup(q);
	gensp:=GeneratorsOfGroup(gp);
	r1:=Size(gensp);
	gensq:=GeneratorsOfGroup(gq);
	r2:=Size(gensq);
	Np:= LargestMovedPoint(gp);
	Nq:= LargestMovedPoint(gq);;
	gensnew:=[];
	for i in [1..Maximum(r1,r2)] do
		Add(gensnew,[]);
	od;
	for r in [1..Minimum(r1,r2)] do
    		for i in [1..Np] do
    		for j in [1..Nq] do
    			gensnew[r][CtoL(i,j,Np,Nq)]:=CtoL(i^gensp[r],j^gensq[r],Np,Nq);
  		od;
  		od;
	od;
	for r in [Minimum(r1,r2)+1.. Maximum(r1,r2)] do
  		if r1 < r2 then
    			for i in [1..Np] do
    			for j in [1..Nq] do
      				gensnew[r][CtoL(i,j,Np,Nq)]:=CtoL(i,j^gensq[r],Np,Nq);
    			od;
    			od;
  		else
    			for i in [1..Np] do
    			for j in [1..Nq] do
      				gensnew[r][CtoL(i,j,Np,Nq)]:=CtoL(i^gensp[r],j,Np,Nq);
    			od;
    			od;
  		fi;
	od;
	Apply(gensnew, i -> PermList(i));
	return   Maniplex(Action(Group(gensnew),Orbit(Group(gensnew),1)));
	end);


