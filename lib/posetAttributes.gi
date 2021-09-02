

InstallMethod(MaximalChains,
	[IsPoset],
	function(poset)
	local faces, facesByRanks, flags, maxFaces, listofchildren, listofparents, i, top, j, newflags, tempflags, order;
	faces:=ElementsList(poset);
	listofchildren:=List(faces,x->PositionsProperty(faces,y->IsSubface(x,y,poset)));
	flags:=List(PositionsProperty(listofchildren,x->Length(x)=1),x->[x]);
	listofparents:=List(faces,x->PositionsProperty(faces,y->IsSubface(y,x,poset)));
	maxFaces:=PositionsProperty(listofparents,x->Length(x)=1);
	newflags:=[];
	tempflags:=[];
	while  DuplicateFreeList(List(flags,Last))<>maxFaces do
		for i in flags do
			top:=Last(i);
			listofparents:=PositionsProperty(faces,x->IsSubface(x,faces[top],poset));
			listofparents:=Filtered(listofparents,x->x<>top);
			for j in listofparents do
				listofchildren:=PositionsProperty(faces,x->IsSubface(faces[j],x,poset));
				if Intersection(listofchildren,listofparents)=[j] then 
					Append(newflags,[Concatenation(i,[j])]);
				fi;
			od;
		od;
		Append(tempflags,Filtered(newflags,x->(Last(x) in maxFaces)));
		flags:=newflags;
		newflags:=[];
	od;
	flags:=List(tempflags,x->faces{x});
	return flags;
	end);

InstallOtherMethod(MaximalChains,
	[IsPoset and HasPartialOrder],
	function(poset)
	local maxChains, po, hasse, elms, parents, children, flags, deg, maxFaces, listofparents, newflags, tempflags, i, j, top, faces;
	po:=PartialOrder(poset);
	hasse:=HasseDiagramBinaryRelation(po);
	elms:=Union(Range(hasse),Source(hasse));
	faces:=ElementsList(poset);
	deg:=DegreeOfBinaryRelation(po);
	if elms<>[1..deg] then Error("Partial order of poset is improperly indexed.");fi;
	parents:=Successors(hasse);
	flags:=List(PositionsProperty([1..deg],x->not(x in Union(parents))),x->[x]);
	maxFaces:=PositionsProperty([1..deg],x->parents[x]=[]);
	newflags:=[];
	tempflags:=[];
	while Unique(List(flags,Last))<>maxFaces do
		for i in flags do
			top:=Last(i);
			listofparents:=parents[top];
			Append(newflags,List(listofparents,x->Concatenation(i,[x])));
			od;
		Append(tempflags,Filtered(newflags,x->Last(x) in maxFaces));
		flags:=newflags;
		newflags:=[];
	od;
	flags:=List(tempflags,x->faces{x});
	return flags;
	end);


InstallOtherMethod(Rank,
	[IsPoset and HasRankPoset],
	x->RankPoset(x));

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
# 	if HasRankPoset(poset) then return RankPoset(poset); fi;
	chains:=MaximalChains(poset);
	chains:=List(chains,Length);
	len:=Length(DuplicateFreeList(chains));
	if len<>1 then 	
		SetRankPoset(poset,false); 
		return false; 
	fi;
	SetIsP2(poset,true);
	if IsP1(poset) then
		SetRankPoset(poset,chains[1]-2);
	else
		SetRankPoset(poset,chains[1]);
	fi;
	return RankPoset(poset);
	end);




InstallOtherMethod(ElementsList,
	[IsPosetOfFlags],
	function(poset)
	local list, e;
	list:=RankedFaceListOfPoset(poset,true);
	return List(list,PosetElementFromListOfFlags);
	end);

InstallOtherMethod(ElementsList,
	[IsPosetOfAtoms],
	function(poset)
	local list, faces;
	list:=poset!.faces_list_of_atoms;
	return List(list,PosetElementFromAtomList);
	end);

