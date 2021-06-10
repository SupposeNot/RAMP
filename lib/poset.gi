###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...


#! @Chapter Combinatorics and Structure
#! @Section Posets

#! @Arguments g
#! @Returns a full poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. This function does include the minimal (empty) face nor the maximal face of the maniplex, so the list has <A>n+2</A> ranks if the maniplex is of rank <A>n</A>. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.
InstallMethod(FullPosetOfConnectionGroup, 
	[IsGroup],
	function(g)
	local conng,poset,flags,rank,gens,genIndexes,i;
	rank:=Length(GeneratorsOfGroup(g));
	if IsPermGroup(g)=true then 
		conng:=g;
	else
		Print("Group was not given as a permutation group, may not be a connection group. Treat results with suspicion.\n");
		conng:=Image(IsomorphismPermGroup(g));
	fi;
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	poset:=[];
	for i in [1..rank] do
		Append(poset,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	Add(poset,[],1);
	Add(poset,flags);
	return poset;
	end);


#! @Arguments g
#! @Given a group, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.

InstallMethod(PosetOfConnectionGroup,
	[IsGroup],
	function(g)
	local conng,poset,flags,rank,gens,genIndexes,i;
	if IsPermGroup(g)=true then 
		conng:=g;
	else
		Print("Group was not given as a permutation group, may not be a connection group. Treat results with suspicion.\n");
		conng:=Image(IsomorphismPermGroup(g));
	fi;
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	poset:=[];
	for i in [1..rank] do
		Append(poset,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	return poset;
	end);
	


#! @Arguments mani
#! @Given a maniplex, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.

InstallMethod(PosetOfManiplex,
	[IsManiplex],
	function(mani)
	local conng,poset,flags,rank,gens,genIndexes,i;
	conng:=ConnectionGroup(mani);
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	poset:=[];
	for i in [1..rank] do
		Append(poset,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	return poset;
	end);
	
	
#! @Arguments mani
#! @Given a maniplex, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does include the minimal (empty) face and the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.

InstallMethod(FullPosetOfManiplex,
	[IsManiplex],
	function(mani)
	local conng,poset,flags,rank,gens,genIndexes,i;
	conng:=ConnectionGroup(mani);
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	poset:=[];
	for i in [1..rank] do
		Append(poset,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	Add(poset,[],1);
	Add(poset,flags);
	return poset;
	end);	

InstallMethod(AreIncidentFaces,
	[IsList,IsList],
	function(list1,list2)
	if list1=[] or list2=[] then
		return true;
	elif Intersection(list1,list2)=[] then
		return false;
	else
		return true;
	fi;
	return "Was unable to evaluate for some reason.\n";
	end);	
	
