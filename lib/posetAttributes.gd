
#! @Chapter Posets
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
