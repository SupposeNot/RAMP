gap> SchlafliSymbol(Cuboctahedron());
[ [ 3, 4 ], 4 ]
gap> SchlafliSymbol(TruncatedTetrahedron());
[ [ 3, 6 ], 3 ]
gap> Fvector(TruncatedOctahedron());
[ 24, 36, 14 ]
gap> Fvector(TruncatedCube());
[ 24, 36, 14 ]
gap> SchlafliSymbol(TruncatedCube());
[ [ 3, 8 ], 3 ]
gap> VertexFigure(Icosadodecahedron());
Pgon(4)
gap> Facets(Icosadodecahedron());
[ Pgon(5), Pgon(3) ]
gap> Facets(TruncatedIcosahedron());
[ Pgon(6), Pgon(5) ]
gap> ZigzagVector(SmallRhombicuboctahedron());
[ 12, 8 ]
gap> Size(ConnectionGroup(Pseudorhombicuboctahedron()));
16072626615091200
gap> IsEquivelar(PetrieDual(SnubCube()));
true
gap> SchlafliSymbol(PetrieDual(SnubCube()));
[ 30, 5 ]
gap> Size(ConnectionGroup(PetrieDual(SnubCube())));
3804202857922560
gap> Size(AutomorphismGroup(PetrieDual(SnubCube())));
24
gap> Facets(SmallRhombicosidodecahedron());
[ Pgon(5), Pgon(4), Pgon(3) ]
gap> Facets(GreatRhombicosidodecahedron());
[ Pgon(10), Pgon(4), Pgon(6) ]
gap> Facets(SnubDodecahedron());
[ Pgon(5), Pgon(3) ]
gap> IsEquivelar(PetrieDual(SnubDodecahedron()));
true
gap> Facets(TruncatedDodecahedron());
[ Pgon(10), Pgon(3) ]
gap> Size(ConnectionGroup(GreatRhombicuboctahedron()));
5308416
