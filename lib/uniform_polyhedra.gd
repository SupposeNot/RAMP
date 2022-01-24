


#! @Chapter Families of Polytopes
#! @Section Uniform polyhedra
#! Representations of the uniform polyhedra here are from <Cite Key="HarWil10"/>.

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the cuboctahedron.
DeclareOperation("Cuboctahedron",[]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Cuboctahedron());
#! [ [ 3, 4 ], 4 ]
#! @EndExampleSession


#! @Arguments
#! @Returns maniplex
#! @Description Constructs the truncated tetrahedron.
DeclareOperation("TruncatedTetrahedron",[]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(TruncatedTetrahedron());
#! [ [ 3, 6 ], 3 ]
#! @EndExampleSession


#! @Arguments
#! @Returns maniplex
#! @Description Constructs the truncated octahedron.
DeclareOperation("TruncatedOctahedron",[]);
#! @BeginExampleSession
#! gap> Fvector(TruncatedOctahedron());
#! [ 24, 36, 14 ]
#! @EndExampleSession


#! @Arguments
#! @Returns maniplex
#! @Description Constructs the truncated octahedron.
DeclareOperation("TruncatedCube",[]);
#! @BeginExampleSession
#! gap> Fvector(TruncatedCube());
#! [ 24, 36, 14 ]
#! gap> SchlafliSymbol(TruncatedCube());
#! [ [ 3, 8 ], 3 ]
#! @EndExampleSession



#! @Arguments
#! @Returns maniplex
#! @Description Constructs the icosadodecahedron.
DeclareOperation("Icosadodecahedron",[]);
#! @BeginExampleSession
#! gap> VertexFigure(Icosadodecahedron());
#! Pgon(4)
#! gap> Facets(Icosadodecahedron());
#! [ Pgon(5), Pgon(3) ]
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the truncated icosahedron.
DeclareOperation("TruncatedIcosahedron",[]);
#! @BeginExampleSession
#! gap> Facets(TruncatedIcosahedron());
#! [ Pgon(6), Pgon(5) ]
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the small rhombicuboctahedron.
DeclareOperation("SmallRhombicuboctahedron",[]);
#! @BeginExampleSession
#! gap> ZigzagVector(SmallRhombicuboctahedron());
#! [ 12, 8 ]
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the pseudorhombicuboctahedron.
DeclareOperation("Pseudorhombicuboctahedron",[]);
#! @BeginExampleSession
#! gap> Size(ConnectionGroup(Pseudorhombicuboctahedron()));
#! 16072626615091200
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the snub cube.
DeclareOperation("SnubCube",[]);
#! @BeginExampleSession
#! gap> IsEquivelar(PetrieDual(SnubCube()));
#! true
#! gap> SchlafliSymbol(PetrieDual(SnubCube()));
#! [ 30, 5 ]
#! gap> Size(ConnectionGroup(PetrieDual(SnubCube())));
#! 3804202857922560
#! gap> Size(AutomorphismGroup(PetrieDual(SnubCube())));
#! 24
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the small rhombicosidodecahedron.
DeclareOperation("SmallRhombicosidodecahedron",[]);
#! @BeginExampleSession
#! gap> Facets(SmallRhombicosidodecahedron());
#! [ Pgon(5), Pgon(4), Pgon(3) ]
#! @EndExampleSession

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the great rhombicosidodecahedron.
DeclareOperation("GreatRhombicosidodecahedron",[]);
#! @BeginExampleSession
#! gap> Facets(GreatRhombicosidodecahedron());
#! [ Pgon(10), Pgon(4), Pgon(6) ]
#! @EndExampleSession


#! @Arguments
#! @Returns maniplex
#! @Description Constructs the small snub dodecahedron.
DeclareOperation("SnubDodecahedron",[]);
#! @BeginExampleSession
#! gap> Facets(SnubDodecahedron());
#! [ Pgon(5), Pgon(3) ]
#! gap> IsEquivelar(PetrieDual(SnubDodecahedron()));
#! true
#! @EndExampleSession


#! @Arguments
#! @Returns maniplex
#! @Description Constructs the truncated dodecahedron.
DeclareOperation("TruncatedDodecahedron",[]);

#! @Arguments
#! @Returns maniplex
#! @Description Constructs the great rhombicuboctahedron.
DeclareOperation("GreatRhombicuboctahedron",[]);

