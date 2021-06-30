
# Dealing with maniplexes as posets



#! @Chapter Posets
#! I'm in the process of reconciling all of this, but there are going to be a number of ways to `define` a poset:
#! * As an `IsPosetOfFlags`, where the underlying description is an ordered list of length $n+2$. Each of the $n+2$ list elements is a list of faces, and the assumption is that these are the faces of rank $i-2$, where $i$ is the index in the master list (e.g., `l[1][1]` would usually correspond to the unique $-1$ face of a polytope -- and there won't be an `l[1][2]`). Each face is then a list of the flags incident with that face.
#! * As an `IsPosetOfIndices`, where the underlying description is a binary relation on a set of indices, which correspond to labels for the elements of the poset.
#! * If the poset is known to be atomic, then by a description of the faces in terms of the atoms... usually we'll just need the list of the elements of maximal rank, from which all other elements may be obtained.
#! * As an `IsPosetOfElements`, where the elements could be anything, and we have a known function determining the partial order on the elements.
#! Usually, we assume that the poset will have a natural rank function on it.


#! @Section Poset constructors

#! @Arguments list
#! @Returns `IsPosetOfFlags`. Note that the function is INTENTIONALLY agnostic about whether it is being given full poset or not.
#! @Description Given a <A>list</A> of lists of faces in increasing rank, where each face is described by the incident flags, gives you a IsPosetOfFlags object back. Note that if you don't include faces or ranks, this function doesn't know about about them!
DeclareOperation("PosetFromFaceListOfFlags",[IsList]);
#! Here we have a poset using the `IsPosetOfFlags` description for the triangle.
#! @BeginExampleSession
#! gap> poset:=PosetFromFaceListOfFlags([[[]],[[1,2],[3,6],[4,5]],[[1,4],[2,3],[5,6]],[[1,2,3,4,5,6]]]);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! gap> FaceListOfPoset(poset);
#! [ [ [  ] ], [ [ 1, 2 ], [ 3, 6 ], [ 4, 5 ] ], [ [ 1, 4 ], [ 2, 3 ], [ 5, 6 ] ], [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! @EndExampleSession

#! @Arguments g
#! @Returns `IsPosetOfFlags` with `IsP1`=true.
#! @Description Given a group, returns a poset with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function includes the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfConnectionGroup",[IsPermGroup]);
#! @BeginExampleSession
#! gap> g:=Group([(1,4)(2,3)(5,6),(1,2)(3,6)(4,5)]);
#! Group([ (1,4)(2,3)(5,6), (1,2)(3,6)(4,5) ])
#! gap> PosetOfConnectionGroup(g);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! @EndExampleSession


#! @Arguments mani
#! @Returns `IsPosetOfFlags` 
#List of lists of faces, ordered by rank. Each face is a list of the flags it contains.
#! @Description Given a maniplex, returns a poset of the maniplex with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does include the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfManiplex", [IsManiplex]);
#! @BeginExampleSession
#! gap> p:=HemiCube(3);
#! Regular 3-polytope of type [ 4, 3 ] with 24 flags
#! gap> PosetOfManiplex(p);
#! A poset using the IsPosetOfFlags representation with 15 faces.
#! @EndExampleSession


#helper function for PosetFromPartialOrder
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
#! gap> UnderlyingRelation(h);
#! Domain([ DirectProductElement( [ 1, 2 ] ), DirectProductElement( [ 1, 3 ] ), DirectProductElement( [ 2, 4 ] ) ])
#! @EndExampleSession
#! Note that what we've accomplished here is the poset containing the elements 1, 2, 3, 4 with partial order determined by whether the first element divides the second. The essential information about the poset can be obtained from the Hasse diagram.


