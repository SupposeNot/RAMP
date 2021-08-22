
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
#! 
#! __Notes:__ I'm rethinking this a little bit. Since we __already__ know that the poset admits a description in terms of faces described by incident flags, then we have a set with a natural rank function, and all maximal chains must be the same length. I think I should probably take advantage of that a little more. Will rewrite the code to take advantage of the assumptions that IsP1 and IsP2 are true. I'll try not to break things.
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


#! @Section Poset attributes

#! Posets have many properties we might be interested in. Here's a few.


#! @Arguments poset
#! @Description Gives the list of maximal chains in a poset in terms of the elements of the poset. Synonyms are `FlagsList` and `Flags`. 
#! Tends to work faster (sometimes significantly) if the poset `HasPartialOrder`.
DeclareAttribute("MaximalChains", IsPoset);
#! Synonym is `FlagsList`.


DeclareSynonymAttr("FlagsList", MaximalChains);
DeclareSynonymAttr("Flags", MaximalChains);
#! @BeginExampleSession
#! gap> poset:=PosetFromManiplex(HemiCube(3));
#! A poset using the IsPosetOfFlags representation.
#! gap> MaximalChains(poset)[1];
#! [ An element of a poset made of flags, An element of a poset made of flags, 
#!   An element of a poset made of flags, An element of a poset made of flags, 
#!   An element of a poset made of flags ]
#! gap> List(last,x->RankInPoset(x,poset));
#! [ -1, 0, 1, 2, 3 ]
#! @EndExampleSession


#! @Arguments poset
#! @Description If the poset `IsP1`, ranks are assumed to run from $-1$ to $n$, and function will return $n$. If `IsP1(poset)=false`, ranks are assumed to run from 1 to $n$.
#! In RAMP, at least currently, we are assuming that graded/ranked posets are bounded. 
#! Note that in general what you __actually__ want to do is call `Rank(poset)`. The reason is that `Rank` will calculate the `RankPoset` if it isn't set, and then set and store the value in the poset.
DeclareAttribute("RankPoset", IsPoset);

#! @BeginGroup elements
#! @Arguments poset
#! @Description Will recover the list of faces of the poset, format may depend on __type__ of representation of `poset`.
#! * We also have `FacesList` and `Faces` as synonyms for this command.
DeclareAttribute("ElementsList", IsPoset); #for storing facelists


DeclareSynonymAttr("FacesList", ElementsList);
DeclareSynonymAttr("Faces", ElementsList);
#! @EndGroup

#! @Arguments poset
#! @Description `OrderingFunction` is an attribute of a poset which stores a function for ordering elements.
DeclareAttribute("OrderingFunction", IsPoset); #helpful for facelist info.
#! @BeginExampleSession
#! gap> p:=PosetFromManiplex(Cube(2));;
#! gap> p3:=PosetFromElements(RankedFaceListOfPoset(p),PairCompareFlagsList);;
#! gap> f3:=FacesList(p3);;
#! gap> OrderingFunction(p3)(ElementObject(f3[2]),ElementObject(f3[1]));
#! true
#! gap> OrderingFunction(p3)(ElementObject(f3[1]),ElementObject(f3[2]));
#! false
#! @EndExampleSession




#! @Arguments poset
#! @Description Checks or creates the value of the attribute `IsFlaggable` for an `IsPoset`. Point here is to see if the structure of the poset is sufficient to determine the flag graph.  For IsPosetOfFlags this is another way of saying that the intersection of the faces (thought of as collections of flags) containing a flag is that selfsame flag. (Might be equivalent to prepolytopal... but Gabe was tired and Gordon hasn't bothered to think about it yet.)
#! Now also works with generic poset element types (not just `IsPosetOfFlags`).
DeclareProperty("IsFlaggable",IsPoset);


#! @Arguments poset
#! @Description This checks whether or not the faces of an IsP1 poset may be described uniquely in terms of the posets atoms.
#!
#! Note: At some point this will have to be renamed, but I've forgotten the right terminology. 
DeclareProperty("IsAtomic", IsPoset);
#! @BeginExampleSession
#! gap> po:=BinaryRelationOnPoints([[2,3],[4,5],[4,5],[6],[6],[]]);;
#! gap> po:=ReflexiveClosureBinaryRelation(TransitiveClosureBinaryRelation(po));;
#! gap> p:=PosetFromPartialOrder(po);; IsAtomic(p);
#! false
#! gap> p2:=PosetFromManiplex(Cube(3));; IsAtomic(p2);
#! true
#! @EndExampleSession

