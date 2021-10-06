




InstallMethod(JoinProduct,
	[IsPoset, IsPoset],
	function(poset1, poset2)
	local elements, pairs, order1, order2, order, suc1, suc2, n1, n2, list, temp, po, n, i, j;
	order1:=PartialOrder(poset1);
	order2:=PartialOrder(poset2);
	suc1:=Successors(ReflexiveClosureBinaryRelation(HasseDiagramBinaryRelation(order1)));
	suc2:=Successors(ReflexiveClosureBinaryRelation(HasseDiagramBinaryRelation(order2)));
# 	Print("Found successors.\n");
	n1:=Length(suc1);n2:=Length(suc2);
	list:=[1..n1*n2];
	for i in [1..n1] do
		for j in [1..n2] do
			temp:=Cartesian(suc1[i],suc2[j]);
			list[(i-1)*n2+j]:=List(temp, x->(x[1]-1)*n2+x[2]);
			od;
		od;
	po:=TransitiveClosureBinaryRelation(BinaryRelationOnPoints(list));
	return PosetFromPartialOrder(po);
	end);	



InstallOtherMethod(JoinProduct,
	[IsBinaryRelation, IsBinaryRelation],
	function(order1, order2)
	local elements, order, suc1, suc2, n1, n2, i, j, list, temp, po;
	elements:=Cartesian(Source(order1),Source(order2));
 	suc1:=Successors(ReflexiveClosureBinaryRelation(HasseDiagramBinaryRelation(order1)));
	suc2:=Successors(ReflexiveClosureBinaryRelation(HasseDiagramBinaryRelation(order2)));
# 	Print("Found successors.\n");
	n1:=Length(suc1);n2:=Length(suc2);
	list:=[1..n1*n2];
	for i in [1..n1] do
		for j in [1..n2] do
			temp:=Cartesian(suc1[i],suc2[j]);
			list[(i-1)*n2+j]:=List(temp, x->(x[1]-1)*n2+x[2]);
			od;
		od;
	po:=TransitiveClosureBinaryRelation(BinaryRelationOnPoints(list));
	return po;
	end);

#  InstallMethod(JoinProduct,
# 	[IsManiplex,IsManiplex],
# 	function(m1,m2)
# 	local p1,p2,r1,r2,jp;
# 	p1:=PosetFromManiplex(m1);
# 	p2:=PosetFromManiplex(m2);
# 	jp:=Maniplex(ConnectionGroup(JoinProduct(p1,p2)));
# 	return jp;
# 	end);
	
# InstallMethod(CartesianProduct,
# 	[IsPolytope,IsPolytope],
# 	function(poset1,poset2)
# 	local elements, pairs, order1, order2, order, suc1, suc2, n1, n2, list, temp, po, n, i, j;
# 	order1:=PartialOrder(poset1);
# 	order2:=PartialOrder(poset2);
# 	suc1:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order1 ) ) ) );
# 	Remove(suc1,1);
# 	suc2:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order2) ) ) );
# 	Remove(suc2, 1);
# # 	Print("Found successors.\n");
# 	n1:=Length(suc1);n2:=Length(suc2);
# 	list:=[1..(n1)*(n2)];
# 	for i in [1..n1] do #Note... this assumes that the item in position one is the empty set... which it SHOULD be.
# 		for j in [1..n2] do
# 			temp:=Cartesian(suc1[i],suc2[j]);
# 			list[(i-1)*n2+j]:=List(temp, x->(x[1]-1)*n2+x[2]);
# 			od;
# 		od;
# 	n:=Minimum(DuplicateFreeList(Concatenation(list)))-2;
# 	list:=list-n;
# 	Add(list,[1..Length(list)+1],1);
# # 	return list;
# 	po:=TransitiveClosureBinaryRelation(BinaryRelationOnPoints(list));
# 	return PosetFromPartialOrder(po);
# 	end);
	
InstallMethod(CartesianProduct,
	[IsPoset,IsPoset],
	function(poset1,poset2)
	local elements, pairs, order1, order2, order, suc1, suc2, n1, n2, list, temp, po, n, i, j, posMin1, posMin2;
	if IsP1(poset1)=false or IsP1(poset2)=false then return fail; fi;
	order1:=PartialOrder(poset1);
	order2:=PartialOrder(poset2);
	posMin1:=PositionProperty(Successors(order1),x->x=AsList(Source(order1)));
	posMin2:=PositionProperty(Successors(order2),x->x=AsList(Source(order2)));
	suc1:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order1 ) ) ) );
# 	Print(suc1,"\n");
	Remove(suc1,posMin1);
# 	Print(suc1,"\n");
	suc2:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order2) ) ) );
	Remove(suc2, posMin2);
# 	Print("Found successors.\n");
	n1:=Length(suc1);n2:=Length(suc2);
	list:=[1..(n1)*(n2)];
	for i in [1..n1] do 
		for j in [1..n2] do
			temp:=Cartesian(suc1[i],suc2[j]);
			list[(i-1)*n2+j]:=List(temp, x->(x[1]-1)*n2+x[2]);
			od;
		od;
	n:=Minimum(DuplicateFreeList(Concatenation(list)))-2;
	list:=list-n;
# 	Print(list);
	Add(list,[1..Length(list)+1],1);
# 	return list;
	po:=TransitiveClosureBinaryRelation(BinaryRelationOnPoints(list));
	return PosetFromPartialOrder(po);
	end);

