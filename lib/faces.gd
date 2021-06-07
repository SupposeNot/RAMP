#! @Chapter Combinatorics and Structure
#! @Section Faces

#! @Arguments P, i
#! @Returns The number of <A>i</A>-faces that <A>P</A> has.
DeclareOperation("NumberOfIFaces", [IsAbstractPolytope, IsInt]);

#! @Arguments P
DeclareAttribute("NumberOfVertices", IsAbstractPolytope);
#! @Arguments P
DeclareAttribute("NumberOfEdges", IsAbstractPolytope);
#! @Arguments P
DeclareAttribute("NumberOfFacets", IsAbstractPolytope);
#! @Arguments P
DeclareAttribute("NumberOfRidges", IsAbstractPolytope);
#! @Arguments P
DeclareAttribute("Fvector", IsAbstractPolytope);

#! @Arguments P
#! @Description Currently only works for regular polytopes.
DeclareAttribute("Facets", IsAbstractPolytope);

#! @Arguments P
#! @Description Currently only works for regular polytopes.
DeclareAttribute("VertexFigures", IsAbstractPolytope);

