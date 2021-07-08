
###Operations for dealing with maniplexes as posets###
#This stuff is Gordon's fault...

#Note: The following function is INTENTIONALLY agnostic about whether it is being given full poset or not. I should probably fix that so that it will report a problem if the first entry isn't [[]] and the last entry has length more than 1. I should do something similar for atomic posets.
InstallMethod(PosetFromFaceListOfFlags,
	[IsList],
	function(list)
	local fam, poset;
	poset:=Objectify(NewType(PosetFamily, IsPoset and IsPosetOfFlags), rec(faces_list_by_rank:=list));
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
	if IsPartialOrderBinaryRelation(reln)=false then Print("Sorry, that's not a partial order."); return; fi;
	myreln:=POConvertToBROnPoints(reln);
	n:=Length(Successors(myreln));
# 	fam:=NewFamily("Poset From Partial Order", IsPoset);
	poset:=Objectify(NewType(PosetFamily, IsPoset and IsPosetOfIndices), rec(domain:=[1..n]));
	SetPartialOrder(poset,myreln);
	return(poset);
	end);

InstallOtherMethod(ElementsList,
	[IsPosetOfFlags],
	function(poset)
	local list;
	list:=RankedFaceListOfPoset(poset);
# 	SetElementsList(poset,List(list,PosetElementFromListOfFlags));
	return List(list,PosetElementFromListOfFlags);
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
	local fl,ranks,m,chains, len;
	if HasRankPoset(poset) then return RankPoset(poset); fi;
	chains:=MaximalChains(poset);
	chains:=List(chains,Length);
	len:=Length(DuplicateFreeList(chains));
	if len<>1 then 	
		SetRankPoset(poset,false); 
		return false; 
	fi;
	SetRankPoset(poset,chains[1]-2);
	return chains[1]-2;
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
# 	if HasIsP1(poset) then return IsP1(poset); fi;
	if faceList[1]=[[]] and Length(faceList[Rank(poset)+2])=1 then
# 		SetIsP1(poset,true);
		return true;
	else
		return false;
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
# 			SetIsP1(poset,true);
			return true; 
		else 
# 			SetIsP1(poset,false); 
			return false;
		fi;
	elif HasPartialOrder(poset) then #if we only know we have a partial order...
		partialOrder:=PartialOrder(poset);
		sourceList:=Elements(Source(partialOrder));
		successors:=Successors(partialOrder);
		if Length(PositionsProperty(successors,x->x=sourceList))=1 and Length(PositionsProperty([1..Length(sourceList)],x->successors[x]=[x]))=1 then
# 			SetIsP1(poset,true);
			return true;
		else 
# 			SetIsP1(poset,false); 
			return false;
		fi;
	fi;
end);

InstallMethod(IsP2,
	[IsPoset],
	function(poset)
	local maxChains;
	maxChains:=MaximalChains(poset);
#	maxChains:=List(maxChains,x->Compacted(DuplicateFreeList(x)));
	maxChains:=DuplicateFreeList(List(maxChains,Length));
	if Length(maxChains)=1 then
# 		SetIsP2(poset,true);
		return true;
		else
# 		SetIsP2(poset,false);
		return false;
	fi;
	end);

InstallMethod(EqualChains,
	[IsList,IsList],
	function(flag1,flag2)
	local pairs;
	if Length(flag1)<>Length(flag2) then return false; fi;
	pairs:=[1..Length(flag1)];
	pairs:=List(pairs,x->IsEqualFaces(flag1[x],flag2[x]));
	if DuplicateFreeList(pairs)=[true] then return true;
		else
		return false;
		fi;
	end);

InstallMethod( \=,
	ReturnTrue,
	[IsPosetElement, IsPosetElement],
	function(p,q)
	return IsEqualFaces(p,q);
	end);

