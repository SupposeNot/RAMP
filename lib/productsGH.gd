#! @Chapter Products of Posets and Digraphs

#! This uses the work of Gleason and Hubard.

#! @Section Methods from __Products of abstract polytopes__
#! Anyone know how to link stuff?

#! @Arguments poset1, poset2
#! @Returns poset
#! @Description Given two posets, this forms the join product.
#! If given two partial orders, returns the join product binary relation of the partial orders. Appending `true` in this case will force is to return a BinaryRelationOnPoints.
DeclareOperation("JoinProduct", [IsPoset,IsPoset]);

