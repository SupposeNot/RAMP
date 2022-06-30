
#! @Chapter Databases
#! @Section Regular polyhedra
#! Eventually we should put information here about where the data comes from.

#! @Arguments maniplexes, filename, attributeNames
#! @Description Writes the data in <A>maniplexes</A> to the designated file,
#! including the defining information and the values of the attributes in
#! <A>attributeNames</A>. 
#! This calls `DatabaseString` on each maniplex in <A>maniplexes</A> to get
#! the file representation.
DeclareGlobalFunction("WriteManiplexesToFile");

#! @Arguments filename
#! @Returns IsList
#! @Description Reads the maniplexes from <A>filename</A> in the data directory
#! of RAMP and returns them as a list.
#! Note that for performance reasons, some safety checks are disabled for data
#! read from a file. For example, `AbstractRegularPolytope` usually checks its
#! input to make sure that it defines a polytope, but `ManiplexesFromFile`
#! just assumes that any maniplex defined using `AbstractRegularPolytope` really
#! is a polytope.
DeclareGlobalFunction("ManiplexesFromFile");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all degenerate polyhedra (of type $\{2, q\}$ and $\{p, 2\}$) with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("DegeneratePolyhedra");
#! @BeginExampleSession
#! gap> DegeneratePolyhedra(24);
#! [ AbstractRegularPolytope([ 2, 2 ]), AbstractRegularPolytope([ 2, 3 ]), 
#!   AbstractRegularPolytope([ 3, 2 ]), AbstractRegularPolytope([ 2, 4 ]), 
#!   AbstractRegularPolytope([ 4, 2 ]), AbstractRegularPolytope([ 2, 5 ]), 
#!   AbstractRegularPolytope([ 5, 2 ]), AbstractRegularPolytope([ 2, 6 ]), 
#!   AbstractRegularPolytope([ 6, 2 ]) ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all nondegenerate flat regular polyhedra with 
#! sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
#! Currently supports a maxsize of 4000 or less.
DeclareGlobalFunction("FlatRegularPolyhedra");
#! @BeginExampleSession
#! gap> FlatRegularPolyhedra([10..24]);
#! [ AbstractRegularPolytope([ 2, 3 ]), AbstractRegularPolytope([ 3, 2 ]), 
#!   AbstractRegularPolytope([ 2, 4 ]), AbstractRegularPolytope([ 4, 2 ]), 
#!   AbstractRegularPolytope([ 2, 5 ]), AbstractRegularPolytope([ 5, 2 ]), 
#!   AbstractRegularPolytope([ 4, 3 ], "r2 r1 r0 r1 = (r0 r1)^2 r1 (r1 r2)^1, r2 r1 r2 r1 r0 r1 = (r0\
#!  r1)^3 (r1 r2)^2"), 
#!   ReflexibleManiplex([ 3, 4 ], "(r2*r1)^2*r1^2*r0*r1*r2*r1*r0,(r2*r1)^3*(r1*r0)^2*r1*r2*(r1*r0)^2"\
#! ), AbstractRegularPolytope([ 2, 6 ]), AbstractRegularPolytope([ 6, 2 ]) ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular toroidal polyhedra of type $\{4,4\}$
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("RegularToroidalPolyhedra44");
#! @BeginExampleSession
#! gap> RegularToroidalPolyhedra44([60..100]);
#! [ AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2)^4"), 
#!   AbstractRegularPolytope([ 4, 4 ], "(r0 r1 r2 r1)^3") ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular toroidal polyhedra of type $\{3,6\}$
#! with sizes in <A>sizerange</A>. Also accepts a single integer
#! __maxsize__ as input to indicate a sizerange of `[1..maxsize]`.
DeclareGlobalFunction("RegularToroidalPolyhedra36");
#! @BeginExampleSession
#! gap> RegularToroidalPolyhedra36([100..150]);
#! [ AbstractRegularPolytope([ 3, 6 ], "(r0 r1 r2)^6"), 
#!   AbstractRegularPolytope([ 3, 6 ], "(r0 r1 r2 r1 r2)^4") ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular polyhedra with sizes in <A>sizerange</A> flags
#! that are stored separately in a file. These are polyhedra that
#! are not part of one of several infinite families that are covered
#! by the other generators. The return value of this function is
#! unstable and may change as more infinite familes of polyhedra
#! are identified and written as separate generators.
DeclareGlobalFunction("SmallRegularPolyhedraFromFile");
#! @BeginExampleSession
#! gap> SmallRegularPolyhedraFromFile(64);
#! [ Simplex(3), AbstractRegularPolytope([ 3, 6 ], "(r2*r0*r1)^2*(r0*r2*r1)^2 "), CrossPolytope(3), 
#!   AbstractRegularPolytope([ 6, 3 ], "(r0*r2*r1)^2*(r2*r0*r1)^2 "), Cube(3), 
#!   AbstractRegularPolytope([ 5, 5 ], "r1*r2*r0*(r1*r0*r2)^2 "), 
#!   AbstractRegularPolytope([ 3, 5 ], "(r2*r0*r1)^3*(r0*r2*r1)^2 "), 
#!   AbstractRegularPolytope([ 5, 3 ], "(r0*r2*r1)^3*(r2*r0*r1)^2 ") ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
#! You can also set options `nondegenerate`, `nonflat`, and `nontoroidal`.
DeclareGlobalFunction("SmallRegularPolyhedra");
#! @BeginExampleSession
#! gap> L1 := SmallRegularPolyhedra(500);;
#! gap> L2 := SmallRegularPolyhedra(1000 : nondegenerate);;
#! gap> L3 := SmallRegularPolyhedra(2000 : nondegenerate, nonflat);;
#! gap> Length(SmallRegularPolyhedra(64));
#! 53
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all degenerate regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 8000 or less. 
DeclareGlobalFunction("SmallDegenerateRegular4Polytopes");
#! @BeginExampleSession
#! gap>  SmallDegenerateRegular4Polytopes([64]);
#! [ AbstractRegularPolytope([ 4, 2, 4 ]), AbstractRegularPolytope([ 2, 8, 2 ]), 
#!   regular 4-polytope of type [ 4, 4, 2 ] with 64 flags, 
#!   ReflexibleManiplex([ 2, 4, 4 ], "(r2*r1*r2*r3)^2,(r1*r2*r3*r2)^2") ]
#! @EndExampleSession

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallRegular4Polytopes");
#! @BeginExampleSession
#! gap> SmallRegular4Polytopes([100]);
#! [ AbstractRegularPolytope([ 5, 2, 5 ]) ]
#! @EndExampleSession



