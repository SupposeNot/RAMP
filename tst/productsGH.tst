gap> p:=PosetFromManiplex(Cube(2));;
gap> rel:=BinaryRelationOnPoints([[1,2],[2]]);;
gap> p1:=PosetFromPartialOrder(rel);;
gap> j:=JoinProduct(p,p1);;
gap> IsIsomorphicPoset(j,PosetFromManiplex(Pyramid(Cube(2))));
true
gap> p1:=PosetFromManiplex(Edge());;
gap> p2:=PosetFromManiplex(Simplex(2));;
gap> c:=CartesianProduct(p1,p2);;
gap> IsIsomorphicPoset(c,PosetFromManiplex(Prism(Simplex(2))));
true
gap> p1:=PosetFromManiplex(Cube(2));;p2:=PosetFromManiplex(Edge());;
gap> ds:=DirectSumOfPosets(p1,p2);;
gap> IsIsomorphicPoset(ds,PosetFromManiplex(CrossPolytope(3)));
true
gap> p:=PosetFromManiplex(Pgon(3));;
gap> tp:=TopologicalProduct(p,p);;
gap> s0 := (5,6);;
gap> s1 := (1,2)(3,5)(4,6);;
gap> s2 := (2,3);;
gap> poly := Group([s0,s1,s2]);;
gap> torus:=PosetFromManiplex(ReflexibleManiplex(poly));;
gap> IsIsomorphicPoset(p,tp);
false
gap> IsIsomorphicPoset(torus,tp);
true
gap> p:=PosetFromManiplex(Pgon(3));;
gap> a:=Antiprism(p);;
gap> IsIsomorphicPoset(a,PosetFromManiplex(CrossPolytope(3)));
true
gap> p:=PosetFromManiplex(Pgon(4));;a:=Antiprism(p);;
gap> d:=DualPoset(p);;ad:=Antiprism(d);;
gap> IsIsomorphicPoset(a,ad);
true