

#! @Chapter Posets
#! @Section Working with posets

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

#! @Arguments poset
#! @Returns posetFromAtoms
#! @Description If <A>poset</A> is an IsP1 poset admits a description of its elements in terms of its atoms, this function will construct an isomorphic poset whose faces are described using PosetFromAtomList.
DeclareOperation("AsPosetOfAtoms", [IsPoset]);
#! @BeginExampleSession
#! gap> poset:=PosetFromManiplex(Cube(2));;
#! gap> p2:=AsPosetOfAtoms(poset);
#! A poset on 10 elements using the IsPosetOfIndices representation.
#! gap> IsIsomorphicPoset(poset,p2);
#! true
#! @EndExampleSession

#! @BeginGroup Special Faces
#! @GroupTitle Max/min faces

#! @Arguments poset
#! @Returns face
#! @Description Gives the minimal/maximal face of a <A>poset</A> when it IsP1 and IsP2.
DeclareOperation("MinFace", [IsPoset]);
DeclareOperation("MaxFace", [IsPoset]);
#! @EndGroup Special Faces