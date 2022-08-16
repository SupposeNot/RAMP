BindGlobal("ManiplexFamily", NewFamily("Maniplexes", IsManiplex));
BindGlobal("PosetFamily", NewFamily("Posets", IsPoset));
BindGlobal("PosetElementFamily", NewFamily("PosetElements", IsObject));
BindGlobal("EdgeLabeledGraphFamily", NewFamily("EdgeLabeledGraphs", IsEdgeLabeledGraph));
BindGlobal("PremaniplexFamily", NewFamily("Premaniplexes", IsPremaniplex));
BindGlobal("VoltageGraphFamily", NewFamily("VoltageGraphs", IsVoltageGraph));



InstallTrueMethod(IsReflexibleManiplex, IsManiplex and IsReflexible);
InstallTrueMethod(IsManiplex and IsReflexible, IsReflexibleManiplex);
InstallTrueMethod(IsPremaniplex, IsManiplex);

InstallMethod(IsReflexibleManiplex, [IsManiplex],
	function(M)
	return IsReflexible(M);
	end);

InstallTrueMethod(IsRotaryManiplex, IsManiplex and IsRotary);
InstallTrueMethod(IsManiplex and IsRotary, IsRotaryManiplex);

InstallMethod(IsRotaryManiplex, [IsManiplex],
	function(M)
	return IsRotary(M);
	end);

InstallTrueMethod(IsRotary, IsReflexible);
InstallTrueMethod(IsRotary, IsChiral);

#For posets
InstallTrueMethod(IsPolytope, IsPoset and IsP1 and IsP2 and IsP3 and IsP4);
InstallTrueMethod(IsPrePolytope, IsPoset and IsP1 and IsP2 and IsP4);
InstallTrueMethod(IsPoset and IsP1 and IsP2 and IsP3 and IsP4,IsPolytope);
InstallTrueMethod( IsPoset and IsP1 and IsP2 and IsP4, IsPrePolytope);
InstallTrueMethod(IsFlagConnected, IsPoset and IsP3);
InstallTrueMethod(IsLattice, IsP1 and IsAllMeets and IsAllJoins);
InstallTrueMethod(IsP1 and IsAllMeets and IsAllJoins, IsLattice);
InstallTrueMethod(IsP1, IsAllMeets and IsAllJoins);
InstallTrueMethod(IsAllMeets, IsP1 and IsAllJoins);
InstallTrueMethod(IsAllJoins, IsP1 and IsAllMeets);

InstallImmediateMethod(IsMapOnSurface, IsManiplex and Tester(RankManiplex),	
	function(m)
	return Rank(m)=3;
	end);

# When we add an attribute computer, we can optionally pass in a list of
# "prerequisite attributes" of the base. Then, if the base already has
# values for those attributes, we just run the attribute computer right away.
InstallGlobalFunction(AddAttrComputer,
	function(M, attr, computer)
	local prereqs;
	prereqs := ValueOption("prereqs");
	if prereqs <> fail and ForAll(prereqs, p -> Tester(p)(M!.base)) then
		Setter(attr)(M, computer(M));
	else
		AddDictionary(M!.attr_computers, attr, computer);
	fi;
	end);

InstallGlobalFunction(ComputeAttr,
	function(M, attr)
	local computer;
	computer := LookupDictionary(M!.attr_computers, attr);
	if computer = fail then
		return fail;
	else
		return computer(M);
	fi;
	end);
