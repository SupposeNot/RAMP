
#! @Chapter Constructions
#! @Section Products

#! @Arguments M
#! Returns the pyramid over <A>M</A>.
DeclareOperation("PyramidOver", [IsManiplex]);

#! @Arguments k
#! Returns the pyramid over a <A>k</A>-gon.
DeclareOperation("Pyramid", [IsInt]);

#! @Arguments M
#! Returns the prism over <A>M</A>.
DeclareOperation("PrismOver", [IsManiplex]);

#! @Arguments k
#! Returns the prism over a <A>k</A>-gon.
DeclareOperation("Prism", [IsInt]);

#! @Arguments M
#! Returns the antiprism over <A>M</A>.
DeclareOperation("Antiprism", [IsManiplex]);

#! @Arguments k
#! Returns the antiprism over a <A>k</A>-gon.
DeclareOperation("Antiprism", [IsInt]);



#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the join product.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("JoinProduct", [IsManiplex, IsManiplex]);

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the cartesian product.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("CartesianProduct", [IsManiplex, IsManiplex]);

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the direct sum.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("DirectSumOfManiplexes", [IsManiplex, IsManiplex]);

#! @Arguments M1, M2
#! @Returns Maniplex
#! @Description Given two maniplexes, this forms the direct sum.
#! May give weird results if the maniplexes aren't faithfully represented
#! by their posets.
DeclareOperation("TopologicalProduct", [IsManiplex, IsManiplex]);

