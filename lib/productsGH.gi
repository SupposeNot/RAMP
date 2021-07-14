

InstallMethod(JoinProduct,
	[IsPoset, IsPoset],
	function(poset1, poset2)
	local elements, pairs, order1, order2, order, inp1, inp2, po;
	order1:=AsBinaryRelationOnPoints(PartialOrder(poset1));
	order2:=AsBinaryRelationOnPoints(PartialOrder(poset2));
	Print("Found ordering functions.\n");
	elements:=Cartesian(Source(order1),Source(order2));
	Print("Found product elements.\n");
 	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
 	Print("Constructed order function.\n");
	po:=PartialOrderByOrderingFunction(Domain(elements),order);
	Print("Calculated PO.\n");
	po:=AsBinaryRelationOnPoints(po);
	Print("Calculated PO.\n");
	return PosetFromPartialOrder(po);
	end);	


# InstallMethod(JoinProduct,
# 	[IsPoset, IsPoset,IsBool],
# 	function(poset1, poset2, bool)
# 	local elements, pairs, order1, order2, order, inp1, inp2, po, n, i, j;
# 	order1:=PartialOrder(poset1);
# 	order2:=PartialOrder(poset2);
# 	Print("Found ordering functions.\n");
# 	elements:=Cartesian(Source(order1),Source(order2));
# 	Print("Found product elements.\n");
#  	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
#  	n:=Length(elements);
#  	
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