#! @Arguments list_of_faces, {func}
#! @Returns `IsPosetOfElements`
#! @Description This is for gathering elements with a known ordering <A>func</A> on two variables into a poset. Note... you should expect to get complete garbage if you send it a list of faces of different types. If your list of faces HasFlagList or HasAtomList, you may omit the function. Also note, the expectation is that <A>func</A> behaves similarly to IsSubset, i.e., <A>func</A> (x,y)=true means $y$ is less than  $x$ in the order.
#! Also worth noting, is that the internal representation of this kind of poset can and does keep both the partial order on the indices, and the list of faces corresponding to those indices, and the binary relation <A>func</A> (if the <A>list_of_faces</A> elements all have HasFlagList or HasAtomList, this will be the operation `PairCompareFlagsList` or `PairCompareAtomsList`).
DeclareOperation("PosetFromElements",[IsList]);
#! @BeginExampleSession
#! gap> g:=SymmetricGroup(3);
#! Sym( [ 1 .. 3 ] )
#! gap> asg:=AllSubgroups(g);
#! [ Group(()), Group([ (2,3) ]), Group([ (1,2) ]), Group([ (1,3) ]), Group([ (1,2,3) ]), Group([ (1,2,3), (2,3) ]) ]
#! gap> poset:=PosetFromElements(asg,IsSubgroup);
#! A poset using the IsPosetOfIndices representation 
#! gap> HasseDiagramBinaryRelation(PartialOrder(poset));
#! <general mapping: Domain([ 1 .. 6 ]) -> Domain([ 1 .. 6 ]) >
#! gap> UnderlyingRelation(last);
#! Domain([ DirectProductElement( [ 1, 2 ] ), DirectProductElement( [ 1, 3 ] ), DirectProductElement( [ 1, 4 ] ),   DirectProductElement( [ 1, 5 ] ), DirectProductElement( [ 2, 6 ] ), DirectProductElement( [ 3, 6 ] ),   DirectProductElement( [ 4, 6 ] ), DirectProductElement( [ 5, 6 ] ) ])
#! gap> ElementsList(poset){[2,6]};
#! [ Group([ (2,3) ]), Group([ (1,2,3), (2,3) ]) ]
#! @EndExampleSession
#! Here we have an example of how we can store a partially ordered set, and recover information about which objects are incident in the partial order.
#! Another interesting example:
#! @BeginExampleSession
#! gap> poset:=PosetOfManiplex(HemiCube(3));
#! A poset using the IsPosetOfFlags representation with 15 faces.
#! gap> rfl:=RankedFaceListOfPoset(poset);
#! [ [ [  ], -1 ], [ [ 1, 6, 2, 9, 3, 13 ], 0 ], [ [ 4, 14, 16, 23, 11, 21 ], 0 ], [ [ 5, 22, 8, 17, 19, 20 ], 0 ], 
#!   [ [ 7, 10, 12, 24, 15, 18 ], 0 ], [ [ 1, 5, 2, 8 ], 1 ], [ [ 3, 11, 13, 21 ], 1 ], [ [ 4, 12, 16, 7 ], 1 ], 
#!   [ [ 6, 15, 9, 18 ], 1 ], [ [ 10, 19, 24, 20 ], 1 ], [ [ 14, 22, 23, 17 ], 1 ], 
#!   [ [ 1, 5, 6, 22, 15, 14, 12, 4 ], 2 ], [ [ 2, 8, 3, 19, 11, 10, 16, 7 ], 2 ], 
#!   [ [ 9, 18, 13, 24, 21, 20, 23, 17 ], 2 ], 
#!   [ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 ], 3 ] ]
#! gap> Apply(rfl,PosetElementFromListOfFlags);
#! gap> pos2:=PosetFromElements(rfl);
#! A poset using the IsPosetOfIndices representation 
#! gap>  List(FacesList(pos2),x->Rank(x));
#! [ -1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3 ]
#! @EndExampleSession

#Helper functions for PosetFromElements
#! @Arguments list1, list2
#! @Returns `true` or `false`
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form [`listOfFlags`,`i`] where `listOfFlags` is a list of flags in the face and `i` is the rank of the face.
DeclareOperation("PairCompareFlagsList",[IsList,IsList]);

#! @Arguments list1, list2
#! @Returns `true` or `false`
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form `[listOfAtoms,int]` where `listOfAtoms` is a list of flags in the face and `int` is the rank of the face.
DeclareOperation("PairCompareAtomsList",[IsList,IsList]);

#! @Section Poset attributes

DeclareAttribute("ElementsList", IsPoset); #for storing facelists
DeclareSynonymAttr("FacesList", ElementsList);
DeclareAttribute("OrderingFunction", IsPoset); #helpful for facelist info.
# DeclareAttribute("Ranks", IsPoset,"mutable"); #for storing the list of ranks in the poset
# for what it is worth, thinking about killing off the full versus not stuff. Just make the user make a NEW poset with all the stuff in it they want.

DeclareAttribute("RankPoset", IsPoset);

