

InstallMethod(IsIsomorphicPoset,
	[IsPoset,IsPoset],
	function(poset1,poset2)
	local h1, h2;
	h1:=HasseDiagramOfPoset(poset1);
	h2:=HasseDiagramOfPoset(poset2);
	return IsIsomorphicGraph(h1,h2);
	end);


InstallMethod(PosetIsomorphism,
	[IsPoset,IsPoset],
	function(poset1,poset2)
	local h1,h2;
	h1:=HasseDiagramOfPoset(poset1);
	h2:=HasseDiagramOfPoset(poset2);
	return GraphIsomorphism(h1,h2);
	end);

InstallMethod(FlagsAsFlagListFaces,
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

InstallMethod(FlagsAsFlagListFaces,
	[IsPoset],
	function(poset)
	local faces, facesAsLists, flags, flagsAsLists, args;
		faces:=ElementsList(poset);
		flags:=MaximalChains(poset);
		facesAsLists:=List(faces, x->PositionsProperty(flags,flag-> x in flag));
# 		if IsP1(poset)=true then 
# 			facesAsLists[PositionsProperty(faces,x->x=flags[1][1])[1]]:=[];
# 			fi;
		flagsAsLists:=List(flags,x->facesAsLists{PositionsProperty(faces,y->y in x)});
		if IsP2(poset) then flagsAsLists:=List(flagsAsLists,x->x{[2..Length(x)-1]});fi;
		return flagsAsLists;
	end);


InstallMethod(RankedFaceListOfPoset,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local list, flp, i;
	flp:=ShallowCopy(FaceListOfPoset(poset));
	if IsP1(poset) then 
		list:=[];
		for i in [1..Length(flp)] do
		Add(list,List(flp[i],y->[y,i-2]));
		od;
		return Concatenation(list);	
	else
		Error("Posets using a flag description should be IsP1.");
	fi;
	end);

InstallOtherMethod(RankedFaceListOfPoset,
	[IsPoset and IsPosetOfFlags,IsBool],
	function(poset, bool)
	local list,flp, i;
	if bool<>true then return RankedFaceListOfPoset(poset); fi;
	flp:=ShallowCopy(FaceListOfPoset(poset));
	if IsP1(poset) then 
		list:=[];
		for i in [1..Length(flp)] do
		Add(list,List(flp[i],y->[y,poset,i-2]));
		od;
		return Concatenation(list);	
	else
		Error("Posets using a flag description should be IsP1.");
	fi;
	end);


InstallMethod(AdjacentFlag,
	[IsPosetOfFlags,IsList,IsInt],
	function(poset,flag,i)
	#Note that flag and list of flags here are assumed to be given as lists of incident faces in increasing order. the variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags;
	flags:=FlagsAsFlagListFaces(poset);
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
	if IsPrePolytope(poset)<>true then Error("I was expecting a pre-polytope.\n"); 
# 		return; 
		fi;
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
	flags:=FlagsAsFlagListFaces(poset);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x))[1];
	end);

