#! @Chapter Maniplex Properties
#! @Section Orientability


#! @Description A maniplex is orientable if its flag graph is bipartite.
#! @Arguments M
#! @Returns
DeclareProperty("IsOrientable", IsManiplex);
#! @BeginExampleSession
#! gap> IsOrientable(HemiCube(3));
#! false
#! gap> IsOrientable(Cube(3));
#! true
#! @EndExampleSession

#! @Description For a subset I of {0, ..., n-1}, a maniplex is I-orientable
#! if every closed path in its flag graph contains an even number
#! of edges with colors in I.
#! @Arguments M, I
DeclareOperation("IsIOrientable", [IsManiplex, IsList]);
#! @BeginExampleSession
#! gap> IsIOrientable(HemiCube(3),[1,2]);
#! true
#! @EndExampleSession

#! @Description A maniplex is vertex-bipartite if its 1-skeleton is
#! bipartite. This is equivalent to being I-orientable for
#! I = {0}.
#! @Arguments M
DeclareProperty("IsVertexBipartite", IsManiplex);
#! @BeginExampleSession
#! gap> IsVertexBipartite(HemiCube(4));
#! true
#! @EndExampleSession

#! @Description A maniplex is facet-bipartite if the 1-skeleton of its
#! dual is bipartite. This is equivalent to being I-orientable for
#! I = {n-1}.
#! @Arguments M
DeclareProperty("IsFacetBipartite", IsManiplex);
#! @BeginExampleSession
#! gap> IsFacetBipartite(HemiCube(4));
#! false
#! @EndExampleSession

#! @Arguments M
#! @Description Returns the minimal __orientable cover__ of the maniplex <A>M</A>.
DeclareAttribute("OrientableCover", IsManiplex);
#! @BeginExampleSession
#! gap> OrientableCover(HemiCube(3))=Cube(3);
#! true
#! @EndExampleSession

#! @Arguments M
#! @Description Returns the minimal __I-orientable cover__ of the maniplex <A>M</A>.
DeclareOperation("IOrientableCover", [IsManiplex, IsList]);