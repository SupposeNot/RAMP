
#! @Chapter Databases
#! @Section Regular polyhedra

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all degenerate polyhedra (of type $\{2, q\}$ and $\{p, 2\}$) with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("DegeneratePolyhedra");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all nondegenerate flat regular polyhedra with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("FlatRegularPolyhedra");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular toroidal polyhedra of type $\{4,4\}$
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("RegularToroidalPolyhedra44");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular toroidal polyhedra of type $\{3,6\}$
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("RegularToroidalPolyhedra36");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular polyhedra with sizes in <A>sizerange</A> flags
#! that are stored separately in a file. These are polyhedra that
#! are not part of one of several infinite families that are covered
#! by the other generators. The return value of this function is
#! unstable and may change as more infinite familes of polyhedra
#! are identified and written as separate generators.
DeclareGlobalFunction("SmallRegularPolyhedraFromFile");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
#! You can also set options `nondegenerate`, `nonflat`, and `nontoroidal`.
#! @BeginExampleSession
#! L1 := SmallRegularPolyhedra(500);;
#! L2 := SmallRegularPolyhedra(1000 : nondegenerate);;
#! L3 := SmallRegularPolyhedra(2000 : nondegenerate, nonflat);;
#! @EndExampleSession
DeclareGlobalFunction("SmallRegularPolyhedra");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all degenerate regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 8000 or less. 
DeclareGlobalFunction("SmallDegenerateRegular4Polytopes");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallRegular4Polytopes");


DeclareGlobalFunction("ReadChiralPolytopesFromFile");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all chiral polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallChiralPolyhedra");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all chiral 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallChiral4Polytopes");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 2000 or less.
#! If the option `nonpolytopal` is set, only returns maniplexes that
#! are not polyhedra.
DeclareGlobalFunction("SmallReflexible3Maniplexes");

#! @Arguments minsize, maxsize[, func1, val1, func2, val2, ...]
#! @Returns IsList
#! @Description Returns a list of all regular polyhedra with at least <A>minsize</A>
#! at at most <A>maxsize</A> flags. Optionally, you may include any number of pairs
#! of functions and values, in which case this only returns those polyhedra such that
#! the given functions have the given values.
#! The name of this function is temporary and this function is here as a proof-of-concept.
DeclareGlobalFunction("SRP");
#! @BeginExampleSession
#! gap> SRP(1,200,SchlafliSymbol,[4,4]);
#! [ FlatOrientablyRegularPolyhedron(4,4,-1,1), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2)^4"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^3"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^4"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2)^6"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^5") ]
#! gap> SRP(1,200,SchlafliSymbol,[4,4],IsFlat,false);
#! [ AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2)^4"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^3"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^4"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2)^6"), AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^5") ]
#! gap> SRP(1,32,p->SchlafliSymbol(p)[1], 4);
#! [ AbstractRegularPolytope([ 4, 2 ]), AbstractRegularPolytope([ 4, 3 ], "r2 r1 r0 r1 = (r0 r1)^2 r1 (r1 r2)^1, r2 r1 r2 r1 r0 r1 = (r0 r1)^3 (r1 r2)^2"), FlatOrientablyRegularPolyhedron(4,4,-1,1) ]
#! @EndExampleSession
