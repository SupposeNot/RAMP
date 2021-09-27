
#! @Chapter Families of Polytopes
#! @Section Classical Polytopes

#! @Arguments
#! @Returns the universal 0-polytope.
DeclareOperation("Vertex", []);

#! @Arguments
#! @Returns the universal 1-polytope.
DeclareOperation("Edge", []);

#! @Arguments p
#! @Returns the p-gon.
DeclareOperation("Pgon", [IsInt]);

#! @Arguments n
#! @Returns the n-cube.
DeclareOperation("Cube", [IsInt]);

#! @Arguments n
#! @Returns the n-hemi-cube.
DeclareOperation("HemiCube", [IsInt]);

#! @Arguments n
#! @Returns the n-cross-polytope.
DeclareOperation("CrossPolytope", [IsInt]);

#! @Arguments n
#! @Returns the n-hemi-cross-polytope.
DeclareOperation("HemiCrossPolytope", [IsInt]);

#! @Arguments n
#! @Returns the n-simplex.
DeclareOperation("Simplex", [IsInt]);

#! @Arguments n
#! @Returns the rank n+1 polytope; the tiling of E^n by n-cubes.
DeclareOperation("CubicTiling", [IsInt]);

#! @Arguments
#! @Returns the dodecahedron, {5, 3}.
DeclareOperation("Dodecahedron", []);

#! @Arguments
#! @Returns the hemi-dodecahedron, {5, 3}_5.
DeclareOperation("HemiDodecahedron", []);

#! @Arguments
#! @Returns the icosahedron, {3, 5}.
DeclareOperation("Icosahedron", []);

#! @Arguments
#! @Returns the hemi-icosahedron, {3, 5}_5.
DeclareOperation("HemiIcosahedron", []);

#! @Arguments
#! @Returns the 24-cell, {3, 4, 3}.
DeclareOperation("24Cell", []);

#! @Arguments
#! @Returns the hemi-24-cell, {3, 4, 3}_6.
DeclareOperation("Hemi24Cell", []);

#! @Arguments
#! @Returns the 120-cell, {5, 3, 3}.
DeclareOperation("120Cell", []);

#! @Arguments
#! @Returns the hemi-120-cell, {5, 3, 3}_15.
DeclareOperation("Hemi120Cell", []);

#! @Arguments
#! @Returns the 600-cell, {3, 3, 5}.
DeclareOperation("600Cell", []);

#! @Arguments
#! @Returns the hemi-600-cell, {3, 3, 5}_15.
DeclareOperation("Hemi600Cell", []);

#! @Arguments
#! @Returns Bruckner's sphere.
DeclareOperation("BrucknerSphere",[]);

#! @Arguments k
#! @Returns the internally self-dual polyhedron of type {k, k} described in Theorem 5.3 of
#! <Cite Key="CunMix17"/> (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! k must be at least 7.
DeclareOperation("InternallySelfDualPolyhedron1",[IsInt]);