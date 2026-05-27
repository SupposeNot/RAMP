gap> Flags(Pgon(5));
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
gap> M := Maniplex(Group((3,4)(5,6)(7,8)(9,10), (3,6)(4,5)(7,10)(8,9), (3,7)(4,8)(5,9)(6,10)));;
gap> Flags(M);
[ 3, 4, 5, 6, 7, 8, 9, 10 ]
gap> BaseFlag(Cube(3));
1
gap> BaseFlag(M);
3
gap> LabeledEdges(SymmetryTypeGraph(Prism(5)));
[ [ [ 1 ], 0 ], [ [ 2 ], 0 ], [ [ 3 ], 0 ], [ [ 1, 2 ], 1 ], [ [ 3 ], 1 ], 
  [ [ 1 ], 2 ], [ [ 2, 3 ], 2 ] ]
gap> NumberOfFlagOrbits(Prism(Simplex(3)));
4
gap> FlagOrbitRepresentatives(Prism(Simplex(3)));
[ 1, 49, 97, 145 ]
gap> m:=Prism(Dodecahedron());;
gap> s:=FlagOrbitsStabilizer(m);;
gap> IsSubgroup(ConnectionGroup(m),s);
true
gap> AsSet(Orbit(AutomorphismGroupOnFlags(m),1))=AsSet(Orbit(s,1));
true
gap> IsReflexible(Epsilonk(6));
true
gap> IsChiral(ToroidalMap44([2,3]));
true
gap> M := ToroidalMap44([2,3]);; Size(ChiralityGroup(M));
13
gap> IsTotallyChiral(M);
false
gap> IsRotary(ToroidalMap44([3,5]));
true
gap> Size(FlagOrbits(ToroidalMap44([3,2])));
2
