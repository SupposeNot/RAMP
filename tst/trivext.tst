gap> p := Simplex(3);;
gap> p2 := TrivialExtension(p);;
gap> p3 := AbstractRegularPolytope([3,3,2]);;
gap> p2 = p3;
true
gap> q := Cube(3);;
gap> q2 := Maniplex(ConnectionGroup(q));;
gap> q3 := TrivialExtension(q2);;
gap> Fvector(q3);
[ 8, 12, 6, 2 ]
