




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

# InstallOtherMethod(JoinProduct,
# 	[IsPoset, IsPoset, IsBool],
# 	function(poset1, poset2, bool)
# 	local elements, pairs, order1, order2, order, inp1, inp2, po;
# 	order1:=AsBinaryRelationOnPoints(PartialOrder(poset1));
# 	order2:=AsBinaryRelationOnPoints(PartialOrder(poset2));
# 	Print("Found ordering functions.\n");
# 	elements:=Cartesian(Source(order1),Source(order2));
# 	Print("Found product elements.\n");
#  	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
#  	Print("Constructed order function.\n");
# 	po:=PartialOrderByOrderingFunction(Domain(elements),order);
# 	Print("Calculated PO.\n");
# 	po:=AsBinaryRelationOnPoints(po);
# 	Print("Calculated PO.\n");
# 	return PosetFromPartialOrder(po);
# 	end);		
	
InstallOtherMethod(JoinProduct,
	[IsBinaryRelation, IsBinaryRelation],
	function(order1, order2)
	local elements, order, inp1, inp2, po;
	elements:=Cartesian(Source(order1),Source(order2));
 	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
	po:=PartialOrderByOrderingFunction(Domain(elements),order);
	return po;
	end);

InstallOtherMethod(JoinProduct,
	[IsBinaryRelation, IsBinaryRelation, IsBool],
	function(order1, order2, bool)
	local elements, order, inp1, inp2, po;
	elements:=Cartesian(Source(order1),Source(order2));
 	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
	po:=PartialOrderByOrderingFunction(Domain(elements),order);
	if bool=true then po:=AsBinaryRelationOnPoints(po);fi;
	return po;
	end);