###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...
#Probably need to figure out how to go from Poset TO connection group.




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
	Add(poset,[[]],1);
	Add(poset,[flags]);
	return poset;
	end);




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
	Add(poset,[[]],1);
	Add(poset,[flags]);
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
	

InstallMethod(FlagsAsListOfFacesFromPoset,
	[IsList],
	function(poset)
	local flags,size,flagList,rank,i,flag;
	flags:=DuplicateFreeList(Flat(poset));
	Sort(flags);
	size:=Length(flags);
	rank:=Length(poset);
	flagList:=ShallowCopy(flags);
	Apply(flagList, x->List([1..rank],i->[]));
	for flag in flags do
		for i in [1..rank] do
			flagList[flag][i]:=Filtered(poset[i],x-> flag in x)[1]; #Might want to have a precheck that makes sure that poset doesn't have more than one face at each rank containing each flag.
			od;
		od;
	return flagList;
	end);	


InstallMethod(AdjacentFlag,
	[IsList,IsList,IsInt],
	function(flag,flags,i)
	#Note that flag and list of flags here are assumed to be given as lists of incident faces in increasing order. the variable i is the rank of the adjacency (indexed from 0)
	local n,ranks;
	n:=Length(flag);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	return Filtered(flags,x->(flag{ranks}=x{ranks} and not(flag=x)))[1];
	end);
	

InstallMethod(ConnectionGeneratorOfPoset,
	[IsList,IsInt],
	function(poset,i) # here i is the rank of the generator, e.g., 0 is the rank of the generator for 0-connections.
	local flagsList,nFlags,imagesList,flagPosition,iNeighbor,j;
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	nFlags:=Length(flagsList);
	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
	for j in [1..nFlags] do
		iNeighbor:=AdjacentFlag(flagsList[j],flagsList,i);
		imagesList[j]:=Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);
	

InstallMethod(ConnectionGroupOfPoset,
	[IsList],
	function(poset)
	local rank,flagsList,ranks,generators;
	rank:=Length(poset);
	ranks:=[1..rank];
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	generators:=ShallowCopy(ranks);
	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
	return Group(generators);
	end);


#Todo item: rewrite some of this code so it is more efficient, e.g., reorganizing so that the flagslist isn't being regenerated quite so often.