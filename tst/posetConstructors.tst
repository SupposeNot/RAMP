gap> poset:=PosetFromFaceListOfFlags([[[1,2,3,4,5,6]],[[1,2],[3,6],[4,5]],[[1,4],[2,3],[5,6]],[[1,2,3,4,5,6]]]);;
gap> FaceListOfPoset(poset);
[ [ [ 1, 2, 3, 4, 5, 6 ] ], [ [ 1, 2 ], [ 3, 6 ], [ 4, 5 ] ], 
  [ [ 1, 4 ], [ 2, 3 ], [ 5, 6 ] ], [ [ 1, 2, 3, 4, 5, 6 ] ] ]
gap> g:=Group([(1,4)(2,3)(5,6),(1,2)(3,6)(4,5)]);
Group([ (1,4)(2,3)(5,6), (1,2)(3,6)(4,5) ])
gap> PosetFromConnectionGroup(g);;
gap> p:=HemiCube(3);;
gap> PosetFromManiplex(p);;
gap> l:=List([[1,1],[1,2],[1,3],[1,4],[2,4],[2,2],[3,3],[4,4]],x->Tuple(x));;
gap> r:=BinaryRelationByElements(Domain([1..4]), l);;
gap> poset:=PosetFromPartialOrder(r);;
gap> h:=HasseDiagramBinaryRelation(PartialOrder(poset));;
gap> Successors(h);
[ [ 2, 3 ], [ 4 ], [  ], [  ] ]
gap> list:=[[1,2,3],[1,2,4],[1,3,4],[2,3,4]];
[ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
gap> poset:=PosetFromAtomicList(list);;
gap> List(Faces(poset),AtomList);
[ [  ], [ 1 ], [ 1, 2 ], [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3 ], [ 1, 3, 4 ], 
  [ 1, 4 ], [ 2 ], [ 2, 3 ], [ 2, 3, 4 ], [ 2, 4 ], [ 3 ], [ 3, 4 ], [ 4 ], 
  [ 1 .. 4 ] ]
gap>  g:=SymmetricGroup(3);
Sym( [ 1 .. 3 ] )
gap> asg:=AllSubgroups(g);
[ Group(()), Group([ (2,3) ]), Group([ (1,2) ]), Group([ (1,3) ]), 
  Group([ (1,2,3) ]), Group([ (1,2,3), (2,3) ]) ]
gap> poset:=PosetFromElements(asg,IsSubgroup);;
gap> HasseDiagramBinaryRelation(PartialOrder(poset));;
gap> Successors(last);
[ [ 2, 3, 4, 5 ], [ 6 ], [ 6 ], [ 6 ], [ 6 ], [  ] ]
gap> List( ElementsList(poset){[2,6]}, ElementObject);
[ Group([ (2,3) ]), Group([ (1,2,3), (2,3) ]) ]
gap> p:=PosetFromManiplex(HemiCube(3));;
gap> Print(p);
PosetFromSuccessorList([ [ 2, 3, 4, 5 ], [ 6, 7, 9 ], [ 6, 8, 11 ], [ 7, 10, 11 ], 
[ 8, 9, 10 ], [ 1, 2, 13 ], [ 12, 14 ], [ 12, 14 ], [ 13, 14 ], [ 12, 13 ], [ 13, 14 ], 
[ 15 ], [ 15 ], [ 15 ], [ ] ]);
gap> p:=PosetFromManiplex(Cube(3));; c:=PosetFromManiplex(CrossPolytope(3));;
gap> IsIsomorphicPoset(DualPoset(DualPoset(p)),p);
true
gap> IsIsomorphicPoset(DualPoset(p),c);
true
gap> IsIsomorphicPoset(DualPoset(p),p);
false
gap> poset:=PosetFromManiplex(Pyramid(Cube(2)));;
gap> faces:=Faces(poset);;List(faces,x->RankInPoset(x,poset));
[ -1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3 ]
gap> IsIsomorphicPoset(Section(faces[15],faces[1],poset),PosetFromManiplex(Simplex(2)));
true
gap> IsIsomorphicPoset(Section(faces[16],faces[1],poset),PosetFromManiplex(Cube(2)));
true
gap> IsIsomorphicPoset(Section(faces[20],faces[2],poset),PosetFromManiplex(Cube(2)));
true