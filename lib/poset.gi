
###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...

#Note: The following function is INTENTIONALLY agnostic about whether it is being given full poset or not. I should probably fix that so that it will report a problem if the first entry isn't [[]] and the last entry has length more than 1. I should do something similar for atomic posets.


# This is where I'm storing low level code for things like display and view.






InstallMethod(DisplayString,
	[IsPosetOfFlags],
	function(poset)
	local string, ranks, n, shift, i;
	string:="This is a poset of rank ";
	Append(string,String(Rank(poset)));
	Append(string, Concatenation(" with ", String(Size(ElementsList(poset))), " elements"));
	if HasMaximalChains(poset) then
		Append(string, Concatenation(" and ", String(Size(MaximalChains(poset)))," flags"));
		fi;
	Append(string,".\n");
	if HasIsPolytope(poset) then
		if IsPolytope(poset) then Append(string, "It is a polytope.\n");fi;
	elif HasIsPrePolytope(poset) then
		if IsPrePolytope(poset) then Append(string, "It is  pre-polytope.\n");fi;
	fi;
	return string;
	end);
	

InstallMethod(PrintString,
	[IsPosetOfFlags],
	function(poset)
	local string;
	string:= Concatenation("PosetFromFaceListOfFlags(", String(poset!.faces_list_by_rank), ");");
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

InstallMethod(PrintString,
	[IsPosetOfIndices and HasElementsList],
	function(poset)
	local string, successors, PO, els;
	els:=List(ElementsList(poset),ElementObject);
	PO:=ElementOrderingFunction(ElementsList(poset)[1]);
	string:=Concatenation("PosetFromElements(",String(els),",",String(PO),")");
	return string;
	end);

InstallMethod(PrintString,
	[IsPosetOfIndices],
	function(poset)
	local string, successors,PO;
	successors:=Successors(PartialOrder(poset));
# 	PO:=BinaryRelationOnPoints(successors);
	string:=Concatenation( "PosetFromPartialOrder( BinaryRelationOnPoints(", String(successors), "))");
	return string;
	end);





# InstallMethod(Rank,[IsFace],RankFace);

InstallMethod(DisplayString,
	[IsFace],
	function(face)
	local string, elobj;
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
posetFM:=function(n) return PosetFromManiplex(PyramidOver(Cube(n)));end;
posetFE:=function(n) return PosetFromElements(ElementsList(posetFM(n)),IsSubface);end;
posetFG:=function(n) return PosetFromConnectionGroup(ConnectionGroup(posetFE(n))); end;
pbad:=function() local g,a,p; g:=AlternatingGroup(4); a:=AllSubgroups(g); p:=PosetFromElements(a,IsSubgroup); return p; end;
# posetFA:=function() return 
# posetFM:=PosetFromManiplex(HemiCube(3));
# posetFE:=PosetFromElements(ElementsList(posetFM),IsSubface);
# posetFG:= PosetFromConnectionGroup(ConnectionGroup(posetFE));