#! @Arguments poset
#! @Returns `partial order`
#! @Description HasPartialOrder Checks if <A>poset</A> has a declared partial order (binary relation). SetPartialOrder assigns a partial order to the <A>poset</A>. In many cases, PartialOrder is able to compute one from structural information.
DeclareAttribute("PartialOrder", IsPoset);


#! @Arguments list
#! @Returns `true` or `false`
#! @Description Given <A>list</A>, comprised of sublists of faces ordered by rank, each face listing the flags on the face, this function will tell you if the list corresponds to a P1 poset or not.
DeclareOperation("ListIsP1Poset",[IsList]);


#! @Arguments poset
#! @Description Determines whether a poset has property P1 from ARP.
DeclareProperty("IsP1", IsPoset);
#! @BeginExampleSession
#! gap> p:=PosetFromElements(AllSubgroups(AlternatingGroup(4)),IsSubgroup);
#! A poset using the IsPosetOfIndices representation 
#! gap> IsP1(p);
#! true
#! gap> p2:=PosetFromFaceListOfFlags([[[1],[2]],[[1,2]]]);
#! A poset using the IsPosetOfFlags representation with 3 faces.
#! gap> IsP1(p2);
#! false
#! @EndExampleSession


#! @Arguments poset
#! @Description Determines whether a poset has property P2 from ARP.
DeclareProperty("IsP2", IsPoset);
#! @BeginExampleSession
#! gap> poset:=PosetFromManiplex(HemiCube(3)); 
#! gap> IsP2(poset);
#! true
#! @EndExampleSession
#! Another nice example
#! @BeginExampleSession
#! gap> g:=AlternatingGroup(4);; a:=AllSubgroups(g);; poset:=PosetFromElements(a,IsSubgroup);
#! A poset using the IsPosetOfIndices representation 
#! gap> IsP2(poset);
#! false
#! @EndExampleSession

#! @Arguments poset
#! @Description Determines whether a poset is strongly flag connected (property P3' from ARP). May also be called with command `IsStronglyFlagConnected`. If you are not working with a pre-polytope, expect this to take a LONG time.
DeclareProperty("IsP3", IsPoset);


DeclareSynonymAttr("IsStronglyFlagConnected", IsP3);

#! Helper for IsP3
#! @Arguments poset
#! @Description Determines whether a poset is flag connected.
DeclareProperty("IsFlagConnected", IsPoset);


#! @Arguments poset
#! @Description Determines whether a poset satisfies the diamond condition. May also be invoked using `IsDiamondCondition`.
DeclareProperty("IsP4", IsPoset);


DeclareSynonymAttr("IsDiamondCondition", IsP4);


#! @Arguments poset
#! @Description Determines whether a poset is an abstract polytope.
DeclareProperty("IsPolytope", IsPoset);
#! @BeginExampleSession
#! gap> poset:=PosetFromManiplex(Cube(3));
#! A poset using the IsPosetOfFlags representation with 28 faces.
#! gap> IsPolytope(poset);
#! true
#! gap> KnownPropertiesOfObject(poset);
#! [ "IsP1", "IsP2", "IsP3", "IsP4", "IsPolytope" ]
#! gap> poset2:=PosetFromElements(AllSubgroups(AlternatingGroup(4)),IsSubgroup);
#! A poset using the IsPosetOfIndices representation 
#! gap> IsPolytope(poset2);
#! false
#! gap> KnownPropertiesOfObject(poset2);
#! [ "IsP1", "IsP2", "IsPolytope" ]
#! @EndExampleSession

#! @Arguments poset
#! @Description Determines whether a poset is an abstract pre-polytope.
DeclareProperty("IsPrePolytope", IsPoset);


#! @Section Working with posets


#! @Arguments poset1, poset2
#! @Returns `true` or `false`
#! @Description Determines whether <A>poset1</A> and <A>poset2</A> are equal by