InstallMethod(AdjacentFlags,
	[IsPoset,IsList,IsInt],
	function(poset,flagaslistoffaces,adjacencyrank)
	local r,flag,flagsList,fixedranks;
	if Rank(poset)=false then Print("Poset must be P1 and P2."); return; fi;
	r:=adjacencyrank; flag:=flagaslistoffaces;
	flagsList:=MaximalChains(poset);
	fixedranks:=[1..Rank(poset)+2];
	Remove(fixedranks,r+2);
	flagsList:=Filtered(flagsList,x->EqualChains(x{fixedranks},flag{fixedranks}));
	flagsList:=Filtered(flagsList,x->EqualChains(x,flag)=false);
	return flagsList;
	end);

InstallOtherMethod(AdjacentFlags,
	[IsPoset,IsInt,IsInt],
	function(poset,flag,adjacencyrank)
	local ranks,flags;
	if Rank(poset)=false then Print("Poset must be P1 and P2."); return; fi;
	ranks:=[1..Rank(poset)+2];
	Remove(ranks,adjacencyrank+2);
	flags:=MaximalChains(poset);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x));
	end);

InstallOtherMethod(IsFlagConnected,
	[IsPoset],
	function(poset)
	local flags, pathends, i, ranks, f, temppathends, newends;
	if (not(IsP1(poset)) or not (IsP2(poset))) then return false; fi;
	if Rank(poset)=false then return false; fi;
	if Rank(poset)<=1 then return true; fi;
	flags:=MaximalChains(poset);
	ranks:=[0..Rank(poset)-1];
	pathends:=[];
	temppathends:=[];
	newends:=[flags[1]];
	while DuplicateFreeList(List(newends,x->x in pathends))<>[true] do
		pathends:=DuplicateFreeList(Concatenation(newends,pathends));
		temppathends:=newends;
		newends:=[];
		for f in temppathends do
			for i in ranks do
				Append(newends,AdjacentFlags(poset,f,i));
				od;
			od;
		newends:=DuplicateFreeList(newends);
		od;
	return Length(flags)=Length(pathends);
	end);

InstallMethod(IsP3,
	[IsPoset],
	function(poset)
	local maxChains, r, ranks, i , j, truthList,cGens, overlap, overlapcomplement, nMC, orbit, repsList, compList;
# 	if bool=false then Print("Using true might speed up this process"); return IsP3(poset); fi;
	if Rank(poset)=false then return false; fi;
	if IsP1(poset)=false or IsP2(poset)=false then return false;fi;
 	if IsP4(poset)=false then return IsP3(poset,true);fi;
 	Print("This is a pre-polytope, so I am using the connection group to help answer your question.\n");
	maxChains:=MaximalChains(poset);
	nMC:=Length(maxChains);
	r:=Rank(poset);
	truthList:=[];
	cGens:=GeneratorsOfGroup(ConnectionGroup(poset));
	repsList:=List(Orbits(AutomorphismGroup(poset)),First);
	if Length(Orbits(ConnectionGroup(poset)))<>1 then return false;fi;
	for i in repsList do
		compList:=Difference([1..nMC],[i]);
		for j in compList do
			overlap:=PositionsProperty([1..r+2],x->maxChains[i][x]=maxChains[j][x]);
# 			Print(overlap,"\n");
			if overlap<>[1,r+2] then
				overlapcomplement:=Intersection(Difference([1..r+2],overlap),[2..r+1])-1;
				orbit:=Orbit(Group(cGens{overlapcomplement}),i);
#  				Print([i,j,orbit],"\n");
				if not (j in orbit) then
					return false;
				fi;
			else
# 				Print("Skipped ", i,", ", j,"\n");
			fi;
		od;
	od;
	return true;
	end);

