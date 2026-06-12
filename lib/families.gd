
#! @Chapter Families of Polytopes
#! @Section Classical polytopes

#! @Returns IsPolytope
#! @Description Returns the universal 0-polytope.
DeclareOperation("Vertex", []);
#! @BeginExampleSession
#! gap> Rank(Vertex());
#! 0
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the universal 1-polytope.
DeclareOperation("Edge", []);
#! @BeginExampleSession
#! gap> Rank(Edge());
#! 1
#! @EndExampleSession

#! @Arguments p
#! @Returns IsPolytope
#! @Description Returns the p-gon.
DeclareOperation("Pgon", [IsInt]);
#! @BeginExampleSession
#! gap> Rank(Pgon(5));
#! 5
#! gap> Facet(Pgon(5)) = Edge();
#! true
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cube.
DeclareOperation("Cube", [IsInt]);
#! @BeginExampleSession
#! gap> Fvector(Cube(4));
#! [ 16, 32, 24, 8 ]
#! gap> Facet(Cube(5)) = Cube(4);
#! true
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-hemi-cube, the quotient of the n-cube by central inversion.
DeclareOperation("HemiCube", [IsInt]);
#! @BeginExampleSession
#! gap> Fvector(HemiCube(4));
#! [ 8, 16, 12, 4 ]
#! gap> IsOrientable(HemiCube(3));
#! false
#! @EndExampleSession

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cross-polytope.
DeclareOperation("CrossPolytope", [IsInt]);
#! @BeginExampleSession
#! gap> NumberOfVertices(CrossPolytope(5));
#! 10
#! gap> Dual(CrossPolytope(4)) = Cube(4);
#! true
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the octahedron (3-cross-polytope).
DeclareOperation("Octahedron", []);
#! @BeginExampleSession
#! gap> Octahedron() = CrossPolytope(3);
#! true
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
#! gap> Fvector(Simplex(4));
#! [ 5, 10, 10, 5 ]
#! gap> Petrial(Simplex(3)) = HemiCube(3);
#! true
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the tetrahedron (3-simplex).
DeclareOperation("Tetrahedron", []);
#! @BeginExampleSession
#! gap> Tetrahedron() = Simplex(3);
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
#! gap> Dual(HemiDodecahedron()) = HemiIcosahedron();
#! true
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
#! @Description Constructs the small stellated dodecahedron combinatorially. This is the same combinatorial object as the great dodecahedron. You may also use the command `GreatDodecahedron();`.
DeclareOperation("SmallStellatedDodecahedron",[]);
#! @BeginExampleSession
#! gap> SmallStellatedDodecahedron() = GreatDodecahedron();
#! true
#! gap> Size(GreatDodecahedron());
#! 120
#! @EndExampleSession

DeclareSynonym("GreatDodecahedron",SmallStellatedDodecahedron);

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
#! gap> Size(Hemi24Cell());
#! 576
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the 120-cell, {5, 3, 3}.
DeclareOperation("120Cell", []);
#! @BeginExampleSession
#! gap> NumberOfIFaces(120Cell(), 3);
#! 120
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the hemi-120-cell, `{5, 3, 3}_15`.
DeclareOperation("Hemi120Cell", []);
#! @BeginExampleSession
#! gap> NumberOfIFaces(Hemi120Cell(), 3);
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
#! gap> Dual(Hemi600Cell()) = Hemi120Cell();
#! true
#! @EndExampleSession

#! @Returns IsPoset
#! @Description Returns Bruckner's sphere. This is non-convex simple 4-sphere. It was originally part of an enumeration of simple 4-polytopes by Brückner <Cite Key="Bru09"/> with eight facets, however, as discovered by Grünbaum and Sreedharan <Cite Key="GruSre67"/>, this example is not realizable as a convex polytope. 
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
#! gap> M := InternallySelfDualPolyhedron1(40);; SchlafliSymbol(M);
#! [ 40, 40 ]
#! gap> IsSelfDual(M);
#! true
#! @EndExampleSession

#! @Arguments p, k
#! @Returns IsPolytope
#! @Description Constructs  the internally self-dual polyhedron of type `{p, p}` described in Theorem 5.8 of <Cite Key="CunMix17"/>.# (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! `p` must be even and at least 6, and `k` must be odd.
DeclareOperation("InternallySelfDualPolyhedron2",[IsInt, IsInt]);
#! @BeginExampleSession
#! gap> M := InternallySelfDualPolyhedron2(8,7);; SchlafliSymbol(M);
#! [ 8, 8 ]
#! gap> Size(M);
#! 116218388160
#! @EndExampleSession

#! @Returns IsPolytope
#! @Description Returns the Grand Antiprism.
DeclareOperation("GrandAntiprism", []);
#! @BeginExampleSession
#! gap> M := GrandAntiprism;; SchlafliSymbol(M);
#! [ [ 3, 5 ], [ 3, 4 ], [ 4, 5 ] ]
#! @EndExampleSession


#! @Arguments n
#! @Returns premaniplex
#! @Description Builds the 1 flag premaniplex of rank <A>n</A>.
#! See Voltage operations on maniplexes (<Cite Key="VoltOps"/>).
DeclareOperation("STG1",[IsInt]);
#! @BeginExampleSession
#! gap> STG1(5);
#! 5-premaniplex with 1 flag
#! @EndExampleSession


#! @Arguments n, I
#! @Returns premaniplex
#! @Description Builds the 2 flag premaniplex of rank <A>n</A> with semi-edges in <A>I</A>.
#! See Voltage operations on maniplexes (<Cite Key="VoltOps"/>).
DeclareOperation("STG2",[IsInt,IsList]);
#! @BeginExampleSession
#! gap> STG2(5,[2,4]);
#! 5-premaniplex with 2 flags
#! @EndExampleSession


#! @Arguments n, i
#! @Returns premaniplex
#! @Description Builds the 3 flag premaniplex of rank <A>n</A> described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes <Cite Key="CDHT15"/> (<URL>https://doi.org/10.1007/s00026-015-0263-z</URL>). The edges of label i-1 and i+1 are parallel.
DeclareOperation("STG3",[IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(5,2);
#! 5-premaniplex with 3 flags
#! @EndExampleSession


#! @Arguments n, i, j
#! @Returns premaniplex
#! @Description Assumes `j=i+1` and builds the 3 flag premaniplex of rank <A>n</A> described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes <Cite Key="CDHT15"/> (<URL>https://doi.org/10.1007/s00026-015-0263-z</URL>). There are edges of label <A>i</A> and <A>j</A>.
DeclareOperation("STG3",[IsInt,IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(6,2,3);
#! 6-premaniplex with 3 flags
#! @EndExampleSession
