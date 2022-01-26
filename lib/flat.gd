
#! @Chapter Families of Polytopes
#! @Section Flat and tight polytopes

#! @Arguments p, q, i, j
#! @Returns polyhedron
#! @Description `polyhedron` is the flat orientably regular polyhedron with automorphism group [p, q] / (r2 r1 r0 r1 = (r0 r1)^i (r1 r2)^j). This function validates the inputs to make sure that the polyhedron is well-defined.
#! Use FlatOrientablyRegularPolyhedronNC if you do not want this validation.
DeclareOperation("FlatOrientablyRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);

DeclareOperation("FlatOrientablyRegularPolyhedronNC", [IsInt, IsInt, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> FlatOrientablyRegularPolyhedron(4,2,3,3);
#! FlatOrientablyRegularPolyhedron(4,2,-1,1)
#! @EndExampleSession


#! @Arguments sym
#! @Description Returns a list of all flat, orientably regular polyhedra with Schlafli symbol <A>sym</A>.
DeclareOperation("FlatOrientablyRegularPolyhedraOfType", [IsList]);
#! @BeginExampleSession
#! ap> FlatOrientablyRegularPolyhedraOfType([6,6]);
#! [ FlatOrientablyRegularPolyhedron(6,6,3,1), FlatOrientablyRegularPolyhedron(6,6,-1,1), 
#!   FlatOrientablyRegularPolyhedron(6,6,-1,3) ]
#! @EndExampleSession

#! @Arguments sym
#! @Description Returns a list of all tight, orientably regular polytopes with Schlafli symbol <A>sym</A>. When <A>sym</A> has length 2, this just calls FlatOrientablyRegularPolyhedraOfType(<A>sym</A>).
DeclareOperation("TightOrientablyRegularPolytopesOfType", [IsList]);
#! @BeginExampleSession
#! gap> TightOrientablyRegularPolytopesOfType([6,6]);
#! [ FlatOrientablyRegularPolyhedron(6,6,3,1), FlatOrientablyRegularPolyhedron(6,6,-1,1), 
#!   FlatOrientablyRegularPolyhedron(6,6,-1,3) ]
#! @EndExampleSession