

#! @Chapter Combinatorics and Structure
#! @Section Zigzags and holes

#! @Arguments M, j
#! @Returns The lengths of <A>j</A>-zigzags of the 3-maniplex <A>M</A>.
#! @Description This corresponds to the lengths of orbits under r0 (r1 r2)^j.
DeclareOperation("ZigzagLength", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> ZigzagLength(Cube(3),1);
#! 6
#! gap> ZigzagLength(Cube(3),2);
#! 6
#! gap> ZigzagLength(Cube(3),3);
#! 2
#! @EndExampleSession

#! @Arguments M
#! @Returns The lengths of all zigzags of the 3-maniplex <A>M</A>.
#! @Description A rank 3 maniplex of type {p, q} has Floor(q/2) distinct zigzag lengths
#! because the j-zigzags are the same as the (q-j)-zigzags.
DeclareAttribute("ZigzagVector", IsManiplex);
#! @BeginExampleSession
#! gap> ZigzagVector(Pseudorhombicuboctahedron());
#! [ [ 40, 56 ], [ 8, 32 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns The length of the petrie polygons of the maniplex <A>M</A>.
DeclareAttribute("PetrieLength", IsManiplex);
#! @BeginExampleSession
#! gap> PetrieLength(Cube(3));
#! 6
#! @EndExampleSession

#! @Arguments i, j
#! @Returns relation
#! @Description Returns the Petrie relation for a rank <A>i</A> maniplex of length <A>j</A>.
DeclareOperation("PetrieRelation", [IsInt, IsInt]);
#! @BeginExampleSession
#! gap> p:=PetrieRelation(3,3);
#! "(r0r1r2)^3"
#! gap> q:=Cube(3)/p;
#! 3-maniplex
#! gap> Size(q);
#! 24
#! @EndExampleSession

#! @Arguments M, j
#! @Returns The lengths of <A>j</A>-holes of the 3-maniplex <A>M</A>.
#! @Description This corresponds to the lengths of orbits under r0 (r1 r2)^(j-1) r2.
DeclareOperation("HoleLength", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> HoleLength(ToroidalMap44([3,0]),2);
#! 3
#! @EndExampleSession

#! @Arguments M
#! @Returns The lengths of all zigzags of the 3-maniplex <A>M</A>.
#! @Description A rank 3 maniplex of type {p, q} has Floor(q/2) distinct zigzag lengths
#! because the j-zigzags are the same as the (q-j)-zigzags.
DeclareAttribute("HoleVector", IsManiplex);
#! @BeginExampleSession
#! gap> HoleVector(ToroidalMap44([3,0],[0,5]));
#! [ [ 3, 5 ] ]
#! @EndExampleSession
