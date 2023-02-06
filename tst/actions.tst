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
