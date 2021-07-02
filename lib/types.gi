BindGlobal("ManiplexFamily", NewFamily("Maniplexes", IsManiplex));
BindGlobal("PosetFamily", NewFamily("Posets", IsPoset));
BindGlobal("PosetElementFamily", NewFamily("PosetElements", IsObject));

InstallTrueMethod(IsReflexibleManiplex, IsManiplex and IsReflexible);
InstallTrueMethod(IsManiplex and IsReflexible, IsReflexibleManiplex);
InstallTrueMethod(IsRotaryManiplex, IsManiplex and IsRotary);
InstallTrueMethod(IsManiplex and IsRotary, IsRotaryManiplex);
InstallTrueMethod(IsPolytope, IsManiplex and IsPolytopal);
InstallTrueMethod(IsManiplex and IsPolytopal, IsPolytope);
InstallTrueMethod(IsRegularPolytope, IsPolytope and IsReflexible);
InstallTrueMethod(IsPolytope and IsReflexible, IsRegularPolytope);

InstallGlobalFunction(AddAttrComputer,
	function(M, attr, computer)
	AddDictionary(M!.attr_computers, attr, computer);
	end);

# What if the attribute doesn't have a computer?	
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