InstallOtherMethod(IsP3,
	[IsPoset,IsString],
	function(poset,string)
	local repsList, chainsLists, flag, chain, flagChain, flags, faces, face, gRanks, cGens, component, chainIntersection, ranks;
	if string<>"Flaggable" then Print("If you have a string as an alternative second input, is must be the word Flaggable."); return; fi;
# 	if Rank(poset)=false then return false; fi;
# 	if IsP1(poset)=false or IsP2(poset)=false then return false;fi;
#  	if IsP4(poset)=false then return IsP3(poset,true);fi;
#  	Print("This is a pre-polytope, so I am using the connection group to help answer your question.\n");
# 	Print(AutomorphismGroup(poset),"\n");
	repsList:=List(Orbits(AutomorphismGroup(poset)),First);
# 	Print("Reps: ",repsList,"\n");
	ranks:=[2..Rank(poset)+2];
	chainsLists:=Filtered(Combinations(ranks),x->x<>[]);
# 	Print("Number of chains to check each:", Length(chainsLists),"\n");
	flags:=MaximalChains(poset);
	faces:=ElementsList(poset);
	cGens:=GeneratorsOfGroup(ConnectionGroup(poset));
	if Length(Orbits(ConnectionGroup(poset)))<>1 then return false;fi;
	for flag in repsList do
# 		Print("Starting rep ", flag, "\n");
		for chain in chainsLists do
# 			Print("Starting chain ", chain, "\n");
			flagChain:=flags[flag]{chain};
			flagChain:=List(flagChain,face->PositionsProperty(flags,x->face in x));
			gRanks:= Difference([1..Rank(poset)], Intersection(chain, [2..Rank(poset)+1])-1);
			chainIntersection:=Intersection(flagChain);
			if gRanks<>[] then
				if IsSubset(Orbit(Group(cGens{gRanks}),flag),chainIntersection)=false then
# 					Print([gRanks,flag,chain]);
					return false; 
					fi;
				fi;
			Print("Check complete.\n\n");
			od;
		od;
	return true;
	end);

InstallOtherMethod(IsP3,
	[IsPoset,IsBool],
	function(poset,tvalue)
	local maxChains,faces,facePairs,sections,list;
	if Rank(poset)=false then return false; fi;
	if IsP1(poset)=false or IsP2(poset)=false then return false;fi;
	maxChains:=MaximalChains(poset);
	faces:=ElementsList(poset);
	facePairs:=Cartesian(faces,faces);
	facePairs:=Filtered(facePairs,x->IsSubface(x[2],x[1]));
	sections:=List(facePairs,x->Filtered(faces,y->IsSubface(x[2],y) and IsSubface(y,x[1])));
	sections:=Filtered(sections,x->Length(x)<>1);
	list:=List(sections,x->IsFlagConnected(PosetFromElements(x,IsSubface)));
	if DuplicateFreeList(list)=[true] then
		return true;
	else
		return false;
	fi;
	end);


InstallMethod(IsP4,
	[IsPoset],
	function(poset)
	local r, ranks, flags, i, faceslow, faceshigh, facesmid, facepairs, pair, mids;
	if IsP1(poset)=false or IsP2(poset)=false then 
		Print("Your poset isn't P1 or isn't P2.\n");
# 		SetIsP4(poset,false);
		return false;
	fi;
	r:=Rank(poset);
	flags:=MaximalChains(poset);
	if r=0 then 
# 		SetIsP4(poset,true);
		return true;
	elif r=1 and Length(flags)=2 then
# 		SetIsP4(poset,true);
		return true;
	elif r=1 and Length(flags)<>2 then
# 		SetIsP4(poset,false);
		return false;
	fi;
	ranks:=[0..r-1];
# 	for i in [2..r-1] do
	for i in [2..r] do
		faceslow:=DuplicateFreeList(List(flags,x->x[i]));
		faceshigh:=DuplicateFreeList(List(flags,x->x[i+2]));
		facesmid:=DuplicateFreeList(List(flags,x->x[i+1]));
		facepairs:=Cartesian(faceshigh,faceslow);
		facepairs:=Filtered(facepairs,x->IsSubface(x[1],x[2]));
		for pair in facepairs do
			mids:=Filtered(facesmid,x-> IsSubface(pair[1],x) and IsSubface(x,pair[2]));
			if Length(mids)<>2 then
# 				SetIsP4(poset,false);
				return false;
			fi;
#  			Print(pair,", ", mids,"\n\n");
		od;
# 		Print(i,"\n");
	od;
# 	SetIsP4(poset,true);
	return true;
	end);

