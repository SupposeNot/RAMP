
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
#! @Description Constructs the amalgamation of <A>M1</A> and <A>M2</A>.
#! Implicitly assumes that <A>M1</A> and <A>M2</A> are compatible.
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("Amalgamate", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> Amalgamate(Cube(3),CrossPolytope(3));
#! reflexible 4-maniplex of type [ 4, 3, 4 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns IsManiplex
#! @Description Given a 3-maniplex <A>M</A>, returns its medial.
DeclareOperation("Medial", [IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Medial(Dodecahedron()));
#! [ [ 3, 5 ], 4 ]
#! @EndExampleSession78
