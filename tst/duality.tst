gap> p := Cube(3);
3-cube
Regular 3-polytope of type [ 4, 3 ] with 48 flags
gap> q := CrossPolytope(3);
3-cross-polytope
Regular 3-polytope of type [ 3, 4 ] with 48 flags
gap> r := Simplex(3);
3-simplex
Regular 3-polytope of type [ 3, 3 ] with 24 flags
gap> Dual(p) = q;
true
gap> Dual(p) = r;
false
gap> Dual(r) = r;
true
gap> IsSelfDual(r);
true
gap> p2 := HemiCube(3);
Regular 3-polytope with 24 flags
gap> Petrial(p2) = r;
true
