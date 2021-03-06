

#! @Chapter Posets



#! @Section Poset constructors

#! I'm in the process of reconciling all of this, but there are going to be a number of ways to `define` a poset:
#! * As an `IsPosetOfFlags`, where the underlying description is an ordered list of length $n+2$. Each of the $n+2$ list elements is a list of faces, and the assumption is that these are the faces of rank $i-2$, where $i$ is the index in the master list (e.g., `l[1][1]` would usually correspond to the unique $-1$ face of a polytope -- and there won't be an `l[1][2]`). Each face is then a list of the flags incident with that face.
#! * As an `IsPosetOfIndices`, where the underlying description is a binary relation on a set of indices, which correspond to labels for the elements of the poset.
#! * If the poset is known to be atomic, then by a description of the faces in terms of the atoms... usually we'll just need the list of the elements of maximal rank, from which all other elements may be obtained.
#! * As an `IsPosetOfElements`, where the elements could be anything, and we have a known function determining the partial order on the elements.
#! Usually, we assume that the poset will have a natural rank function on it. More information on the poset attributes that are important in the study of abstract polytopes and maniplexes is available in <Cite Key="McMSch02"/>, <Cite Key="MonPelWil14"/>, and <Cite Key="Wil12"/>.

#! @Arguments list
#! @Returns `IsPosetOfFlags`. 
#! @Description Given a <A>list</A> of lists of faces in increasing rank, where each face is described by the incident flags, gives you a IsPosetOfFlags object back.
#! Posets constructed this way are assumed to be IsP1 and IsP2.
DeclareOperation("PosetFromFaceListOfFlags",[IsList]);
#! Here we have a poset using the `IsPosetOfFlags` description for the triangle.
#! @BeginExampleSession
#! gap> poset:=PosetFromFaceListOfFlags([[[1,2,3,4,5,6]],[[1,2],[3,6],[4,5]],[[1,4],[2,3],[5,6]],[[1,2,3,4,5,6]]]);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! gap> FaceListOfPoset(poset);
#! [ [ [ 1, 2, 3, 4, 5, 6 ] ], [ [ 1, 2 ], [ 3, 6 ], [ 4, 5 ] ], [ [ 1, 4 ], [ 2, 3 ], [ 5, 6 ] ], [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! @EndExampleSession

#! @Arguments g
#! @Returns `IsPosetOfFlags` with `IsP1`=true.
#! @Description Given a group, returns a poset with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function includes the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetFromConnectionGroup",[IsPermGroup]);
#! @BeginExampleSession
#! gap> g:=Group([(1,4)(2,3)(5,6),(1,2)(3,6)(4,5)]);
#! Group([ (1,4)(2,3)(5,6), (1,2)(3,6)(4,5) ])
#! gap> PosetFromConnectionGroup(g);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! @EndExampleSession


#! @Arguments mani
#! @Returns `IsPosetOfFlags` 
#List of lists of faces, ordered by rank. Each face is a list of the flags it contains.
#! @Description Given a maniplex, returns a poset of the maniplex with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does include the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetFromManiplex", [IsManiplex]);
#! @BeginExampleSession
#! gap> p:=HemiCube(3);
#! Regular 3-polytope of type [ 4, 3 ] with 24 flags
#! gap> PosetFromManiplex(p);
#! A poset using the IsPosetOfFlags representation with 15 faces.
#! @EndExampleSession


#helper function for PosetFromPartialOrder, converts a binary relation to a binary relation on points.
DeclareOperation("POConvertToBROnPoints",[IsBinaryRelation]);

#! @Arguments partialOrder
#! @Returns `IsPosetOfIndices`
#! @Description Given a partial order on a finite set of size $n$, this function will create a partial order on `[1..n]`.
DeclareOperation("PosetFromPartialOrder",[IsBinaryRelation]);
#! @BeginExampleSession
#! gap> l:=List([[1,1],[1,2],[1,3],[1,4],[2,4],[2,2],[3,3],[4,4]],x->Tuple(x));
#! gap> r:=BinaryRelationByElements(Domain([1..4]), l);
#! <general mapping: Domain([ 1 .. 4 ]) -> Domain([ 1 .. 4 ]) >
#! gap> poset:=PosetFromPartialOrder(r);
#! A poset using the IsPosetOfIndices representation 
#! gap> h:=HasseDiagramBinaryRelation(PartialOrder(poset));
#! <general mapping: Domain([ 1 .. 4 ]) -> Domain([ 1 .. 4 ]) >
#! gap> Successors(h);
#! [ [ 2, 3 ], [ 4 ], [  ], [  ] ]
#! @EndExampleSession
#! Note that what we've accomplished here is the poset containing the elements 1, 2, 3, 4 with partial order determined by whether the first element divides the second. The essential information about the poset can be obtained from the Hasse diagram.

