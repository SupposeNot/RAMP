gap> M := Medial(Cube(3));;
gap> Pgon(4) in Facets(M);
true
gap> Pgon(3) in Facets(M);
true
gap> Pgon(5) in Facets(M);
false
gap> P := PyramidOver(Cube(3));;
gap> fs := Facets(P);;
gap> Cube(3) in fs;
true
gap> PyramidOver(Pgon(4)) in fs;
true
gap> vs := VertexFigures(P);;
gap> Cube(3) in vs;
true
gap> ARP([3,3]) in vs;
true
gap> CrossPolytope(3) in vs;
false
