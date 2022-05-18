gap> M := ToroidalMap44([1,2],[-2,1]);;
gap> M2 := EnantiomorphicForm(M);;
gap> M = M2;
true
gap> IsIsomorphicRootedManiplex(M,M2);
false
gap> M3 := ToroidalMap44([2,1],[-1,2]);;
gap> IsIsomorphicRootedManiplex(M,M3);
false
gap> IsIsomorphicRootedManiplex(M2,M3);
true
gap> M4 := Maniplex(ConnectionGroup(M2));;
gap> IsIsomorphicRootedManiplex(M2,M4);
true
gap> IsIsomorphicRootedManiplex(M3,M4);
true
gap> IsIsomorphicRootedManiplex(M,M4);
false
