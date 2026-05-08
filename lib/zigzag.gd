

#! @Chapter Combinatorics and Structure
#! @Section Zigzags and holes

#! @Arguments M, j
#! @Returns The length(s) of <A>j</A>-zigzags of the 3-maniplex <A>M</A>.
#! @Description This corresponds to the lengths of orbits under r0 (r1 r2)^j.
#! If all j-zigzags have the same length, then returns that length as an integer;
#! otherwise, returns a list of all possible lengths.
DeclareOperation("ZigzagLength", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> ZigzagLength(Pyramid(8),1);
#! 32
#! gap> ZigzagLength(Pyramid(8),2);
#! 4
#! gap> ZigzagLength(Pyramid(8),3);
#! [ 2, 16 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns The list [ZigzagLength(M,1), ..., ZigzagLength(M,k)], where
#! k = Floor(q/2), with q the maximum vertex degree.
DeclareAttribute("ZigzagVector", IsManiplex);
#! @BeginExampleSession
#! gap> ZigzagVector(Pyramid(8));
#! [ 32, 4, [ 2, 16 ], 16 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns The length(s) of the Petrie polygons of the maniplex <A>M</A>.
#! When M has rank 3, this is the same as the length of the 1-zigzags.
#! Returns a single integer if all Petrie polygons have the same length;
#! otherwise returns a list of the lengths.
DeclareAttribute("PetrieLength", IsManiplex);
#! @BeginExampleSession
#! gap> PetrieLength(Cube(3));
#! 6
#! gap> PetrieLength(Cube(4));
#! 8
#! gap> M := SmallChiralPolytopes([240..240])[1];; PetrieLength(M);
#! [ 4, 6 ]
#! @EndExampleSession

#! @Arguments i, j
#! @Returns relation
#! @Description Returns the string "(r0 ... r(i-1))^j", which represents the j-th power of the Petrie word
#! for a rank <A>i</A> maniplex.
DeclareOperation("PetrieRelation", [IsInt, IsInt]);
#! @BeginExampleSession
#! gap> p := PetrieRelation(3,3);
#! "(r0 r1 r2)^3"
#! gap> q := Cube(3)/p;; q = HemiCube(3);
#! true
#! gap> Size(q);
#! 24
#! @EndExampleSession

#! @Arguments M, j
#! @Returns The lengths of <A>j</A>-holes of the 3-maniplex <A>M</A>.
#! @Description This corresponds to the lengths of orbits under r0 (r1 r2)^(j-1) r1.
#! Usually j is assumed to be at least 2.
#! If all j-holes have the same length, then returns that length as an integer;
#! otherwise, returns a list of all possible lengths.
DeclareOperation("HoleLength", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> HoleLength(ToroidalMap44([3,0]),2);
#! 3
#! gap> HoleLength(ToroidalMap44([2,0],[0,3]),2);
#! [ 2, 3 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns The list [HoleLength(M,2), ..., HoleLength(M,k)], where
#! k = Floor((q+1)/2), with q the maximum vertex degree.
DeclareAttribute("HoleVector", IsManiplex);
#! @BeginExampleSession
#! gap> HoleVector(Pyramid(6));
#! [ 6, [ 2, 4 ] ]
#! @EndExampleSession
