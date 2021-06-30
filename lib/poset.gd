
# Dealing with maniplexes as posets



#! @Chapter Posets
#! I'm in the process of reconciling all of this, but there are going to be a number of ways to __define__ a poset:
#! * As an __IsPosetOfFlags__, where the underlying description is an ordered list of length $n+2$. Each of the $n+2$ list elements is a list of faces, and the assumption is that these are the faces of rank $i-2$, where $i$ is the index in the master list (e.g., __l[1][1]__ would usually correspond to the unique $-1$ face of a polytope -- and there won't be an __l[1][2]__). Each face is then a list of the flags incident with that face.
#! * As an __IsPosetOfIndices__, where the underlying description is a binary relation on a set of indices, which correspond to labels for the elements of the poset.
#! * If the poset is known to be atomic, then by a description of the faces in terms of the atoms... usually we'll just need the list of the elements of maximal rank, from which all other elements may be obtained.
#! * As an __IsPosetOfElements__, where the elements could be anything, and we have a known function determining the partial order on the elements.
#! Usually, we assume that the poset will have a natural rank function on it.


#! @Section Poset constructors

#! @Arguments list
#! @Returns __IsPosetOfFlags__. Note that the function is INTENTIONALLY agnostic about whether it is being given full poset or not.
#! @Description Given a <A>list</A> of lists of faces in increasing rank, where each face is described by the incident flags, gives you a IsPosetOfFlags object back. Note that if you don't include faces or ranks, this function doesn't know about about them!
DeclareOperation("PosetFromFaceListOfFlags",[IsList]);
#! Here we have a poset using the __IsPosetOfFlags__ description for the triangle.
#! @BeginExampleSession
#! gap> poset:=PosetFromFaceListOfFlags([[[]],[[1,2],[3,6],[4,5]],[[1,4],[2,3],[5,6]],[[1,2,3,4,5,6]]]);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! gap> FaceListOfPoset(poset);
#! [ [ [  ] ], [ [ 1, 2 ], [ 3, 6 ], [ 4, 5 ] ], [ [ 1, 4 ], [ 2, 3 ], [ 5, 6 ] ], [ [ 1, 2, 3, 4, 5, 6 ] ] ]
#! @EndExampleSession

#! @Arguments g
#! @Returns __IsPosetOfFlags__ with __IsFull__=true.
#! @Description Given a group, returns a poset with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function includes the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfConnectionGroup",[IsPermGroup]);

#! @BeginExampleSession
#! gap> g:=Group([(1,4)(2,3)(5,6),(1,2)(3,6)(4,5)]);
#! Group([ (1,4)(2,3)(5,6), (1,2)(3,6)(4,5) ])
#! gap> PosetOfConnectionGroup(g);
#! A poset using the IsPosetOfFlags representation with 8 faces.
#! @EndExampleSession


#! @Arguments mani
#! @Returns __IsPosetOfFlags__ 
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
#! @Returns __IsPosetOfIndices__
#! @Description Given a partial order on a finite set of size $n$, this function will create a partial order on __[1..n]__.
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
#! @Returns __IsPosetOfElements__
#! @Description This is for gathering elements with a known ordering <A>func</A> on two variables into a poset. Note... you should expect to get complete garbage if you send it a list of faces of different types. If your list of faces HasFlagList or HasAtomList, you may omit the function. Also note, the expectation is that <A>func</A> behaves similarly to IsSubset, i.e., <A>func</A> (x,y)=true means $y$ is less than  $x$ in the order.
#! Also worth noting, is that the internal representation of this kind of poset can and does keep both the partial order on the indices, and the list of faces corresponding to those indices, and the binary relation <A>func</A> (if the <A>list_of_faces</A> elements all have HasFlagList or HasAtomList, this will be the operation __PairCompareFlagsList__ or __PairCompareAtomsList__).
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

