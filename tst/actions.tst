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
gap> Qp := PrismOver(Q);;
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
