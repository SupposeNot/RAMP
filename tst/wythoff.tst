gap> WythoffVoltageOperator(3,[0],Cube(3)) = Cube(3);
true
gap> WythoffVoltageOperator(3,[2],Cube(3)) = CrossPolytope(3);
true
gap> WythoffVoltageOperator(3,[1],Cube(3)) = Cuboctahedron();
true
gap> WythoffVoltageOperator(3,[0,1],Cube(3)) = Truncation(Cube(3));
true
gap> Kis(Cube(3)) = Dual(WythoffVoltageOperator(3, [0,1], CrossPolytope(3)));
true
gap> fs :=  Facets(WythoffVoltageOperator(4,[0,1],Cube(4)));;
gap> Truncation(Cube(3)) in fs;
true
gap> Simplex(3) in fs;
true