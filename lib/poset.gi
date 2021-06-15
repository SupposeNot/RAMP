###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...
#Probably need to figure out how to go from Poset TO connection group.


InstallMethod(PosetFromFaceListOfFlags,
	[IsList],
	function(list)
	local fam, poset;
	fam:=NewFamily("Poset From Flags Description",IsPosetOfFlags);
	poset:=Objectify(NewType(fam, IsPoset and IsPosetOfFlags), rec(faces_list_by_rank:=list));
	return(poset);
	end);

InstallMethod(RankOfPoset,
	[IsPosetOfFlags],
	function(poset)
	local list;
	list:=poset!.faces_list_by_rank;
	if HasIsFullPoset(poset)=false then
		SetIsFullPoset(poset,ListIsFullPoset(list));
	fi;
	if IsFullPoset(poset) then
		SetRankPoset(poset,Length(list)-2);
	else
		SetRankPoset(poset,Length(list));
	fi;
	return poset!.RankPoset;	
	end);

InstallOtherMethod(Rank, [IsPosetOfFlags], RankOfPoset);

InstallMethod(ListIsFullPoset,
	[IsList],
	function(list)
	local rank,flags;
	flags:=DuplicateFreeList(Flat(list));
	Sort(flags);
	rank:=Length(list);
	if list[1]=[[]] and list[rank]=[flags] then
		return true;
	else
		return false;
	fi;
	Print("Something went wrong");
	return;
	end);

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
	return PosetFromFaceListOfFlags(poset);
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
	return PosetFromFaceListOfFlags(poset);
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
	return PosetFromFaceListOfFlags(poset);
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
	return PosetFromFaceListOfFlags(poset);
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
	[IsPosetOfFlags],
	function(poset)
	local faceList, flags, size, flagList, rank, i, flag;
	faceList:=poset!.faces_list_by_rank;
	flags:=DuplicateFreeList(Flat(faceList));
	Sort(flags);
	size:=Length(flags);
	rank:=Length(faceList);
	flagList:=ShallowCopy(flags);
	Apply(flagList, x->List([1..rank],i->[]));
	for flag in flags do
		for i in [1..rank] do
			flagList[flag][i]:=Filtered(faceList[i],x-> flag in x)[1]; #Might want to have a precheck that makes sure that poset doesn't have more than one face at each rank containing each flag.
			od;
		od;
	return flagList;
	end);	
#Doesn't handle full posets yet.


InstallMethod(AdjacentFlag,
	[IsList,IsPosetOfFlags,IsInt],
	function(flag,poset,i)
	#Note that flag and list of flags here are assumed to be given as lists of incident faces in increasing order. the variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags;
	flags:=FlagsAsListOfFacesFromPoset(poset);
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	return Filtered(flags,x->(flag{ranks}=x{ranks} and flag<>x))[1];
	end);

InstallOtherMethod(AdjacentFlag,
	[IsInt,IsPosetOfFlags,IsInt],
	function(flag,poset,i)
	#The variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags;
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	flags:=FlagsAsListOfFacesFromPoset(poset);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
	end);


InstallMethod(ConnectionGeneratorOfPoset,
	[IsPosetOfFlags,IsInt],
	function(poset,i) # here i is the rank of the generator, e.g., 0 is the rank of the generator for 0-connections.
	local flagsList,nFlags,imagesList,flagPosition,iNeighbor,j;
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	nFlags:=Length(flagsList);
	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
	for j in [1..nFlags] do
		iNeighbor:=AdjacentFlag(j,poset,i);
		imagesList[j]:=Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);


# 
# InstallOtherMethod(ConnectionGeneratorOfPoset,
# 	[IsList,IsInt,IsList],
# 	function(poset,i,flagsList) #in this case we have precalculated the flagsList.
# 	local nFlags,imagesList,flagPosition,iNeighbor,j;
# #	flagsList:=FlagsAsListOfFacesFromPoset(poset);
# 	nFlags:=Length(flagsList);
# 	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
# 	for j in [1..nFlags] do
# 		iNeighbor:=AdjacentFlag(flagsList[j],flagsList,i);
# 		imagesList[j]:=Position(flagsList,iNeighbor);
# 		od;
# 	return PermutationOfImage(Transformation(imagesList));
# 	end);


InstallMethod(IsFlaggablePoset,
	[IsPosetOfFlags],
	function(poset)
	local flags,flag,facesList,facesForFlag,ranks,x,y,truthValues, result;
	if ListIsFullPoset(poset!.faces_list_by_rank) then
		ranks:=[2..Rank(poset)+1];
	else
		ranks:=[1..Rank(poset)];
	fi;
	flags:=DuplicateFreeList(Flat(poset!.faces_list_by_rank));
	truthValues:=[];
	Sort(flags);
	facesList:=[];
	for flag in flags do
		for x in ranks do
			facesForFlag:=Filtered(poset!.faces_list_by_rank[x],y->flag in y);
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
	result:= DuplicateFreeList(truthValues)=[true];
	SetFlaggable(poset,result);
	return result;
	end
);

InstallMethod(ConnectionGroupOfPoset,
	[IsPosetOfFlags],
	function(poset)
	local rank,facelist,flagsList,ranks,generators,x;
	if IsFlaggablePoset(poset)=false then
		Print("This poset is not flaggable.");
		return;
	fi;
	facelist:=poset!.faces_list_by_rank;
	if ListIsFullPoset(facelist) then
		ranks:=[2..Rank(poset)+1];
	else
		ranks:=[1..Rank(poset)];
	fi;
	facelist:=facelist{ranks};	
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	generators:=ShallowCopy(ranks);
	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
	return Group(generators);
	end);
#Can't handle full posets yet.




#Here's a sample of things you can do...
#p:=PyramidOver(HemiCube(3));
#pos:=PosetOfManiplex(p);;
#cg:=ConnectionGroup(p);
#flagList:=FlagsAsListOfFacesFromPoset(pos);;
#flagList[4];
#AdjacentFlag(flagList[4],flagList,3);
#conG:=ConnectionGroupOfPoset(pos);
#GeneratorsOfGroup(cg)=GeneratorsOfGroup(conG);

#If you want to play with the flaggable stuff... m44 is the {4,4}_(1,0) map.
#m44:=ReflexibleManiplex(Group([(1,8)(2,3)(4,5)(6,7),(1,2)(3,4)(5,6)(7,8),(1,4)(2,7)(3,6)(5,8)]);
#m44pos:=PosetOfManiplex(m44);
#IsFlaggablePoset(m44);
#IsFlaggablePoset(pos);