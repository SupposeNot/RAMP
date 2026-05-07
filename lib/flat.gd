
#! @Chapter Families of Polytopes
#! @Section Flat and tight polytopes

#! @Arguments p, q, i, j
#! @Returns Polyhedron P
#! @Description Returns the flat orientably regular polyhedron `P` of the form ARP([p,q], "r2 r1 r0 r1 = (r0 r1)^i (r1 r2)^j");
#! every flat orientably regular polyhedron is of this type (see <Cite Key="tight-polyhedra"/>). There are some restrictions on 
#! p, q, i, and j, and this function validates the inputs to make sure that the polyhedron is well-defined.
#! Use FlatOrientablyRegularPolyhedronNC if you do not want this validation.
DeclareOperation("FlatOrientablyRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);

DeclareOperation("FlatOrientablyRegularPolyhedronNC", [IsInt, IsInt, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> FlatOrientablyRegularPolyhedron(4,4,-1,1) = ToroidalMap44([2,0]);
#! true
#! @EndExampleSession


#! @Arguments sym
#! @Description Returns a list of all flat, orientably regular polyhedra with Schlafli symbol <A>sym</A>.
#! This is generated on the fly and may be slow.
DeclareOperation("FlatOrientablyRegularPolyhedraOfType", [IsList]);
#! @BeginExampleSession
#! gap> FlatOrientablyRegularPolyhedraOfType([6,6]);
#! [ FlatOrientablyRegularPolyhedron(6,6,3,1), FlatOrientablyRegularPolyhedron(6,6,-1,1), 
#!   FlatOrientablyRegularPolyhedron(6,6,-1,3) ]
#! @EndExampleSession

#! @Arguments sym
#! @Description Returns a list of all tight, orientably regular polytopes with Schlafli symbol <A>sym</A>. When <A>sym</A> has 
#! length 2, this just calls FlatOrientablyRegularPolyhedraOfType(<A>sym</A>). Otherwise, this attempts to find candidate facets 
#! and vertex-figures and amalgamate them.
DeclareOperation("TightOrientablyRegularPolytopesOfType", [IsList]);
#! @BeginExampleSession
#! gap> TightOrientablyRegularPolytopesOfType([6,6]);
#! [ FlatOrientablyRegularPolyhedron(6,6,3,1), FlatOrientablyRegularPolyhedron(6,6,-1,1), 
#!   FlatOrientablyRegularPolyhedron(6,6,-1,3) ]
#! @EndExampleSession