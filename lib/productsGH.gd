
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


#! @Arguments polytope1, polytope2
#! @Returns polytope
#! @Description Given two polytopes, forms the cartesian product of the polytopes. Should also work if you give it any two posets.
DeclareOperation("CartesianProduct",[IsPoset,IsPoset]);
#! @BeginExampleSession
#! gap> p1:=PosetFromManiplex(Edge());
#! A poset
#! gap> p2:=PosetFromManiplex(Simplex(2));
#! A poset
#! gap> c:=CartesianProduct(p1,p2);
#! A poset using the IsPosetOfIndices representation
#! gap> IsIsomorphicPoset(c,PosetFromManiplex(PrismOver(Simplex(2))));
#! true
#! @EndExampleSession

#! @Arguments polytope1, polytope2
#! @Returns polytope
#! @Description Given two polytopes, forms the direct sum of the polytopes. 
DeclareOperation("DirectSumOfPosets",[IsPoset,IsPoset]);
#! @BeginExampleSession
#! gap> p1:=PosetFromManiplex(Cube(2));;p2:=PosetFromManiplex(Edge());;
#! gap> ds:=DirectSumOfPosets(p1,p2);
#! A poset using the IsPosetOfIndices representation.
#! gap> IsIsomorphicPoset(ds,PosetFromManiplex(CrossPolytope(3)));
#! true
#! @EndExampleSession

#! @Arguments polytope1, polytope2
#! @Returns polytope
#! @Description Given two polytopes, forms the topological product of the polytopes. 
DeclareOperation("TopologicalProduct",[IsPoset,IsPoset]);
#! Here we demonstrate that the topological product (as expected) when taking the product of a triangle with itself gives us the torus $\{4,4\}_{(3,0)}$ with 72 flags.
#! @BeginExampleSession
#! gap> p:=PosetFromManiplex(Pgon(3));
#! A poset using the IsPosetOfFlags representation.
#! gap> tp:=TopologicalProduct(p,p);
#! A poset using the IsPosetOfIndices representation.
#! gap> s0 := (5,6);;
#! gap> s1 := (1,2)(3,5)(4,6);;
#! gap> s2 := (2,3);;
#! gap> poly := Group([s0,s1,s2]);;
#! gap> torus:=PosetFromManiplex(ReflexibleManiplex(poly));
#! A poset using the IsPosetOfFlags representation.
#! gap> IsIsomorphicPoset(p,tp);
#! false
#! gap> IsIsomorphicPoset(torus,tp);
#! true
#! @EndExampleSession


#The following is a helper function.
DeclareOperation("DownShifter112358",[IsInt,IsInt,IsInt]);


#! @Arguments polytope
#! @Returns poset
#! @Description Given a <A>polytope</A> (actually, might work for any poset), will return the antiprism of the polytope.
DeclareOperation("Antiprism",[IsPoset]);