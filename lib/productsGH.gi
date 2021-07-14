InstallMethod(JoinProduct,
	[IsPoset, IsPoset],
	function(poset1, poset2)
	local elements, pairs, order1, order2, order, inp1, inp2, po;
	order1:=PartialOrder(poset1); order2:=PartialOrder(poset2);
	elements:=Cartesian(Source(order1),Source(order2));
 	order:={inp1,inp2}->[inp1[1],inp2[1]] in order1 and [inp1[2],inp2[2]] in order2;
	po:=PartialOrderByOrderingFunction(Domain(elements),order);
# 	po:=POConvertToBROnPoints(po);
	return PosetFromPartialOrder(po);
	end);	
	

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
	if bool=true then po:=POConvertToBROnPoints(po);fi;
	return po;
	end);