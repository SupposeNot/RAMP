gap> g := Group([(1,2), (2,3), (3,4)]);;
gap> M := ReflexibleManiplex(g);;
gap> M = Simplex(3);
true
gap> q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");;
gap> q = ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
true
gap> p := ReflexibleManiplex([infinity], "r0 r1 r0 = r1 r0 r1");;
gap> n := 3;;
gap> Size(ReflexibleManiplex([4,4], "(r0 r1 r2 r1)^$n"));
72
gap> L := List([1..5], k -> ReflexibleManiplex([4,4], ["r0 r1 r2 r1"], [k]));;
gap> List(L, IsPolytopal);
[ false, true, true, true, true ]
gap> M := ReflexibleManiplex([4,4], "r0 r1 r2");;
gap> HasSchlafliSymbol(M);
false
gap> M := ReflexibleManiplex([4,4], "r0 r1 r2" : set_schlafli);;
gap> HasSchlafliSymbol(M);
true
gap> ReflexibleManiplex("{4,4 | 6}") = ToroidalMap44([6,0]);
true
gap> ReflexibleManiplex("{4,4}_4") = ToroidalMap44([2,2]);
true
gap> M := ReflexibleManiplex("{6,6 | 6,2}_4");;
gap> HoleLength(M,2);
6
gap> HoleLength(M,3);
2
gap> ZigzagLength(M,1);
4
gap> g := Group([(1,2), (2,3), (3,4)]);;
gap> ReflexiblePremaniplex(g) = ReflexibleManiplex(g);
false
gap> G := Group([(1,2)(3,4)(5,6), (2,3)(4,5)(1,6)]);;
gap> M := Maniplex(G);;
gap> M = Pgon(3);
true
gap> c := ConnectionGroup(Cube(3));;
gap> Maniplex(c) = Cube(3);
true
gap> M := ReflexibleManiplex([4,4]);;
gap> M = CubicTiling(2);
true
gap> G := AutomorphismGroup(M);;
gap> H := Subgroup(G, [G.1*G.2*G.3*G.2, (G.2*G.1*G.2*G.3)^2]);;
gap> M2 := Maniplex(M, H);;
gap> Size(M2);
16
gap> M := Cube(4);; P := PosetFromManiplex(M);;
gap> M = Maniplex(P);
true
gap> M := Cube(4);;
gap> M = Maniplex(FlagGraph(M));
true
gap> g:=Group((1,2),(2,3),(1,2));;
gap> Size(Premaniplex(g));
3
gap> L:=[[[1,2],0], [[1,2],1], [[1],2], [[2],2]];;
gap> F:=EdgeLabeledGraphFromLabeledEdges(L);;
gap> Size(Premaniplex(F));
2
gap> M := RotaryManiplex(UniversalRotationGroup([3,3]));;
gap> M = Simplex(3);
true
gap> M := RotaryManiplex([4,3]);;
gap> M = Cube(3);
true
gap> M := RotaryManiplex([4,4], "(s2^-1 s1)^6");;
gap> M = ToroidalMap44([6,0]);
true
gap> L := List([1..5], k -> RotaryManiplex([4,4], ["s1 s2^-1"], [k]));;
gap> List(L, IsPolytopal);
[ false, true, true, true, true ]
gap> M := RotaryManiplex([6,6], "(s1^2 s2^2)^8" : set_schlafli);;
gap> SchlafliSymbol(M);
[ 6, 6 ]
gap> M := ToroidalMap44([1,2]);;
gap> g := AutomorphismGroup(M);;
gap> RelatorsOfFpGroup(g);
[ (s1*s2)^2, s1^4, s2^4, s2^-1*s1*(s2*s1^-1)^2 ]
gap> h := AutomorphismGroup(EnantiomorphicForm(M));;
gap> RelatorsOfFpGroup(h);
[ (s1*s2)^2, s1^4, s2^4, s2*s1^-1*(s2^-1*s1)^2 ]
