gap> p := Cube(3);;
gap> q := CrossPolytope(3);;
gap> r := Simplex(3);;
gap> Dual(p) = q;
true
gap> Dual(p) = r;
false
gap> Dual(r) = r;
true
gap> IsSelfDual(r);
true
gap> p2 := HemiCube(3);;
gap> Petrial(p2) = r;
true
