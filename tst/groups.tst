
gap> p := ARP(Group((3,7)(4,8)(5,6), (2,3)(4,6)(5,7), (1,2)(3,6)(4,8)(5,7)));;
gap> AutomorphismGroup(p);
Group([ (3,7)(4,8)(5,6), (2,3)(4,6)(5,7), (1,2)(3,6)(4,8)(5,7) ])
gap> g := AutomorphismGroupFpGroup(p);; IsFpGroup(g);
true
gap> GeneratorsOfGroup(g);
[ r0, r1, r2 ]
gap> AutomorphismGroupPermGroup(Cube(3));
Group([ (3,4), (2,3)(4,5), (1,2)(5,6) ])
gap> NrMovedPoints(ConnectionGroup(HemiCube(3)));
24
gap> g := EvenConnectionGroup(HemiCube(3));; Order(g.1);
4
gap> RotationGroup(HemiCube(3));
Group([ r0*r1, r1*r2 ])
gap> g := RotationGroupFpGroup(ToroidalMap44([1,2]));; GeneratorsOfGroup(g);
[ s1, s2 ]
gap> M := ToroidalMap44([1,2]);
ToroidalMap44([ 1, 2 ])
gap> Size(ChiralityGroup(M));
5
gap> ExtraRelators(HemiCube(3));
[ (r0*r1*r2)^3 ]