#! @Arguments list
#! @Returns `IsPosetOfAtoms`
#! @Description Given a list of elements, where each element is given as a list of atoms, this function will construct the corresponding poset. Note that this will construct any implied faces as well (i.e., all possible intersections of the listed faces).
DeclareOperation("PosetFromAtomicList",[IsList]);
#! @BeginExampleSession
#! gap> list:=[[1,2,3],[1,2,4],[1,3,4],[2,3,4]];
#! [ [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3, 4 ], [ 2, 3, 4 ] ]
#! gap> poset:=PosetFromAtomicList(list);;
#! gap> List(Faces(poset),AtomList);
#! [ [  ], [ 1 ], [ 1, 2 ], [ 1, 2, 3 ], [ 1, 2, 4 ], [ 1, 3 ], [ 1, 3, 4 ], [ 1, 4 ], [ 2 ], [ 2, 3 ], 
#!   [ 2, 3, 4 ], [ 2, 4 ], [ 3 ], [ 3, 4 ], [ 4 ], [ 1 .. 4 ] ]
#! gap> ml:=["abc","abd","acd","bcd"];;
#! gap> p:=PosetFromAtomicList(ml);;
#! gap> List(Flags(p),x->List(x,AtomList));
#! [ [ [  ], "a", "ab", "abc", "abcd" ], [ [  ], "a", "ab", "abd", "abcd" ], 
#!   [ [  ], "a", "ac", "abc", "abcd" ], [ [  ], "a", "ac", "acd", "abcd" ], 
#!   [ [  ], "a", "ad", "abd", "abcd" ], [ [  ], "a", "ad", "acd", "abcd" ], 
#!   [ [  ], "b", "ab", "abc", "abcd" ], [ [  ], "b", "ab", "abd", "abcd" ], 
#!   [ [  ], "b", "bc", "abc", "abcd" ], [ [  ], "b", "bc", "bcd", "abcd" ], 
#!   [ [  ], "b", "bd", "abd", "abcd" ], [ [  ], "b", "bd", "bcd", "abcd" ], 
#!   [ [  ], "c", "ac", "abc", "abcd" ], [ [  ], "c", "ac", "acd", "abcd" ], 
#!   [ [  ], "c", "bc", "abc", "abcd" ], [ [  ], "c", "bc", "bcd", "abcd" ], 
#!   [ [  ], "c", "cd", "acd", "abcd" ], [ [  ], "c", "cd", "bcd", "abcd" ], 
#!   [ [  ], "d", "ad", "abd", "abcd" ], [ [  ], "d", "ad", "acd", "abcd" ], 
#!   [ [  ], "d", "bd", "abd", "abcd" ], [ [  ], "d", "bd", "bcd", "abcd" ], 
#!   [ [  ], "d", "cd", "acd", "abcd" ], [ [  ], "d", "cd", "bcd", "abcd" ] ]
#! @EndExampleSession

#! @Arguments list_of_faces, func
#! @Returns `IsPosetOfElements`
#! @Description This is for gathering elements with a known ordering <A>func</A> on two variables into a poset. Also note, the expectation is that <A>func</A> behaves similarly to IsSubset, i.e., <A>func</A> (x,y)=true means $y$ is less than  $x$ in the order.
DeclareOperation("PosetFromElements",[IsList,IsFunction]);
#! @BeginExampleSession
#! gap>  g:=SymmetricGroup(3);
#! Sym( [ 1 .. 3 ] )
#! gap> asg:=AllSubgroups(g);
#! [ Group(()), Group([ (2,3) ]), Group([ (1,2) ]), Group([ (1,3) ]), Group([ (1,2,3) ]),   Group([ (1,2,3), (2,3) ]) ]
#! gap> poset:=PosetFromElements(asg,IsSubgroup);
#! A poset on 6 elements using the IsPosetOfIndices representation.
#! gap> HasseDiagramBinaryRelation(PartialOrder(poset));
#! <general mapping: Domain([ 1 .. 6 ]) -> Domain([ 1 .. 6 ]) >
#! gap> Successors(last);
#! [ [ 2, 3, 4, 5 ], [ 6 ], [ 6 ], [ 6 ], [ 6 ], [  ] ]
#! gap> List( ElementsList(poset){[2,6]}, ElementObject);
#! [ Group([ (2,3) ]), Group([ (1,2,3), (2,3) ]) ]
#! @EndExampleSession

