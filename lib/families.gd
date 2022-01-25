
#! @Chapter Families of Polytopes
#! @Section Classical polytopes

#! @Returns IsPolytope
#! @Description Returns the universal 0-polytope.
DeclareOperation("Vertex", []);
#! @BeginExampleSession
#! gap> Vertex();
#! UniversalPolytope(0)
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the universal 1-polytope.
DeclareOperation("Edge", []);
#! @BeginExampleSession
#! gap> Edge();
#! UniversalPolytope(1)
#! @EndExampleSession

#! @Arguments p
#! @Returns IsPolytope
#! @Description Returns the p-gon.
DeclareOperation("Pgon", [IsInt]);
#! @BeginExampleSession
#! gap> Facets(Pgon(5));
#! [ UniversalPolytope(1) ]
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cube.
DeclareOperation("Cube", [IsInt]);
#! @BeginExampleSession
#! gap> Fvector(Cube(4));
#! [ 16, 32, 24, 8 ]
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-hemi-cube.
DeclareOperation("HemiCube", [IsInt]);
#! @BeginExampleSession
#! gap> Fvector(HemiCube(4));
#! [ 8, 16, 12, 4 ]
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cross-polytope.
DeclareOperation("CrossPolytope", [IsInt]);
#! @BeginExampleSession
#! gap> NumberOfVertices(CrossPolytope(5));
#! 10
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-hemi-cross-polytope.
DeclareOperation("HemiCrossPolytope", [IsInt]);
#! @BeginExampleSession
#! gap> NumberOfVertices(HemiCrossPolytope(5));
#! 5
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-simplex.
DeclareOperation("Simplex", [IsInt]);
#! @BeginExampleSession
#! gap> Petrial(Simplex(3))=HemiCube(3);
#! true
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the rank $n+1$ polytope; the tiling of $E^n$ by $n$-cubes.
DeclareOperation("CubicTiling", [IsInt]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(CubicTiling(3));
#! [ 4, 3, 4 ]
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the dodecahedron, `{5, 3}`.
DeclareOperation("Dodecahedron", []);
#! @BeginExampleSession
#! gap> Dual(Dodecahedron());
#! Icosahedron()
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-dodecahedron, `{5, 3}_5`.
DeclareOperation("HemiDodecahedron", []);
#! @BeginExampleSession
#! gap> Dual(HemiDodecahedron());
#! ReflexibleManiplex([ 3, 5 ], "(r2*r1*r0)^5")
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the icosahedron, `{3, 5}`.
DeclareOperation("Icosahedron", []);
#! @BeginExampleSession
#! gap> Dual(Icosahedron());
#! Dodecahedron()
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-icosahedron, `{3, 5}_5`.
DeclareOperation("HemiIcosahedron", []);
#! @BeginExampleSession
#! gap> Fvector(HemiIcosahedron());
#! [ 6, 15, 10 ]
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the 24-cell, `{3, 4, 3}`.
DeclareOperation("24Cell", []);
#! @BeginExampleSession
#! gap> SchlafliSymbol(24Cell());
#! [ 3, 4, 3 ]
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-24-cell, `{3, 4, 3}_6`.
DeclareOperation("Hemi24Cell", []);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Hemi24Cell());
#! [ 3, 4, 3 ]
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the 120-cell, {5, 3, 3}.
DeclareOperation("120Cell", []);
#! @BeginExampleSession
#! gap> NumberOfIFaces(120Cell(),3);
#! 120
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-120-cell, `{5, 3, 3}_15`.
DeclareOperation("Hemi120Cell", []);
#! @BeginExampleSession
#! gap> NumberOfIFaces(Hemi120Cell(),3);
#! 60
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the 600-cell, `{3, 3, 5}`.
DeclareOperation("600Cell", []);
#! @BeginExampleSession
#! gap> Dual(600Cell());
#! 120Cell()
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-600-cell, `{3, 3, 5}_15`.
DeclareOperation("Hemi600Cell", []);
#! @BeginExampleSession
#! gap> Dual(Hemi600Cell())=Hemi120Cell();
#! true
#! @EndExampleSession

#! @Returns IsPoset
#! @Description Returns Bruckner's sphere.
DeclareOperation("BrucknerSphere",[]);
#! @BeginExampleSession
#! gap> IsLattice(BrucknerSphere());
#! true
#! @EndExampleSession

#! @Arguments p
#! @Returns IsPolytope
#! @Description Constructs the internally self-dual polyhedron of type `{p, p}` described in Theorem 5.3 of
#! <Cite Key="CunMix17"/>. #(<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! p must be at least 7.
DeclareOperation("InternallySelfDualPolyhedron1",[IsInt]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(InternallySelfDualPolyhedron1(40));
#! [ 40, 40 ]
#! @EndExampleSession

#! @Arguments p, k
#! @Returns IsPolytope
#! @Description Constructs  the internally self-dual polyhedron of type `{p, p}` described in Theorem 5.8 of <Cite Key="CunMix17"/>.# (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! `p` must be even and at least 6, and `k` must be odd.
DeclareOperation("InternallySelfDualPolyhedron2",[IsInt, IsInt]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(InternallySelfDualPolyhedron2(40,7));
#! [ 40, 40 ]
#! @EndExampleSession