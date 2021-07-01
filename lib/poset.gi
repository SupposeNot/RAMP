
###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...

#Note: The following function is INTENTIONALLY agnostic about whether it is being given full poset or not. I should probably fix that so that it will report a problem if the first entry isn't [[]] and the last entry has length more than 1. I should do something similar for atomic posets.
InstallMethod(PosetFromFaceListOfFlags,
	[IsList],
	function(list)
	local fam, poset;
	fam:=NewFamily("Poset From Flags Description", IsPoset);
	poset:=Objectify(NewType(fam, IsPoset and IsPosetOfFlags), rec(faces_list_by_rank:=list));
	return(poset);
	end);


InstallMethod(POConvertToBROnPoints,
	[IsBinaryRelation],
	function(reln)
	local source, pairs, ord, i;
		source:=AsList(Source(reln));
		pairs:=[1..Length(source)];
		ord:=UnderlyingRelation(reln);
		for i in pairs do
			pairs[i]:=PositionsProperty(source,x->Tuple([source[i],x]) in ord);
		od;
		return BinaryRelationOnPoints(pairs);
	end);

InstallMethod(PosetFromPartialOrder,
	[IsBinaryRelation],
	function(reln)
	local fam, poset, myreln, n;
	if IsPartialOrderBinaryRelation(reln)=false then Print("Sorry, that's not a partial order.");fi;
	myreln:=POConvertToBROnPoints(reln);
	n:=Length(Successors(myreln));
	fam:=NewFamily("Poset From Partial Order", IsPoset);
	poset:=Objectify(NewType(fam, IsPoset and IsPosetOfIndices), rec(domain:=[1..n]));
	SetPartialOrder(poset,myreln);
	return(poset);
	end);

InstallOtherMethod(ElementsList,
	[IsPosetOfFlags],
	function(poset)
	local list;
	list:=RankedFaceListOfPoset(poset);
	SetElementsList(poset,List(list,PosetElementFromListOfFlags));
	return ElementsList(poset);
	end);

InstallOtherMethod(Rank,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local list;
	list:=poset!.faces_list_by_rank;
	if HasIsP1(poset)=false then
		SetIsP1(poset,ListIsP1Poset(list));
	fi;
	if IsP1(poset) then
		SetRankPoset(poset,Length(list)-2);
	else
		SetRankPoset(poset,Length(list));
	fi;
	return poset!.RankPoset;	
	end);

InstallOtherMethod(Rank,
	[IsPoset],
	function(poset)
	local fl,ranks,m;
	fl:=ElementsList(poset);
	ranks:=DuplicateFreeList(List(fl,Rank));
	m:=Maximum(ranks);
	return m;
	end);
	

