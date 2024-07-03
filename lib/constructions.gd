
#! @Chapter Polytope Constructions and Operations
#! @Section Extensions, amalgamations, and quotients

#! @Arguments n
#! @Returns IsManiplex
#! @Description Constructs the universal polytope of rank <A>n</A>.
DeclareOperation("UniversalPolytope", [IsInt]);
#! @BeginExampleSession
#! gap> UniversalPolytope(3);
#! UniversalPolytope(3)
#! gap> Rank(last);
#! 3
#! @EndExampleSession


#! @Arguments M
#! @Returns IsManiplex
#! @Description Constructs the universal extension of <A>M</A>, i.e. the maniplex with facets
#! isomorphic to <A>M</A> that covers all other maniplexes with facets
#! isomorphic to <A>M</A>.
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex]);
#! @BeginExampleSession
#! gap> UniversalExtension(Cube(3));
#! regular 4-polytope of type [ 4, 3, infinity ] with infinity flags
#! @EndExampleSession

#! @Arguments M, k
#! @Returns IsManiplex
#! @Description Constructs the universal extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.
#! Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> UniversalExtension(Cube(3),2);
#! regular 4-polytope of type [ 4, 3, 2 ] with 96 flags
#! @EndExampleSession


#! @Arguments M
#! @Returns IsManiplex
#! @Description Constructs the trivial extension of <A>M</A>, also known as {<A>M</A>, 2}.
DeclareOperation("TrivialExtension", [IsManiplex]);
#! @BeginExampleSession
#! gap> TrivialExtension(Dodecahedron());
#! regular 4-polytope of type [ 5, 3, 2 ] with 240 flags
#! @EndExampleSession

#! @Arguments M, k
#! @Returns IsManiplex#! @Description Constructs the flat extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.
#! (As defined in **Flat Extensions of Abstract Polytopes** <Cite Key="Cun21"/>.)
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("FlatExtension", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> FlatExtension(Simplex(3),4);
#! reflexible 4-maniplex of type [ 3, 3, 4 ] with 48 flags
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns IsManiplex
#! @Description Constructs the amalgamation of the n-maniplexes <A>M1</A> and <A>M2</A>. This does not check
#! whether <A>M1</A> and <A>M2</A> are compatible, so the output may not have facets
#! isomorphic to <A>M1</A> or vertex-figures isomorphic to <A>M2</A>.
#! Currently only defined for rotary maniplexes. Note that if M1 and M2 are chiral, then the
#! amalgamation depends on the choices of base flag for each.
DeclareOperation("Amalgamate", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> Amalgamate(Cube(3), Simplex(3)) = Cube(4);
#! true
#! gap> Size(Amalgamate(ToroidalMap44([1,2]), Cube(3)));
#! 240
#! gap> Size(Amalgamate(ToroidalMap44([1,2]), ToroidalMap44([2,1])));
#! 240
#! gap> Size(Amalgamate(ToroidalMap44([1,2]), ToroidalMap44([1,2])));
#! 4
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns IsManiplex
#! @Description Constructs the amalgamation of the n-maniplexes <A>M1</A> and <A>M2</A>, and then
#! fills in some data, assuming that the universal amalgamation exists (i.e., that there is no
#! collapse of the facets or vertex-figures). You should only use this if you are certain
#! from theory that the universal amalgamation exists.
DeclareOperation("AmalgamateNC", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> A := Amalgamate(ToroidalMap44([1,2]), ToroidalMap44([2,1]));;
#! gap> HasSchlafliSymbol(A); HasFacet(A);
#! false
#! false
#! gap> A2 := AmalgamateNC(ToroidalMap44([1,2]), ToroidalMap44([2,1]));;
#! gap> HasSchlafliSymbol(A2); HasFacet(A2);
#! true
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns IsManiplex
#! @Description Given a 3-maniplex <A>M</A>, returns its medial.
DeclareOperation("Medial", [IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Medial(Dodecahedron()));
#! [ [ 3, 5 ], 4 ]
#! @EndExampleSession78



#! @Arguments M
#! @Returns List
#! @Description Given a maniplex M,
#! returns the maniplex defined by the operation 2^M from Section 8C of Abstract Regular Polytopes.
#!
DeclareAttribute("TwoToThe", IsManiplex);
#! @BeginExampleSession
#! gap> TwoToThe(Simplex(3))=Cube(4);
#! true
#! @EndExampleSession