#Helper functions for PosetFromElements
#! @Arguments list1, list2
#! @Returns __true__ or __false__
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form [__listOfFlags__,__i__] where __listOfFlags__ is a list of flags in the face and __i__ is the rank of the face.
DeclareOperation("PairCompareFlagsList",[IsList,IsList]);

#! @Arguments list1, list2
#! @Returns __true__ or __false__
#! @Description Function assumes <A>list1</A> and <A>list2</A> are of the form __[listOfAtoms,int]__ where __listOfAtoms__ is a list of flags in the face and __int__ is the rank of the face.
DeclareOperation("PairCompareAtomsList",[IsList,IsList]);

#! @Section Poset attributes

DeclareAttribute("ElementsList", IsPoset); #for storing facelists
DeclareSynonymAttr("FacesList", IsPoset);
DeclareAttribute("OrderingFunction", IsPoset); #helpful for facelist info.
DeclareAttribute("Ranks", IsPoset,"mutable"); #for storing the list of ranks in the poset
# for what it is worth, thinking about killing off the full versus not stuff. Just make the user make a NEW poset with all the stuff in it they want.

DeclareAttribute("RankPoset",IsPoset);

# @Arguments poset
# @Returns __true__ or __false__
# @Description Checks or creates the value of the attribute IsFull for an IsPoset.
# DeclareAttribute("IsFull",IsPoset);


DeclareAttribute("IsFlaggable",IsPoset);


#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Checks if <A>poset</A> is atomic. __Note, currently something that is not computed, just declared.__
DeclareAttribute("IsAtomic",IsPoset);

#! @Arguments poset
#! @Returns __partial order__
#! @Description HasPartialOrder Checks if <A>poset</A> has a declared partial order (binary relation). SetPartialOrder assigns a partial order to the <A>poset</A>. __Note, currently something that is not computed, just declared.__
DeclareAttribute("PartialOrder", IsPoset);


#! @Arguments list
#! @Returns __true__ or __false__
#! @Description Given <A>list</A>, a poset as a list of faces ordered by rank, each face listing the flags on the face, this function will tell you if the poset is full or not.
 DeclareOperation("ListIsFullPoset",[IsList]);


#! @Arguments poset
#! @Returns __integer__
#! @Description Given a <A>poset</A>, returns the rank of the poset. Note: There may be hidden assumptions here to untangle later. NOT IMPLEMENTED YET.
DeclareOperation("RankOfPoset", [IsPoset]);


##! @Arguments poset
##! @Returns __true__ or __false__
##! @Description Lets me check to see if a poset is NOT full.  For use in certain filtering operations.
#DeclareOperation("IsNotFull",[IsPoset]);

#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Determines whether a poset has property P1 from ARP.
DeclareAttribute("IsP1", IsPoset);




#! @Section Working with posets

#! @Arguments object1, object2
#! @Returns __true__ or __false__
#! @Description Given two faces, will tell you if they are incident. Currently only supports faces as list of their incident flags.
DeclareOperation("AreIncidentFlagFaces",[IsObject,IsObject]);

#! @Arguments poset
#! @Returns __IsList__
#a list of flags as a list of faces from <A>PosetFromFaceListOfFlags</A>.
#! @Description Given a <A>poset</A>, this will give you a version of the list of flags in terms of the faces described in the <A>poset</A>. Note that the flag list does not include the empty face or the maximal face.
DeclareOperation("FlagsAsListOfFacesFromPoset",[IsPoset]); 

#! @Arguments poset, flag, i
#! @Returns __flag(s)__
#! @Description Given a flag (represented as chains of faces comprised of lists of flags) and a poset  and a rank, this function will give you the <A>i</A>-adjacent flag. Note that adjacencies are listed from ranks 0 to one less than the dimension.
#! You can replace <A>flag</A> with the integer corresponding to that flag.
#! Appending __true__ to the arguments will give the position of the flag instead of its description from __FlagsAsListOfFacesFromPoset__.
DeclareOperation("AdjacentFlag",[IsPosetOfFlags,IsList,IsInt]);

