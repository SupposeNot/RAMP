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
gap> M := InternallySelfDualPolyhedron2(8,1);;
gap> g := AutomorphismGroup(M);;
gap> IsInternallySelfDual(M, (g.1*g.3*g.2)^4);
true
gap> IsProperlySelfDual(Cube(4));
false
gap> IsProperlySelfDual(Simplex(4));
true
gap> IsProperlySelfDual(ARP([4,5,4]));
true
gap> IsProperlySelfDual(ToroidalMap44([1,2]));
false
gap> IsProperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1) (s2 s1^-1)^3, (s2 s3^-1) (s2^-1 s3)^3"));
true
gap> IsProperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1)^3 (s2 s1^-1), (s2 s3^-1) (s2^-1 s3)^3"));
false
gap> IsProperlySelfDual(Pyramid(ToroidalMap44([2,0])));
false
gap> IsImproperlySelfDual(Cube(4));
false
gap> IsImproperlySelfDual(Simplex(4));
false
gap> IsImproperlySelfDual(ToroidalMap44([1,2]));
true
gap> IsImproperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1) (s2 s1^-1)^3, (s2 s3^-1) (s2^-1 s3)^3"));
false
gap> IsImproperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1)^3 (s2 s1^-1), (s2 s3^-1) (s2^-1 s3)^3"));
true
gap> ExponentGroup(ToroidalMap44([3,0]));
[ 1, 3 ]
gap> ExponentGroup(ToroidalMap44([1,2]));
[ 1 ]
gap> ExponentGroup(ReflexibleManiplex([10,10], "(r0 r1 r2)^2"));
[ 1, 3, 7, 9 ]
gap> UpToDuality([Cube(3), Simplex(3), CrossPolytope(3)]);
[ Cube(3), Simplex(3) ]
gap> UpToDuality([CrossPolytope(3), Simplex(3), Cube(3)]);
[ CrossPolytope(3), Simplex(3) ]
gap> L := SmallReflexibleManiplexes(3, [1..100]);;
gap> Size(L);
250
gap> L2 := UpToDuality(L);;
gap> Size(L2);
147
gap> Number(L, IsSelfDual);
44
