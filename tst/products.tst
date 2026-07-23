
gap> SchlafliSymbol(Pyramid(Cube(3)));
[ [ 3, 4 ], [ 3, 4 ], 3 ]
gap> SchlafliSymbol(Pyramid(4));
[ [ 3, 4 ], [ 3, 4 ] ]
gap> Cube(3)=Prism(Cube(2));
true
gap> Prism(4)=Cube(3);
true
gap> SchlafliSymbol(Antiprism(Dodecahedron()));
[ [ 3, 5 ], [ 3, 5 ], 4 ]
gap> SchlafliSymbol(Antiprism(5));
[ [ 3, 5 ], 4 ]
gap> SchlafliSymbol(CartesianProduct(HemiCube(3),Simplex(2)));
[ [ 3, 4 ], 3, 3, 3 ]
gap> SchlafliSymbol(DirectSumOfManiplexes(HemiCube(3),Simplex(2)));
[ [ 3, 4 ], [ 3, 4 ], [ 3, 4 ], [ 3, 4 ] ]
gap> SchlafliSymbol(TopologicalProduct(HemiCube(3),Simplex(2)));
[ 4, 3, [ 3, 4 ] ]
gap> SchlafliSymbol(JoinProduct(Pgon(3), Pgon(4)));
[ [ 3, 4 ], [ 3, 4 ], [ 3, 4 ], [ 3, 4 ] ]
