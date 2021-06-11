# Dealing with maniplexes as posets

DeclareCategory("IsPoset", IsObject);

#in each of the represenations below, at some level, the object is going to be a list. At this point, the expectation is that all of them will have some way of storing the flags in a face, and some way of accessing the rank of the face (either by position or by label).

#DeclareRepresentation("IsPosetAsListOfListsByRank",IsComponentObjectRep and IsAttributeStoringRep,["ListedByIncreasingRank"]);
#DeclareRepresentation("IsPosetAsListOfListsByRank",IsComponentObjectRep and IsAttributeStoringRep,["ListedByIncreasingRankWithRanks"]);
#DeclareRepresentation("IsPosetAsListOfListsByRank",IsComponentObjectRep and IsAttributeStoringRep,["FacesWithRanks"]);


#! @Chapter Combinatorics and Structure
#! @Section Posets

#! @Arguments g
#! Given a group, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfConnectionGroup",[IsGroup]);

#! @Arguments g
#! Returns a full poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. This function does include the minimal (empty) face nor the maximal face of the maniplex, so the list has <A>n+2</A> ranks if the maniplex is of rank <A>n</A>. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.
DeclareOperation("FullPosetOfConnectionGroup",[IsGroup]);

#! @Arguments mani
#! Given a maniplex, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfManiplex", [IsManiplex]);

#! @Arguments mani
#! Given a maniplex, returns a poset as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does include the minimal (empty) face and the maximal face of the maniplex. Note that the <A>i</A>-faces correspond to the <A>i+1</A> item in the list because of how GAP indexes lists.
DeclareOperation("FullPosetOfManiplex", [IsManiplex]);


DeclareOperation("AreIncidentFaces",[IsObject,IsObject]);

#! @Arguments poset
#! Given a poset, (not a fullposet) this will give you a version of the list of flags in terms of the faces described in the poset.
DeclareOperation("FlagsAsListOfFacesFromPoset",[IsList]); 


#! @Arguments flag,flags,i
#! Given a flag and a list of flags (represented as chains of faces comprised of lists of flags) and a rank, this function will give you the <A>i</A>-adjacent flag. Note that adjacencies are listed from ranks 0 to one less than the dimension.
DeclareOperation("AdjacentFlag",[IsList,IsList,IsInt]);

#! @Arguments poset, i
#! Given a <A>poset</A> and an integer <A>i</A>, this function will give you the associated permutation for the rank <A>i</A>-connection.
DeclareOperation("ConnectionGeneratorOfPoset",[IsList,IsInt]);


#! @Arguments poset
#! Given a <A>poset</A> corresponding to a maniplex, this function will give you the connection group. Note that it assumes we are NOT using a full poset (currently).
DeclareOperation("ConnectionGroupOfPoset",[IsList]);



#! @Arguments poset
#! Given a <A>poset</A> (whose elements are lists of flags) corresponding to a maniplex, this function will tell you if it is flaggable, i.e., if the flags can be recovered from the poset or not.
DeclareOperation("IsFlaggablePoset",[IsList]);