InstallOtherMethod(AdjacentFlag,
	[IsPosetOfFlags,IsList,IsInt,IsBool],
	function(poset,flag,i,bool)
	#Note that flag and list of flags here are assumed to be given as lists of incident faces in increasing order. the variable i is the rank of the adjacency (indexed from 0)
	local n,ranks,flags,found;
	if bool<>true then return AdjacentFlag(poset,flag,i);fi;
	flags:=FlagsAsFlagListFaces(poset);
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
	flags:=FlagsAsFlagListFaces(poset);
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


InstallMethod(AdjacentFlags,
	[IsPoset,IsList,IsInt],
	function(poset,flagaslistoffaces,adjacencyrank)
	local r,flag,flagsList,fixedranks;
	if Rank(poset)=false then Error("Poset must be P1 and P2."); 
# 	return; 
		fi;
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
	if Rank(poset)=false then Error("Poset must be P1 and P2."); 
# 	return; 
		fi;
	ranks:=[1..Rank(poset)+2];
	Remove(ranks,adjacencyrank+2);
	flags:=MaximalChains(poset);
	return Filtered(flags,x->(flags[flag]{ranks}=x{ranks} and flags[flag]<>x));
	end);


InstallMethod(EqualChains,
	[IsList,IsList],
	function(flag1,flag2)
	local pairs;
	if Length(flag1)<>Length(flag2) then return false; fi;
	pairs:=[1..Length(flag1)];
	pairs:=List(pairs,x->IsIdenticalObj(flag1[x],flag2[x]));
	if DuplicateFreeList(pairs)=[true] then return true;
		else
		return false;
		fi;
	end);


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
	if IsPrePolytope(poset)<>true then Error("This function was expecting a pre-polytope."); 
# 		return; 
		fi;
	if Rank(poset)=0 then return TrivialGroup();fi;
	flags:=MaximalChains(poset);
	generators:=[1..Rank(poset)];
	Apply(generators,x->ConnectionGeneratorOfPoset(poset,x-1));
	return Group(generators);
	end);

InstallMethod(AutomorphismGroup,
	[IsPoset],
	function(poset)
	local faces, chains, newChains, AGFaces, AGFacesGens, AGFlags, AGFlagGens, po, i;
	faces:=ElementsList(poset);
	chains:=MaximalChains(poset);
	newChains:=[1..Length(chains)];
	Apply(newChains, x->List(chains[x],y->Position(faces,y)));
	if HasPartialOrder(poset)=false then po:=PartialOrder(poset);fi;
	if HasAutomorphismGroupOnElements(poset)=false then 
		AGFaces:=AutomorphismGroupOnElements(poset);
		SetAutomorphismGroupOnElements(poset,AGFaces);
		fi;
	AGFaces:=AutomorphismGroupOnElements(poset);	
	AGFacesGens:=GeneratorsOfGroup(AGFaces);
	AGFlagGens:=[1..Length(AGFacesGens)];
	for i in AGFlagGens do
		AGFlagGens[i]:=PermListList([1..Length(newChains)], List(newChains,x-> Position(newChains,List(x,y->y^AGFacesGens[i]))));
		od;
	return Group(AGFlagGens);
	end);


InstallMethod(AutomorphismGroupOnElements,
	[IsPoset and HasPartialOrder],
	poset -> AutGroupGraph(HasseDiagramOfPoset(poset)));


InstallMethod(FaceListOfPoset,
	[IsPoset and IsPosetOfFlags],
	function(poset)
	local n;
	if IsPosetOfFlags(poset)=true then return ShallowCopy(poset!.faces_list_by_rank); fi;
	return;
	end);


InstallMethod(RankPosetElements,
	[IsPoset],
	function(poset)
	local faces;
	if Rank(poset)=false then Error("Given poset doesn't admit a rank function.\n"); fi;
	faces:=Faces(poset);
	Perform(faces,x->RankInPoset(x,poset));
	return true;
	end);


