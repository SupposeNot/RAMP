
#! @Chapter Combinatorics and Structure
#! @Section Faces

#! @Arguments M, i
#! Returns The number of <A>i</A>-faces of <A>M</A>.
DeclareOperation("NumberOfIFaces", [IsManiplex, IsInt]);

#! @Arguments M
#! Returns the number of vertices of <A>M</A>.
DeclareAttribute("NumberOfVertices", IsManiplex);

#! @Arguments M
#! Returns the number of edges of <A>M</A>.
DeclareAttribute("NumberOfEdges", IsManiplex);

#! @Arguments M
#! Returns the number of facets of <A>M</A>.
DeclareAttribute("NumberOfFacets", IsManiplex);

#! @Arguments M
#! Returns the number of ridges ((n-2)-faces) of <A>M</A>.
DeclareAttribute("NumberOfRidges", IsManiplex);

#! @Arguments M
#! Returns the f-vector of <A>M</A>.
DeclareAttribute("Fvector", IsManiplex);

#! @Arguments M
#! Returns the facet-types of <A>M</A> (i.e. the maniplexes corresponding to the facets).
#! Currently only works for reflexible maniplexes.
DeclareAttribute("Facets", IsManiplex);

#! @Arguments M
#! Returns the types of vertex-figures of <A>M</A> (i.e. the maniplexes corresponding to the vertex-figures).
#! Currently only works for reflexible maniplexes.
DeclareAttribute("VertexFigures", IsManiplex);

