#! @Chapter Properties
#! @Section Orientability


#! @Description A polytope is orientable if its flag graph is bipartite.
#! Currently only implemented for regular polytopes.
#! @Arguments p
#! @Returns
DeclareProperty("IsOrientable", IsAbstractPolytope);

#! @Description For a subset I of {0, ..., n-1}, a polytope if I-orientable
#! if every closed path in its flag graph contains an even number
#! of edges with colors in I.
#! Currently only implemented for regular polytopes.
#! @Arguments p, I
DeclareOperation("IsIOrientable", [IsAbstractPolytope, IsList]);

#! @Description A polytope is vertex-bipartite if its 1-skeleton is
#! bipartite. This is equivalent to being I-orientable for
#! I = {0}.
#! @Arguments p
DeclareProperty("IsVertexBipartite", IsAbstractPolytope);

#! @Description A polytope is facet-bipartite if the 1-skeleton of its
#! dual is bipartite. This is equivalent to being I-orientable for
#! I = {n-1}.
#! @Arguments p
DeclareProperty("IsFacetBipartite", IsAbstractPolytope);