#! @Arguments poset1, poset2
#! @Returns `true` or `false`
#! @Description Determines whether <A>poset1</A> and <A>poset2</A> are isomorphic by checking to see if their Hasse diagrams are isomorphic.
DeclareOperation("IsIsomorphicPoset",[IsPoset,IsPoset]);
#! @BeginExampleSession
#! gap>  IsIsomorphicPoset( PosetFromManiplex( PyramidOver( Cube(3) ) ),  PosetFromManiplex( PrismOver (PyramidOver( Cube(2) ) ) ) );
#! false
#! gap>  IsIsomorphicPoset( PosetFromManiplex( PyramidOver( Cube(3) ) ), PosetFromManiplex( PyramidOver( PrismOver( Cube(2) ) ) ) );
#! true
#! @EndExampleSession

#! @Arguments poset1, poset2
#! @Returns map on face indices
#! @Description When <A>poset1</A> and <A>poset2</A> are isomorphic, will give you a map from the faces of <A>poset1</A> to the faces of <A>poset2</A>.
DeclareOperation("PosetIsomorphism",[IsPoset,IsPoset]);

#! @Arguments poset
#! @Returns `IsList`
#a list of flags as a list of faces from `PosetFromFaceListOfFlags`.
#! @Description Given a <A>poset</A>, this will give you a version of the list of flags in terms of the proper faces described in the <A>poset</A>. Note that the flag list does not include the minimal face or the maximal face if the poset IsP2; i.e., this gives a list of flags where each face is described in terms of its (enumerated) list of incident flags. 
DeclareOperation("FlagsAsListOfFacesFromPoset",[IsPoset]); 

#! @Arguments IsPosetOfFlags
#! @Returns `list`
#! @Description Gives a list of [<A>face</A>,<A>rank</A>] pairs for all the faces of <A>poset</A>. Assumptions here are that faces are lists of incident flags.
DeclareOperation("RankedFaceListOfPoset",[IsPoset]);

#! @Arguments poset, flag, i
#! @Returns `flag(s)`
#! @Description Given a poset, a flag, and a rank, this function will give you the <A>i</A>-adjacent flag. Note that adjacencies are listed from ranks 0 to one less than the dimension.
#! You can replace <A>flag</A> with the integer corresponding to that flag.
#! Appending `true` to the arguments will give the position of the flag instead of its description from `FlagsAsListOfFacesFromPoset`.
DeclareOperation("AdjacentFlag",[IsPosetOfFlags,IsList,IsInt]);

#Helper for flag connected
#! @Arguments poset, flagaslistoffaces, adjacencyrank
#! @Description If your poset isn't P4, there may be multiple adjacent maximal chains at a given rank. This function handles that case. May substitute `IsInt` for `flagaslistoffaces` corresponding to position of `flag` in list of maximal chains.
DeclareOperation("AdjacentFlags",[IsPoset,IsList,IsInt]);

# Helper again
#! @Arguments flag1, flag2
#! @Description Determines whether two chains are equal.
DeclareOperation("EqualChains",[IsList,IsList]);

#! @Arguments poset, i
#! @Returns A permutation on the flags.
#! @Description Given a <A>poset</A> and an integer $i$, this function will give you the associated permutation for the rank $i$-connection.
DeclareOperation("ConnectionGeneratorOfPoset",[IsPoset,IsInt]);


#! @Arguments poset
#! @Returns `IsPermGroup`
#! @Description Given a <A>poset</A> that is `IsPrePolytope`, this function will give you the connection group.
DeclareAttribute("ConnectionGroup",IsPoset);

#! @Arguments poset
#! @Description Given a <A>poset</A>, gives the automorphism group of the poset as an action on the maximal chains.
DeclareAttribute("AutomorphismGroup", IsPoset);

#! @Arguments poset
#! @Description Given a <A>poset</A>, gives the automorphism group of the poset as an action on the elements.
DeclareAttribute("AutomorphismGroupOnElements", IsPoset);



##! @Arguments poset
##! @Returns `list`
##! @Description Gives a list of faces collected into lists ordered by increasing rank. Suitable as input for `PosetFromFaceListOfFlags`. Argument must be IsPosetOfFlags.
DeclareOperation("FaceListOfPoset",[IsPoset]);

#! @Arguments poset
#! @Description Assigns to each face of a poset (when possible) the rank of the element in the poset. 
DeclareOperation("RankPosetElements",[IsPoset]);

DeclareSynonym("RankPosetFaces", RankPosetElements);

#! @Arguments poset
#! @Returns `list`
# #! @Description Gives lists of faces ordered by rank. Also sets the rank for each of the faces.
DeclareOperation("FacesByRankOfPoset",[IsPoset]);

