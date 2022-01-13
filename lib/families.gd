
#! @Chapter Families of Polytopes
#! @Section Classical Polytopes

#! @Returns IsPolytope
#! @Description Returns the universal 0-polytope.
DeclareOperation("Vertex", []);

#! @Returns IsPolytope
#! @Description Returns the universal 1-polytope.
DeclareOperation("Edge", []);

#! @Arguments p
#! @Returns IsPolytope
#! @Description Returns the p-gon.
DeclareOperation("Pgon", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cube.
DeclareOperation("Cube", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-hemi-cube.
DeclareOperation("HemiCube", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-cross-polytope.
DeclareOperation("CrossPolytope", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-hemi-cross-polytope.
DeclareOperation("HemiCrossPolytope", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the n-simplex.
DeclareOperation("Simplex", [IsInt]);

#! @Arguments n
#! @Returns IsPolytope
#! @Description Returns the rank $n+1$ polytope; the tiling of $E^n$ by $n$-cubes.
DeclareOperation("CubicTiling", [IsInt]);

#! @Returns IsPolytope
#! @Description Returns the dodecahedron, `{5, 3}`.
DeclareOperation("Dodecahedron", []);

#! @Returns IsPolytope
#! @Description Returns the hemi-dodecahedron, `{5, 3}_5`.
DeclareOperation("HemiDodecahedron", []);

#! @Returns IsPolytope
#! @Description Returns the icosahedron, `{3, 5}`.
DeclareOperation("Icosahedron", []);

#! @Returns IsPolytope
#! @Description Returns the hemi-icosahedron, `{3, 5}_5`.
DeclareOperation("HemiIcosahedron", []);

#! @Returns IsPolytope
#! @Description Returns the 24-cell, `{3, 4, 3}`.
DeclareOperation("24Cell", []);

#! @Returns IsPolytope
#! @Description Returns the hemi-24-cell, `{3, 4, 3}_6`.
DeclareOperation("Hemi24Cell", []);

#! @Returns IsPolytope
#! @Description Returns the 120-cell, {5, 3, 3}.
DeclareOperation("120Cell", []);

#! @Returns IsPolytope
#! @Description Returns the hemi-120-cell, `{5, 3, 3}_15`.
DeclareOperation("Hemi120Cell", []);

#! @Returns IsPolytope
#! @Description Returns the 600-cell, `{3, 3, 5}`.
DeclareOperation("600Cell", []);

#! @Returns IsPolytope
#! @Description Returns the hemi-600-cell, `{3, 3, 5}_15`.
DeclareOperation("Hemi600Cell", []);

#! @Returns IsPolytope
#! @Description Returns Bruckner's sphere.
DeclareOperation("BrucknerSphere",[]);

#! @Arguments p
#! @Returns IsPolytope
#! @Description Constructs the internally self-dual polyhedron of type `{p, p}` described in Theorem 5.3 of
#! <Cite Key="CunMix17"/>. #(<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! p must be at least 7.
DeclareOperation("InternallySelfDualPolyhedron1",[IsInt]);

#! @Arguments p, k
#! @Returns IsPolytope
#! @Description Constructs  the internally self-dual polyhedron of type `{p, p}` described in Theorem 5.8 of <Cite Key="CunMix17"/>.# (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! `p` must be even and at least 6, and `k` must be odd.
DeclareOperation("InternallySelfDualPolyhedron2",[IsInt, IsInt]);