gap> Wythoffian([0],Cube(3)) = Cube(3);
true
gap> Wythoffian([2],Cube(3)) = CrossPolytope(3);
true
gap> Wythoffian([1],Cube(3)) = Cuboctahedron();
true
gap> Wythoffian([0,1],Cube(3)) = Truncation(Cube(3));
true
gap> Kis(Cube(3)) = Dual(Wythoffian([0,1], CrossPolytope(3)));
true
gap> fs :=  Facets(Wythoffian([0,1],Cube(4)));;
gap> Truncation(Cube(3)) in fs;
true
gap> Simplex(3) in fs;
true