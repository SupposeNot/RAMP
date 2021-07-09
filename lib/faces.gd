
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

#! @Arguments M, j, i
#! Returns the section F_j / F_i, where F_j is the j-face of the base flag of <A>M</A> and
#! F_i is the i-face of the base flag.
DeclareOperation("Section", [IsManiplex, IsInt, IsInt]);

#! @Arguments M, j, i, k
#! Returns the section F_j / F_i, where F_j is the j-face of flag number <A>k</A> of <A>M</A> and
#! F_i is the i-face of the same flag.
DeclareOperation("Section", [IsManiplex, IsInt, IsInt, IsInt]);

#! @Arguments M, j, i
#! Returns all sections of type F_j / F_i, where F_j is a j-face and F_i is an incident i-face.
DeclareOperation("Sections", [IsManiplex, IsInt, IsInt]);

#! @Arguments M
#! Returns the facet-types of <A>M</A> (i.e. the maniplexes corresponding to the facets).
DeclareAttribute("Facets", IsManiplex);

#! @Arguments M, k
#! Returns the facet of <A>M</A> that contains the flag number <A>k</A> (that is, the maniplex corresponding to the facet).
DeclareOperation("Facet", [IsManiplex, IsInt]);

#! @Arguments M
#! Returns the facet of <A>M</A> that contains flag number 1 (that is, the maniplex corresponding to the facet).
DeclareAttribute("Facet", IsManiplex);

#! @Arguments M
#! Returns the types of vertex-figures of <A>M</A> (i.e. the maniplexes corresponding to the vertex-figures).
DeclareAttribute("VertexFigures", IsManiplex);

#! @Arguments M, k
#! Returns the vertex-figures of <A>M</A> that contains flag number <A>k</A>.
DeclareOperation("VertexFigure", [IsManiplex, IsInt]);

#! @Arguments M
#! Returns the vertex-figures of <A>M</A> that contains the base flag.
DeclareAttribute("VertexFigure", IsManiplex);



#! @Chapter Combinatorics and Structure
#! @Section Flatness

#! @BeginGroup IsFlat
#! @GroupTitle IsFlat

#! @Arguments M
#! In the first form, returns true if every vertex of the maniplex <A>M</A> is incident
#! to every facet.
DeclareProperty("IsFlat", IsManiplex);

#! @Arguments M, i, j
#! In the second form, returns true if every i-face of the maniplex <A>M</A> is
#! incident to every j-face.
DeclareOperation("IsFlat", [IsManiplex, IsInt, IsInt]);

#! @EndGroup



#! @Chapter Combinatorics and Structure
#! @Section Schlafli symbol

#! @Arguments M
#! Returns the Schlafli symbol of the maniplex <A>M</A>.
#! Each entry is either an integer or a set of integers,
#! where entry number i shows the polygons that we obtain
#! as sections of (i+1)-faces over (i-2)-faces.
DeclareAttribute("SchlafliSymbol", IsManiplex);

#! @Arguments M
#! @Returns the the maniplex <A>M</A> is equivelar; i.e.,
#! whether its Schlafli Symbol consists of integers at each
#! position (no lists).
DeclareProperty("IsEquivelar", IsManiplex);

