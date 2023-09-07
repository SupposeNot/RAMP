
InstallMethod(ConjugacyClassesOfInvolutionsRepresentatives,
	[IsGroup],
	function(gamma)
		local involutions, sylow2, involutionClassReps,conjClass;
		sylow2:=SylowSubgroup(gamma,2);
		involutions:=Filtered(Elements(sylow2),x->Order(x)=2);
		involutionClassReps:=[];
		while Size(involutions)<>0 do
			Append(involutionClassReps,[involutions[1]]);
			conjClass:=ConjugacyClass(gamma,involutions[1]);
			involutions:=Filtered(involutions,x-> not x in conjClass);
			od;
		return involutionClassReps;
	end);

#This one needs some work/rethinking. It is also SUPER slow. Should probably take better advantage of the first key idea... namely that representatives of conjugacy classes that belong to the same automorphism class will have the same size conjugacy class.
InstallMethod(AutomorphismClassRepresentativeInvolutions, [IsGroup],
	function(gamma)
		local conjClassesInv, autsGamma, autsGens, outerAuts, Out, pos, reps, i, j;
  		conjClassesInv:= ConjugacyClassesOfInvolutionsRepresentatives(gamma);
 		if Length(Set(List(conjClassesInv, x -> Size(ConjugacyClass(gamma,x))))) = Length(conjClassesInv) then return conjClassesInv; fi; #This checks to see if there are conjugacy classes of involutions that might be related by an outer involution... since outer involutions will preserve the size of conjugacy classes.
		reps:= conjClassesInv;
  		autsGamma:= AutomorphismGroup(gamma);
  		autsGens:= GeneratorsOfGroup(autsGamma);
		outerAuts  := Filtered( autsGens, a -> not IsInnerAutomorphism(a));
		Out:=Group(outerAuts);
		return List(Orbits(Out,reps),Representative);
# 		Out:= Group(()); pos := [];
# 		for i in [ 1 .. Length(outerAuts)] do
# 			pos[i]:=List([ 1..Length(conjClassesInv)], j -> Position(List(reps,g->IsConjugate(gamma,g,Image(outerAuts[i],reps[j]))),true)); 
# 			Out:=ClosureGroup(Out,SortingPerm(pos[i]));
# 		od;
# 		#determines which items belong to each others automorphism classes.
# 		return List( Orbits( Out, [ 1 .. Length( conjClassesInv ) ] ),
#                orb -> Representative( conjClassesInv[ orb[ 1 ] ] ) );
	end);