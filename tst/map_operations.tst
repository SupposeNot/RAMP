gap> List([HemiCube(3), Cube(4), Icosahedron()], IsMapOnSurface);
[ true, false, true ]
gap> FinalizedOutputMap(Cube(3), Dual(Cube(3)), "Test") = Dual(Cube(3));
true
gap> testop := MapOperation(Dual, "TestDual");;
gap> testop(Cube(3)) = Dual(Cube(3));
true
gap> Opp(Opp(Cube(3))) = Cube(3);
true
gap> Dodecahedron() = Hole(Dodecahedron(), 2);
true
gap> Truncation(Dodecahedron()) = TruncatedDodecahedron();
true
gap> Snub(Cube(3)) = SnubCube();
true
gap> Size(Chamfer(Cube(3)));
192
gap> Size(Subdivision1(Simplex(3)));
48
gap> Size(Subdivision2(Cube(3)));
144
gap> NumberOfFacets(BarycentricSubdivision(Cube(3)));
48
gap> Size(Leapfrog(Dodecahedron()));
360
gap> NumberOfEdges(CombinatorialMap(Cube(3)));
72
gap> NumberOfEdges(Angle(ToroidalMap44([3, 0])));
36
gap> MapJoin(Cube(3)) = Angle(Cube(3));
true
gap> Ambo(Cube(3)) = Medial(Cube(3));
true
gap> gothicMap := AbstractRegularPolytope([3, 6], "(r0 r1 r2)^6");;
gap> NumberOfEdges(Gothic(gothicMap));
162
gap> chiralMap := ToroidalMap44([1,2]);;
gap> Reflection(chiralMap) = EnantiomorphicForm(chiralMap);
true
gap> Reflection(Truncation(chiralMap)) = Truncation(EnantiomorphicForm(chiralMap));
true
gap> Size(Kis(Cube(3)));
144
gap> Size(Needle(Cube(3)));
144
gap> Zip(Cube(3)) = TruncatedOctahedron();
true
gap> Size(Ortho(Cube(3)));
192
gap> Expand(Cube(3)) = SmallRhombicuboctahedron();
true
gap> Gyro(Dual(Cube(3))) = Gyro(Cube(3));
true
gap> NumberOfFacets(Meta(Cube(3))) = Size(Cube(3));
true
gap> CombinatorialMap(Cube(3)) = Bevel(Cube(3));
true
gap> Size(Subdivide(Cube(3)));
192
gap> Dual(Propeller(Cube(3))) = Propeller(Dual(Cube(3)));
true
gap> NumberOfFacets(Loft(Cube(3)));
30
gap> NumberOfVertices(Quinto(Cube(3)));
44
gap> NumberOfFacets(JoinLace(Cube(3)));
42
gap> NumberOfFacets(Lace(Cube(3)));
54
gap> NumberOfFacets(Stake(Cube(3)));
48
gap> NumberOfVertices(Whirl(Cube(3)));
56
gap> NumberOfFacets(Volute(Cube(3)));
54
gap> NumberOfEdges(JoinKisKis(Cube(3)));
96
gap> NumberOfFacets(Cross(Cube(3)));
72
