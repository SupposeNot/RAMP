
#! @Chapter Polytope Constructions and Operations
#! @Section Abstract Regular Polytopes from Groups

#! @Arguments gamma, rank
#! @Returns record
#! @Description
#! Searches for rank <A>rank</A> string C-group representations of
#! <A>gamma</A>. The returned record contains the involutions of
#! <A>gamma</A>, the induced automorphism action on those involutions,
#! representatives up to automorphism, representatives up to automorphism
#! and duality, and search statistics. These representations encode the
#! abstract regular polytopes whose automorphism group is <A>gamma</A>.
DeclareOperation("ARPsFromGroupSearch", [IsGroup, IsPosInt]);
#! The component <C>reps</C> gives representatives up to isomorphism as
#! string C-groups, while <C>repsModDuality</C> also identifies dual pairs.
#! @BeginExampleSession
#! gap> search := ARPsFromGroupSearch(AlternatingGroup(5), 3);;
#! gap> Length(search.reps);
#! 3
#! gap> Length(search.repsModDuality);
#! 2
#! @EndExampleSession

#! @Arguments gamma, rank
#! @Returns list
#! @Description
#! Returns representatives of the rank <A>rank</A> string C-group
#! representations of <A>gamma</A>, up to automorphisms of <A>gamma</A>.
DeclareOperation("ARPsFromGroup", [IsGroup, IsPosInt]);
#! This two-argument form does not identify dual representations.
#! @BeginExampleSession
#! gap> Length(ARPsFromGroup(AlternatingGroup(5), 3));
#! 3
#! gap> ARPsFromGroup(PSL(3,2), 3);
#! [  ]
#! @EndExampleSession

#! @Arguments gamma, rank, identifyDuals
#! @Returns list
#! @Description
#! Returns representatives of the rank <A>rank</A> string C-group
#! representations of <A>gamma</A>. If <A>identifyDuals</A> is true, dual
#! representations are identified.
DeclareOperation("ARPsFromGroup", [IsGroup, IsPosInt, IsBool]);
#! Passing <K>false</K> gives representatives up to isomorphism as string
#! C-groups; passing <K>true</K> also collapses dual pairs.
#! @BeginExampleSession
#! gap> Length(ARPsFromGroup(AlternatingGroup(5), 3, false));
#! 3
#! gap> Length(ARPsFromGroup(AlternatingGroup(5), 3, true));
#! 2
#! @EndExampleSession

#! @Arguments gamma, rank
#! @Returns record
#! @Description
#! Synonym for <C>ARPsFromGroupSearch</C> using string C-group
#! terminology.
DeclareOperation("StringCGroupRepresentationSearch", [IsGroup, IsPosInt]);
#! @BeginExampleSession
#! gap> search := StringCGroupRepresentationSearch(PSL(2,11), 4);;
#! gap> Length(search.reps);
#! 1
#! @EndExampleSession

#! @Arguments gamma, rank
#! @Returns list
#! @Description
#! Synonym for <C>ARPsFromGroup</C> using string C-group terminology.
DeclareOperation("StringCGroupRepresentations", [IsGroup, IsPosInt]);
#! @BeginExampleSession
#! gap> Length(StringCGroupRepresentations(PSL(2,11), 3));
#! 4
#! @EndExampleSession

#! @Arguments gamma, rank, identifyDuals
#! @Returns list
#! @Description
#! Synonym for <C>ARPsFromGroup</C> using string C-group terminology.
DeclareOperation("StringCGroupRepresentations", [IsGroup, IsPosInt, IsBool]);
#! As for <C>ARPsFromGroup</C>, the third argument controls whether
#! dual representations are identified.
#! @BeginExampleSession
#! gap> Length(StringCGroupRepresentations(PSL(2,11), 3, true));
#! 3
#! @EndExampleSession
