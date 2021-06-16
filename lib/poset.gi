###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...
#Probably need to figure out how to go from Poset TO connection group.

#Note: The following function is INTENTIONALLY agnostic about whether it is being given full poset or not.
InstallMethod(PosetFromFaceListOfFlags,
	[IsList],
	function(list)
	local fam, poset;
	fam:=NewFamily("Poset From Flags Description",IsPosetOfFlags);
	poset:=Objectify(NewType(fam, IsPoset and IsPosetOfFlags), rec(faces_list_by_rank:=list));
	return(poset);
	end);

InstallOtherMethod(Rank,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local list;
	list:=poset!.faces_list_by_rank;
	if HasIsFull(poset)=false then
		SetIsFull(poset,ListIsFullPoset(list));
	fi;
	if IsFull(poset) then
		SetRankPoset(poset,Length(list)-2);
	else
		SetRankPoset(poset,Length(list));
	fi;
	return poset!.RankPoset;	
	end);

InstallMethod(IsNotFull,
	[IsPoset and IsPosetOfFlags],
	function(poset)
#	local ;
	if IsFull(poset) then
		return false;
	else 
		return true;
	fi;
	end);

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
	[IsPermGroup],
	function(g)
	local conng,poset,posetList,flags,rank,gens,genIndexes,i;
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
	posetList:=[];
	for i in [1..rank] do
		Append(posetList,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	Add(posetList,[[]],1);
	Add(posetList,[flags]);
	poset:=PosetFromFaceListOfFlags(posetList);
	SetIsFull(poset,true);
	return poset;
	end);


InstallMethod(PosetOfConnectionGroup,
	[IsPermGroup],
	function(g)
	local conng,poset,posetList,flags,rank,gens,genIndexes,i;
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
	posetList:=[];
	for i in [1..rank] do
		Append(posetList,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	poset:=PosetFromFaceListOfFlags(posetList);
	SetIsFull(poset,false);
	return poset;
	end);
	




InstallMethod(PosetOfManiplex,
	[IsManiplex],
	function(mani)
	local poset,conng,posetList,flags,rank,gens,genIndexes,i;
	conng:=ConnectionGroup(mani);
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	posetList:=[];
	for i in [1..rank] do
		Append(posetList,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	poset:=PosetFromFaceListOfFlags(posetList);
	SetIsFull(poset,false);
	return poset;
	end);
	
	


InstallMethod(FullPosetOfManiplex,
	[IsManiplex],
	function(mani)
	local posetList,conng,poset,flags,rank,gens,genIndexes,i;
	conng:=ConnectionGroup(mani);
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	posetList:=[];
	for i in [1..rank] do
		Append(posetList,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	Add(posetList,[[]],1);
	Add(posetList,[flags]);
	poset:=PosetFromFaceListOfFlags(posetList);
	SetIsFull(poset,true);
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
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local faceList, flags, size, flagList, rank, i, flag, newPoset;
	if IsFull(poset) then
		newPoset:=PosetFromFaceListOfFlags(poset!.faces_list_by_rank{[2..Rank(poset)+1]});
	else
		newPoset:=poset;
	fi;
	faceList:=newPoset!.faces_list_by_rank;
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
	[IsPosetOfFlags,IsList,IsInt],
	function(poset,flag,i)
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
	[IsPosetOfFlags,IsInt,IsInt],
	function(poset,flag,i)
	#The variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags;
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	flags:=FlagsAsListOfFacesFromPoset(poset);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
	end);

InstallOtherMethod(AdjacentFlag,
	[IsPosetOfFlags,IsList,IsInt,IsBool],
	function(poset,flag,i,bool)
	#Note that flag and list of flags here are assumed to be given as lists of incident faces in increasing order. the variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags,found;
	if bool<>true then return AdjacentFlag(poset,flag,i);fi;
	flags:=FlagsAsListOfFacesFromPoset(poset);
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	found:=Filtered(flags,x->(flag{ranks}=x{ranks} and flag<>x))[1];
	return Position(flags,found);
	end);

InstallOtherMethod(AdjacentFlag,
	[IsPosetOfFlags,IsInt,IsInt,IsBool],
	function(poset,flag,i,bool)
	#The variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags,found;
	if bool<>true then return AdjacentFlag(poset,flag,i);fi;
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	flags:=FlagsAsListOfFacesFromPoset(poset);
	found:=Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
	return Position(flags,found);
	end);

InstallMethod(ConnectionGeneratorOfPoset,
	[IsPoset and IsPosetOfFlags,IsInt],
	function(poset,i) # here i is the rank of the generator, e.g., 0 is the rank of the generator for 0-connections. Also note, the poset here MUST not be full.
	local flagsList,nFlags,imagesList,flagPosition,iNeighbor,j;
#	if IsFull(poset) then Print("ConnectionGeneratorOfPoset was given a full poset, and failed."); return; fi;
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	nFlags:=Length(flagsList);
	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
	for j in [1..nFlags] do
		iNeighbor:=AdjacentFlag(poset,j,i);
		imagesList[j]:=Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);



InstallMethod(IsFlaggable,
	[IsPoset and IsPosetOfFlags],
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
	SetIsFlaggable(poset,result);
	return result;
	end
);

InstallMethod(ConnectionGroupOfPoset,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local rank,facelist,flagsList,ranks,generators,x,newPoset;
	if IsFlaggable(poset)=false then
		Print("This poset is not flaggable, and this function only works for flaggable posets.");
		return;
	fi;
#	facelist:=poset!.faces_list_by_rank;
	if IsFull(poset) then
		ranks:=[2..Rank(poset)+1];
	else
		ranks:=[1..Rank(poset)];
	fi;
	facelist:=poset!.faces_list_by_rank{ranks};	
	flagsList:=FlagsAsListOfFacesFromPoset(poset);
	generators:=[1..Rank(poset)];
	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
	return Group(generators);
	end);
#Can't handle full posets yet.

# InstallOtherMethod(ConnectionGroupOfPoset,
# 	[IsPoset and IsPosetOfFlags and IsFull],
# 	function(poset)
# 	Print("whoa.");
# 	end);



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