
InstallMethod(Epsilonk,
	[IsInt],
	function(k)
	local p, q;
	if k<=0 then Error("Not an integer>0."); fi;
	if k mod 2 = 0 then
		p:=ARP(UniversalSggi([k,2]));
		q:=ReflexibleQuotientManiplex(p,PetrieRelation(3,k));
		return q;
	else
		p:=ARP(UniversalSggi([k,2]));
		q:=ReflexibleQuotientManiplex(p,PetrieRelation(3,2*k));
		return q;
	fi;
	end);


InstallMethod(Deltak,
	[IsInt],
	function(k)
	local p,q;
	if k<=0 then Error("Not an integer>0."); fi;
	if k mod 2 = 0 then
		q:=Concatenation("{",String(k),",2}");;
		return ARP(q);
	else
		p:=ARP(UniversalSggi([2*k,2]));
		q:=ReflexibleQuotientManiplex(p,PetrieRelation(3,k));
		return q;
	fi;
	end);