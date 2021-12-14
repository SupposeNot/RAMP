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
gap> IsInternallySelfDual(Simplex(4));
true
gap> IsInternallySelfDual(ARP([4,4], "h2^6"));
false
gap> IsInternallySelfDual(ARP([4,4], "h2^5"));
true
gap> IsInternallySelfDual(Cube(3));
false
gap> IsExternallySelfDual(Simplex(4));
false
gap> IsExternallySelfDual(ARP([4,4], "h2^6"));
true
gap> IsExternallySelfDual(ARP([4,4], "h2^5"));
false
gap> IsExternallySelfDual(Cube(3));
false
gap> IsInternallySelfDual(CubicToroid(3,1,3));
true
gap> IsInternallySelfDual(CubicToroid(4,1,3));
false
gap> M := InternallySelfDualPolyhedron2(10,1);;
gap> g := AutomorphismGroup(M);;
gap> IsInternallySelfDual(M, (g.1*g.3*g.2)^6);
true
