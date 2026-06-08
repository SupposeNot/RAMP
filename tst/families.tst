gap> Rank(Vertex());
0
gap> Rank(Edge());
1
gap> Rank(Pgon(5));
2
gap> Facet(Pgon(5)) = Edge();
true
gap> Fvector(Cube(4));
[ 16, 32, 24, 8 ]
gap> Facet(Cube(5)) = Cube(4);
true
gap> Fvector(HemiCube(4));
[ 8, 16, 12, 4 ]
gap> IsOrientable(HemiCube(3));
false
gap> NumberOfVertices(CrossPolytope(5));
10
gap> Dual(CrossPolytope(4)) = Cube(4);
true
gap> Octahedron() = CrossPolytope(3);
true
gap> NumberOfVertices(HemiCrossPolytope(5));
5
gap> Fvector(Simplex(4));
[ 5, 10, 10, 5 ]
gap> Petrial(Simplex(3)) = HemiCube(3);
true
gap> Tetrahedron() = Simplex(3);
true
gap> SchlafliSymbol(CubicTiling(3));
[ 4, 3, 4 ]
gap> Dual(Dodecahedron());
Icosahedron()
gap> Dual(HemiDodecahedron()) = HemiIcosahedron();
true
gap> Dual(Icosahedron());
Dodecahedron()
gap> Fvector(HemiIcosahedron());
[ 6, 15, 10 ]
gap> SmallStellatedDodecahedron() = GreatDodecahedron();
true
gap> Size(GreatDodecahedron());
120
gap> SchlafliSymbol(24Cell());
[ 3, 4, 3 ]
gap> SchlafliSymbol(Hemi24Cell());
[ 3, 4, 3 ]
gap> Size(Hemi24Cell());
576
gap> NumberOfIFaces(120Cell(), 3);
120
gap> NumberOfIFaces(Hemi120Cell(), 3);
60
gap> Dual(600Cell());
120Cell()
gap> Dual(Hemi600Cell()) = Hemi120Cell();
true
gap> IsLattice(BrucknerSphere());
true
gap> M := InternallySelfDualPolyhedron1(8);; SchlafliSymbol(M);
[ 8, 8 ]
gap> IsSelfDual(M);
true
gap> M := InternallySelfDualPolyhedron2(8,7);; SchlafliSymbol(M);
[ 8, 8 ]
gap> Size(M);
116218388160
gap> M := GrandAntiprism();; SchlafliSymbol(M);
[ [ 3, 5 ], [ 3, 4 ], [ 4, 5 ] ]
gap> STG1(5);
5-premaniplex with 1 flag
gap> STG2(5,[2,4]);
5-premaniplex with 2 flags
gap> STG3(5,2);
5-premaniplex with 3 flags
gap> STG3(6,2,3);
6-premaniplex with 3 flags