#! @Arguments poset
#! @Returns `list`
#! @Description Gives the list of maximal chains in a P1 poset in terms of the elements of the poset. Synonym function is `FlagsList`.
DeclareAttribute("MaximalChains", IsPoset,"mutable");
#! @BeginExampleSession
#! gap> poset:=PosetOfManiplex(HemiCube(3));
#! A poset using the IsPosetOfFlags representation with 15 faces.
#! gap> rfl:=RankedFaceListOfPoset(poset);
#! [ [ [  ], -1 ], [ [ 1, 6, 2, 9, 3, 13 ], 0 ], [ [ 4, 14, 16, 23, 11, 21 ], 0 ], [ [ 5, 22, 8, 17, 19, 20 ], 0 ], 
#!   [ [ 7, 10, 12, 24, 15, 18 ], 0 ], [ [ 1, 5, 2, 8 ], 1 ], [ [ 3, 11, 13, 21 ], 1 ], [ [ 4, 12, 16, 7 ], 1 ], 
#!   [ [ 6, 15, 9, 18 ], 1 ], [ [ 10, 19, 24, 20 ], 1 ], [ [ 14, 22, 23, 17 ], 1 ], 
#!   [ [ 1, 5, 6, 22, 15, 14, 12, 4 ], 2 ], [ [ 2, 8, 3, 19, 11, 10, 16, 7 ], 2 ], 
#!   [ [ 9, 18, 13, 24, 21, 20, 23, 17 ], 2 ], 
#!   [ [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 ], 3 ] ]
#! gap> Apply(rfl,PosetElementFromListOfFlags);
#! gap> pos2:=PosetFromElements(rfl);
#! A poset using the IsPosetOfIndices representation 
#! gap> MaximalChains(pos2)[1];
#! [ An element of a poset., An element of a poset., An element of a poset., An element of a poset., 
#!   An element of a poset. ]
#! gap> List(last,Rank);
#! [ -1, 0, 1, 2, 3 ]
#! @EndExampleSession


DeclareSynonymAttr("FlagsList", MaximalChains);

#! @Arguments poset
#! @Description Checks or creates the value of the attribute IsFlaggable for an IsPoset. Point here is to see if the structure of the poset is sufficient to determine the flag graph.  For IsPosetOfFlags this is another way of saying that the intersection of the faces (thought of as collections of flags) containing a flag is that selfsame flag. (Might be equivalent to prepolytopal... but Gabe was tired and Gordon hasn't bothered to think about it yet.)
DeclareProperty("IsFlaggable",IsPoset);


#! @Arguments poset
#! @Description Checks if <A>poset</A> is atomic. `Note, currently something that is not computed, just declared.`
DeclareProperty("IsAtomic",IsPoset);

#! @Arguments poset
#! @Returns `partial order`
#! @Description HasPartialOrder Checks if <A>poset</A> has a declared partial order (binary relation). SetPartialOrder assigns a partial order to the <A>poset</A>. `Note, currently something that is not computed, just declared.`
DeclareAttribute("PartialOrder", IsPoset);


#! @Arguments list
#! @Returns `true` or `false`
#! @Description Given <A>list</A>, comprised of sublists of faces ordered by rank, each face listing the flags on the face, this function will tell you if the list corresponds to a P1 poset or not.
DeclareOperation("ListIsP1Poset",[IsList]);


#! @Arguments poset
#! @Returns `integer`
#! @Description Given a <A>poset</A>, returns the rank of the poset. Note: There may be hidden assumptions here to untangle later. NOT IMPLEMENTED YET.
DeclareOperation("RankOfPoset", [IsPoset]);



#! @Arguments poset
#! @Description Determines whether a poset has property P1 from ARP.
DeclareProperty("IsP1", IsPoset);




#! @Section Working with posets

#! @Arguments object1, object2
#! @Returns `true` or `false`
#! @Description Given two faces, will tell you if they are incident. Currently only supports faces as list of their incident flags.
DeclareOperation("AreIncidentFlagFaces",[IsObject,IsObject]);

#! @Arguments poset
#! @Returns `IsList`
#a list of flags as a list of faces from <A>PosetFromFaceListOfFlags</A>.
#! @Description Given a <A>poset</A>, this will give you a version of the list of flags in terms of the faces described in the <A>poset</A>. Note that the flag list does not include the empty face or the maximal face.
DeclareOperation("FlagsAsListOfFacesFromPoset",[IsPoset]); 

