

############# Element stuff #################

#! @Chapter Posets
#! @Section Elements of posets, also known as faces.


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

#! @Arguments face1, face2, poset
#! @Returns meet
#! @Description Finds (when possible) the meet of two elements in a poset.
DeclareOperation("Meet",[IsFace, IsFace, IsPoset]);

#! @Arguments face1, face2, poset
#! @Returns meet
#! @Description Finds (when possible) the join of two elements in a poset.
DeclareOperation("Join",[IsFace, IsFace, IsPoset]);