InstallMethod(FacesByRankOfPoset,
	[IsPoset],
	function(poset)
	local faces, minface, facesByRank, ranks, face, maxface, tempfaces, newtempfaces, i, position;
	if Rank(poset)=false then Error("Poset must admit a rank function.");fi;
	faces:=ElementsList(poset);
	if HasRanksInPosets(faces[1]) then
		position:=Position(RanksInPosets(faces[1]),poset);
		facesByRank:=[];
		ranks:=DuplicateFreeList(List(faces,x->RankInPoset(x,poset)));
		Sort(ranks);
		facesByRank:=List(ranks,x->Filtered(faces,y->RankInPoset(y,poset)=x));
		return facesByRank;
	fi;
	if HasPartialOrder(poset) then 
		minface:=faces[1];
		for face in faces do
			if IsSubface(minface,face,poset) then minface:=face; fi;
		od;
		maxface:=faces[1];
		for face in faces do
			if IsSubface(face,maxface,poset) then maxface:=face; fi;
		od;
		facesByRank:=[[minface]];
		tempfaces:=ShallowCopy(faces);
		tempfaces:=tempfaces{PositionsProperty(tempfaces,x->x<>minface)};
		i:=0;
		AddRanksInPosets(minface,poset,-1);
		while tempfaces<>[] do
			newtempfaces:=[1..Length(tempfaces)];
			newtempfaces:=Filtered(newtempfaces, x->[x]=PositionsProperty(tempfaces, y->IsSubface(tempfaces[x],y)));
			for face in newtempfaces do
				AddRanksInPosets(tempfaces[face],poset,i);
				od;
			Append(facesByRank,[tempfaces{newtempfaces}]);
			tempfaces:=tempfaces{Difference([1..Length(tempfaces)],newtempfaces)};
			i:=i+1;
			od;
		return facesByRank;
	fi;
	if HasElementOrderingFunction(faces[1]) then
		minface:=faces[1];
		for face in faces do
			if IsSubface(minface,face,poset) then minface:=face; fi;
		od;
		maxface:=faces[1];
		for face in faces do
			if IsSubface(face,maxface,poset) then maxface:=face; fi;
		od;
		facesByRank:=[[minface]];
		tempfaces:=ShallowCopy(faces);
		tempfaces:=tempfaces{PositionsProperty(tempfaces,x->x<>minface)};
		i:=0;
		AddRanksInPosets(minface,poset,-1);
		while tempfaces<>[] do
			newtempfaces:=[1..Length(tempfaces)];
			newtempfaces:=Filtered(newtempfaces, x->[x]=PositionsProperty(tempfaces, y->IsSubface(tempfaces[x],y)));
			for face in newtempfaces do
				AddRanksInPosets(tempfaces[face],poset,i);
				od;
			Append(facesByRank,[tempfaces{newtempfaces}]);
			tempfaces:=tempfaces{Difference([1..Length(tempfaces)],newtempfaces)};
			i:=i+1;
			od;
		return facesByRank;
	fi;
	end);


InstallMethod(HasseDiagramOfPoset,
	[IsPoset],
	function(poset)
	local po, hasseBR, underlyingBR, edges, nodes;
	po:=PartialOrder(poset);
	hasseBR:=HasseDiagramBinaryRelation(po);
	underlyingBR:=UnderlyingRelation(hasseBR);
	edges:=List(AsList(underlyingBR),AsList);
	nodes:=Set(Source(po));
# 	nodes:=Set(Concatenation(edges));
	return DirectedGraphFromListOfEdges(nodes,edges);
	end);


InstallMethod(AsPosetOfAtoms,
	[IsPoset],
	function(poset)
	local minFace, minFaces, po, hpo, succ, parents, domain, newFaces, fullSuccessors, atoms, i, j, nonReflSucc;
	if IsP1(poset)=false then Error("Poset must be IsP1."); return fail; fi;
	if HasIsAtomic(poset) then 
		if IsAtomic(poset)<>true then Error("Poset doesn't admit a description of its faces in terms of atoms."); return fail; fi;
		fi;
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
 	newFaces:=List(atoms,PosetElementFromAtomList);
	return PosetFromElements(atoms,PairCompareAtomsList);
	end);

InstallMethod( \=,
	[IsPoset, IsPoset],
	function(p,q)
	return IsIdenticalObj(p,q);
	end);


InstallMethod(MinFace,
	[IsPoset and IsP1 and IsP2],
	function(poset)
	local faces;
	faces:=Faces(poset);
	return faces[PositionProperty(faces,x->RankInPoset(x,poset)=-1)];
	end);

InstallMethod(MaxFace,
	[IsPoset and IsP1 and IsP2],
	function(poset)
	local faces;
	faces:=Faces(poset);
	return faces[PositionProperty(faces,x->RankInPoset(x,poset)=Rank(poset))];
	end);