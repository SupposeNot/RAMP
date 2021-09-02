

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

InstallOtherMethod(POConvertToBROnPoints,
	[IsList,IsFunction],
	function(list,ord)
	local  pairs, i;
	pairs:=[1..Length(list)];
	for i in pairs do
		pairs[i]:=PositionsProperty(list,x->ord(x,list[i]));
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

InstallMethod(PosetFromAtomicList,
	[IsList],
	function(list)
	local els, newList, tempList, intersections, poset;
	newList:=list;
	tempList:=[];
	while Length(newList)<>Length(tempList) do
		tempList:=newList;
		intersections:=List(Cartesian(newList,newList),x->Intersection(x[1],x[2]));
		newList:=Union(newList,intersections);
		od;
	Add(newList,Union(newList));
	poset:=Objectify(NewType(PosetFamily, IsPoset and IsPosetOfAtoms), rec(faces_list_of_atoms:=newList));
	SetIsAtomic(poset,true);
	return poset;
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
			posetList:=[ [ [ 1 ] ],[ [ 1 ] ] ];
		else posetList:=[ [ [ 1,2 ] ],[ [ 1 ],[ 2 ] ],[ [ 1, 2 ] ] ];
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

InstallMethod(Cleave,
	[IsPoset, IsInt],
	function(poset,k)
	local faces, lowFaces, highFaces, pairs, ord, minFace;
	faces:=FacesList(poset);
	lowFaces:=Filtered(faces,x->RankInPoset(x,poset)<= k-1);
	highFaces:=Filtered(faces,x->RankInPoset(x,poset)>=k);
	pairs:=Filtered(Cartesian(lowFaces,highFaces),x->IsSubface(x[2],x[1],poset));
	minFace:=Filtered(lowFaces,x->RankInPoset(x,poset)=-1)[1];
	Add(pairs,[minFace,minFace],1);
	ord:=function(x,y)
		local f,g,fp,gp;
		if y=[minFace,minFace] then return true;fi;
		if x=[minFace,minFace] and y<>[minFace,minFace] then return false;fi;
		fp:=x[1];gp:=x[2];f:=y[1];g:=y[2];
		return IsSubface(f,fp,poset) and IsSubface(g,f,poset) and IsSubface(gp,g,poset);
		end;	
	return PosetFromElements(pairs,ord);
	end);

InstallMethod(PartiallyCleave,
	[IsPoset, IsInt],
	function(poset,k)
	local faces, lowFaces, highFaces, pairs, ord, minFace, maxFace;
	if k<2 or k>Rank(poset)-2 then Error("k must be between 2 and n-2.\n");fi;
	faces:=FacesList(poset);
	lowFaces:=Filtered(faces,x->RankInPoset(x,poset)<= k-1 and RankInPoset(x,poset)>=0);
	highFaces:=Filtered(faces,x->RankInPoset(x,poset)>=k and RankInPoset(x,poset)<=Rank(poset)-1);
	pairs:=Filtered(Cartesian(lowFaces,highFaces),x->IsSubface(x[2],x[1],poset));
	minFace:=MinFace(poset); maxFace:=MaxFace(poset);
	Add(pairs,[minFace,minFace],1); Add(pairs,[minFace,maxFace]);
	ord:=function(x,y)
		local f,g,fp,gp;
		if y=[minFace,minFace] then return true;fi;
		if x=[minFace,minFace] and y<>[minFace,minFace] then return false;fi;
		fp:=x[1];gp:=x[2];f:=y[1];g:=y[2];
		return IsSubface(f,fp,poset) and IsSubface(g,f,poset) and IsSubface(gp,g,poset);
		end;	
	return PosetFromElements(pairs,ord);
	end);