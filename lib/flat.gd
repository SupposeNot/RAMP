
#! @Chapter Families of Polytopes
#! @Section Flat and tight polytopes

#! @Arguments p, q, i, j
#! @Returns the flat orientably regular polyhedron with automorphism group
#! [p, q] / (r2 r1 r0 r1 = (r0 r1)^i (r1 r2)^j).
#! @Description This function validates the inputs to make sure that the polyhedron is well-defined.
#! Use FlatOrientablyRegularPolyhedronNC if you do not want this validation.
DeclareOperation("FlatOrientablyRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);


#! @Arguments p, q, i, j
#! @Returns ???
#! @Description ???
DeclareOperation("FlatOrientablyRegularPolyhedronNC", [IsInt, IsInt, IsInt, IsInt]);

#! @Arguments sym
#! @Returns a lits of all flat, orientably regular polyhedra with Schlafli symbol <A>sym</A>.
DeclareOperation("FlatOrientablyRegularPolyhedraOfType", [IsList]);

#! @Arguments sym
#! @Returns a lits of all flat, orientably regular polytopes with Schlafli symbol <A>sym</A>.
#! @Description When <A>sym</A> has length 2, this just calls FlatOrientablyRegularPolyhedraOfType(<A>sym</A>).
DeclareOperation("TightOrientablyRegularPolytopesOfType", [IsList]);
