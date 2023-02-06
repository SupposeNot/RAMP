
#! @Chapter Maniplex Properties
#! @Section Automorphism group acting on faces and chains

#! @Arguments M, I
#! @Returns IsPermGroup
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the chains of <A>M</A> of type <A>I</A>.
DeclareOperation("AutomorphismGroupOnChains", [IsManiplex, IsCollection]);
#! @BeginExampleSession
#! gap> AutomorphismGroupOnChains(HemiCube(3),[0,2]);
#! Group([ (1,2)(3,4)(5,10)(6,9)(7,8)(11,12), (2,6)(3,5)(4,7)(8,11)(10,12), (1,3)(2,4)(6,11)(7,8)
#!   (9,12) ])
#! @EndExampleSession


#! @Arguments M, i
#! @Returns IsPermGroup
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the <A>i</A>-faces of <A>M</A>.
DeclareOperation("AutomorphismGroupOnIFaces", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> AutomorphismGroupOnIFaces(HemiCube(3),2);
#! Group([ (), (2,3), (1,2) ])
#! @EndExampleSession

#! @Arguments M
#! @Returns IsPermGroup
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the vertices of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnVertices", IsManiplex);
#! @BeginExampleSession
#! gap> AutomorphismGroupOnVertices(HemiCube(4));
#! Group([ (1,2)(3,4)(5,6)(7,8), (2,3)(6,8), (3,5)(4,6), (5,7)(6,8) ])
#! @EndExampleSession

#! @Arguments M
#! @Returns IsPermGroup
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the edges of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnEdges", IsManiplex);
#! @BeginExampleSession
#! gap> AutomorphismGroupOnEdges(Simplex(4));
#! Group([ (2,5)(3,6)(4,7), (1,2)(6,8)(7,9), (2,3)(5,6)(9,10), (3,4)(6,7)(8,9) ])
#! @EndExampleSession

#! @Arguments M
#! @Returns IsPermGroup
#! @Description Returns a permutation group, representing the action of
#! AutomorphismGroup(<A>M</A>) on the facets of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnFacets", IsManiplex);
#! @BeginExampleSession
#! gap> AutomorphismGroupOnFacets(HemiCube(5));
#! Group([ (), (4,5), (3,4), (2,3), (1,2) ])
#! @EndExampleSession

#! @Chapter Maniplex Properties
#! @Section Number of orbits and transitivity

#! @Arguments M, I
#! @Returns IsInt
#! @Description Returns the number of orbits of chains of type <A>I</A> under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareOperation("NumberOfChainOrbits", [IsManiplex, IsCollection]);
#! @BeginExampleSession
#! gap> NumberOfChainOrbits(Cuboctahedron(),[0,2]);
#! 2
#! @EndExampleSession



#! @Arguments M, i
#! @Returns IsInt
#! @Description Returns the number of orbits of <A>i</A>-faces under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareOperation("NumberOfIFaceOrbits", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> NumberOfIFaceOrbits(SnubDodecahedron(),2);
#! 3
#! @EndExampleSession


#! @Arguments M
#! @Returns IsInt
#! @Description Returns the number of orbits of vertices under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfVertexOrbits", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfVertexOrbits(Dual(SnubDodecahedron()));
#! 3
#! @EndExampleSession


#! @Arguments M
#! @Returns IsInt
#! @Description Returns the number of orbits of edges under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfEdgeOrbits", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfEdgeOrbits(SnubDodecahedron());
#! 3
#! @EndExampleSession


#! @Arguments M
#! @Returns IsInt
#! @Description Returns the number of orbits of facets under
#! the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("NumberOfFacetOrbits", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfFacetOrbits(SnubCube());
#! 3
#! @EndExampleSession
	
#! @Arguments M, I
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! chains of type <A>I</A> is transitive.
DeclareOperation("IsChainTransitive", [IsManiplex, IsCollection]);
#! @BeginExampleSession
#! gap> IsChainTransitive(SmallRhombicuboctahedron(),[0,2]);
#! false
#! gap> IsChainTransitive(SmallRhombicuboctahedron(),[0,1]);
#! false
#! gap> IsChainTransitive(Cuboctahedron(),[0,1]);
#! true
#! @EndExampleSession



#! @Arguments M, i
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! <A>i</A>-faces is transitive.
DeclareOperation("IsIFaceTransitive", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> IsIFaceTransitive(Cuboctahedron(),1);
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! vertices is transitive.
DeclareProperty("IsVertexTransitive", IsManiplex);
#! @BeginExampleSession
#! gap> IsVertexTransitive(Bk2l(4,5));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! edges is transitive.
DeclareProperty("IsEdgeTransitive", IsManiplex);
#! @BeginExampleSession
#! gap> IsEdgeTransitive(Prism(Simplex(3)));
#! false
#! @EndExampleSession

#! @Arguments M
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! facets is transitive.
DeclareProperty("IsFacetTransitive", IsManiplex);
#! @BeginExampleSession
#! gap> IsFacetTransitive(Prism(HemiCube(3)));
#! false
#! @EndExampleSession

   
#! @Arguments M
#! @Returns IsBool
#! @Description Determines whether the action of AutomorphismGroup(<A>M</A>) on
#! i-faces is transitive for every i.
DeclareProperty("IsFullyTransitive", IsManiplex);
#! @BeginExampleSession
#! gap> IsFullyTransitive(SmallRhombicuboctahedron());
#! false
#! gap> IsFullyTransitive(Bk2l(4,5));
#! true
#! @EndExampleSession



#! @Section Faithfulness

#! @Arguments M
#! @Description Returns whether the reflexible maniplex <A>M</A> is
#! vertex-faithful; i.e., whether the action of the automorphism
#! group on the vertices is faithful.
DeclareProperty("IsVertexFaithful", IsManiplex);
#! @BeginExampleSession
#! gap> IsVertexFaithful(HemiCube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Description Returns whether the reflexible maniplex <A>M</A> is
#! facet-faithful; i.e., whether the action of the automorphism
#! group on the facets is faithful.
DeclareProperty("IsFacetFaithful", IsManiplex);
#! @BeginExampleSession
#! gap> IsFacetFaithful(HemiCube(3));
#! false
#! gap> IsFacetFaithful(Cube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns Q
#! @Description Returns the maximal vertex-faithful reflexible maniplex covered by <A>M</A>.
DeclareOperation("MaxVertexFaithfulQuotient", [IsManiplex]);
#! @BeginExampleSession
#! gap> MaxVertexFaithfulQuotient(HemiCrossPolytope(3));
#! reflexible 3-maniplex
#! gap> SchlafliSymbol(last);
#! [ 3, 2 ]
#! @EndExampleSession