InstallMethod(IsPolytope,
	[IsPoset],
	function(poset)
	local value;
	if IsP1(poset) and IsP2(poset) and IsP3(poset) and IsP4(poset) then
		SetIsPrePolytope(poset,true);
		return true;
	else 
		if IsP1(poset) and IsP2(poset) and IsP4(poset) then
			Print("No, but it is a pre-polytope.\n");
			SetIsPrePolytope(poset,true);
		else 
			SetIsPrePolytope(poset,false);
		fi;
		return false;
	fi;
	end);

InstallMethod(IsPrePolytope,
	[IsPoset],
	function(poset)
	if IsP1(poset) and IsP2(poset) and IsP4(poset) then
		return true;
	else
		return false;
	fi;
	end);

InstallMethod(AutomorphismGroupOnElements,
	[IsPoset and HasPartialOrder],
	poset -> AutGroupGraph(HasseDiagramOfPoset(poset)));
# 
# InstallMethod(RotationGroup,
# 	[IsManiplex and IsRotaryManiplexRotGpRep],
# 	M -> M!.rot_gp);

InstallMethod(PosetFromConnectionGroup, 
	[IsPermGroup],
	function(g)
	local conng, poset, posetList, flags, rank, gens, genIndexes, i, j, faces, chains;
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
	faces:=RankedFaceListOfPoset(poset);
	chains:=ShallowCopy(flags);
	for i in flags do
		chains[i]:=Concatenation([[[],-1]],Filtered(faces,x->i in x[1]));
		chains[i]:=List(chains[i],PosetElementFromListOfFlags);
		od;
	SetMaximalChains(poset,chains);
	SetConnectionGroup(poset,conng);
# 	if IsStringC(conng) then SetIsPolytope(poset,true);fi; #Can't do this... that just says MRC is reflexible polytope.
	return poset;
	end);



	
InstallMethod(PosetFromManiplex,
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
	if IsPolytopal(mani) then 
		SetIsPolytope(poset,true);
		else
		SetIsP1(poset,true);
		fi;
	return poset;
	end);	

# Deprecated 7/7/21
# InstallOtherMethod(AreIncidentFaces,
# 	[IsList,IsList],
# 	function(list1,list2)
# 	if list1=[] or list2=[] then
# 		return true;
# 	elif Intersection(list1,list2)=[] then
# 		return false;
# 	else
# 		return true;
# 	fi;
# 	return "Was unable to evaluate for some reason.\n";
# 	end);	

InstallMethod(HasseDiagramOfPoset,
	[IsPoset and HasPartialOrder],
	function(poset)
	local po, hasseBR, underlyingBR, edges, nodes;
	po:=PartialOrder(poset);
	hasseBR:=HasseDiagramBinaryRelation(po);
	underlyingBR:=UnderlyingRelation(hasseBR);
	edges:=List(AsList(underlyingBR),AsList);
	nodes:=DuplicateFreeList(Concatenation(edges));
	return DirectedGraphFromListOfEdges(nodes,edges);
	end);



InstallMethod(AreIncidentElements,
	[IsObject,IsObject],
	{face1,face2}->IsSubface(face1,face2) or IsSubface(face2,face1));

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

