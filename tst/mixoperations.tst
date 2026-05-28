gap> g1:=ConnectionGroup(Cube(3));
<permutation group with 3 generators>
gap> g2:=ConnectionGroup(Edge());
Group([ (1,2) ])
gap> Mix(g1,g2);
<permutation group with 3 generators>
gap> Size(Mix(Cube(3), Edge()));
48
gap> Size(Mix(Octahedron(), Edge()));
96
gap> M := ToroidalMap44([1,2]);;
gap> FlagMix(M,M) = M;
true
gap> R := FlagMix(M, EnantiomorphicForm(M));; Size(R);
200
gap> IsReflexible(R);
true
gap> R = ToroidalMap44([5,0]);
true
gap> M := Comix(ToroidalMap44([2,0]), ToroidalMap44([3,0]));;
gap> M = ToroidalMap44([1,0]);
true
