
#! @Chapter Databases
#! @Section Regular polyhedra

#! @Arguments sizerange
#! Returns all degenerate polyhedra (of type {2, q} and {p, 2}) with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of [1..maxsize].
DeclareGlobalFunction("DegeneratePolyhedra");

#! @Arguments sizerange
#! Returns all nondegenerate flat regular polyhedra with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of [1..maxsize].
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("FlatRegularPolyhedra");

#! @Arguments sizerange
#! Returns all regular toroidal polyhedra of type {4,4}
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of [1..maxsize].
DeclareGlobalFunction("RegularToroidalPolyhedra44");

#! @Arguments sizerange
#! Returns all regular toroidal polyhedra of type {3,6}
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of [1..maxsize].
DeclareGlobalFunction("RegularToroidalPolyhedra36");

#! @Arguments sizerange
#! Returns all regular polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
#! You can also set options "nondegenerate" and "nonflat".
#! @BeginExampleSession
#! L1 := SmallRegularPolyhedra(500);;
#! L2 := SmallRegularPolyhedra(1000 : nondegenerate);;
#! L3 := SmallRegularPolyhedra(2000 : nondegenerate, nonflat);;
#! @EndExampleSession
DeclareGlobalFunction("SmallRegularPolyhedra");

#! @Arguments sizerange
#! Returns all chiral polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("SmallChiralPolyhedra");