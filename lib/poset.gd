# Dealing with maniplexes as posets


#! @Chapter Combinatorics and Structure
#! @Section Posets

#! @Arguments list
#! @Returns __IsPosetOfFlags__. Not that the function is INTENTIONALLY agnostic about whether it is being given full poset or not.
#! @Description Given a <A>list</A> of lists of faces in increasing rank, where each face is described by the incident flags, gives you a IsPosetOfFlags object back.
DeclareOperation("PosetFromFaceListOfFlags",[IsList]);


#Poset attributes
#DeclareAttribute("IsFullPoset",IsPoset,"mutable");
#DeclareAttribute("IsFlaggable",IsPoset);
DeclareAttribute("RankPoset",IsPoset);

#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Checks or creates the value of the attribute IsFull for an IsPoset.
DeclareAttribute("IsFull",IsPoset,"mutable");
DeclareAttribute("IsFlaggable",IsPoset);


#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Given a <A>poset</A> (whose elements are lists of flags) corresponding to a maniplex, this function will tell you if it is flaggable, i.e., if the flags can be recovered from the poset or not.
DeclareOperation("IsFlaggablePoset",[IsPosetOfFlags]);

#! @Arguments list
#! @Returns __true__ or __false__
#! @Description Given <A>list</A>, a poset as a list of faces ordered by rank, each face listing the flags on the face, this function will tell you if the poset is full or not.
DeclareOperation("ListIsFullPoset",[IsList]);


#! @Arguments poset
#! @Returns __integer__
#! @Description Given a <A>poset</A>, returns the rank of the poset. Note: There may be hidden assumptions here to untangle later.
DeclareOperation("RankOfPoset", [IsPoset]);


#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Lets me check to see if a poset is NOT full.  For use in certain filtering operations.
DeclareOperation("IsNotFull",[IsPoset]);


#! @Arguments g
#! @Returns __IsPosetOfFlags__ with __IsFull__=false.
#! @Description Given a group, returns a poset with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfConnectionGroup",[IsPermGroup]);

#! @Arguments g
#! @Returns __IsPosetOfFlags__ with __IsFull__=true.
#! @Description Returns a full poset corresponding to the connection group <A>g</A> with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. This function does include the minimal (empty) face nor the maximal face of the maniplex, so the list has $n+2$ ranks if the maniplex is of rank $n$. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("FullPosetOfConnectionGroup",[IsPermGroup]);

#! @Arguments mani
#! @Returns __IsPosetOfFlags__ 
#List of lists of faces, ordered by rank. Each face is a list of the flags it contains.
#! @Description Given a maniplex, returns a poset of the maniplex with an internal representation as a list of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does not include the minimal (empty) face nor the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("PosetOfManiplex", [IsManiplex]);

#! @Arguments mani
#! @Returns __IsPosetOfFlags__
#List of lists of faces, ordered by rank. Each face is a list of the flags it contains.
#! @Description Given a maniplex, returns a poset with the internal representation be a list of lists of faces ordered by rank, where each face is represented as a list of the flags it contains. Note that this function does include the minimal (empty) face and the maximal face of the maniplex. Note that the $i$-faces correspond to the $i+1$ item in the list because of how GAP indexes lists.
DeclareOperation("FullPosetOfManiplex", [IsManiplex]);


#! @Arguments object1, object2
#! @Returns __true__ or __false__
#! @Description Given two faces, will tell you if they are incident. Currently only supports faces as list of their incident flags.
DeclareOperation("AreIncidentFaces",[IsObject,IsObject]);

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

#! @Arguments poset
#! @Returns A binary relation on the integers 1 through $n$, where $n$ is the number of faces of the full poset.
#! @Description FacesOfPosetAsBinaryRelationOnFaces 
DeclareOperation("FacesOfPosetAsBinaryRelationOnFaces",[IsPoset]);

##! @Arguments 
##! @Returns 
##! @Description 



#! @Arguments poset1, poset2
#! @Returns __true__ or __false__
#! @Description Determines whether <A>poset1</A> and <A>poset2</A> are isomorphic.

