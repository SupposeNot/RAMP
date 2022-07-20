
#Constructors
InstallMethod(Epsilonk,
	[IsInt],
	function(k)
	local p, q, M;
	if k<=0 then Error("Not an integer>0."); fi;
	M := AbstractRegularPolytopeNC([k,2]);
	SetPetrieLength(M, Lcm(k,2));
	return M;
	end);

InstallMethod(Deltak,
	[IsInt],
	function(k)
	local M, r0, r1, r2;
	if k<=0 then Error("Not an integer>0.");
	else 
		M := ReflexibleManiplex([2*k,2],Concatenation("(r0 r1)^",String(k)," r2") : set_schlafli);
		SetSize(M, 4*k);
		SetIsPolytopal(M, false);
		r0 := PermFromRange((1,2), (4*k-1, 4*k));
		r1 := (1,4*k) * PermFromRange((2,3), (4*k-2, 4*k-1));
		r2 := (r0*r1)^k;
		SetConnectionGroup(M, Group(r0,r1,r2));
		SetIsFlat(M, true);
		return M;
	fi;
	end);

InstallMethod(Mk,
	[IsInt],
	function(k)
	local M, r0, r1, r2;
	if k<=0 then Error("Not an integer >0");
	elif k mod 2=0 then
		M := ReflexibleManiplex([2*k,2*k],Concatenation("(r0 r1)^",String(k)," r0 = r2") : set_schlafli);
	else
		M := ReflexibleManiplex([2*k, k], Concatenation("(r0 r1)^",String(k)," r0 = r2") : set_schlafli);
	fi;

	SetSize(M, 4*k);
	SetIsPolytopal(M, false);
	
	r0 := PermFromRange((1,2), (4*k-1, 4*k));
	r1 := (1,4*k) * PermFromRange((2,3), (4*k-2, 4*k-1));
	r2 := (r0*r1)^k * r0;
	SetConnectionGroup(M, Group(r0,r1,r2));
	SetIsFlat(M, true);
	return M;

	end);

#InstallMethod(MkPrime,
#	[IsInt],
#	k->Opp(Epsilonk(k)));

InstallMethod(MkPrime,
	[IsInt],
	function(k)
	local M;
	if IsEvenInt(k) then
		M := ReflexibleManiplex([k, k], "(r0 r1 r2)^2" : set_schlafli);
	else
		M := ReflexibleManiplex([k, 2*k], "(r0 r1 r2)^2" : set_schlafli);
	fi;

	SetSize(M, 4*k);
	
	# Only MkPrime(2) is polytopal
	SetIsPolytopal(M, k = 2);

	return M;

	end);


InstallOtherMethod(MkPrime,
	[IsInt,IsBool],
	function(k,truth)
	local r0f,r1f,r2f,r0,r1,r2;
	if truth<>true then return MkPrime(k);fi;
	r0f:=function(n,k) local temp;
		temp:=n-1;
		if IsEvenInt(temp) then
			return (temp+1) mod (4*k) +1;
		else 
			return (temp-1) mod (4*k) +1;
		fi;
		end;
	r1f:=function(n,k)
		if n =1 then return 2*k;
		elif n =2*k+1 then return 4*k;
		elif n =2*k then return 1;
		elif n =4*k then return 2*k+1;
		elif IsEvenInt(n) then return n+1;
		else return n-1;
		fi;
		end;
	r0:=PermList(List([1..4*k],x->r0f(x,k)));
	r1:=List([1..4*k],x->r1f(x,k));
	r1:=PermList(r1);
	r2f:=function(n,k) local step;
		if n<=2*k then
			step:=Int(Floor(Float((n-1)/2)));
			return (-step mod k)*2 +2*(k+1) -(n mod 2);
		else
			step:=Int(Floor(Float((n-1)/2)))-k;
			return (-step mod k)*2+2-(n mod 2);
		fi;
		end;
	r2:=PermList(List([1..4*k],x->r2f(x,k)));
	return Maniplex(Group([r0,r1,r2]));
	end);	


InstallOtherMethod(MkPrime,
	[IsInt,IsInt],
	function(k,i)
	local q;
	if  ((i^2 mod k) <>1) then Error("Need i^2 mod k<>1.");
	else 
		q:=2*(k)/Gcd(k,i+1);
		return ReflexibleManiplex([k , q],Concatenation("r2 r1 r0 r2 (r1 r0)^",String(i)));
	fi;
	end);
	
