
#! @Arguments p, q, i, j
#! Returns the flat orientably regular polyhedron with automorphism group
#! [p, q] / (r2 r1 r0 r1 = (r0 r1)^i (r1 r2)^j).
#! This function validates the inputs to make sure that the polyhedron is well-defined.
#! Use FlatOrientablyRegularPolyhedronNC if you do not want this validation.
DeclareOperation("FlatOrientablyRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);

DeclareOperation("FlatOrientablyRegularPolyhedronNC", [IsInt, IsInt, IsInt, IsInt]);

#! @Arguments sym
#! Returns a lits of all flat, orientably regular polyhedra with Schlafli symbol <A>sym</A>.
DeclareOperation("FlatOrientablyRegularPolyhedraOfType", [IsList]);

#! @Arguments sym
#! Returns a lits of all flat, orientably regular polytopes with Schlafli symbol <A>sym</A>.
#! When <A>sym</A> has length 2, this just calls FlatOrientablyRegularPolyhedraOfType(<A>sym</A>).
DeclareOperation("TightOrientablyRegularPolytopesOfType", [IsList]);