#! @Arguments poset, i
#! @Returns A permutation on the flags.
#! @Description Given a <A>poset</A> and an integer $i$, this function will give you the associated permutation for the rank $i$-connection.
DeclareOperation("ConnectionGeneratorOfPoset",[IsPoset,IsInt]);


#! @Arguments poset
#! @Returns __IsPermGroup__
#! @Description Given a <A>poset</A> corresponding to a maniplex, this function will give you the connection group.
DeclareOperation("ConnectionGroupOfPoset",[IsPoset]);

##! @Arguments poset
##! @Returns A binary relation on the integers 1 through $n$, where $n$ is the number of faces of the full poset.
##! @Description FacesOfPosetAsBinaryRelationOnFaces 
#DeclareOperation("FacesOfPosetAsBinaryRelationOnFaces",[IsPoset]);


##! @Arguments poset
##! @Returns __list__
##! @Description Gives a list of faces collected into lists ordered by increasing rank. 
DeclareOperation("FaceListOfPoset",[IsPoset]);

############# Face stuff #################

#! @Section Elements of posets, also known as faces.

#! @Subsection Element properties

#! @Arguments posetelement {face}
#! @Returns __true__ or __false__
#! @Description The rank of a poset element. Alternately __RankFace__(<A>IsPosetElement</A>).
DeclareAttribute("RankPosetElement",IsPosetElement); 
#the rank in the poset of the element
DeclareSynonymAttr("RankFace",RankPosetElement);

#! @Arguments posetelement {face}
#! @Returns __list__
#! @Description Description of <A>posetelement</A> n as a list of incident flags (when present).
DeclareAttribute("FlagList", IsPosetElement); #list of incident flags

#! @Arguments posetelement {face}
#! @Returns __poset__
#! @Description Gives the poset to which the face belongs (when present).
DeclareAttribute("FromPoset",IsPosetElement); #Which poset the element belongs to.

#! @Arguments posetelement {face}
#! @Returns __list__
#! @Description Description of <A>posetelement</A> n as a list of atoms (when present).
DeclareAttribute("AtomList", IsPosetElement); #list of atoms

#! 
DeclareAttribute("Index", IsPosetElement); #face index, i.e., label from some list of unique identifiers


#! @Arguments list, n
#! @Returns __IsPosetElement__
#! @Description This is used to create a face of rank <A>n</A> from a <A>list</A> of flags of poset. If an IsPoset object is appended to the input will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromListOfFlags",[IsList,IsInt]);


#! @Arguments list, n
#! @Returns __IsFace__
#! @Description Creates a __face__ with <A>list</A> of atoms at rank <A>n</A>. If an IsPoset object is appended to the input will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromAtomList",[IsList,IsInt]);

#! @Arguments obj, n
#! @Returns __IsFace__
#! @Description Creates a __face__ with index <A>obj</A> at rank <A>n</A>. If an IsPoset object is appended to will tell the element what poset it belongs to.
DeclareOperation("PosetElementFromIndex",[IsObject,IsInt]);

#! @Arguments poset
#! @Returns __list__
#! @Description Gives a list of [<A>face</A>,<A>rank</A>] pairs for all the faces of <A>poset</A>.
DeclareOperation("RankedFaceListOfPoset",[IsPoset]);



#! @Arguments [face1,face1]
#! @Returns __true__ or __false__
#! @Description <A>face1</A> and <A>face2</A> are IsFace or IsPosetElement. Subface will check to make sure <A>face2</A> is a subface of <A>face1</A>. 
DeclareOperation("IsSubface", [IsFace,IsFace]);


###To Do

#! @Arguments poset1, poset2
#! @Returns __true__ or __false__
#! @Description Determines whether <A>poset1</A> and <A>poset2</A> are isomorphic.



