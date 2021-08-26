
InstallMethod(Epsilonk,
	[IsInt],
	function(k)
	local p, q;
	if k<=0 then Error("Not an integer>0."); fi;
	return ARP([k,2]);
	end);

InstallMethod(Deltak,
	[IsInt],
	function(k)
	local p;
	if k<=0 then Error("Not an integer>0.");
	else return ARP([2*k,2],Concatenation("(r0 r1)^",String(k)," r2"));
	fi;
	end);

InstallMethod(Mk,
	[IsInt],
	function(k)
	if k<=0 then Error("Not an integer >0");
	elif k mod 2=0 then
		return ARP([2*k,2*k],Concatenation("(r0 r1)^",String(k)," r0 = r2"));
	else
		return ARP([2*k, k], Concatenation("(r0 r1)^",String(k)," r0 = r2"));
	fi;
	end);
	
InstallMethod(MkPrime,
	[IsInt],
	k->Opp(Epsilonk(k)));
	
InstallMethod(Opp,
	[IsReflexibleManiplex],
	map->Petrial(Dual(Petrial(map))));
	
InstallMethod(Hole,
	[IsReflexibleManiplex,IsInt],
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