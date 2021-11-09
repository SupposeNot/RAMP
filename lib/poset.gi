
###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...

#Note: The following function is INTENTIONALLY agnostic about whether it is being given full poset or not. I should probably fix that so that it will report a problem if the first entry isn't [[]] and the last entry has length more than 1. I should do something similar for atomic posets.


# This is where I'm storing low level code for things like display and view.





InstallMethod(DisplayString,
	[IsPoset],
	function(poset)
	local string, prop, attr;
	string:="A poset of rank ";
	Append(string, String(Rank(poset)));
	Append(string, " with ");
	Append(string, String(Size(ElementsList(poset))));
	Append(string," elements.\n");
	for prop in KnownPropertiesOfObject(poset) do
		Append(string, prop);
		Append(string, ": ");
		Append(string, String(Tester(EvalString(prop))(poset)));
		Append(string, "\n");
	od;
	Append(string, "Information is available for the following attributes of the poset have already been computed: \n");
	attr:=KnownAttributesOfObject(poset);
	Append(string, String(attr));
	return string;
	end);

	
InstallMethod(PrintString,
	[IsPosetOfFlags],
	function(poset)
	local string;
	string:="PosetFromSuccessorList(";
	Append(string,String(HasseDiagramOfPoset(poset).adjacencies));
	Append(string,");");
	return string;
	end);
	
InstallMethod(ViewString,
	[IsPoset],
	function(poset)
	local faces, string;
	string:="A poset";
	if HasRankPoset(poset) then Append(string,Concatenation(" of rank ",String(Rank(poset))));fi;
	if HasElementsList(poset) then Append(string, Concatenation(" on ", String(Size(ElementsList(poset))), " elements"));fi;
	if IsPosetOfIndices(poset) then Append(string," using the IsPosetOfIndices representation");fi;
	if IsPosetOfFlags(poset) then Append(string, " using the IsPosetOfFlags representation");fi;
	Append(string,".");
	return string;
	end);


InstallMethod(DisplayString,
	[IsFace],
	function(face)
	local string, elobj, attr, prop;
	string:="An element of a poset";
	if HasElementObject(face) then
		elobj:=ElementObject(face);
# 		if HasRanksInPosets(elobj) then Append(string, Concatenation(" of rank ", String(RankPosetElement(elobj))));fi;
		if HasFlagList(elobj) then Append(string, Concatenation(" corr. to flags ", String(FlagList(elobj))));fi;
		if HasAtomList(elobj) then Append(string, Concatenation(" made up of atoms ", String(AtomList(elobj))));fi;
		if HasIndex(elobj) then Append(string,Concatenation(" with index=",String(Index(elobj)))); fi;
	else
# 		if HasRankPosetElement(face) then Append(string, Concatenation(" of rank ", String(RankPosetElement(face))));fi;
		if HasFlagList(face) then Append(string, Concatenation(" corr. to flags ", String(FlagList(face))));fi;
		if HasAtomList(face) then Append(string, Concatenation(" made up of atoms ", String(AtomList(face))));fi;
		if HasIndex(face) then Append(string,Concatenation(" with index=",String(Index(face)))); fi;
	fi;
	Append(string,".\n");
	attr:=KnownAttributesOfObject(face);
	prop:=KnownPropertiesOfObject(face);
	Append(string,"Computed attributes of face are ");
	Append(string, String(attr));
	Append(string,".\n");	
	Append(string,"Computed properties of face are ");
	Append(string,String(prop));
	Append(string,".\n");
	return string;
	end);


# InstallMethod(ViewObj,
# 	[IsFace],
# 	function(face)
# 	Display(face);
# 	end);

InstallMethod(ViewString,
	[IsFace],
	function(face)
	local string, elobj;
	string:="An element of a poset";
	if HasElementObject(face) then
		elobj:=ElementObject(face);
		if HasFlagList(elobj) then Append(string, " made up of flags");fi;
		if HasAtomList(elobj) then Append(string, " made up of atoms");fi;
		if HasIndex(elobj) then Append(string," with index"); fi;
	else
		if HasFlagList(face) then Append(string, " made of flags");fi;
		if HasAtomList(face) then Append(string, " made up of atoms");fi;
		if HasIndex(face) then Append(string," with index"); fi;
	fi;
# 	Append(string,".");
	return string;
	end);




# Some test objects:
posetFM:=function(n) return PosetFromManiplex(Pyramid(Cube(n)));end;
posetFE:=function(n) return PosetFromElements(ElementsList(posetFM(n)),IsSubface);end;
posetFG:=function(n) return PosetFromConnectionGroup(ConnectionGroup(posetFE(n))); end;
pbad:=function() local g,a,p; g:=AlternatingGroup(4); a:=AllSubgroups(g); p:=PosetFromElements(a,IsSubgroup); return p; end;
testPosets:=function (n) return [posetFM(n),posetFE(n),posetFG(n),pbad()]; end;
# posetFA:=function() return 
# posetFM:=PosetFromManiplex(HemiCube(3));
# posetFE:=PosetFromElements(ElementsList(posetFM),IsSubface);
# posetFG:= PosetFromConnectionGroup(ConnectionGroup(posetFE));