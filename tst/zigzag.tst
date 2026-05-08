gap> ZigzagLength(Pyramid(8),1);
32
gap> ZigzagLength(Pyramid(8),2);
4
gap> ZigzagLength(Pyramid(8),3);
[ 2, 16 ]
gap> ZigzagVector(Pyramid(8));
[ 32, 4, [ 2, 16 ], 16 ]
gap> PetrieLength(Cube(3));
6
gap> PetrieLength(Cube(4));
8
gap> M := SmallChiral4Polytopes([240..240])[1];; PetrieLength(M);
[ 4, 6 ]
gap> p := PetrieRelation(3,3);
"(r0 r1 r2)^3"
gap> q := Cube(3)/p;; q = HemiCube(3);
true
gap> Size(q);
24
gap> HoleLength(ToroidalMap44([3,0]),2);
3
gap> HoleLength(ToroidalMap44([2,0],[0,3]),2);
[ 2, 3 ]
gap> HoleVector(Pyramid(6));
[ 6, [ 2, 4 ] ]
