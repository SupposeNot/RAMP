
# Let's go ahead and assume that we're going to convert whatever we have to a permutation connection group representation on the flags.


#! c:=combined connection group, i1:= index of flag on first facet, i2:= index of flag on second facet
GlueFacet:=function(c,i1,i2)
	local orb1, orb2, mappers, cgens, ncgens, orb1Els, cfacet, orbcheck;
	cgens:=GeneratorsOfGroup(c);
	ncgens:=Length(cgens);
	cfacet:=Group(cgens{[1..ncgens-1]});
	orb1:=Orbit(cfacet,i1);
# 	Print("orb1",orb1,"\n");
	orb1Els:=List(orb1,y->ElementProperty(cfacet,x->i1^x=y));
# 	Print(Length(orb1Els),"\n");
	orb2:=List(orb1Els,x->i2^x);
# 	Print("orb2",orb2,"\n");
	orbcheck:=Orbit(cfacet,i2);
	if AsSet(orbcheck)<>AsSet(orb2) then Error("Facets don't appear to be a matching pair."); fi;
	return InvolutionListList(orb1,orb2);
	end;