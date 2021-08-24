

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
	if IsPartialOrderBinaryRelation(reln)=false then Error("Sorry, that's not a partial order.\n");
# 	return; 
		fi;
	myreln:=POConvertToBROnPoints(reln);
	n:=Length(Successors(myreln));
	poset:=Objectify(NewType(PosetFamily, IsPoset and IsPosetOfIndices), rec(domain:=[1..n]));
	SetPartialOrder(poset,myreln);
	return(poset);
	end);


InstallMethod(PosetFromElements,
	[IsList,IsFunction],
	function(faceList,orderFunc)
	local nFaceList,workingList,pairs,tuplesList,po,i,j, poset;
	if Size(faceList)=infinity then Error("This only works for finite lists of poset elements."); fi;
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
	for i in [1..Length(faceList)] do SetIndex(faceList[i],i);od;
	SetElementsList(poset,faceList);
	SetOrderingFunction(poset,orderFunc);
	return poset;
	end);
	
	
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
	Add(posetList,[flags],1);
	Add(posetList,[flags]);
	poset:=PosetFromFaceListOfFlags(posetList); 
	SetIsP1(poset,true);
	SetIsP2(poset,true);
	faces:=RankedFaceListOfPoset(poset,true);
# 	chains:=ShallowCopy(flags);
# 	for i in flags do
# 		chains[i]:=Filtered(faces,x->i in x[1]);
# 		chains[i]:=List(chains[i],PosetElementFromListOfFlags);
# 		od;
# 	SetMaximalChains(poset,chains);
# 	SetConnectionGroup(poset,conng);
	return poset;
	end);



	
InstallMethod(PosetFromManiplex,
	[IsManiplex],
	function(mani)
	local posetList,conng,poset,flags,rank,gens,genIndexes,i;
	if Rank(mani) in [0,1] then 
		if Rank(mani)=0 then 
			posetList:=[ [ [  ] ],[ [ 1 ] ] ];
		else posetList:=[ [ [  ] ],[ [ 1 ],[ 2 ] ],[ [ 1, 2 ] ] ];
		fi;
		poset:=PosetFromFaceListOfFlags(posetList);
		SetIsPolytope(poset,true);
		return poset;
	fi;
	conng:=ConnectionGroup(mani);
	rank:=Length(GeneratorsOfGroup(conng));
	flags:=MovedPoints(conng);
	gens:=GeneratorsOfGroup(conng);
	genIndexes:=Reversed(Combinations([1..rank],rank-1));
	posetList:=[];
	for i in [1..rank] do
		Append(posetList,[Orbits(Group(gens{genIndexes[i]}))]);
		od;
	Add(posetList,[flags],1);
	Add(posetList,[flags]);
	poset:=PosetFromFaceListOfFlags(posetList);
	if IsPolytopal(mani) then 
		SetIsPolytope(poset,true);
		else
		SetIsP1(poset,true);
		fi;
	return poset;
	end);	

InstallMethod(PairCompareFlagsList,
	[IsList,IsList],
	function(b,a) 
# 	if a[1]=[] and a[2]<=b[2] then return true; fi;
	return Intersection(b[1],a[1])<>[] and b[2]<=a[2];end);

# InstallMethod(PairCompareAtomsList,
# 	[IsList,IsList],
# 	function(a,b) 
# 	return IsSubset(b[1],a[1]) and a[2]<=b[2];end);
InstallMethod(PairCompareAtomsList,
	[IsList,IsList],
	function(a,b) 
	return IsSubset(a,b);end);


InstallMethod(DualPoset,
	[IsPoset],
	function(poset)
	local order, points, suc, pairs, i, x, l, newOrder, pos;
	order:=PartialOrder(poset);
	pairs:=ShallowCopy(HasseDiagramBinaryRelation( order ));
	pairs:=ShallowCopy(AsList(UnderlyingRelation(pairs)));
	Apply(pairs, AsList);
	suc:=[];
	for i in [1..DegreeOfBinaryRelation(order)] do
		pos:=PositionsProperty(pairs, x->x[2]=i);
		l:=List(pairs{pos},x->x[1]);
# 		Print(l,"\n");
		Append(suc,[l]);
	od;
	newOrder:=ReflexiveClosureBinaryRelation( TransitiveClosureBinaryRelation( BinaryRelationOnPoints(suc)));
	return PosetFromPartialOrder(AsBinaryRelationOnPoints(newOrder));
	end);


InstallMethod(Section,
	[IsFace, IsFace, IsPoset],
	function(face1, face2, poset)
	local faces, elements, ord;
	faces:=Faces(poset);
	if not (face1 in faces and  face2 in faces) then return fail; fi;
	if IsSubface(face1,face2,poset)<>true then return fail;fi;
	elements:=Filtered(faces,x->IsSubface(face1,x,poset) and IsSubface(x,face2,poset));
	ord:=function(x,y) return IsSubface(x,y,poset); end;
	return PosetFromElements(elements,ord);
	end);