InstallOtherMethod(ElementsList,
	[IsPoset and HasPartialOrder],
	function(poset)
	local elms, succ, n, checkList, ranks, i, j, li, x, po, posmin, posmax, min, pelms, perm;
	po:=PartialOrder(poset);
	elms:=AsList(Union(Source(po),Range(po)));
	pelms:=List(elms,x->PosetElementWithPartialOrder(x,PartialOrder(poset)));
	for i in elms do SetIndex(pelms[i],i); od;
	return pelms;
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


InstallMethod(PartialOrder,
	[IsPoset],
	function(poset)
	local faceList, workingList, po;
	faceList:=ElementsList(poset);
	if DuplicateFreeList(List(faceList,HasFlagList))=[true] then
		workingList:=List(faceList,x->[FlagList(x),RankInPoset(x,poset)]);
		po:=PartialOrderByOrderingFunction(Domain(workingList),PairCompareFlagsList);
		return POConvertToBROnPoints(po);
	elif DuplicateFreeList(List(faceList,HasAtomList))=[true] then
		workingList:=List(faceList,AtomList);
		return POConvertToBROnPoints(workingList,PairCompareAtomsList);
	else
		Error("ya got me doc! You might try including a partial ordering function.");
	fi;	
	end);


InstallMethod(IsAtomic,
	[IsPoset],
	function(poset)
	local minFace, minFaces, po, hpo, succ, parents, domain, newFaces, fullSuccessors, atoms, i, j, nonReflSucc;
	if IsLattice(poset)=false then return false; fi;
	po:=PartialOrder(poset);
	hpo:=HasseDiagramBinaryRelation(po);
	parents:=Successors(hpo);
	fullSuccessors:=Successors(po);
	nonReflSucc:=Successors(TransitiveClosureBinaryRelation(hpo));
	succ:=Union(parents);
	domain:=Union(Source(po),Range(po));
	minFace:=Filtered(domain,x->not (x in succ))[1];
 	minFaces:=parents[minFace];
 	atoms:=List(domain,x->[]);
 	for i in minFaces do atoms[i]:=[i];od;
 	for i in minFaces do
 		for j in nonReflSucc[i] do
 			Append(atoms[j],[i]);
 		od;
 	od;
	return IsDuplicateFreeList(atoms);
	end);
	


InstallMethod(IsLattice,
	[IsPoset],
	function(poset)
	local faces, meets, joins, i, j;
	if IsP1(poset)<>true then return false;fi;
	faces:=Faces(poset);
	meets:=[];joins:=[];
	for i in [1..Length(faces)-1] do
		for j in [i+1..Length(faces)] do
			Add(meets,Meet(faces[i],faces[j],poset));
			Add(joins,Join(faces[i],faces[j],poset));
		od;
	od;
	if Positions(meets,fail)=[] and Positions(joins,fail)=[] then return true;
	else return false; fi;
	end);

InstallMethod(IsAllMeets,
	[IsPoset],
	function(poset)
	local faces, meets, joins, i, j;
	if IsP1(poset)<>true then return false;fi;
	faces:=Faces(poset);
	meets:=[];
	for i in [1..Length(faces)-1] do
		for j in [i+1..Length(faces)] do
			Add(meets,Meet(faces[i],faces[j],poset));
		od;
	od;
	if Positions(meets,fail)=[] then return true;
	else return false; fi;
	end);

InstallMethod(IsAllJoins,
	[IsPoset],
	function(poset)
	local faces, meets, joins, i, j;
	if IsP1(poset)<>true then return false;fi;
	faces:=Faces(poset);
	joins:=[];
	for i in [1..Length(faces)-1] do
		for j in [i+1..Length(faces)] do
			Add(joins,Join(faces[i],faces[j],poset));
		od;
	od;
	if Positions(joins,fail)=[] then return true;
	else return false; fi;
	end);


InstallMethod(ListIsP1Poset,
	[IsList],
	function(list)
	local rank,flags;
	flags:=DuplicateFreeList(Flat(list));
	Sort(flags);
	rank:=Length(list);
	if Length(list[1])=1 and Length(list[rank])=1 then
		return true;
	else
		return false;
	fi;
	Error("Something went wrong.\n");
	return;
	end);


InstallMethod(IsP1,
	[IsPoset and IsPosetOfFlags],
	function(poset)
		local faceList;
	faceList:=poset!.faces_list_by_rank;
	if Length(faceList[1])=1 and Length(faceList[Rank(poset)+2])=1 then
		return true;
	else
		return false;
	fi;
	end);	

InstallMethod(IsP1,
	[IsPoset and IsPosetOfAtoms],
	function(poset)
	local faceList;
	faceList:=poset!.faces_list_of_atoms;
	if [] in faceList and Union(faceList) in faceList then
		return true;
	else
		return false;
	fi;
	end);

InstallOtherMethod(IsP1,
	[IsPoset and IsPosetOfIndices],
	function(poset)
	local faceList,atomicFaceList, partialOrder,successors, sourceList;
# 	if HasIsP1(poset) then return IsP1(poset); fi;
	faceList:=ElementsList(poset);
	#for handling the case when all the elements have an atomic description
	if DuplicateFreeList(List(faceList,x->HasAtomList(x)))=[true] then
		atomicFaceList:=List(faceList,x->AtomList(x));
		if [] in atomicFaceList and DuplicateFreeList(Concatenation(atomicFaceList)) in atomicFaceList then
			return true; 
		else 
			return false;
		fi;
	elif HasPartialOrder(poset) then #if we only know we have a partial order...
		partialOrder:=PartialOrder(poset);
		sourceList:=Elements(Source(partialOrder));
		successors:=Successors(partialOrder);
		if Length(PositionsProperty(successors,x->x=sourceList))=1 and Length(PositionsProperty([1..Length(sourceList)],x->successors[x]=[x]))=1 then
			return true;
		else 
			return false;
		fi;
	fi;
end);

InstallMethod(IsP2,
	[IsPoset],
	function(poset)
	local maxChains;
	maxChains:=MaximalChains(poset);
	maxChains:=DuplicateFreeList(List(maxChains,Length));
	if Length(maxChains)=1 then
		return true;
		else
		return false;
	fi;
	end);


InstallMethod(IsP3,
	[IsPoset],
	function(poset)
	local maxChains, r, ranks, i , j, truthList,cGens, overlap, overlapcomplement, nMC, orbit, repsList, compList;
	if Rank(poset)=false then return false; fi;
	if IsP1(poset)=false or IsP2(poset)=false then return false;fi;
 	if IsP4(poset)=false then return IsP3(poset,true);fi;
#  	Print("This is a pre-polytope, so I am using the connection group to help answer your question.\n");
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
	SetIsFlagConnected(poset,true);
	return true;
	end);

InstallOtherMethod(IsP3,
	[IsPoset,IsString],
	function(poset,string)
	local repsList, chainsLists, flag, chain, flagChain, flags, faces, face, gRanks, cGens, component, chainIntersection, ranks;
	if string<>"Flaggable" then Error("If you have a string as an alternative second input, it must be the word Flaggable."); 
# 		return; 
		fi;
	repsList:=List(Orbits(AutomorphismGroup(poset)),First);
	ranks:=[2..Rank(poset)+2];
	chainsLists:=Filtered(Combinations(ranks),x->x<>[]);
	flags:=MaximalChains(poset);
	faces:=ElementsList(poset);
	cGens:=GeneratorsOfGroup(ConnectionGroup(poset));
	if Length(Orbits(ConnectionGroup(poset)))<>1 then return false;fi;
	for flag in repsList do
		for chain in chainsLists do
			flagChain:=flags[flag]{chain};
			flagChain:=List(flagChain,face->PositionsProperty(flags,x->face in x));
			gRanks:= Difference([1..Rank(poset)], Intersection(chain, [2..Rank(poset)+1])-1);
			chainIntersection:=Intersection(flagChain);
			if gRanks<>[] then
				if IsSubset(Orbit(Group(cGens{gRanks}),flag),chainIntersection)=false then
					return false; 
					fi;
				fi;
			od;
		od;
	SetIsFlagConnected(poset,true);
	return true;
	end);

InstallOtherMethod(IsP3,
	[IsPoset,IsBool],
	function(poset,tvalue)
	local maxChains,faces,facePairs,sections,list,ord;
	if Rank(poset)=false then return false; fi;
	if IsP1(poset)=false or IsP2(poset)=false then return false;fi;
	maxChains:=MaximalChains(poset);
	faces:=ElementsList(poset);
	facePairs:=Cartesian(faces,faces);
	facePairs:=Filtered(facePairs,x->IsSubface(x[2],x[1],poset));
	sections:=List(facePairs,x->Filtered(faces,y->IsSubface(x[2],y,poset) and IsSubface(y,x[1],poset)));
	sections:=Filtered(sections,x->Length(x)<>1);
	ord:=function(a,b) return IsSubface(a,b,poset); end;
	list:=List(sections,x->IsFlagConnected(PosetFromElements(x,ord)));
	if DuplicateFreeList(list)=[true] then
		SetIsFlagConnected(poset,true);
		return true;
	else
		return false;
	fi;
	end);


InstallOtherMethod(IsFlagConnected,
	[IsPoset],
	function(poset)
	local flags, pathends, i, ranks, f, jf, temppathends, newends;
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
			jf:=Position(flags,f);
			for i in ranks do
				Append(newends,AdjacentFlags(poset,jf,i));
				od;
			od;
		newends:=DuplicateFreeList(newends);
		od;
	return Length(flags)=Length(pathends);
	end);


InstallMethod(IsP4,
	[IsPoset],
	function(poset)
	local r, ranks, flags, i, faceslow, faceshigh, facesmid, facepairs, pair, mids;
	if IsP1(poset)=false or IsP2(poset)=false then 
		Print("Your poset isn't P1 or isn't P2.\n");
		return false;
	fi;
	r:=Rank(poset);
	flags:=MaximalChains(poset);
	if r=0 then 
		return true;
	elif r=1 and Length(flags)=2 then
		return true;
	elif r=1 and Length(flags)<>2 then
		return false;
	fi;
	ranks:=[0..r-1];
	for i in [2..r] do
		faceslow:=DuplicateFreeList(List(flags,x->x[i]));
		faceshigh:=DuplicateFreeList(List(flags,x->x[i+2]));
		facesmid:=DuplicateFreeList(List(flags,x->x[i+1]));
		facepairs:=Cartesian(faceshigh,faceslow);
		facepairs:=Filtered(facepairs,x->IsSubface(x[1],x[2],poset));
		for pair in facepairs do
			mids:=Filtered(facesmid,x-> IsSubface(pair[1],x,poset) and IsSubface(x,pair[2],poset));
			if Length(mids)<>2 then
				return false;
			fi;
		od;
	od;
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


InstallOtherMethod(IsSelfDual,
	[IsPoset],
	p->IsIsomorphicPoset(p,DualPoset(p)));


	