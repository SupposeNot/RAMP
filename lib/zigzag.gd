#! @Chapter Combinatorics and Structure
#! @Section Zigzags and holes

#! @Arguments M, j
#! @Returns The lengths of <A>j</A>-zigzags of the 3-maniplex <A>M</A>.
#! This corresponds to the lengths of orbits under r0 (r1 r2)^j.
DeclareOperation("ZigzagLength", [IsManiplex, IsInt]);

#! @Arguments M
#! @Returns The lengths of all zigzags of the 3-maniplex <A>M</A>.
#! A rank 3 maniplex of type {p, q} has Floor(q/2) distinct zigzag lengths
#! because the j-zigzags are the same as the (q-j)-zigzags.
DeclareAttribute("ZigzagVector", IsManiplex);

#! @Arguments M
#! @Returns The length of the petrie polygons of the maniplex <A>M</A>.
DeclareAttribute("PetrieLength", IsManiplex);

DeclareOperation("PetrieRelation", [IsInt, IsInt]);


#! @Arguments M, j
#! @Returns The lengths of <A>j</A>-holes of the 3-maniplex <A>M</A>.
#! This corresponds to the lengths of orbits under r0 (r1 r2)^(j-1) r2.
DeclareOperation("HoleLength", [IsManiplex, IsInt]);

#! @Arguments M
#! @Returns The lengths of all zigzags of the 3-maniplex <A>M</A>.
#! A rank 3 maniplex of type {p, q} has Floor(q/2) distinct zigzag lengths
#! because the j-zigzags are the same as the (q-j)-zigzags.
DeclareAttribute("HoleVector", IsManiplex);

