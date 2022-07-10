
#! @Chapter Polytope Constructions and Operations
#! @Section Products

#! @BeginGroup Pyramid
#! @GroupTitle Pyramids
#! @Arguments M
#! @Description In the first form, returns the pyramid over <A>M</A>.
DeclareOperation("Pyramid", [IsManiplex]);

#! @Arguments k
#! @Description In the second form, returns the pyramid over a <A>k</A>-gon.
DeclareOperation("Pyramid", [IsInt]);

#! @BeginExampleSession
#! gap> SchlafliSymbol(Pyramid(Cube(3)));
#! [ [ 3, 4 ], [ 3, 4 ], 3 ]
#! gap> SchlafliSymbol(Pyramid(4));
#! [ [ 3, 4 ], [ 3, 4 ] ]
#! @EndExampleSession

#! @EndGroup


#! @BeginGroup Prisms
#! @GroupTitle Prisms
#! @Arguments M
#! @Description In the first form, returns the prism over <A>M</A>.
DeclareOperation("Prism", [IsManiplex]);

#! @Arguments k
#! @Description In the second form, returns the prism over a <A>k</A>-gon.
DeclareOperation("Prism", [IsInt]);
#! @BeginExampleSession
#! gap> Cube(3)=Prism(Cube(2));
#! true
#! gap> Prism(4)=Cube(3);
#! true
#! @EndExampleSession
#! @EndGroup

#! @BeginGroup Antiprisms
#! @GroupTitle Antiprisms
#! @Arguments M
#! @Description In the first form, returns the antiprism over <A>M</A>.
DeclareOperation("Antiprism", [IsManiplex]);

#! @Arguments k
#! @Description In the second form, returns the antiprism over a <A>k</A>-gon.
DeclareOperation("Antiprism", [IsInt]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Antiprism(Dodecahedron()));
#! [ [ 3, 5 ], [ 3, 5 ], 4 ]
#! gap> SchlafliSymbol(Antiprism(5));
#! [ [ 3, 5 ], 4 ]
#! @EndExampleSession
#! @EndGroup

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the join product.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("JoinProduct", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(last);
#! [ [ 3, 4 ], [ 3, 4 ], [ 3, 4 ], [ 3, 4 ], 3 ]
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the cartesian product.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("CartesianProduct", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(CartesianProduct(HemiCube(3),Simplex(2)));
#! [ [ 3, 4 ], 3, 3, 3 ]
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the direct sum.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("DirectSumOfManiplexes", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(DirectSumOfManiplexes(HemiCube(3),Simplex(2)));
#! [ [ 3, 4 ], [ 3, 4 ], [ 3, 4 ], [ 3, 4 ] ]
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the direct sum.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("TopologicalProduct", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(TopologicalProduct(HemiCube(3),Simplex(2)));
#! [ 4, 3, [ 3, 4 ] ]
#! @EndExampleSession