InstallMethod(ListIsP1Poset,
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


InstallMethod(IsP1,
	[IsPoset and IsPosetOfFlags],
	function(poset)
		local faceList;
	faceList:=poset!.faces_list_by_rank;
	if HasIsP1(poset) then return IsP1(poset); fi;
	if faceList[1]=[[]] and Length(faceList[Rank(poset)+2])=1 then
	SetIsP1(poset,true);
	return true;
	fi;
	end);	

InstallOtherMethod(IsP1,
	[IsPoset and IsPosetOfIndices],
	function(poset)
	local faceList,atomicFaceList, partialOrder,successors, sourceList;
	if HasIsP1(poset) then return IsP1(poset); fi;
	faceList:=ElementsList(poset);
	#for handling the case when all the elements have an atomic description
	if DuplicateFreeList(List(faceList,x->HasAtomList(x)))=[true] then
		atomicFaceList:=List(faceList,x->AtomList(x));
		if [] in atomicFaceList and DuplicateFreeList(Concatenation(atomicFaceList)) in atomicFaceList then
			SetIsP1(poset,true);
			return true; 
		else 
			SetIsP1(poset,false); 
			return false;
		fi;
	elif HasPartialOrder(poset) then #if we only know we have a partial order...
		partialOrder:=PartialOrder(poset);
		sourceList:=Elements(Source(partialOrder));
		successors:=Successors(partialOrder);
		if Length(PositionsProperty(successors,x->x=sourceList))=1 and Length(PositionsProperty([1..Length(sourceList)],x->successors[x]=[x]))=1 then
			SetIsP1(poset,true);
			return true;
		else 
			SetIsP1(poset,false); 
			return false;
		fi;
	fi;
end);

InstallMethod(IsP2,
	[IsPoset],
	function(poset)
	local maxChains;
	maxChains:=MaximalChains(poset);
	maxChains:=List(maxChains,x->Compacted(DuplicateFreeList(x)));
	maxChains:=DuplicateFreeList(List(maxChains,Length));
	if Length(maxChains)=1 then
		SetIsP2(poset,true);
		return true;
		else
		SetIsP2(poset,false);
		return false;
	fi;
	end);


InstallMethod(PosetOfConnectionGroup, 
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
	SetIsP1(poset,true);
	return poset;
	end);



	
InstallMethod(PosetOfManiplex,
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
	SetIsP1(poset,true);
	return poset;
	end);	

InstallMethod(AreIncidentFlagFaces,
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
	if IsP1(poset) then
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
		iNeighbor:=AdjacentFlag(poset,j,i,true);
		imagesList[j]:=iNeighbor;#Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);



InstallMethod(IsFlaggable,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local flags,flag,facesList,facesForFlag,ranks,x,y,truthValues, result;
	if ListIsP1Poset(poset!.faces_list_by_rank) then
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
	if IsP1(poset) then
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

InstallMethod(ViewObj,
	[IsPoset],
	function(poset)
	local faces;
	Print("A poset ");
	if IsPosetOfIndices(poset) then Print("using the IsPosetOfIndices representation ");fi;
	if HasRankPoset(poset) then Print("of rank ",Rank(poset));fi;
	if IsPosetOfFlags(poset) then 
		Print("using the IsPosetOfFlags representation ");
		faces:=Concatenation(ShallowCopy(poset!.faces_list_by_rank));
		Print("with ",Length(faces)," faces.");
	fi;
	end);

InstallMethod(PrintObj,
	[IsPoset],
	function(poset)
	ViewObj(poset);
	Print("\n");
	if IsPosetOfFlags(poset) then Print("List of faces in terms of incident flags, collected by rank:\n", poset!.faces_list_by_rank);fi;
	end);


#####Todo
# InstallMethod(FacesOfPosetAsBinaryRelationOnFaces,
# 	[IsPoset and IsPosetOfFlags],
# 	function(poset)
# 	local n,faces,faceIndices;
# 	faces:=ShallowCopy(poset!.faces_list_by_rank);
# 	n:=Length(Concatenation(poset!.faces_list_by_rank));
# 	
# 	end);


InstallMethod(FaceListOfPoset,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local n;
	if IsPosetOfFlags(poset)=true then return poset!.faces_list_by_rank; fi;
	return;
	end);



InstallMethod(RankedFaceListOfPoset,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local list,flp;
	flp:=ShallowCopy(FaceListOfPoset(poset));
	if IsP1(poset) then 
		list:=Concatenation(List(flp,x->List(x,y->[y,Position(flp,x)-2])));
	else
		list:=Concatenation(List(flp,x->List(x,y->[y,Position(flp,x)-1])));
	fi;
	return list;
	end);


InstallMethod(MaximalChains,
	[IsPoset],
	function(poset)
	local faces, ranks, facesByRanks, flags, maxFaces, listofchildren, listofparents, i, top, j, newflags;
#	if IsP1(poset)=false then Print("Sorry, I need a P1 poset."); return; fi;
	faces:=ShallowCopy(ElementsList(poset));
	ranks:=DuplicateFreeList(List(ElementsList(poset),Rank));
	listofchildren:=List(faces,x->PositionsProperty(faces,y->IsSubface(x,y)));
	flags:=List(PositionsProperty(listofchildren,x->Length(x)=1),x->[x]);
	listofparents:=List(faces,x->PositionsProperty(faces,y->IsSubface(y,x)));
	maxFaces:=PositionsProperty(listofparents,x->Length(x)=1);
	newflags:=[];
	while  DuplicateFreeList(List(flags,Last))<>maxFaces do
		for i in flags do
			top:=Last(i);
			listofparents:=PositionsProperty(faces,x->IsSubface(x,faces[top]));
			listofparents:=Filtered(listofparents,x->x<>top);
			for j in listofparents do
				listofchildren:=PositionsProperty(faces,x->IsSubface(faces[j],x));
				if Intersection(listofchildren,listofparents)=[j] then 
					Append(newflags,[Concatenation(i,[j])]);
				fi;
			od;
		od;
		flags:=newflags;
		newflags:=[];
	od;
	flags:=List(flags,x->faces{x});
	SetMaximalChains(poset,flags);
	return flags;
	end);



InstallMethod(PosetElementFromListOfFlags,
 	[IsList,IsInt],
 	function(list,n)
	local fam, face;
	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRankFace(face,n);
	return(face);
	end);

InstallOtherMethod(PosetElementFromListOfFlags,
 	[IsList],
 	function(listrank)
	local fam, face,list,rank;
	if IsList(listrank[1]) and IsInt(listrank[2]) then 
		list:=listrank[1]; rank:=listrank[2];
	else
		Print("I expected a list of the form [list of flags, IsInt].");return;
	fi;
	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRankFace(face,rank);
	return(face);
	end);

InstallOtherMethod(PosetElementFromListOfFlags,
 	[IsList,IsInt,IsPoset],
 	function(list,n,poset)
	local fam, face;
	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRankFace(face,n);
	SetFromPoset(face,poset);
	return(face);
	end);


InstallMethod(Rank,[IsFace],RankFace);

InstallMethod(ViewObj,
	[IsFace],
	function(face)
	Print("An element of a poset.");
	end);
	

InstallMethod(PrintObj,
	[IsFace],
	function(face)
	ViewObj(face);
	if HasRankFace(face) then Print(" Rank of element=", Rank(face));fi;
	if HasFlagList(face) then Print("\n with flags: ", FlagList(face));fi;
	if HasAtomList(face) then Print("\n made up of atoms: ", AtomList(face));fi;
	if HasIndex(face) then Print("\n with index=",face!.IndexAndRank); fi;
	end);

# InstallMethod("IsP1")


InstallMethod(IsSubface,
	[IsFace and HasFlagList,IsFace and HasFlagList],
	function(face1,face2)
	if FlagList(face2)=[] then return true;fi;
	if Rank(face1)>=Rank(face2) and Intersection(FlagList(face1),FlagList(face2))<>[] then return true;
	else return false;
	fi;
	end);


InstallMethod(PosetElementFromAtomList,
 	[IsList,IsInt],
 	function(list,n)
	local fam, face;
	fam:=NewFamily("Face as list of atoms", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetAtomList(face,list);
	SetRankFace(face,n);
	return(face);
	end);

InstallOtherMethod(IsSubface,
	[IsFace and HasAtomList, IsFace and HasAtomList],
	function(face1,face2)
	if Rank(face1)>=Rank(face2) and IsSubset(AtomList(face1),AtomList(face2)) then return true;
	else return false;
	fi;
	end);

InstallMethod(PosetElementFromIndex,
 	[IsObject,IsInt],
 	function(index,n)
	local fam, face;
	fam:=NewFamily("Face an indexed object", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetIndex(face,index);
	SetRankFace(face,n);
	return(face);
	end);

InstallOtherMethod(PosetElementFromIndex,
 	[IsObject,IsInt,IsPoset],
 	function(index,n,pos)
	local fam, face;
	fam:=NewFamily("Face as list of atoms", IsFace);
	face:=Objectify(NewType(fam, IsFace and IsFaceOfPoset), rec());
	SetIndex(face,index);
	SetRankFace(face,n);
	SetFromPoset(face,pos);
	return(face);
	end);



InstallOtherMethod(IsSubface,
	[IsFace and HasIndex, IsFace and HasIndex],
	function(face1,face2)
	local reln,po;
	if FromPoset(face1)=FromPoset(face2) and HasPartialOrder(FromPoset(face1)) then
		po:=PartialOrder(FromPoset(face1));
		if Rank(face1)>=Rank(face2) and Tuple([Index(face1),Index(face2)]) in po then return true;
		else return false;
		fi;
	else Print("No partial order found for elements of this poset.");
	fi;
	end); #Not sure this works yet... Have to build up the right kind of object.

InstallMethod(PairCompareFlagsList,
	[IsList,IsList],
	function(a,b) 
	if a[1]=[] and a[2]<=b[2] then return true; fi;
	return Intersection(b[1],a[1])<>[] and a[2]<=b[2];end);

InstallMethod(PairCompareAtomsList,
	[IsList,IsList],
	function(a,b) 
	return IsSubset(b[1],a[1]) and a[2]<=b[2];end);


InstallMethod(PosetFromElements,
	[IsList],
	function(faceList)
	local nFaceList, workingList, po, poset;
	nFaceList:=Length(faceList);
	if DuplicateFreeList(List(faceList,HasFlagList))[1] then
		workingList:=List(faceList,x->[FlagList(x),Rank(x)]);
		po:=PartialOrderByOrderingFunction(Domain(workingList),PairCompareFlagsList);
		poset:= PosetFromPartialOrder(po);
		SetElementsList(poset,ShallowCopy(faceList));
		SetOrderingFunction(poset,PairCompareFlagsList);
		return poset;
	elif DuplicateFreeList(List(faceList,HasAtomList))[1] then
		workingList:=List(faceList,x->[AtomList(x),Rank(x)]);
		po:=PartialOrderByOrderingFunction(Domain(workingList),PairCompareAtomsList);
		poset:= PosetFromPartialOrder(po);
		SetElementsList(poset,ShallowCopy(faceList));
		SetOrderingFunction(poset,PairCompareAtomsList);
		return poset;
	else
		Print("ya got me doc! You might try including a partial ordering function.");
	fi;	
	end);

InstallOtherMethod(PosetFromElements,
	[IsList,IsFunction],
	function(faceList,orderFunc)
	local nFaceList,workingList,pairs,tuplesList,po,i,j, poset;
	if Size(faceList)=infinity then Print("This only works for finite lists of poset elements."); fi;
	nFaceList:=Length(faceList);
	tuplesList:=List([1..nFaceList],x->[]);
	for i in [1..nFaceList] do
		for j in [1..nFaceList] do
			if orderFunc(faceList[i],faceList[j]) then 
				Append(tuplesList[j],[i]); 
			fi;
		od;
	od;
	po:=BinaryRelationOnPoints(tuplesList);
	poset:= PosetFromPartialOrder(po);
	SetElementsList(poset,ShallowCopy(faceList));
	SetOrderingFunction(poset,orderFunc);
	return poset;
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

#If you want to play with the flaggable stuff... m44 below is the {4,4}_(1,0) map.
#m44:=ReflexibleManiplex(Group([(1,8)(2,3)(4,5)(6,7),(1,2)(3,4)(5,6)(7,8),(1,4)(2,7)(3,6)(5,8)]);
#m44pos:=PosetOfManiplex(m44);
#IsFlaggablePoset(m44);
#IsFlaggablePoset(pos);