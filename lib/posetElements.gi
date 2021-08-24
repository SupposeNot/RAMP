
# Constructors

InstallMethod(PosetElementWithOrder,
	[IsObject, IsFunction],
	function(obj, func)
	local face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset),rec());
	SetElementObject(face,obj);
	SetElementOrderingFunction(face,func);
	return face;
	end);


InstallMethod(PosetElementFromListOfFlags,
 	[IsList,IsPoset,IsInt],
 	function(list,poset,n)
	local fam, face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRanksInPosets(face,[[poset,n]]);
	return(face);
	end);

InstallOtherMethod(PosetElementFromListOfFlags,
 	[IsList],
 	function(listrank)
	local fam, face,list,rank, poset;
	if IsList(listrank[1]) and IsPoset(listrank[2]) and IsInt(listrank[3]) then 
		list:=listrank[1]; poset:=listrank[2]; rank:=listrank[3];
	else
		Error("I expected a list of the form [list of flags, IsPoset, IsInt].");
# 		return;
	fi;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetFlagList(face,list);
	SetRanksInPosets(face,[[poset,rank]]);
	return(face);
	end);

InstallMethod(PosetElementFromAtomList,
 	[IsList],
 	function(list)
	local fam, face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetAtomList(face,list);
	return(face);
	end);

InstallMethod(PosetElementFromIndex,
 	[IsObject],
 	function(index)
	local fam, face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
	SetIndex(face,index);
	return(face);
	end);

# InstallOtherMethod(PosetElementFromIndex,
#  	[IsObject,IsInt,IsPoset],
#  	function(index,n,pos)
# 	local fam, face;
# 	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset), rec());
# 	SetIndex(face,index);
# 	SetRankFace(face,n);
# 	SetFromPoset(face,pos);
# 	return(face);
# 	end);

InstallMethod(PosetElementWithPartialOrder,
	[IsObject, IsBinaryRelation],
	function(obj, func)
	local face;
	face:=Objectify(NewType(PosetElementFamily, IsFace and IsFaceOfPoset),rec());
	SetElementObject(face,obj);
	SetElementBR(face,func);
	return face;
	end);	

# Properties

InstallMethod(AddRanksInPosets,
	[IsPosetElement,IsPoset,IsInt],
	function(elm,poset,n)
	local position, prompt;
	if HasRanksInPosets(elm) then
		position:=PositionProperty(RanksInPosets(elm),x->poset=x[1]);
		if position=fail then
			Add(RanksInPosets(elm),[poset,n]);
		else
			prompt:= NCurses.Select(["yes", "no"]);
			if prompt=1 then
			RanksInPosets(elm)[position]:=[poset,n];
			else 
				Print("Did not modify the rank of the element in the given poset.\n");
				return;
			fi;
		fi;
	else
		SetRanksInPosets(elm,[[poset,n]]);
	fi;
	end);

# Operations
InstallMethod(RankInPoset,
	[IsPosetElement and HasRanksInPosets,IsPoset],
	function(elm,poset)
	local position;
	position:=PositionProperty(RanksInPosets(elm),x->x[1]=poset);
	if position=fail then 
		return RankInPoset(elm,poset,true);
	fi;
	return RanksInPosets(elm)[position][2];
	end);

InstallOtherMethod(RankInPoset,
#	This is to be used when elements don't know their own ranks in a particular poset.
	[IsPosetElement, IsPoset, IsBool],
	function(elm,poset,bool)
	local maxPos, elmPos, maxRank, successors, counter;
	# Posets should know if they are P1 or not.
	if bool<>true then return fail; fi;
	if IsP1(poset)<>true then
		Error("Your poset isn't P1.");
		fi;
	if RankPoset=false then 
		Error("This poset does not appear to have a rank.");
		fi;	
	maxRank:=Rank(poset);
	successors:=Successors(HasseDiagramBinaryRelation(PartialOrder(poset)));
	maxPos:=PositionProperty(successors,x->x=[]);
	elmPos:=Position(ElementsList(poset),elm);
	if elmPos=maxPos and HasRanksInPosets(elm)=false then 
		AddRanksInPosets(elm,poset,maxRank);
		return maxRank;
		fi;
	counter:=1;
	while  (maxPos in successors[elmPos])=false do
		elmPos:=successors[elmPos][1];
		counter:=counter+1;
		od;
	AddRanksInPosets(elm,poset,maxRank - counter);
	return maxRank - counter;	
	end);	

InstallOtherMethod(RankInPoset,
#	This is to be used when elements don't know their own ranks.
	[IsPosetElement, IsPoset],
	function(elm,poset)
	local maxPos, elmPos, maxRank, successors, counter;
	# Posets should know if they are P1 or not.
	if IsP1(poset)<>true then
		Error("Your poset isn't P1.");
		fi;
	if RankPoset=false then 
		Error("This poset does not appear to have a rank.");
		fi;	
	maxRank:=Rank(poset);
	successors:=Successors(HasseDiagramBinaryRelation(PartialOrder(poset)));
	maxPos:=PositionProperty(successors,x->x=[]);
	elmPos:=Position(ElementsList(poset),elm);
	if elmPos=maxPos and HasRanksInPosets(elm)=false then 
		SetRanksInPosets(elm,[[poset,maxRank]]);
		return maxRank;
		fi;
	counter:=1;
	while  (maxPos in successors[elmPos])=false do
		elmPos:=successors[elmPos][1];
		counter:=counter+1;
		od;
	if HasRanksInPosets(elm)=true then 
		Add(RanksInPosets(elm),[poset, maxRank - counter]);
	else
		SetRanksInPosets(elm,[[poset, maxRank - counter]]);
		fi;
	return maxRank - counter;	
	end);	


