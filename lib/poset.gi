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
#	return Filtered(flags,x->(flag{ranks}=x{ranks} and not(flag=x)))[1];
	return Filtered(flags,x->(flag{ranks}=x{ranks} and flag<>x))[1];
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

InstallOtherMethod(ConnectionGeneratorOfPoset,
	[IsList,IsInt,IsList],
	function(poset,i,flagsList) #in this case we have precalculated the flagsList.
	local nFlags,imagesList,flagPosition,iNeighbor,j;
#	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	nFlags:=Length(flagsList);
	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
	for j in [1..nFlags] do
		iNeighbor:=AdjacentFlag(flagsList[j],flagsList,i);
		imagesList[j]:=Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);

InstallMethod(IsFlaggablePoset,
	[IsList],
	function(poset)
	local flags,flag,facesList,facesForFlag,ranks,x,y,truthValues;
	ranks:=Length(poset);
	flags:=DuplicateFreeList(Flat(poset));
	truthValues:=[];
	Sort(flags);
	facesList:=[];
	for flag in flags do
		for x in [1..ranks] do
			facesForFlag:=Filtered(poset[x],y->flag in y);
			Append(facesList,facesForFlag);
			od;			
		#Print([flag,Intersection(facesList)]);
		if Intersection(facesList)=[flag] then
			Append(truthValues,[true]);
		else
			Append(truthValues,[false]);
		fi;
		facesList:=[];
		od;
	return DuplicateFreeList(truthValues)=[true];
	end
);
	
InstallMethod(ConnectionGroupOfPoset,
	[IsList],
	function(poset)
	local rank,flagsList,ranks,generators,x;
	if IsFlaggablePoset(poset)=false then
		Print("This poset is not flaggable.");
		return;
	else
		rank:=Length(poset);
		ranks:=[1..rank];
		flagsList:=FlagsAsListOfFacesFromPoset(poset);
		generators:=ShallowCopy(ranks);
		Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1,flagsList));
	 	return Group(generators);
	 fi;
	end);




#Here's a sample of things you can do...
#p:=PyramidOver(HemiCube(3));
#pos:=PosetOfManiplex(p);;
#cg:=ConnectionGroup(p);
#flagList:=FlagsAsListOfFacesFromPoset(pos);;
#flagList[4];
#AdjacentFlag(flagList[4],flagList,3);
#conG:=ConnectionGroupOfPoset(pos);
#GeneratorsOfGroup(cg)=GeneratorsOfGroup(conG);