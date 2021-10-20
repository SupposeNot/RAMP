

InstallMethod(StratifiedProduct,
	[IsList,IsList],
	function(el1,el2)
	local perm1, list1, perm2, list2, newlist, newperm, n;
	if Length(el1)<>2 or Length(el2)<>2 then Error("Elements are not properly formatted."); fi;
	if IsPerm(el1[1]) then perm1:=el1[1]; else Error("Elements are not properly formatted."); fi;
	if IsPerm(el2[1]) then perm2:=el2[1]; else Error("Elements are not properly formatted."); fi;
# 	At some point need to figure out how to do error checking on the lists of group elements.
	list1:=el1[2]; list2:=el2[2];
# 	So I'm forming el1*el2, which means I need to move the permutation perm2 to the left of list1, i.e., act on list1.
	list1:=Permuted(list1,perm2);
	n:=Length(list1);
	newlist:=List([1..n],i->list1[i]*list2[i]);
	newperm:=perm1*perm2;
	return [newperm,newlist];
	end);