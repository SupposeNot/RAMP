gap> SchlafliSymbol(Cube(3));
[ 4, 3 ]
gap> SchlafliSymbol(Medial(Cube(3)));
[ [ 3, 4 ], 4 ]
gap> p := Pyramid(Pgon(5));;
gap> SchlafliSymbol(p);
[ [ 3, 5 ], [ 3, 5 ] ]
gap> q := Medial(Cube(3));;
gap> qd := Dual(q);;
gap> SchlafliSymbol(qd);
[ 4, [ 3, 4 ] ]
gap> IsEquivelar(q);
false
gap> g := Group([(1,2),(2,3),(3,4)]);; M := ReflexibleManiplex(g);;
gap> HasIsEquivelar(M);
true
gap> IsEquivelar(M);
true
gap> p := Pyramid(Cube(3));;
gap> SchlafliSymbol(p);
[ [ 3, 4 ], [ 3, 4 ], 3 ]
gap> SchlafliSymbol(Prism(Pgon(5)));
[ [ 4, 5 ], 3 ]
gap> SchlafliSymbol(Dual(Prism(Pgon(5))));
[ 3, [ 4, 5 ] ]
