#! @Chapter Products of Posets and Digraphs

#! This uses the work of Gleason and Hubard.

#! @Section Construction methods
#! Anyone know how to link stuff?

#! @Arguments poset1, poset2
#! @Returns poset
#! @Description Given two posets, this forms the join product.
#! If given two partial orders, returns the join product of the partial orders.
DeclareOperation("JoinProduct", [IsPoset,IsPoset]);
#! @BeginExampleSession
#! gap> p:=PosetFromManiplex(Cube(2));
#! A poset
#! gap> rel:=BinaryRelationOnPoints([[1,2],[2]]);
#! Binary Relation on 2 points
#! gap> p1:=PosetFromPartialOrder(rel);
#! A poset using the IsPosetOfIndices representation
#! gap> j:=JoinProduct(p,p1);
#! A poset using the IsPosetOfIndices representation
#! gap> IsIsomorphicPoset(j,PosetFromManiplex(PyramidOver(Cube(2))));
#! true
#! @EndExampleSession