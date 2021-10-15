
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
#! Returns all regular polyhedra with sizes in <A>sizerange</A> flags
#! that are stored separately in a file. These are polyhedra that
#! are not part of one of several infinite families that are covered
#! by the other generators. The return value of this function is
#! unstable and may change as more infinite familes of polyhedra
#! are identified and written as separate generators.
DeclareGlobalFunction("SmallRegularPolyhedraFromFile");

#! @Arguments sizerange
#! Returns all regular polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
#! You can also set options "nondegenerate", "nonflat", and "nontoroidal".
#! @BeginExampleSession
#! L1 := SmallRegularPolyhedra(500);;
#! L2 := SmallRegularPolyhedra(1000 : nondegenerate);;
#! L3 := SmallRegularPolyhedra(2000 : nondegenerate, nonflat);;
#! @EndExampleSession
DeclareGlobalFunction("SmallRegularPolyhedra");

#! @Arguments sizerange
#! Returns all degenerate regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 8000 or less. 
DeclareGlobalFunction("SmallDegenerateRegular4Polytopes");

#! @Arguments sizerange
#! Returns all regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("SmallRegular4Polytopes");


DeclareGlobalFunction("ReadChiralPolytopesFromFile");

#! @Arguments sizerange
#! Returns all chiral polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("SmallChiralPolyhedra");

#! @Arguments sizerange
#! Returns all chiral 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("SmallChiral4Polytopes");