DeclareGlobalFunction("ReadChiralPolytopesFromFile");

#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all chiral polyhedra with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallChiralPolyhedra");
#! @BeginExampleSession
#! gap> SmallChiralPolyhedra(100);
#! [ AbstractRotaryPolytope([ 4, 4 ], "s1*s2^-2*s1^2*s2^-1,(s1^-1*s2^-1)^2"), 
#!   AbstractRotaryPolytope([ 4, 4 ], "s2*s1^-1*s2*s1^2*s2^2*s1^-1,(s1^-1*s2^-1)^2"), 
#!   AbstractRotaryPolytope([ 3, 6 ], "s2^-1*s1*s2^-2*s1^-1*s2*s1^-1*s2^-2,(s1^-1*s2^-1)^2"), 
#!   AbstractRotaryPolytope([ 6, 3 ], "s1*s2^-1*s1^2*s2*s1^-1*s2*s1^2,(s2*s1)^2") ]
#! @EndExampleSession


#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all chiral 4-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 4000 or less.
DeclareGlobalFunction("SmallChiral4Polytopes");
#! @BeginExampleSession
#! gap> SmallChiral4Polytopes([200..250]);
#! [ AbstractRotaryPolytope([ 3, 4, 4 ], "s3^-1*s2^-2*s1^-1*s3*s1,s2^-1*s3^-2*s2^2*s3,(s2^-1*s3^-1)^2,(s1^-1*s2^-1)^2"), 
#!   AbstractRotaryPolytope([ 4, 4, 3 ], "s1*s2^2*s3*s1^-1*s3^-1,s2*s1^2*s2^-2*s1^-1,(s2*s1)^2,(s3*s2)^2"), 
#!   AbstractRotaryPolytope([ 4, 4, 4 ], "s2*s3^-2*s2^2*s3^-1,s3*s2*s1^-1*s3^2*s1,s3^-1*s2^-2*s1^-1*s3*s1,(s2^-1*s3^-1)^2,s1^-1*s2^-2*s1^2*s2,(s1^-1*s2^-1)^2") ]
#! @EndExampleSession


#! @Arguments sizerange
#! @Returns IsList
#! @Description Gives all regular 3-polytopes with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 2000 or less.
#! If the option `nonpolytopal` is set, only returns maniplexes that
#! are not polyhedra.
DeclareGlobalFunction("SmallReflexible3Maniplexes");

#! @Arguments n, sizerange[, filt1, filt2, ...]
#! @Returns IsList
#! @Description First finds a list of all reflexible maniplexes of rank <A>n</A>
#! where the number of flags is in <A>sizerange</A>. Then applies the given filters
#! and returns the result. Each filter is either a function-value pair or a boolean
#! function. In the first case, we keep only those maniplexes such that applying the
#! given function returns the given value. In the second case, we keep only those
#! maniplexes such that the given boolean function returns `true`.
DeclareGlobalFunction("SmallReflexibleManiplexes");
#! @BeginExampleSession
#! gap> L := SmallReflexibleManiplexes(3, [100..200], IsPolytopal, [NumberOfVertices, 6]);;
#! gap> Size(L);
#! 14
#! gap> ForAll(L, IsPolytopal);
#! true
#! gap> List(L, NumberOfVertices);
#! [ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 ]
#! @EndExampleSession

#! @Arguments I, sizerange
#! @Returns IsList
#! @Description Gives all two-orbit 3-maniplexes in class $2_I$ with sizes in <A>sizerange</A> flags.
#! Currently supports a `maxsize` of 1000 or less.
DeclareGlobalFunction("SmallTwoOrbit3Maniplexes");
#! @BeginExampleSession
#! gap> L := SmallTwoOrbit3Maniplexes([0], 100);
#! [ TwoOrbit3ManiplexClass2_0([ 10, 4 ], "  r0*a21*a101*a21^-1, r0*a21^-1*a101*r0*a101*a21 "),
#!  TwoOrbit3ManiplexClass2_0([ 14, 3 ], "  r0*a21*a101*a21^-1, r0*a101*a21*(a101*r0)^2*a21^-1 ") ]
#! @EndExampleSession
