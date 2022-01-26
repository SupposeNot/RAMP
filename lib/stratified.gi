

InstallMethod(ChunkMultiply,
	[IsList,IsList],
	function(el1,el2)
	local perm1, list1, perm2, list2, newlist, newperm, n;
	if Length(el1)<>2 or Length(el2)<>2 then Error("Elements are not properly formatted."); fi;
	if IsPerm(el1[1]) then perm1:=el1[1]; else Error("Elements are not properly formatted."); fi;
	if IsPerm(el2[1]) then perm2:=el2[1]; else Error("Elements are not properly formatted."); fi;
# 	At some point need to figure out how to do error checking on the lists of group elements.
	if Length(el1[2])<>Length(el2[2]) then Error("Elements are not properly formatted."); fi;
	list1:=el1[2]; list2:=el2[2];
# 	So I'm forming el1*el2, which means I need to move the permutation perm2 to the left of list1, i.e., act on list1.
	list1:=Permuted(list1,perm2);
	n:=Length(list1);
	newlist:=List([1..n],i->list1[i]*list2[i]);
	newperm:=perm1*perm2;
	return [newperm,newlist];
	end);


InstallMethod(ChunkPower,
	[IsList,IsInt],
	function(el1,n)
	local elnew, i;
	elnew:=el1;
	for i in [1..n-1] do
		elnew:=ChunkMultiply(elnew,el1);
		od;
	return elnew;
	end);

InstallMethod(ChunkGeneratedGroup,
	[IsList, IsPermGroup],
	function(gens, grp)
	local nGens, nChunk, e, id, grpEls, grpElsTemp, permGroup, x,y, newEls, permList, grpEls2, inGrpEls;
	nGens:=Length(gens);
	e:=One(grp);
# 	if not(IsPermGroup(grp)) then SetReducedMultiplication(grp.1);fi;
	grpEls:=ShallowCopy(gens);
	grpElsTemp:=[];
	nChunk:=Length(gens[1][2]);
	id:=[(),List([1..nChunk],x->e)];
	Append(grpEls,[id]);
	while grpEls<>grpElsTemp do
		grpElsTemp:=ShallowCopy(grpEls);
		newEls:=Unique(Concatenation(List(grpEls,x->List(gens,y->ChunkMultiply(x,y)))));
		newEls:=Filtered(newEls,x->not(x in grpEls));
		grpEls:=Concatenation(grpEls,newEls);
# 		Print(grpEls[Length(grpEls)],",",Length(grpEls),"\n");
		od;
	permList:=[];
	for x in gens do
		grpEls2:=List(grpEls,y->ChunkMultiply(y,x));
		Add(permList,PermListList(grpEls,grpEls2));
		od;
	return Group(permList);
	end);

InstallOtherMethod(ChunkGeneratedGroup,
	[IsList,IsGroup],
	function(gens,grp)
	local newgens, phi, permRep, x, y,z ;
	phi:=IsomorphismPermGroup(grp);
	newgens:=[];
	for x in gens do
		y:=[];
		Add(y,x[1]);
		Add(y,List(x[2],z->Image(phi,z)));
		Add(newgens,y);
		od;
	return ChunkGeneratedGroup(newgens,Image(phi));
	end);


InstallMethod(ChunkGeneratedGroupElements,
	[IsList, IsGroup],
	function(gens, grp)
	local nGens, nChunk, e, id, grpEls, grpElsTemp, permGroup, x,y, newEls, permList, grpEls2, testPair, inGrpEls;
	nGens:=Length(gens);
	e:=One(grp);
#  	if not(IsPermGroup(grp)) then SetReducedMultiplication(grp.1);fi;
	SetReducedMultiplication(grp.1);
	grpEls:=ShallowCopy(gens);
	grpElsTemp:=[];
	nChunk:=Length(gens[1][2]);
	id:=[(),List([1..nChunk],x->e)];
	Append(grpEls,[id]);
	testPair:=function(l1,l2)
		local l11, l12, l21, l22, ind;
		l11:=l1[1];l12:=l1[2];l21:=l2[1];l22:=l2[2];
		if l11<>l21 then return false; fi;
		for ind in [1..nChunk] do
			if l12<>l22 then return false; fi;
			od;
		return true;
		end;
	inGrpEls:=function(l)
		local elt;
		for elt in grpEls do
			if testPair(l,elt) then return true;fi;
			od;
		return false;
		end;
# 	Print("Elements generated so far:\n");
	while grpEls<>grpElsTemp do
		grpElsTemp:=ShallowCopy(grpEls);
		newEls:=Unique(Concatenation(List(grpEls,x->List(gens,y->ChunkMultiply(x,y)))));
		newEls:=Filtered(newEls,x->not(inGrpEls(x)));
		grpEls:=Concatenation(grpEls,newEls);
# 		Print(Length(grpEls),"\n");
		od;
# 		Print("\n Done\n");
	return grpEls;
	end);

InstallMethod(FullyStratifiedGroup,
	[IsList, IsGroup],
	function(gens,grp)
	local nGrp, nBlocks, els, flags, permedFlags, permGens, x, y, applyGen, gen, elt;
	nGrp:=Size(grp);
	if IsPermGroup(grp)=false then SetReducedMultiplication(grp.1);fi;
# 	We could, if it turns out to cause trouble, do a conversion that sends grp to a permutation group. Hopefully we don't have problems there.
	nBlocks:=Length(gens[1][2]);
	els:=Elements(grp);
	flags:=Cartesian([1..nBlocks],els);
	permGens:=[];
	applyGen:=function(gen, elt)
		return [elt[1]^gen[1],elt[2]*gen[2][elt[1]]];
		end;
	for x in gens do
		permedFlags:=List(flags,y->applyGen(x,y));
# 		Print(permedFlags,"\n");
		Add(permGens,PermListList(flags,permedFlags));
		od;
# 	Print(flags,"\n");
	return Group(permGens);
	end);

testList:=function(list)
	local elements,templist, i, newEls, x;
	elements:=list;
	templist:=[];
	while Length(templist)<>Length(elements) do
		templist:=elements; #templist stores the old list
		for i in list do
			newEls:=List(elements, x->ChunkMultiply(x,i));
			elements:=Union(elements,newEls);
			od;
# 			Print(elements,"\n\n");
		od;
	return elements;
	end;