# InstallMethod(CartesianProduct,
# 	[IsManiplex,IsManiplex],
# 	function(m1,m2)
# 	local p1,p2,r1,r2,cp;
# 	p1:=PosetFromManiplex(m1);
# 	p2:=PosetFromManiplex(m2);
# 	cp:=Maniplex(ConnectionGroup(CartesianProduct(p1,p2)));
# 	return cp;
# 	end);
# 	
InstallMethod(DirectSumOfPosets,
	[IsPoset,IsPoset],
	function(poset1, poset2)
	return DualPoset(CartesianProduct(DualPoset(poset1),DualPoset(poset2)));
	end);





InstallMethod(TopologicalProduct,
	[IsPoset,IsPoset],
	function(poset1,poset2)
	local elements, pairs, order1, order2, order, suc1, suc2, n1, n2, list, temp, po, n, i, j, posMin1, posMin2, posMax1, posMax2, DownShifter, min, max, i2, m;
	if IsP1(poset1)=false or IsP1(poset2)=false then return fail; fi;
	DownShifter:=function(min, max, i2)
		local m;
		m:=i2;
		if m>max and m>min then m:=m-2;
		elif m>max or m>min then m:=m-1;
		fi;
		return m;
		end;
	order1:=PartialOrder(poset1);
	order2:=PartialOrder(poset2);
	suc1:= ShallowCopy( Successors( HasseDiagramBinaryRelation( order1 ) ) );
	suc2:= ShallowCopy( Successors( HasseDiagramBinaryRelation( order2 ) ) );
	posMin1:=PositionProperty(Successors(order1),x->x=AsList(Source(order1)));
	posMin2:=PositionProperty(Successors(order2),x->x=AsList(Source(order2)));
	posMax1:=PositionProperty(suc1,x->x=[]);
	posMax2:=PositionProperty(suc2,x->x=[]);
	suc1:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order1 ) ) ) );
	suc2:= ShallowCopy( Successors( ReflexiveClosureBinaryRelation( HasseDiagramBinaryRelation( order2 ) ) ) );
	if posMin1<posMax1 then
		Remove(suc1,posMax1);
		Remove(suc1,posMin1);
		else
		Remove(suc1,posMin1);	
		Remove(suc1,posMax1);
		fi;
	if posMin2<posMax2 then
		Remove(suc2,posMax2);
		Remove(suc2,posMin2);
		else
		Remove(suc2,posMin2);	
		Remove(suc2,posMax2);
		fi;
	suc1:=List(suc1,x->Difference(x,[posMin1,posMax1]));
	suc1:=List(suc1,x->List(x,y->DownShifter(posMin1,posMax1,y)));
	suc2:=List(suc2,x->Difference(x,[posMin2,posMax2]));
	suc2:=List(suc2,x->List(x,y->DownShifter(posMin2,posMax2,y)));	
	n1:=Length(suc1);n2:=Length(suc2);
	list:=[];
	for i in [1..n1] do 
		for j in [1..n2] do
		temp:=Cartesian(suc1[i],suc2[j]);
		list[(i-1)*n2+j]:=List(temp, x->(x[1]-1)*n2+x[2]);
		od;
	od;
 	n:=Minimum(DuplicateFreeList(Concatenation(list)))-2;
	list:=list-n;
	Add(list,[1..Length(list)+1],1);
	Add(list,[]);
	list:=List(list,x->Concatenation(x,[Length(list)]));
	po:=TransitiveClosureBinaryRelation(BinaryRelationOnPoints(list));
	return PosetFromPartialOrder(po);
	end);

# InstallMethod(TopologicalProduct,
# 	[IsManiplex,IsManiplex],
# 	function(m1,m2)
# 	local p1,p2,r1,r2,cp;
# 	p1:=PosetFromManiplex(m1);
# 	p2:=PosetFromManiplex(m2);
# 	cp:=Maniplex(ConnectionGroup(TopologicalProduct(p1,p2)));
# 	return cp;
# 	end);
	

InstallMethod(Antiprism,
	[IsPoset],
	function(poset)
	local suc, newSuc, list, po, n, i, j, temp, pairs;
	po:=AsBinaryRelationOnPoints(PartialOrder(poset));
	n:=Length(AsList(Source(po)));
	suc:=Successors(po);
# 	Print(suc,"\n");
	pairs:=Cartesian([1..n],[1..n]);
	pairs:=Filtered(pairs,x->x[2] in suc[x[1]]);
# 	Print(pairs,"\n");
	newSuc:=[];
	for i in pairs do
		temp:=PositionsProperty(pairs,x-> [i[1],x[1]] in pairs and [x[2],i[2]] in pairs );
		Append(newSuc,[temp]);
		od;
	newSuc:=List(newSuc,x->Concatenation(x,[Length(pairs)+1]));
	Append(newSuc,[[Length(pairs)+1]]);
	po:=TransitiveClosureBinaryRelation( ReflexiveClosureBinaryRelation( BinaryRelationOnPoints( newSuc ) ) );
	return PosetFromPartialOrder(po);
	end);


# InstallMethod(Antiprism,
# 	[IsManiplex],
# 	function(m)
# 	local p,r,ap;
# 	p:=PosetFromManiplex(m);
# 	ap:=Maniplex(ConnectionGroup(Antiprism(p)));
# 	return ap;
# 	end);