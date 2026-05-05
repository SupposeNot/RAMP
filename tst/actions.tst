gap> P := Prism(5);;
gap> IsFullyTransitive(P);
false
gap> IsVertexTransitive(P);
true
gap> IsEdgeTransitive(P);
false
gap> IsFacetTransitive(P);
false
gap> IsFacetTransitive(Dual(P));
true
gap> IsVertexTransitive(Dual(P));
false
gap> Q := Pyramid(4);;
gap> NumberOfVertexOrbits(Q);
2
gap> Qp := Prism(Q);;
gap> NumberOfVertexOrbits(Qp);
2
gap> NumberOfFacetOrbits(Qp);
3
gap> NumberOfIFaceOrbits(Qp,2);
4
gap> NumberOfEdgeOrbits(Qp);
4
gap> NumberOfChainOrbits(Prism(7), [0,2]);
2
gap> NumberOfChainOrbits(Qp, [0,3]);
5
gap> ForAll(SmallRegularPolyhedra(100), IsFullyTransitive);
true
gap> M := Medial(Cube(3));
Medial(Cube(3))
gap> IsVertexTransitive(M);
true
gap> IsFacetTransitive(M);
false
gap> IsEdgeTransitive(M);
true
gap> IsChainTransitive(M, [0,1]);
true
gap> IsChainTransitive(SmallRhombicuboctahedron(),[0,2]);
false
gap> IsChainTransitive(SmallRhombicuboctahedron(),[0,1]);
false
gap> IsChainTransitive(Cuboctahedron(),[0,1]);
true
gap> IsIFaceTransitive(Cuboctahedron(),1);
true
gap> IsVertexFaithful(HemiCube(3));
true
gap> IsFacetFaithful(HemiCube(3));
false
gap> IsVertexFaithful(AbstractRotaryPolytope([ 6, 9 ], "(s1*s2^-2)^2,s2*s1^-3*s2^-1*s1*s2,(s1^-1*s2^-1)^2"));
false
gap> IsFacetFaithful(ToroidalMap44([5,0],[0,1]));
false
gap> IsFacetFaithful(ToroidalMap44([5,0],[0,3]));
true
gap> NrMovedPoints(AutomorphismGroupOnChains(HemiCube(3),[0,2]));
12
gap> NrMovedPoints(AutomorphismGroupOnChains(Pyramid(5), [0,2]));
20
gap> NrMovedPoints(AutomorphismGroupOnIFaces(HemiCube(3),2));
3
gap> NrMovedPoints(AutomorphismGroupOnVertices(Cube(3)));
8
gap> NrMovedPoints(AutomorphismGroupOnEdges(Simplex(4)));
10
gap> NrMovedPoints(AutomorphismGroupOnFacets(HemiCube(5)));
5
gap> Size(MaxVertexFaithfulQuotient(ToroidalMap44([2,0])));
8
gap> MaxVertexFaithfulQuotient(ARPNC([3,8], "(r0 s2^4)^2")) = ARPNC([3,4]);
true
gap> Size(IFaceStabilizer(Cube(4), 1));
12
gap> ReflexibleManiplex(IFaceStabilizer(Cube(4), 0)) = Simplex(3);
true
gap> Size(ChainStabilizer(Cube(4), [0,3]));
6
gap> Size(MaxChainStabilizer(Cube(4)));
1
gap> M := ReflexibleManiplex([6,3], "(r0 r1)^3 = r0 r2");;
gap> Size(MaxChainStabilizer(M));
2
