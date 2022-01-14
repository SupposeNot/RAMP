
#! @Chapter Constructions
#! @Section Extensions, amalgamations, and quotients

#! @Arguments n
#! @Returns IsManiplex
#! @Description Constructs the universal polytope of rank <A>n</A>.
DeclareOperation("UniversalPolytope", [IsInt]);

#! @Arguments M
#! @Returns IsManiplex
#! @Description Constructs the universal extension of <A>M</A>, i.e. the maniplex with facets
#! isomorphic to <A>M</A> that covers all other maniplexes with facets
#! isomorphic to <A>M</A>.
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex]);

#! @Arguments M, k
#! @Returns IsManiplex
#! @Description Constructs the universal extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.
#! Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex, IsInt]);

#! @Arguments M
#! @Returns IsManiplex
#! @Description Constructs the trivial extension of <A>M</A>, also known as {<A>M</A>, 2}.
DeclareOperation("TrivialExtension", [IsManiplex]);

#! @Arguments M, k
#! @Returns IsManiplex#! @Description Constructs the flat extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.

#! (As defined in **Flat Extensions of Abstract Polytopes** <Cite Key="Cun21"/>.)
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("FlatExtension", [IsManiplex, IsInt]);

#! @Arguments M1, M2
#! @Returns IsManiplex
#! @Description Constructs the amalgamation of <A>M1</A> and <A>M2</A>.
#! Implicitly assumes that <A>M1</A> and <A>M2</A> are compatible.
#! @Description Currently only defined for reflexible maniplexes.
DeclareOperation("Amalgamate", [IsManiplex, IsManiplex]);

#! @Arguments M
#! @Returns IsManiplex
#! @Description Given a 3-maniplex <A>M</A>, returns its medial.
DeclareOperation("Medial", [IsManiplex]);