InstallMethod(Bk2l,
	[IsInt,IsInt],
	function(k,l)
	local l0, l1, l2, r0, r1, r2, r0f, r1f, r2f, blocklength;
	if k mod 2 <> 0  then Error("k must be even."); fi;
	blocklength:=2*2*l;
	r0f:=function(n,l) local temp,value;
		temp:=n-1;
		if IsEvenInt(temp) then
			value:=(temp+1) mod (k*2*2*l) +1;
		else value:=(temp-1) mod (k*2*2*l) +1;
		fi;
		return value;
		end;
	r1f:=function(n,l) local temp,value;
		temp:=n-1;
		if IsEvenInt(temp) then
			value:=(temp-1) mod (2*2*l) +1;
		else value:=(temp +1) mod (2*2*l) +1;
		fi;
		return value;
		end;
	r0:=PermList(List([1..blocklength*k],x->r0f(x,l)));
	r1:=List([1..2*2*l],x->r1f(x,l));
	r1:=PermList(Concatenation(List([0..k-1],x->r1+x*2*2*l)));
	r2f:=function(n,k,l) local temp, value, testl, testk, block;
		temp:=n-1; testl:=Int(Floor(Float(temp mod (4*l))/2));
		testk:=Int(Floor(Float(temp/(2*2*l)))); block:=2*2*l;
		if testk=0 and IsEvenInt(testl) then
			return (temp+(k-1)*block) mod (block*k) +1;
		elif testk=k-1 and IsEvenInt(testl) then 
			return (temp+block) mod (block*k) +1;
		elif IsEvenInt(testk) and IsOddInt(testl) then 
			return (temp + block) mod (block*k) +1;
		elif IsEvenInt(testk) and IsEvenInt(testl) then 
			return (temp - block) mod (block*k) +1;
		elif IsOddInt(testk) and IsOddInt(testl) then 
			return (temp - block) mod (block*k) +1;
		elif IsOddInt(testk) and IsEvenInt(testl) then 
			return (temp + block) mod (block*k) +1;
		fi;
		end;
	r2:=PermList(List([1..2*2*l*k],n->r2f(n,k,l)));
	return Maniplex(Group([r0,r1,r0*r2]));
	end);

InstallMethod(Bk2lStar,
	[IsInt,IsInt],
	function(k,l)
	local l0, l1, l2, r0, r1, r2, r0f, r1f, r2f, blocklength;
	if (k mod 2) <> (l mod 2) then Error("k and l must have same parity."); fi;
	blocklength:=2*2*l;
	r0f:=function(n,l) local temp,value;
		temp:=n-1;
		if IsEvenInt(temp) then
			value:=(temp+1) mod (k*2*2*l) +1;
		else value:=(temp-1) mod (k*2*2*l) +1;
		fi;
		return value;
		end;
	r1f:=function(n,l) local temp,value;
		temp:=n-1;
		if IsEvenInt(temp) then
			value:=(temp-1) mod (2*2*l) +1;
		else value:=(temp +1) mod (2*2*l) +1;
		fi;
		return value;
		end;
	r0:=PermList(List([1..blocklength*k],x->r0f(x,l)));
	r1:=List([1..2*2*l],x->r1f(x,l));
	r1:=PermList(Concatenation(List([0..k-1],x->r1+x*2*2*l)));
	r2f:=function(n,k,l) local temp, value, testl, testk, block;
		temp:=n-1; testl:=Int(Floor(Float(temp mod (4*l))/2));
		testk:=Int(Floor(Float(temp/(2*2*l)))); block:=2*2*l;
		if testk=0 and IsEvenInt(testl) and temp<2*l then
			return (temp+(k-1)*block+2*l) mod (block*k) +1;
		elif testk=0 and IsEvenInt(testl) and temp>=2*l then
			return (temp+(k-1)*block-2*l) mod (block*k) +1;
		elif testk=k-1 and IsOddInt(testl) and IsOddInt(k) and temp mod (4*l)>=2*l then 
			return (temp+block-2*l) mod (block*k) +1;
		elif testk=k-1 and IsOddInt(testl) and IsOddInt(k) and temp mod (4*l)<2*l then 
			return  (temp-(k-1)*block+2*l) mod (block*k) +1;
		elif testk=k-1 and IsEvenInt(testl) and IsEvenInt(k) and temp mod (4*l)>=2*l then
			return (temp -(k-1)*block-2*l) mod (block*k) +1;
		elif testk=k-1 and IsEvenInt(testl) and IsEvenInt(k) and temp mod (4*l)<2*l then
			return (temp -(k-1)*block+2*l) mod (block*k) +1;
		elif IsEvenInt(testk) and IsOddInt(testl) then 
			return (temp + block) mod (block*k) +1;
		elif IsEvenInt(testk) and IsEvenInt(testl) then 
			return (temp - block) mod (block*k) +1;
		elif IsOddInt(testk) and IsOddInt(testl) then 
			return (temp - block) mod (block*k) +1;
		elif IsOddInt(testk) and IsEvenInt(testl) then 
			return (temp + block) mod (block*k) +1;
		fi;
		end;
	r2:=PermList(List([1..2*2*l*k],n->r2f(n,k,l)));
# 	return List([1..4*k*l], x->[x,r2f(x,k,l)]);
	return Maniplex(Group([r0,r1,r0*r2]));
	end);

	
#Operations
	
InstallMethod(Opp,
	[IsMapOnSurface],
	map->Petrial(Dual(Petrial(map))));
	
InstallMethod(Hole,
	[IsMapOnSurface,IsInt],
	function(m,j)
	local g, hole, hgp, orbs, act;
	if Rank(m)<>3 then Error("Not a map.");fi;
	g:=ConnectionGroup(m);
	hole:=(g.2 *g.3)^(j-1) *g.2;
	hgp:=Group([g.1,hole,g.3]);
	orbs:=Orbits(hgp);
	act:=Action(hgp,orbs[1]);
	return Maniplex(act);
	end);	
	
