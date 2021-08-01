gap> IsOrientable(Cube(3));
true
gap> IsOrientable(HemiCube(3));
false
gap> IsOrientable(ReflexibleManiplex([4,4], "z1^2"));
true
gap> IsOrientable(ReflexibleManiplex([4,4], "z1^1"));
false
gap> IsOrientable(Medial(Cube(3)));
true
gap> IsOrientable(PyramidOver(Cube(3)));
true
gap> IsOrientable(Medial(HemiCube(3)));
false
gap> IsOrientable(PyramidOver(HemiCube(3)));
false
gap> IsOrientable(PyramidOver(HemiCube(3)));
false
gap> IsVertexBipartite(Cube(3));
true
gap> IsVertexBipartite(Simplex(3));
false
gap> IsVertexBipartite(ARP([4,4], "z1^4"));
true
gap> IsVertexBipartite(ARP([4,4], "h2^3"));
false
gap> IsFacetBipartite(Cube(3));
false
gap> IsFacetBipartite(Simplex(3));
false
gap> IsFacetBipartite(CrossPolytope(3));
true
gap> IsFacetBipartite(ARP([4,4], "z1^4"));
true
gap> IsFacetBipartite(ARP([4,4], "h2^3"));
false
gap> IsVertexBipartite(Medial(Cube(3)));
false
gap> IsVertexBipartite(Pyramid(4));
false
gap> IsVertexBipartite(ARP([4,4]) / "h2^4, r1 h2^6 r1");
true
gap> IsVertexBipartite(ARP([4,4]) / "h2^4, r1 h2^5 r1");
false
gap> IsFacetBipartite(ARP([4,4]) / "h2^4, r1 h2^6 r1");
true
gap> IsFacetBipartite(ARP([4,4]) / "h2^4, r1 h2^5 r1");
false
gap> IsIOrientable(Cube(3), [0]);
true
gap> IsIOrientable(Cube(3), [1]);
false
gap> IsIOrientable(Cube(3), [2]);
false
gap> IsIOrientable(Cube(3), [0,1]);
false
gap> IsIOrientable(Cube(3), [0,2]);
false
gap> IsIOrientable(Cube(3), [1,2]);
true
gap> IsIOrientable(Cube(3), [0,1,2]);
true
gap> IsIOrientable(Cube(3), []);
true
gap> IsIOrientable(HemiCube(3), [0]);
false
gap> IsIOrientable(HemiCube(3), [1]);
false
gap> IsIOrientable(HemiCube(3), [2]);
false
gap> IsIOrientable(HemiCube(3), [1,2]);
true
gap> IsIOrientable(HemiCube(3), [0,1,2]);
false
gap> IsIOrientable(HemiCube(3), []);
true
gap> IsIOrientable(Pyramid(4), [1]);
false
gap> IsIOrientable(Pyramid(4), [0,1]);
false
gap> IsIOrientable(Pyramid(4), [0,2]);
false
gap> IsIOrientable(Prism(6), [0]);
true
gap> IsIOrientable(Prism(5), [0]);
false
gap> IsIOrientable(Prism(6), [2]);
false
gap> IsIOrientable(Prism(6), [1,2]);
true
gap> IsIOrientable(Prism(5), [1,2]);
false
gap> IsIOrientable(PrismOver(Simplex(3)), [0]);
false
gap> IsIOrientable(PrismOver(Simplex(3)), [0,1,2]);
false
gap> IsIOrientable(PrismOver(Simplex(3)), [0,1,2,3]);
true
gap> OrientableCover(Cube(3)) = Cube(3);
true
gap> OrientableCover(HemiCube(3)) = Cube(3);
true
gap> OrientableCover(PyramidOver(Cube(3))) = PyramidOver(Cube(3));
true
gap> OrientableCover(PyramidOver(HemiCube(3))) = PyramidOver(Cube(3));
true
gap> IOrientableCover(Cube(3), [0]) = Cube(3);
true
gap> IOrientableCover(HemiCube(3), [0]) = Cube(3);
true
gap> IOrientableCover(Cube(3), [2]) = Cube(3);
false
gap> IOrientableCover(HemiCube(3), [2]) = Cube(3);
false
gap> IsQuotient(IOrientableCover(Cube(3), [2]), IOrientableCover(HemiCube(3), [2]));
true
gap> SchlafliSymbol(IOrientableCover(Cube(3), [2])) = [4,6];
true
gap> IOrientableCover(Prism(5), [0]) = Prism(10);
true
