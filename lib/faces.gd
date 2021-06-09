#! @Chapter Combinatorics and Structure
#! @Section Faces

#! @Arguments P, i
#! @Returns The number of <A>i</A>-faces that <A>P</A> has.
DeclareOperation("NumberOfIFaces", [IsManiplex, IsInt]);

#! @Arguments P
DeclareAttribute("NumberOfVertices", IsManiplex);
#! @Arguments P
DeclareAttribute("NumberOfEdges", IsManiplex);
#! @Arguments P
DeclareAttribute("NumberOfFacets", IsManiplex);
#! @Arguments P
DeclareAttribute("NumberOfRidges", IsManiplex);
#! @Arguments P
DeclareAttribute("Fvector", IsManiplex);

#! @Arguments P
#! @Description Currently only works for regular polytopes.
DeclareAttribute("Facets", IsManiplex);

#! @Arguments P
#! @Description Currently only works for regular polytopes.
DeclareAttribute("VertexFigures", IsManiplex);