#! @Arguments successorsList
#! @Returns  poset
#! @Description Given a list of immediate successors, will construct the poset. A valid list of successors is of the form `[[2,3],[3],[]]` where the $i$-th entry is a list of elements that are greater than the $i$-th element in the partial order that determines the poset. If the given list isn't reflexive and transitive, this function will induce those properties from the given list of successors.
DeclareOperation("PosetFromSuccessorList", [IsList]);
#! @BeginExampleSession
#! gap> p:=PosetFromManiplex(HemiCube(3));;
#! gap> Print(p);
#! PosetFromSuccessorList([ [ 2, 3, 4, 5 ], [ 6, 7, 9 ], [ 6, 8, 11 ], [ 7, 10, 11 ], 
#! [ 8, 9, 10 ], [ 1, 2, 13 ], [ 12, 14 ], [ 12, 14 ], [ 13, 14 ], [ 12, 13 ], [ 13, 14 ], 
#! [ 15 ], [ 15 ], [ 15 ], [ ] ]);
#! @EndExampleSession

#! @BeginGroup Helper functions
#! @GroupTitle Helper functions for special partial orders
#! The functions PairCompareFlagsList and PairCompareAtomsList are used in poset construction.

#! @Arguments list1, list2
#! @Returns `true` or `false`
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form [`listOfFlags`,`i`] where `listOfFlags` is a list of flags in the face and `i` is the rank of the face. Allows comparison of HasFlagList elements.
DeclareOperation("PairCompareFlagsList",[IsList,IsList]);

#! @Arguments list1, list2
#! @Returns `true` or `false`
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form `[listOfAtoms,int]` where `listOfAtoms` is a list of flags in the face and `int` is the rank of the face. Allows comparison of HasAtomList elements.
DeclareOperation("PairCompareAtomsList",[IsList,IsList]);
#! @EndGroup 

#! @Arguments poset
#! @Returns dual
#! @Description Given a <A>poset</A>, will construct a poset isomorphic to the dual of <A>poset</A>.
DeclareOperation("DualPoset",[IsPoset]);
#! @BeginExampleSession
#! gap> p:=PosetFromManiplex(Cube(3));; c:=PosetFromManiplex(CrossPolytope(3));;
#! gap> IsIsomorphicPoset(DualPoset(DualPoset(p)),p);
#! true
#! gap> IsIsomorphicPoset(DualPoset(p),c);
#! true
#! gap> IsIsomorphicPoset(DualPoset(p),p);
#! false
#! @EndExampleSession

#! @Arguments face1, face2, poset
#! @Returns section
#! @Description Constructs the section of the <A>poset</A> <A>face1</A>$/$<A>face2</A>.
DeclareOperation("Section",[IsFace, IsFace, IsPoset]);
#! @BeginExampleSession
#! gap> poset:=PosetFromManiplex(PyramidOver(Cube(2)));;
#! gap> faces:=Faces(poset);;List(faces,x->RankInPoset(x,poset));
#! [ -1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3 ]
#! gap> IsIsomorphicPoset(Section(faces[15],faces[1],poset),PosetFromManiplex(Simplex(2)));
#! true
#! gap> IsIsomorphicPoset(Section(faces[16],faces[1],poset),PosetFromManiplex(Cube(2)));
#! true
#! gap> IsIsomorphicPoset(Section(faces[20],faces[2],poset),PosetFromManiplex(Cube(2)));
#! true
#! @EndExampleSession

#! @BeginGroup Cleaving
#! @GroupTitle Cleaving polytopes
#! @Arguments p, k
#! @Returns IsPolytope
#! @Description Given an IsPolytope <A>p</A>, and an IsInt <A>k</A>, `Cleave(polytope,k)` will construct the $k^{th}$-cleaved polytope of <A>p</A>. Cleaved polytopes were introduced by Daniel Pellicer <Cite Key="Pel18"/>. 
DeclareOperation("Cleave", [IsPoset,IsInt]);
#! @BeginExampleSession
#! gap> Cleave(PosetFromManiplex(Cube(4)),3);
#! A poset on 290 elements using the IsPosetOfIndices representation.
#! @EndExampleSession

#! @Arguments p, k
#! @Returns IsPolytope
#! @Description `PartiallyCleave(p,k)` will construct the $k^{\textrm{th}}$-partially cleaved polytope of <A>p</A>.
DeclareOperation("PartiallyCleave", [IsPoset,IsInt]);


#! @EndGroup Cleaving