gap> g := DirectedGraphFromListOfEdges([1,2,3],[[1,2],[2,3],[3,1]]);;
gap> Length(Vertices(g));
3
gap> Length(DirectedEdges(g));
3
gap> g := GraphFromListOfEdges([1,2,3,4],[[1,2],[2,3],[3,1],[1,4],[2,4],[3,4]]);;
gap> Length(Vertices(g));
4
gap> Length(UndirectedEdges(g));
6
gap> g := UnlabeledFlagGraph(Cube(3));;
gap> Length(Vertices(g));
48
gap> Length(UndirectedEdges(g));
72
gap> f := FlagGraphWithLabels(Cube(3));;
gap> Length(Vertices(f[1]));
48
gap> Length(f[2]);
72
gap> Set(f[3]);
[ 0, 1, 2 ]
gap> g := LayerGraph(Cube(3),2,1);;
gap> Length(Vertices(g));
18
gap> Length(UndirectedEdges(g));
24
gap> g := Skeleton(Dodecahedron());;
gap> Length(Vertices(g));
20
gap> Length(UndirectedEdges(g));
30
gap> g := CoSkeleton(Dodecahedron());;
gap> Length(Vertices(g));
12
gap> Length(UndirectedEdges(g));
30
gap> IsIsomorphicGraph(g,Skeleton(Icosahedron()));
true
gap> s := SkeletonEdges(Dodecahedron());;
gap> s.order;
20
gap> Length(s.edges);
30
gap> Length(Set(List(s.edges, Set)));
30
gap> IsIsomorphicGraph(GraphFromListOfEdges([1..s.order], s.edges), Skeleton(Dodecahedron()));
true
gap> s := SkeletonEdges(ReflexibleManiplex([2,3]));;
gap> s.order;
2
gap> Length(s.edges);
3
gap> Collected(List(s.edges, Set));
[ [ [ 1, 2 ], 3 ] ]
gap> Length(UndirectedEdges(Skeleton(ReflexibleManiplex([2,3]))));
1
gap> s := CoSkeletonEdges(Dodecahedron());;
gap> s.order;
12
gap> Length(s.edges);
30
gap> Length(Set(List(s.edges, Set)));
30
gap> s := CoSkeletonEdges(ReflexibleManiplex([3,2]));;
gap> s.order;
2
gap> Collected(List(s.edges, Set));
[ [ [ 1, 2 ], 3 ] ]
gap> g := Hasse(Simplex(3));;
gap> Length(Vertices(g));
16
gap> Length(DirectedEdges(g));
32
gap> Q := QuotientByLabel(f[1],f[2],f[3],[0]);;
gap> Length(Vertices(Q));
8
gap> Length(UndirectedEdges(Q));
12
gap> IsBipartite(Q);
true
gap> V := [1..6];;
gap> Ed := [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]];;
gap> L := [0,1,0,1,0,1];;
gap> gamma := EdgeLabeledGraphFromEdges(V,Ed,L);;
gap> Verts(gamma);
[ 1 .. 6 ]
gap> Labels(gamma);
[ 0, 1, 0, 1, 0, 1 ]
gap> gamma := EdgeLabeledGraphFromLabeledEdges([[[1],0],[[2],0],[[1,2],1]]);;
gap> Verts(gamma);
[ 1, 2 ]
gap> Labels(gamma);
[ 0, 0, 1 ]
gap> gamma := FlagGraph(Simplex(3));;
gap> Length(Verts(gamma));
24
gap> Length(Edges(gamma));
36
gap> Set(Labels(gamma));
[ 0, 1, 2 ]
gap> g := UnlabeledSimpleGraph(FlagGraph(Cube(3)));;
gap> Length(Vertices(g));
48
gap> Length(UndirectedEdges(g));
72
gap> g := EdgeLabelPreservingAutomorphismGroup(FlagGraph(Simplex(3)));;
gap> Size(g);
31104
gap> gamma := EdgeLabeledGraphFromLabeledEdges([[[1],0],[[1,1],1],[[1,2],2],[[1,2],3],[[2,3],0]]);;
gap> s := Simple(gamma);;
gap> Edges(s);
[ [ 1 ], [ 1, 1 ], [ 1, 2 ], [ 2, 3 ] ]
gap> Labels(s);
[ 0, 1, 2, 0 ]
gap> comps := ConnectedComponents(FlagGraph(Cube(3)),[1]);;
gap> Length(comps);
12
gap> Set(List(comps,Length));
[ 4 ]
gap> Length(ConnectedComponents(FlagGraph(Cube(3))));
1
gap> G := AutomorphismGroup(Cube(3));;
gap> H := Group(G.2,G.3);;
gap> phi := FactorCosetAction(G,H);;
gap> gamma := PRGraph(Range(phi));;
gap> Length(Verts(gamma));
8
gap> Set(Labels(gamma));
[ 0, 1, 2 ]
gap> gamma := CPRGraphFromGroups(G,H);;
gap> Length(Verts(gamma));
8
gap> Set(Labels(gamma));
[ 0, 1, 2 ]
gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
gap> AdjacentVertices(gamma,2);
[ 1, 3 ]
gap> LabeledAdjacentVertices(gamma,2);
[ [ 1, 3 ], [ 0, 1 ] ]
gap> SemiEdges(gamma);
[ [ 3 ], [ 1 ] ]
gap> LabeledSemiEdges(gamma);
[ [ [ 3 ], [ 1 ] ], [ 2, 1 ] ]
gap> Length(LabeledDarts(gamma));
6
gap> V := [1,2,3];;
gap> Ed := [[1],[1],[1,2],[2],[2,3],[3],[3]];;
gap> L := [1,2,0,2,1,0,2];;
gap> base := EdgeLabeledGraphFromEdges(V,Ed,L);;
gap> darts := LabeledDarts(base);;
gap> volt := [ (1,2), (3,4), (), (), (3,4), (), (), (4,5), (2,3) ];;
gap> D := DerivedGraph(V,darts,volt);;
gap> Length(Verts(D));
360
gap> Set(Labels(D));
[ 0, 1, 2 ]
gap> gamma := FlagGraph(Simplex(3));;
gap> G := ConnectionGroup(gamma);;
gap> Size(G);
24
gap> Length(GeneratorsOfGroup(G));
3
gap> P := STG2(5,[2,4]);;
gap> Length(LabeledDarts(P));
10
gap> Set(List(LabeledDarts(P),x -> x[2]));
[ 0, 1, 2, 3, 4 ]
gap> LabeledDart(P,1,1);
[ [ 1, 2 ], 1 ]
gap> LabeledDart(P,1,0);
fail