#! @Arguments poset, flag, i
#! @Returns `flag(s)`
#! @Description Given a flag (represented as chains of faces comprised of lists of flags) and a poset  and a rank, this function will give you the <A>i</A>-adjacent flag. Note that adjacencies are listed from ranks 0 to one less than the dimension.
#! You can replace <A>flag</A> with the integer corresponding to that flag.
#! Appending `true` to the arguments will give the position of the flag instead of its description from `FlagsAsListOfFacesFromPoset`.
DeclareOperation("AdjacentFlag",[IsPosetOfFlags,IsList,IsInt]);

#! @Arguments poset, i
#! @Returns A permutation on the flags.
#! @Description Given a <A>poset</A> and an integer $i$, this function will give you the associated permutation for the rank $i$-connection.
DeclareOperation("ConnectionGeneratorOfPoset",[IsPoset,IsInt]);


#! @Arguments poset
#! @Returns `IsPermGroup`
#! @Description Given a <A>poset</A> corresponding to a maniplex, this function will give you the connection group.
DeclareOperation("ConnectionGroupOfPoset",[IsPoset]);

##! @Arguments poset
##! @Returns A binary relation on the integers 1 through $n$, where $n$ is the number of faces of the full poset.
##! @Description FacesOfPosetAsBinaryRelationOnFaces 
#DeclareOperation("FacesOfPosetAsBinaryRelationOnFaces",[IsPoset]);


##! @Arguments poset
##! @Returns `list`
##! @Description Gives a list of faces collected into lists ordered by increasing rank. 
DeclareOperation("FaceListOfPoset",[IsPoset]);

############# Face stuff #################

#! @Section Elements of posets, also known as faces.

#! @Subsection Element properties

#! @Arguments posetelement {face}
#! @Returns `true` or `false`
#! @Description The rank of a poset element. Alternately `RankFace`(<A>IsPosetElement</A>).
DeclareAttribute("RankPosetElement",IsPosetElement); 
#the rank in the poset of the element
DeclareSynonymAttr("RankFace",RankPosetElement);

#! @Arguments posetelement {face}
#! @Returns `list`
#! @Description Description of <A>posetelement</A> n as a list of incident flags (when present).
DeclareAttribute("FlagList", IsPosetElement); #list of incident flags

#! @Arguments posetelement {face}
#! @Returns `poset`
#! @Description Gives the poset to which the face belongs (when present).
DeclareAttribute("FromPoset",IsPosetElement); #Which poset the element belongs to.

#! @Arguments posetelement {face}
#! @Returns `list`
#! @Description Description of <A>posetelement</A> n as a list of atoms (when present).
DeclareAttribute("AtomList", IsPosetElement); #list of atoms

#! 
DeclareAttribute("Index", IsPosetElement); #face index, i.e., label from some list of unique identifiers


#! @Arguments list, n
#! @Returns `IsPosetElement`
#! @Description This is used to create a face of rank <A>n</A> from a <A>list</A> of flags of poset. If an IsPoset object is appended to the input will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromListOfFlags",[IsList,IsInt]);


#! @Arguments list, n
#! @Returns `IsFace`
#! @Description Creates a `face` with <A>list</A> of atoms at rank <A>n</A>. If an IsPoset object is appended to the input will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromAtomList",[IsList,IsInt]);

#! @Arguments obj, n
#! @Returns `IsFace`
#! @Description Creates a `face` with index <A>obj</A> at rank <A>n</A>. If an IsPoset object is appended to will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromIndex",[IsObject,IsInt]);

#! @Arguments poset
#! @Returns `list`
#! @Description Gives a list of [<A>face</A>,<A>rank</A>] pairs for all the faces of <A>poset</A>.
DeclareOperation("RankedFaceListOfPoset",[IsPoset]);



#! @Arguments [face1,face1]
#! @Returns `true` or `false`
#! @Description <A>face1</A> and <A>face2</A> are IsFace or IsPosetElement. Subface will check to make sure <A>face2</A> is a subface of <A>face1</A>. 
DeclareOperation("IsSubface", [IsFace,IsFace]);


###To Do

#! @Arguments poset1, poset2
#! @Returns `true` or `false`
#! @Description Determines whether <A>poset1</A> and <A>poset2</A> are isomorphic.