InstallMethod(IsSubface,
	[IsFace and HasFlagList, IsFace and HasFlagList, IsPoset],
	function(face1, face2, poset)
	if RankInPoset(face1,poset)>=RankInPoset(face2,poset) and Intersection(FlagList(face1),FlagList(face2))<>[] then return true;
	else return false;
	fi;
	end);

InstallOtherMethod(IsSubface,
	[IsFace and HasFlagList, IsFace and HasFlagList],
	function(face1,face2)
	local poset, posets1, posets2;
	posets1:=List(RanksInPosets(face1),x->x[1]);
	posets2:=List(RanksInPosets(face2),x->x[1]);
	poset:=Intersection(posets1,posets2);
	if Size(poset)<>1 then Error("The elements appear to belong to more than one poset, so you must specify which poset you wish to perform the test in."); fi;
	poset:=poset[1];
	return IsSubface(face1,face2,poset);
	end);




InstallOtherMethod(IsSubface,
	[IsFace and HasAtomList, IsFace and HasAtomList],
	function(face1,face2)
	if IsSubset(AtomList(face1),AtomList(face2)) then return true;
	else return false;
	fi;
	end);



InstallOtherMethod(IsSubface,
	[IsFace and HasIndex, IsFace and HasIndex, IsPoset],
	function(face1,face2, poset)
	local reln,po;
	if HasPartialOrder(poset) then
		po:=PartialOrder(poset);
		if Index(face1) in Successors(po)[Index(face2)] then return true;
		else return false;
		fi;
	else Error("Given poset has no defined partial order.");
	fi;
	end);

InstallOtherMethod(IsSubface,
	[IsFace and HasElementOrderingFunction, IsFace and HasElementOrderingFunction,IsPoset],
	function(face1, face2, poset)
	local order;
	if ElementOrderingFunction(face1)<>ElementOrderingFunction(face2) then Error("Faces have different ordering functions."); 
# 		return; 
		fi;
	if HasElementObject(face1)=false or HasElementObject(face2)=false then Error("Elements don't both seem to have ElementObjects.");
		fi;
	order:=ElementOrderingFunction(face1);
	return order(ElementObject(face1), ElementObject(face2));
# 	return [ElementObject(face1), ElementObject(face2)] in order;
	end);	

InstallOtherMethod(IsSubface,
	[IsFace and HasElementBR, IsFace and HasElementBR],
	function(face1,face2)
	local order;
	if ElementBR(face1)<>ElementBR(face2) then Error("Faces don't have the same binary relation on them.");
# 		return;
		fi;
	if HasIndex(face1)=false or HasIndex(face2)=false then Error("Elements don't seem to both have indices.");
		return;
		fi;
	order:=ElementBR(face1);
	return [Index(face2),Index(face1)] in order;
	end);


InstallMethod(IsEqualFaces,
	[IsPosetElement,IsPosetElement,IsPoset],
	function(face1,face2,poset);
	return IsSubface(face1,face2,poset) and IsSubface(face2,face1,poset);
	end);

InstallMethod(\=,
	[IsPosetElement, IsPosetElement],
	function(p,q)
	return IsIdenticalObj(p,q);
	end);


InstallMethod(AreIncidentElements,
	[IsObject,IsObject],
	{face1,face2}->IsSubface(face1,face2) or IsSubface(face2,face1));

InstallMethod(Join,
	[IsFace, IsFace, IsPoset],
	function(face1, face2, poset)
	local faces, up, li, br, meet;
	faces:=Faces(poset);
	if not (face1 in faces and face2 in faces) then return fail; fi;
	up:=Filtered([1..Length(faces)], x->IsSubface(faces[x],face1,poset) and IsSubface(faces[x],face2,poset));
	if up=[] then return fail; fi;
	li:=Flat(up);
	li:=li{PositionsProperty( List(li, x->Unique( List(li, y->IsSubface(faces[y],faces[x],poset)))),x->x=[true])};
	if Length(li)<>1 then return fail;fi;
	return faces[li[1]];
	end);

InstallMethod(Meet,
	[IsFace, IsFace, IsPoset],
	function(face1, face2, poset)
	local faces, down, li, br, meet;
	faces:=Faces(poset);
	if not (face1 in faces and face2 in faces) then return fail; fi;
	down:=Filtered([1..Length(faces)], x->IsSubface(face1,faces[x],poset) and IsSubface(face2,faces[x],poset));
	if down=[] then return fail; fi;
	li:=Flat(down);
	li:=li{PositionsProperty( List(li, x->Unique( List(li, y->IsSubface(faces[y],faces[x],poset)))),x->x=[true])};
	if Length(li)<>1 then return fail;fi;
	return faces[li[1]];
	end);