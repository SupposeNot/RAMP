
# Dealing with maniplexes as posets


#! @Chapter Combinatorics and Structure
#! @Section Posets

#! @Arguments list
#! @Returns __IsPosetOfFlags__. Note that the function is INTENTIONALLY agnostic about whether it is being given full poset or not.
#! @Description Given a <A>list</A> of lists of faces in increasing rank, where each face is described by the incident flags, gives you a IsPosetOfFlags object back.
DeclareOperation("PosetFromFaceListOfFlags",[IsList]);


#! @Subsection Poset attributes
DeclareAttribute("RankPoset",IsPoset);

#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Checks or creates the value of the attribute IsFull for an IsPoset.
DeclareAttribute("IsFull",IsPoset,"mutable");
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
#! @Description Given a <A>poset</A>, returns the rank of the poset. Note: There may be hidden assumptions here to untangle later.
DeclareOperation("RankOfPoset", [IsPoset]);


#! @Arguments poset
#! @Returns __true__ or __false__
#! @Description Lets me check to see if a poset is NOT full.  For use in certain filtering operations.
DeclareOperation("IsNotFull",[IsPoset]);



#! @Subsection Poset constructors

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

#helper function for PosetFromPartialOrder
DeclareOperation("POConvertToBROnPoints",[IsBinaryRelation]);

#! @Arguments partialOrder
#! @Returns __IsPosetOfIndices__
#! @Description Given a partial order on a finite set of size $n$, this function will create a partial order on __[1..n]__.
DeclareOperation("PosetFromPartialOrder",[IsBinaryRelation]);


#! @Arguments list_of_faces, {function}
#! @Returns __IsPosetOfElements__
#! @Description This is for gathering elements with a known ordering <A>function</A> on two variables into a poset. Note... you should expect to get complete garbage if you send it a list of faces of different types. If your list of faces HasFlagList or HasAtomList, you may omit the function.
DeclareOperation("PosetFromElements",[IsList]);

#Helper functions for PosetFromElements
DeclareOperation("pairCompareFlagsList",[IsList,IsList]);
DeclareOperation("pairCompareAtomsList",[IsList,IsList]);

#! @Subsection Working with posets

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

##! @Arguments poset
##! @Returns A binary relation on the integers 1 through $n$, where $n$ is the number of faces of the full poset.
##! @Description FacesOfPosetAsBinaryRelationOnFaces 
#DeclareOperation("FacesOfPosetAsBinaryRelationOnFaces",[IsPoset]);


##! @Arguments poset
##! @Returns __list__
##! @Description Gives a list of faces collected into lists ordered by increasing rank. 
DeclareOperation("FaceListOfPoset",[IsPoset]);

############# Face stuff #################

#! @Subsection Elements of posets, also known as faces.

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


##TEst


