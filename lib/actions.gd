
#! @Chapter Actions
#! @Section Automorphism group acting on faces and chains

#! @Arguments M, I
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the chains of <A>M</A> of type <A>I</A>.
DeclareOperation("AutomorphismGroupOnChains", [IsManiplex, IsCollection]);

#! @Arguments M, i
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the <A>i</A>-faces of <A>M</A>.
DeclareOperation("AutomorphismGroupOnIFaces", [IsManiplex, IsInt]);

#! @Arguments M
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the vertices of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnVertices", IsManiplex);

#! @Arguments M
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the edges of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnEdges", IsManiplex);

#! @Arguments M
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the facets of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnFacets", IsManiplex);


#! @Chapter Actions
#! @Section Number of orbits and transitivity

#! @Arguments M, I
#! @Description Returns the number of orbits of chains of type <A>I</A> under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareOperation("NumberOfChainOrbits", [IsManiplex, IsCollection]);

#! @Arguments M, i
#! @Description Returns the number of orbits of <A>i</A>-faces under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareOperation("NumberOfIFaceOrbits", [IsManiplex, IsInt]);

#! @Arguments M
#! @Description Returns the number of orbits of vertices under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfVertexOrbits", IsManiplex);

#! @Arguments M
#! @Description Returns the number of orbits of edges under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfEdgeOrbits", IsManiplex);

#! @Arguments M
#! @Description Returns the number of orbits of facets under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfFacetOrbits", IsManiplex);

	
#! @Arguments M, I
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! chains of type <A>I</A> is transitive.
DeclareOperation("IsChainTransitive", [IsManiplex, IsCollection]);

#! @Arguments M, i
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! <A>i</A>-faces is transitive.
DeclareOperation("IsIFaceTransitive", [IsManiplex, IsInt]);

#! @Arguments M
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! vertices is transitive.
DeclareProperty("IsVertexTransitive", IsManiplex);

#! @Arguments M
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! edges is transitive.
DeclareProperty("IsEdgeTransitive", IsManiplex);

#! @Arguments M
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! facets is transitive.
DeclareProperty("IsFacetTransitive", IsManiplex);

#! @Arguments M
#! @Description Returns whether the action of AutomorphismGroup(<A>M</A>) on
#! i-faces is transitive for every i.
DeclareProperty("IsFullyTransitive", IsManiplex);
