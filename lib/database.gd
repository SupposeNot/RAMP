
#! @Chapter Databases
#! @Section Regular polyhedra

#! @Arguments maxsize
#! Returns all degenerate polyhedra (of type {2, q} and {p, 2})
#! with up to <A>maxsize</A> flags.
DeclareOperation("DegeneratePolyhedra", [IsInt]);

#! @Arguments maxsize
#! Returns all nondegenerate flat regular polyhedra with up to <A>maxsize</A> flags.
#! Currently supports a maxsize of 4000 or less.
DeclareOperation("FlatRegularPolyhedra", [IsInt]);

#! @Arguments maxsize
#! Returns all regular polyhedra with up to <A>maxsize</A> flags.
#! Currently supports a maxsize of 4000 or less.
#! You can also set options "nondegenerate" and "nonflat".
#! @BeginExampleSession
#! L1 := SmallRegularPolyhedra(500);;
#! L2 := SmallRegularPolyhedra(1000 : nondegenerate);;
#! L3 := SmallRegularPolyhedra(2000 : nondegenerate, nonflat);;
#! @EndExampleSession
DeclareOperation("SmallRegularPolyhedra", [IsInt]);