#! @Arguments poset
#! @Returns directed graph
DeclareOperation("HasseDiagramOfPoset",[IsPoset]);


############# Element stuff #################

#! @Section Elements of posets, also known as faces.

#! @Subsection Element properties

#! @Arguments posetelement
#! @Returns list
#! @Description Gives the `list` of posets <A>posetelement</A> is in, and the corresponding rank (if available) as a list of ordered pairs of the form `[poset,rank]`. #!
#! Note that this attribute is mutable, so if you modify it you may break things.
DeclareAttribute("RanksInPosets", IsPosetElement,"mutable");

#! @Arguments posetelement, poset, int
#! @Returns null
#! @Description Adds an entry in the list of RanksInPosets for <A>posetelement</A> corresponding to <A>poset</A> with assigned rank <A>int</A>.
DeclareOperation("AddRanksInPosets",[IsPosetElement,IsPoset,IsInt]);



#! @Arguments posetelement {face}
#! @Returns `list`
#! @Description Description of <A>posetelement</A> n as a list of incident flags (when present).
DeclareAttribute("FlagList", IsPosetElement); #list of incident flags



#! @Arguments posetelement {face}
#! @Returns `list`
#! @Description Description of <A>posetelement</A> n as a list of atoms (when present).
DeclareAttribute("AtomList", IsPosetElement); #list of atoms

DeclareAttribute("Index", IsPosetElement); #face index, i.e., label from some list of unique identifiers

DeclareAttribute("ElementOrderingFunction", IsPosetElement); 

DeclareAttribute("ElementBR", IsPosetElement);

DeclareAttribute("ElementObject", IsPosetElement); 

#! @Section Element Constructors

#! @Arguments obj, func
#! @Returns `IsFace`
#! @Description Creates a `face` with <A>obj</A> and ordering function `func`.
DeclareOperation("PosetElementWithOrder",[IsObject,IsFunction]);

#! @Arguments list, poset, n
#! @Returns `IsPosetElement`
#! @Description This is used to create a face of rank <A>n</A> from a <A>list</A> of flags of <A>poset</A>.
DeclareOperation("PosetElementFromListOfFlags",[IsList,IsPoset,IsInt]);


#! @Arguments list
#! @Returns `IsFace`
#! @Description Creates a `face` with <A>list</A> of atoms. If you wish to assign ranks or membership in a poset, you must do this separately.
DeclareOperation("PosetElementFromAtomList",[IsList]);

#! @Arguments obj
#! @Returns `IsFace`
#! @Description Creates a `face` with index <A>obj</A> at rank <A>n</A>.
DeclareOperation("PosetElementFromIndex",[IsObject]);

#! @Arguments obj, order
#! @Returns `IsFace`
#! @Description Creates a `face` with index <A>obj</A> and BinaryRelation <A>order</A> on <A>obj</A>. Function does not check to make sure <A>order</A> has <A>obj</A> in its domain.
DeclareOperation("PosetElementWithPartialOrder",[IsObject, IsBinaryRelation]);

#! @Section Element operations



#! @Arguments [face,poset]
#! @Returns `IsInt`
#! @Description Given an element <A>face</A> and a poset <A>poset</A> to which it belongs, will give you the rank of <A>face</A> in <A>poset</A>.
DeclareOperation("RankInPoset",[IsPosetElement,IsPoset]);


#! @Arguments [face1,face2,poset]
#! @Returns `true` or `false`
#! @Description <A>face1</A> and <A>face2</A> are IsFace or IsPosetElement. IsSubface will check to see if  <A>face2</A> is a subface of <A>face1</A> in <A>poset</A>. You may drop the argument <A>poset</A> if the faces only belong to one poset in common.
#! Warning: if the elements are made up of atoms, then IsSubface doesn't need to know what poset you are working with.
DeclareOperation("IsSubface", [IsFace,IsFace,IsPoset]);

#! @Description Determines whether two faces are equal in a poset. Note that `\=` tests whether they are the identical object or not.
DeclareOperation("IsEqualFaces", [IsFace, IsFace, IsPoset]);


#! @Arguments object1, object2
#! @Returns `true` or `false`
#! @Description Given two poset elements, will tell you if they are incident. 
#! * Synonym function: `AreIncidentFaces`.
DeclareOperation("AreIncidentElements",[IsObject,IsObject]);

DeclareSynonym("AreIncidentFaces",AreIncidentElements);





