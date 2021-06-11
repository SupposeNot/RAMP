
#! @Chapter Constructions
#! @Section Extensions, amalgamations, and quotients

#! @Arguments n
#! Returns the universal polytope of rank <A>n</A>.
DeclareOperation("UniversalPolytope", [IsInt]);

#! @Arguments p, q, i, j
#! Returns the flat regular polyhedron with automorphism group
#! [p, q] / (r2 r1 r0 r1 = (r0 r1)^i (r1 r2)^j).
#! This function does not currently validate the inputs to make sure
#! that the output makes sense.
DeclareOperation("FlatRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);

#! @Arguments M, rels
#! Returns the quotient of <A>M</A> by <A>rels</A>, which may be given
#! as either a list of Tietze words, such as [[1,2,1,0,1,2,1,0]] or as
#! a string like "(r0 r1 r2 r1)^2, (r0 r1 r2)^4".
DeclareOperation("QuotientPolytope", [IsManiplex, IsList]);

#! @Arguments M
#! Returns the universal extension of <A>M</A>, i.e. the maniplex with facets
#! isomorphic to <A>M</A> that covers all other maniplexes with facets
#! isomorphic to <A>M</A>.
#! Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex]);

#! @Arguments M, k
#! Returns the universal extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.
#! Currently only defined for reflexible maniplexes.
DeclareOperation("UniversalExtension", [IsManiplex, IsInt]);

#! @Arguments M
#! Returns the trivial extension of <A>M</A>, also known as {<A>M/</A>, 2}.
DeclareOperation("TrivialExtension", [IsManiplex]);

#! @Arguments M, k
#! Returns the flat extension of <A>M</A> with last entry of Schlafli symbol <A>k</A>.
#! (As defined in "Flat Extensions of Abstract Polytopes".)
#! Currently only defined for reflexible maniplexes.
DeclareOperation("FlatExtension", [IsManiplex, IsInt]);

#! @Arguments M1, M2
#! Returns the amalgamation of <A>M1</A> and <A>M2</A>.
#! Implicitly assumes that <A>M1</A> and <A>M2</A> are compatible.
#! Currently only defined for reflexible maniplexes.
DeclareOperation("Amalgamate", [IsManiplex, IsManiplex]);

#! @Arguments M
#! Given a 3-maniplex <A>M</A>, returns its medial.
DeclareOperation("Medial", [IsManiplex]);
