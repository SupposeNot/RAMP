gap> p := Simplex(3);
3-simplex
Regular 3-polytope of type [ 3, 3 ] with 24 flags
gap> p2 := TrivialExtension(p);
Regular 4-polytope of type [ 3, 3, 2 ] with 48 flags
gap> p3 := AbstractRegularPolytope([3,3,2]);
Regular 4-polytope of type [ 3, 3, 2 ] with 48 flags
gap> p2 = p3;
true
gap> q := Cube(3);
3-cube
Regular 3-polytope of type [ 4, 3 ] with 48 flags
gap> q2 := Maniplex(ConnectionGroup(q));
3-maniplex with 48 flags
gap> q3 := TrivialExtension(q2);
4-maniplex with 96 flags
gap> Fvector(q3);
[ 8, 12, 6, 2 ]
