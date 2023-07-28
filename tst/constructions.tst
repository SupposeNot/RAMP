gap> UniversalPolytope(3) = AbstractRegularPolytope([infinity, infinity]);
true
gap> UniversalExtension(Cube(3)) = AbstractRegularPolytope([4,3,infinity]);
true
gap> UniversalExtension(Cube(3), 4) = CubicTiling(3);
true
gap> TrivialExtension(Cube(3)) = AbstractRegularPolytope([4,3,2]);
true
gap> FlatExtension(Pgon(4), 4) = ToroidalMap44([2,0]);
true
gap> Amalgamate(Cube(3), CrossPolytope(3)) = CubicTiling(3);
true
gap> Size(Amalgamate(ToroidalMap44([1,2]), Cube(3)));
240
gap> Size(Amalgamate(ToroidalMap44([1,2]), ToroidalMap44([2,1])));
240
gap> Size(Amalgamate(ToroidalMap44([1,2]), ToroidalMap44([1,2])));
4
gap> Medial(Cube(3)) = Cuboctahedron();
true
