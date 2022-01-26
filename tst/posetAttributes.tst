gap> poset:=PosetFromManiplex(HemiCube(3));;
gap> MaximalChains(poset)[1];;
gap> List(last,x->RankInPoset(x,poset));
[ -1, 0, 1, 2, 3 ]
gap> p:=PosetFromManiplex(Cube(2));;
gap> p3:=PosetFromElements(RankedFaceListOfPoset(p),PairCompareFlagsList);;
gap> f3:=FacesList(p3);;
gap> OrderingFunction(p3)(ElementObject(f3[2]),ElementObject(f3[1]));
false
gap> OrderingFunction(p3)(ElementObject(f3[1]),ElementObject(f3[2]));
true
gap> po:=BinaryRelationOnPoints([[2,3],[4,5],[4,5],[6],[6],[]]);;
gap> po:=ReflexiveClosureBinaryRelation(TransitiveClosureBinaryRelation(po));;
gap> p:=PosetFromPartialOrder(po);; IsAtomic(p);
false
gap> p2:=PosetFromManiplex(Cube(3));; IsAtomic(p2);
true
gap> poset:=PosetFromManiplex(Cube(3));;
gap> IsLattice(poset);
true
gap> bad:=PosetFromManiplex(HemiCube(3));;
gap> IsLattice(bad);
false
gap> l:=[[2,3,4],[5,7],[5,6],[6,7],[8],[8],[8,9],[10],[10],[]];;
gap> b:=BinaryRelationOnPoints(l);; 
gap> po:=ReflexiveClosureBinaryRelation(TransitiveClosureBinaryRelation(b));;
gap> poset:=PosetFromPartialOrder(po);;
gap> IsLattice(poset);
true
gap> IsAtomic(poset);
false
gap> p:=PosetFromElements(AllSubgroups(AlternatingGroup(4)),IsSubgroup);;
gap> IsP1(p);
true
gap> p2:=PosetFromFaceListOfFlags([[[1],[2]],[[1,2]]]);;
gap> IsP1(p2);
false
gap> poset:=PosetFromManiplex(HemiCube(3));;
gap> IsP2(poset);
true
gap> g:=AlternatingGroup(4);; a:=AllSubgroups(g);; poset:=PosetFromElements(a,IsSubgroup);;
gap> IsP2(poset);
false
gap> poset:=PosetFromManiplex(Cube(3));;
gap> IsPolytope(poset);
true
gap> poset2:=PosetFromElements(AllSubgroups(AlternatingGroup(4)),IsSubgroup);;
gap> IsPolytope(poset2);
false
gap> IsP1(poset2);
true
gap> poset:=PosetFromManiplex(Simplex(5));;
gap> IsSelfDual(poset);
true
gap> poset2:=PosetFromManiplex(Pyramid(Cube(3)));;
gap> IsSelfDual(poset2);
false