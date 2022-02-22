
# Let's go ahead and assume that we're going to convert whatever we have to a permutation connection group representation on the flags.


#! c:=combined connection group on lower ranks, i1:= index of flag on first facet, i2:= index of flag on second facet
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

# Will probably want a function that can take a list of polytopes, and a list of ordered quadruples, and produce a glued polytope. Idea being [i,j,k,l] tells you (sub)facet i is glued to (sub)facet j by glueing flag k of i to flag l of j.

TestGlue:=function(i1,i2)
	local con, man;
	con:=Group([r0,r1,r2,r3*GlueFacet(cc,37,i1)*GlueFacet(cc,145,i2)]);
	man:=Maniplex(con);
# 	if IsRotary(man) then 
	return man; #fi;
	end;

TestGlues:=function(list1,list2)
	local con, man, i1, i2, successes;
	successes:=[];
	for i1 in list1 do
		for i2 in list2 do
			if IsRotary(TestGlue(i1,i2)) then Add(successes,[i1,i2]);
				fi;
			od;
		od;
	return successes;
	end;