InstallMethod(FlagsAsListOfFacesFromPoset,
	[IsPoset],
	function(poset)
	local faces, facesAsLists, flags, flagsAsLists;
		faces:=ElementsList(poset);
		flags:=MaximalChains(poset);
		facesAsLists:=List(faces, x->PositionsProperty(flags,flag-> x in flag));
		if IsP1(poset)=true then 
			facesAsLists[PositionsProperty(faces,x->x=flags[1][1])[1]]:=[];
			fi;
		flagsAsLists:=List(flags,x->facesAsLists{PositionsProperty(faces,y->y in x)});
		return flagsAsLists;
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
	[IsPoset,IsInt,IsInt],
	function(poset,flag,i)
	local n, ranks, flags;
	if IsPrePolytope(poset)<>true then Print("I was expecting a pre-polytope.\n"); return; fi;
	flags:=MaximalChains(poset);
	n:=Rank(poset);
	ranks:=[1..n+2];
	i:=i+2;
	Remove(ranks,i);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
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

InstallOtherMethod(AdjacentFlag,
	[IsPoset and IsP2, IsInt, IsInt, IsBool],
	function(poset,flag,i,bool)
	local n, ranks, flags, found;
	if bool <> true then return AdjacentFlag(poset,flag,i);fi;
	n:=Rank(poset);
	ranks:=[1..n];
	i:=i+1;
	Remove(ranks,i);
	flags:=List(MaximalChains(poset),x->x{[2..n+1]});
	found:=PositionsProperty(flags,x->(flags[flag]{ranks}=x{ranks}));
# 	found:=PositionsProperty(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
	return Difference(found,[flag])[1];
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

InstallMethod(IsFlaggable,
	[IsPoset],
	function(poset)
	local flags, faces, facesaslists, flag, face, ranks, facesList;
	if IsP1(poset)=false or IsP2(poset)=false then return false; fi;
	ranks:=[2..Rank(poset)+1];
	flags:=List(MaximalChains(poset),x->x{ranks});
	faces:=ElementsList(poset);
	facesaslists:=List(ElementsList(poset),face->PositionsProperty(flags,flag->face in flag));
	facesList:=[];
	for flag in flags do
		facesList:=PositionsProperty(faces,x->x in flag);
		if Length(Intersection(facesaslists{facesList}))<>1 then return false; fi;
		od;
	return true;
	end);

# Deprecated 7/4/21
# InstallMethod(ConnectionGroup,
# 	[IsPoset and IsPosetOfFlags],
# 	function(poset)
# 	local rank,facelist,flagsList,ranks,generators,x,newPoset;
# 	if IsFlaggable(poset)=false then
# 		Print("This poset is not flaggable, and this function only works for flaggable posets.");
# 		return;
# 	fi;
# 	if IsP1(poset) then
# 		ranks:=[2..Rank(poset)+1];
# 	else
# 		ranks:=[1..Rank(poset)];
# 	fi;
# 	facelist:=poset!.faces_list_by_rank{ranks};	
# 	flagsList:=FlagsAsListOfFacesFromPoset(poset);
# 	generators:=[1..Rank(poset)];
# 	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
# # 	SetConnectionGroup(poset,Group(generators));
# 	return Group(generators);
# 	end);


# Deprecated 7/4/21
# InstallMethod(ConnectionGeneratorOfPoset,
# 	[IsPoset and IsPosetOfFlags,IsInt],
# 	function(poset,i) # here i is the rank of the generator, e.g., 0 is the rank of the generator for 0-connections. Also note, the poset here MUST not be full.
# 	local flagsList,nFlags,imagesList,flagPosition,iNeighbor,j;
# #	if IsFull(poset) then Print("ConnectionGeneratorOfPoset was given a full poset, and failed."); return; fi;
# 	flagsList:=FlagsAsListOfFacesFromPoset(poset);
# 	nFlags:=Length(flagsList);
# 	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
# 	for j in [1..nFlags] do
# 		iNeighbor:=AdjacentFlag(poset,j,i,true);
# 		imagesList[j]:=iNeighbor;#Position(flagsList,iNeighbor);
# 		od;
# 	return PermutationOfImage(Transformation(imagesList));
# 	end);


InstallMethod(ConnectionGeneratorOfPoset,
	[IsPoset,IsInt],
	function(poset,i) # here i is the rank of the generator, e.g., 0 is the rank of the generator for 0-connections. Also note, the poset here MUST not be full.
	local flagsList,nFlags,imagesList,flagPosition,iNeighbor,j;
	flagsList:=MaximalChains(poset);
	nFlags:=Length(flagsList);
	imagesList:=[1..nFlags]; #Where we will store the list of places flags go.
	for j in [1..nFlags] do
		iNeighbor:=AdjacentFlag(poset,j,i,true);
		imagesList[j]:=iNeighbor;#Position(flagsList,iNeighbor);
		od;
	return PermutationOfImage(Transformation(imagesList));
	end);

InstallMethod(ConnectionGroup,
	[IsPoset],
	function(poset)
	local flags,generators;
	if IsPrePolytope(poset)<>true then Print("This function was expecting a pre-polytope."); return; fi;
	flags:=MaximalChains(poset);
	generators:=[1..Rank(poset)];
	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
	return Group(generators);
	end);

InstallMethod(AutomorphismGroup, 
	[IsPoset],
	function(poset)
	local g;
	g:=ConnectionGroup(poset);
	return Centralizer(SymmetricGroup(MovedPoints(g)),g);
	end);
# 	M -> Centralizer(SymmetricGroup(Size(M)), ConnectionGroup(M)));


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

InstallMethod(FacesByRankOfPoset,
	[IsPoset],
	function(poset)
	local faces, minface, facesByRank, ranks, face, maxface, tempfaces, newtempfaces, i;
	faces:=ElementsList(poset);
	if HasRankPosetElement(faces[1]) then
		facesByRank:=[];
		ranks:=DuplicateFreeList(List(faces,RankPosetElement));
		Sort(ranks);
		facesByRank:=List(ranks,x->Filtered(faces,y->RankPosetElement(y)=x));
		return facesByRank;
		fi;
	if HasElementOrderingFunction(faces[1]) then
		minface:=faces[1];
		for face in faces do
			if IsSubface(minface,face) then minface:=face; fi;
		od;
		maxface:=faces[1];
		for face in faces do
			if IsSubface(face,maxface) then maxface:=face; fi;
		od;
		facesByRank:=[[minface]];
		tempfaces:=ShallowCopy(faces);
		tempfaces:=tempfaces{PositionsProperty(tempfaces,x->x<>minface)};
		i:=0;
		SetRankPosetElement(minface,-1);
		while tempfaces<>[] do
			newtempfaces:=[1..Length(tempfaces)];
			newtempfaces:=Filtered(newtempfaces, x->[x]=PositionsProperty(tempfaces, y->IsSubface(tempfaces[x],y)));
			for face in newtempfaces do
				SetRankPosetElement(tempfaces[face],i);
				od;
			Append(facesByRank,[tempfaces{newtempfaces}]);
			tempfaces:=tempfaces{Difference([1..Length(tempfaces)],newtempfaces)};
			i:=i+1;
			od;
		return facesByRank;
		fi;
	end);

InstallMethod(MaximalChains,
	[IsPoset],
	function(poset)
	local faces, ranks, facesByRanks, flags, maxFaces, listofchildren, listofparents, i, top, j, newflags, tempflags, order;
#	if IsP1(poset)=false then Print("Sorry, I need a P1 poset."); return; fi;
	faces:=ShallowCopy(ElementsList(poset));
#	if HasElementObject(faces[1]) then 
# 	ranks:=DuplicateFreeList(List(ElementsList(poset),Rank));
	listofchildren:=List(faces,x->PositionsProperty(faces,y->IsSubface(x,y)));
	flags:=List(PositionsProperty(listofchildren,x->Length(x)=1),x->[x]);
	listofparents:=List(faces,x->PositionsProperty(faces,y->IsSubface(y,x)));
	maxFaces:=PositionsProperty(listofparents,x->Length(x)=1);
# 	Print(maxFaces);
	newflags:=[];
	tempflags:=[];
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
# 			Print(newflags,"\n");
# 			Print("New Layer\n");
		od;
		Append(tempflags,Filtered(newflags,x->(Last(x) in maxFaces)));
		flags:=newflags;
# 		Print(flags,"\n");
		newflags:=[];
	od;
# 	Print("temp\n",tempflags,"\n new\n",newflags);
	flags:=List(tempflags,x->faces{x});
# 	SetMaximalChains(poset,flags);
	return flags;
	end);

# InstallMethod(MaximalChains,
# 	[IsPoset and HasPartialOrder],
# 	function(poset)
# 	local maxChains, PO, hasse, UR, nFaces, pairs, parents, children, flags, maxFaces, newflags, tempflags, i, j, top;
# 	PO:=PartialOrder(poset);
# 	hasse:=HasseDiagramBinaryRelation(PO);
# 	UR:=AsList(UnderlyingRelation(hasse));
# 	nFaces:=[1..Size(ElementsList(poset))];
# 	UR:=Concatenation(UR,List(nFaces,x->DirectProductElement([x,x])));
# 	pairs:=Cartesian(nFaces,nFaces);
# 	pairs:=Filtered(pairs,x->DirectProductElement(x) in UR);
# 	children:=List(nFaces,x->PositionsProperty(nFaces,y->[y,x] in pairs));
# 	flags:=List(PositionsProperty(children,x->Length(x)=1),x->[x]);
# 	parents:=List(nFaces,x->PositionsProperty(nFaces,y->[x,y] in pairs));
# 	maxFaces:=PositionsProperty(parents,x->Length(x)=1);
# 	newflags:=[]; tempflags:=[];
# # 	Print(flags,"\n");
# 	while DuplicateFreeList(List(flags,Last))<>maxFaces do
# 		for i in flags do
# 			top:=Last(i);
# 			parents:=PositionsProperty(nFaces, x->[top,x] in pairs);
# 			parents:=Filtered(parents,x->x<>top);
# # 			Print(parents,"\n");
# 			for j in parents do
# 				children:=PositionsProperty(nFaces,x->[x,j] in pairs);
# # 				Print(children,"\n");
# 				if Intersection(children,parents)=[j] then 
# 					Append(newflags,[Concatenation(i,[j])]);
# 				fi;
# 			od;
# # 			Print(newflags,"\n");
# # 			Print("New layer\n");
# 		od;
# 		Append(tempflags,Filtered(newflags,x->(Last(x) in maxFaces)));
# 		flags:=newflags;
# 		newflags:=[];
# 	od;
# 	maxChains:=List(flags, x->ElementsList(poset){x});
# 	return maxChains;
# 	end);

InstallMethod(MaximalChains,
	[IsPoset and HasPartialOrder],
	function(poset)
	local maxChains, PO, hasse, UR, nFaces, pairs, pairsPlus, parents, children, flags, maxFaces, newflags, tempflags, i, j, top, URplus, successors;
	PO:=PartialOrder(poset);
	hasse:=HasseDiagramBinaryRelation(PO);
	UR:=AsList(UnderlyingRelation(hasse));
	nFaces:=[1..Size(ElementsList(poset))];
	URplus:=Concatenation(UR,List(nFaces,x->DirectProductElement([x,x])));
# 	pairs:=Cartesian(nFaces,nFaces);
# 	pairs:=Filtered(pairs,x->DirectProductElement(x) in UR);
	pairsPlus:=Cartesian(nFaces,nFaces);
	pairsPlus:=Filtered(pairsPlus,x->DirectProductElement(x) in URplus);
	children:=List(nFaces,x->PositionsProperty(nFaces,y->[y,x] in pairsPlus));
	flags:=List(PositionsProperty(children,x->Length(x)=1),x->[x]);
	parents:=List(nFaces,x->PositionsProperty(nFaces,y->[x,y] in pairsPlus));
	maxFaces:=PositionsProperty(parents,x->Length(x)=1);
	newflags:=[]; # tempflags:=[];
	successors:=Successors(hasse);
	while DuplicateFreeList(List(flags,Last))<>maxFaces do
		for i in flags do
			newflags:=Concatenation(newflags, List(successors[Last(i)], x->Concatenation(i,[x])));
			od;
# 		Append(tempflags,Filtered(newflags,x->Last(x) in maxFaces));
		flags:=newflags;
		newflags:=[];
		od;
# 	while DuplicateFreeList(List(flags,Last))<>maxFaces do
# 		for i in flags do
# # 			Print(i,"\n");
# 			top:=Last(i);
# 			parents:=PositionsProperty(nFaces, x->[top,x] in pairs);
# 			newflags:=Concatenation(newflags,List(parents,x->Concatenation(i,[x])));
# 		od;
# # 		Print(newflags,"\n");
# 		Append(tempflags,Filtered(newflags,x->(Last(x) in maxFaces)));
# 		flags:=newflags;
# # 		Print(flags, " bigstep\n");
# 		newflags:=[];
# 	od;
	maxChains:=List(flags, x->ElementsList(poset){x});
	return maxChains;
	end);

InstallMethod(PosetElementFromListOfFlags,
 	[IsList,IsInt],
 	function(list,n)
	local fam, face;
# 	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
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
# 	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRankFace(face,rank);
	return(face);
	end);

InstallOtherMethod(PosetElementFromListOfFlags,
 	[IsList,IsInt,IsPoset],
 	function(list,n,poset)
	local fam, face;
# 	fam:=NewFamily("Face Using Flags Description", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
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
# 	fam:=NewFamily("Face as list of atoms", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
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
# 	fam:=NewFamily("Face an indexed object", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetIndex(face,index);
	SetRankFace(face,n);
	return(face);
	end);

InstallOtherMethod(PosetElementFromIndex,
 	[IsObject,IsInt,IsPoset],
 	function(index,n,pos)
	local fam, face;
# 	fam:=NewFamily("Face as list of atoms", IsFace);
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
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

InstallOtherMethod(IsSubface,
	[IsFace and HasElementOrderingFunction, IsFace and HasElementOrderingFunction],
	function(face1, face2)
	local order;
	if ElementOrderingFunction(face1)<>ElementOrderingFunction(face2) then Print("Faces have different ordering functions."); return; fi;
	order:=ElementOrderingFunction(face1);
	return order(ElementObject(face1), ElementObject(face2));
	end);	

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

InstallMethod(PosetElementWithOrder,
	[IsObject, IsFunction],
	function(obj, func)
	local face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset),rec());
	SetElementObject(face,obj);
	SetElementOrderingFunction(face,func);
	return face;
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
	faceList:=ShallowCopy(faceList);
	Apply(faceList,x->PosetElementWithOrder(x,orderFunc));
	SetElementsList(poset,faceList);
	SetOrderingFunction(poset,orderFunc);
	return poset;
	end);

InstallMethod(IsEqualFaces,
	[IsPosetElement,IsPosetElement],
	function(face1,face2);
	return IsSubface(face1,face2) and IsSubface(face2,face1);
	end);

#Here's a sample of things you can do...
#p:=PyramidOver(HemiCube(3));
#pos:=PosetFromManiplex(p);;
#cg:=ConnectionGroup(p);
#flagList:=FlagsAsListOfFacesFromPoset(pos);;
#flagList[4];
#AdjacentFlag(flagList[4],flagList,3);
#conG:=ConnectionGroupOfPoset(pos);
#GeneratorsOfGroup(cg)=GeneratorsOfGroup(conG);

#If you want to play with the flaggable stuff... m44 below is the {4,4}_(1,0) map.
#m44:=ReflexibleManiplex(Group([(1,8)(2,3)(4,5)(6,7),(1,2)(3,4)(5,6)(7,8),(1,4)(2,7)(3,6)(5,8)]);
#m44pos:=PosetFromManiplex(m44);
#IsFlaggablePoset(m44);
#IsFlaggablePoset(pos);



# Some test objects:
posetFM:=function(n) return PosetFromManiplex(PyramidOver(Cube(n)));end;
posetFE:=function(n) return PosetFromElements(ElementsList(posetFM(n)),IsSubface);end;
posetFG:=function(n) return PosetFromConnectionGroup(ConnectionGroup(posetFE(n))); end;
# posetFM:=PosetFromManiplex(HemiCube(3));
# posetFE:=PosetFromElements(ElementsList(posetFM),IsSubface);
# posetFG:= PosetFromConnectionGroup(ConnectionGroup(posetFE));