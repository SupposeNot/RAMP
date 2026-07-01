
#! @Chapter Graphs for Maniplexes
#! @Section Graph constructors for maniplexes

#! Note that this functionality depends on the functionality of the GRAPE package.

#! @Arguments list, list
#! @Returns `IsGraph`. Note this returns a directed graph.
#! @Description Given a list of vertices and a list of directed edges, represented as ordered pairs, this outputs the directed graph with that vertex set and directed-edge set.
DeclareOperation("DirectedGraphFromListOfEdges",[IsList,IsList]);
#! Here we build a directed cycle on 3 vertices.
#! @BeginExampleSession
#! gap> g := DirectedGraphFromListOfEdges([1,2,3],[[1,2],[2,3],[3,1]]);
#! rec( adjacencies := [ [ 2 ], [ 3 ], [ 1 ] ], group := Group(()), 
#!   isGraph := true, names := [ 1, 2, 3 ], order := 3, 
#!   representatives := [ 1, 2, 3 ], schreierVector := [ -1, -2, -3 ] )
#! gap> Length(Vertices(g));
#! 3
#! gap> Length(DirectedEdges(g));
#! 3
#! @EndExampleSession

#! @Arguments list, list
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a list of vertices and a list of edges, represented as pairs, this outputs the simple underlying graph with that vertex set and edge set.
DeclareOperation("GraphFromListOfEdges",[IsList,IsList]);
#! Here we build a complete graph on 4 vertices.
#! @BeginExampleSession
#! gap> g := GraphFromListOfEdges([1,2,3,4],[[1,2],[2,3],[3,1],[1,4],[2,4],[3,4]]);
#! rec( adjacencies := [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ], 
#!   group := Group(()), isGraph := true, isSimple := true, 
#!   names := [ 1, 2, 3, 4 ], order := 4, representatives := [ 1, 2, 3, 4 ], 
#!   schreierVector := [ -1, -2, -3, -4 ] )
#! gap> Length(Vertices(g));
#! 4
#! gap> Length(UndirectedEdges(g));
#! 6
#! @EndExampleSession

#! @Arguments group
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a group, assumed to be the connection group of a maniplex, this outputs the simple underlying flag graph.
DeclareOperation("UnlabeledFlagGraph",[IsGroup]);
#! Here we build the flag graph for the cube from its connection group.
#! @BeginExampleSession
#! gap> g := UnlabeledFlagGraph(ConnectionGroup(Cube(3)));;
#! gap> Length(Vertices(g));
#! 48
#! gap> Length(UndirectedEdges(g));
#! 72
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex, this outputs the simple underlying flag graph.
DeclareOperation("UnlabeledFlagGraph",[IsManiplex]);
#! Here we build the flag graph for the cube.
#! @BeginExampleSession
#! gap> g := UnlabeledFlagGraph(Cube(3));;
#! gap> Length(Vertices(g));
#! 48
#! gap> Length(UndirectedEdges(g));
#! 72
#! @EndExampleSession

#! @Arguments group
#! @Returns a triple [`IsGraph`, `IsList`, `IsList`].
#! @Description Given a group, assumed to be the connection group of a maniplex, this outputs a triple `[graph, edges, labels]`.
#! The graph is the unlabeled flag graph of the connection group.
#! The first list gives the undirected edges in the flag graph.
#! The second list gives the labels for these edges. The flag-graph labels are `0..r-1`, where `r` is the rank.
DeclareOperation("FlagGraphWithLabels",[IsGroup]);
#! Here we build the flag graph for the cube from its connection group, keeping track of the labels.
#! @BeginExampleSession
#! gap> f := FlagGraphWithLabels(ConnectionGroup(Cube(3)));;
#! gap> Length(Vertices(f[1]));
#! 48
#! gap> Length(f[2]);
#! 72
#! gap> Set(f[3]);
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns a triple [`IsGraph`, `IsList`, `IsList`].
#! @Description Given a maniplex, this outputs a triple `[graph, edges, labels]` containing the unlabeled flag graph, its edge list, and its labels. The flag-graph labels are `0..Rank(M)-1`.
DeclareOperation("FlagGraphWithLabels",[IsManiplex]);
#! Here we build the labeled flag graph data for the cube.
#! @BeginExampleSession
#! gap> f := FlagGraphWithLabels(Cube(3));;
#! gap> Length(Vertices(f[1]));
#! 48
#! gap> Set(f[3]);
#! [ 0, 1, 2 ]
#! @EndExampleSession

DeclareOperation("Vertices",[IsEdgeLabeledGraph]);
#DeclareOperation("Edges",[IsEdgeLabeledGraph]);
#DeclareOperation("Labels",[IsEdgeLabeledGraph]);
DeclareAttribute("LabeledEdges",IsEdgeLabeledGraph);

#! @Arguments group, int, int
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a group, assumed to be the connection group of a maniplex, and two ranks `i` and `j`, this outputs the simple graph whose vertices are the faces of ranks `i` and `j`, with edges recording incidence.
#! Note: There are no warnings yet to make sure that `i` and `j` are bounded by the rank.
DeclareOperation("LayerGraph",[IsGroup, IsInt, IsInt]);
#! Here we build the incidence graph of the 6 faces and 12 edges of a cube from its connection group.
#! @BeginExampleSession
#! gap> g := LayerGraph(ConnectionGroup(Cube(3)),2,1);;
#! gap> Length(Vertices(g));
#! 18
#! gap> Length(UndirectedEdges(g));
#! 24
#! @EndExampleSession

#! @Arguments maniplex, int, int
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex and two ranks `i` and `j`, this outputs the simple graph whose vertices are the faces of ranks `i` and `j`, with edges recording incidence.
DeclareOperation("LayerGraph",[IsManiplex, IsInt, IsInt]);
#! Here we build the incidence graph of the 6 faces and 12 edges of a cube.
#! @BeginExampleSession
#! gap> g := LayerGraph(Cube(3),2,1);
#! rec( adjacencies := [ [ 7, 9, 10, 14 ], [ 8, 10, 16, 17 ], [ 7, 12, 13, 18 ], 
#!       [ 9, 13, 15, 17 ], [ 8, 11, 12, 15 ], [ 11, 14, 16, 18 ], [ 1, 3 ], 
#!       [ 2, 5 ], [ 1, 4 ], [ 1, 2 ], [ 5, 6 ], [ 3, 5 ], [ 3, 4 ], [ 1, 6 ], 
#!       [ 4, 5 ], [ 2, 6 ], [ 2, 4 ], [ 3, 6 ] ], group := Group(()), 
#!   isGraph := true, isSimple := true, names := [ 1 .. 18 ], order := 18, 
#!   representatives := [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 
#!       17, 18 ], 
#!   schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, 
#!       -14, -15, -16, -17, -18 ] )
#! gap> Length(Vertices(g));
#! 18
#! gap> Length(UndirectedEdges(g));
#! 24
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex, this outputs the 0-1 skeleton. The vertices are the 0-faces, and the edges are the 1-faces.
DeclareOperation("Skeleton",[IsManiplex]);
#! Here we build the skeleton of the dodecahedron.
#! @BeginExampleSession
#! gap> g := Skeleton(Dodecahedron());;
#! gap> Length(Vertices(g));
#! 20
#! gap> Length(UndirectedEdges(g));
#! 30
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex, this outputs the `(n-1)`-`(n-2)` skeleton, i.e. the 0-1 skeleton of the dual. The vertices are the `(n-1)`-faces, and the edges are the `(n-2)`-faces.
DeclareOperation("CoSkeleton",[IsManiplex]);
#! Here we build the co-skeleton of the dodecahedron and check that it is isomorphic to the skeleton of the icosahedron.
#! @BeginExampleSession
#! gap> g := CoSkeleton(Dodecahedron());;
#! gap> Length(Vertices(g));
#! 12
#! gap> Length(UndirectedEdges(g));
#! 30
#! gap> IsIsomorphicGraph(g,Skeleton(Icosahedron()));
#! true
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns a record `rec(order, edges)`.
#! @Description Given a maniplex, this outputs the skeleton as an edge multiset. The record's `order` is the number of 0-faces (the vertices), and `edges` is a list of unordered pairs `[u,v]` of vertex numbers, one per 1-face. Unlike `Skeleton`, which returns the underlying simple graph, this preserves multiple edges (distinct 1-faces sharing the same pair of vertices) and loops (a 1-face whose two ends are the same vertex). The vertex numbering agrees with that of `Skeleton`.
DeclareOperation("SkeletonEdges",[IsManiplex]);
#! For the dodecahedron the skeleton is simple, so the multiset has no repeats and matches `Skeleton`.
#! @BeginExampleSession
#! gap> s := SkeletonEdges(Dodecahedron());;
#! gap> s.order;
#! 20
#! gap> Length(s.edges);
#! 30
#! gap> Length(Set(List(s.edges, Set)));
#! 30
#! gap> IsIsomorphicGraph(GraphFromListOfEdges([1..s.order], s.edges), Skeleton(Dodecahedron()));
#! true
#! @EndExampleSession
#! The hosohedron `{2,3}` has a skeleton with three parallel edges, which `Skeleton` collapses to one.
#! @BeginExampleSession
#! gap> s := SkeletonEdges(ReflexibleManiplex([2,3]));;
#! gap> s.order;
#! 2
#! gap> Length(s.edges);
#! 3
#! gap> Collected(List(s.edges, Set));
#! [ [ [ 1, 2 ], 3 ] ]
#! gap> Length(UndirectedEdges(Skeleton(ReflexibleManiplex([2,3]))));
#! 1
#! @EndExampleSession

#! @Arguments group
#! @Returns a record `rec(order, edges)`.
#! @Description Given a group, assumed to be the connection group of a maniplex, this outputs the skeleton edge multiset, as for the maniplex method above.
DeclareOperation("SkeletonEdges",[IsGroup]);

#! @Arguments maniplex
#! @Returns a record `rec(order, edges)`.
#! @Description Given a maniplex, this outputs the co-skeleton as an edge multiset, i.e. the skeleton edge multiset of the dual. The record's `order` is the number of `(n-1)`-faces, and `edges` is a list of unordered pairs of these, one per `(n-2)`-face. Like `SkeletonEdges`, this preserves multiple edges and loops, where `CoSkeleton` returns only the underlying simple graph.
DeclareOperation("CoSkeletonEdges",[IsManiplex]);
#! For the dodecahedron the co-skeleton is simple, so the multiset has no repeats and matches `CoSkeleton`.
#! @BeginExampleSession
#! gap> s := CoSkeletonEdges(Dodecahedron());;
#! gap> s.order;
#! 12
#! gap> Length(s.edges);
#! 30
#! gap> Length(Set(List(s.edges, Set)));
#! 30
#! @EndExampleSession
#! The co-skeleton of the dihedron `{3,2}` has three parallel edges, which `CoSkeleton` collapses to one.
#! @BeginExampleSession
#! gap> s := CoSkeletonEdges(ReflexibleManiplex([3,2]));;
#! gap> s.order;
#! 2
#! gap> Collected(List(s.edges, Set));
#! [ [ [ 1, 2 ], 3 ] ]
#! @EndExampleSession

#! @Arguments group
#! @Returns a record `rec(order, edges)`.
#! @Description Given a group, assumed to be the connection group of a maniplex, this outputs the co-skeleton edge multiset, as for the maniplex method above.
DeclareOperation("CoSkeletonEdges",[IsGroup]);

#! @Arguments maniplex
#! @Returns `IsGraph`. Note this returns a directed graph.
#! @Description Given a maniplex, this outputs its Hasse diagram as a directed graph.
#! Note: The unique minimal and maximal faces are assumed.
DeclareOperation("Hasse",[IsManiplex]);
#! Here we build the Hasse diagram of a 3-simplex.
#! @BeginExampleSession
#! gap> g := Hasse(Simplex(3));;
#! gap> Length(Vertices(g));
#! 16
#! gap> Length(DirectedEdges(g));
#! 32
#! @EndExampleSession

#! @Arguments object, list, list, list
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a graph, its edges, its edge labels, and a sublist of labels, this creates the underlying simple graph of the quotient identifying vertices connected by labels not in the sublist.
DeclareOperation("QuotientByLabel", [IsObject,IsList, IsList, IsList]);
#! Here we start with the flag graph of the 3-cube, whose edge labels are `0,1,2`, and identify vertices connected by labels other than `0`.
#! @BeginExampleSession
#! gap> f := FlagGraphWithLabels(Cube(3));;
#! gap> Q := QuotientByLabel(f[1],f[2],f[3],[0]);;
#! gap> Length(Vertices(Q));
#! 8
#! gap> Length(UndirectedEdges(Q));
#! 12
#! gap> IsBipartite(Q);
#! true
#! @EndExampleSession

DeclareAttribute("Verts", IsEdgeLabeledGraph);
DeclareAttribute("Edges", IsEdgeLabeledGraph);
DeclareAttribute("Labels", IsEdgeLabeledGraph);

#! @Arguments list, list, list
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a list of vertices, a list of edges, and a list of edge labels, this represents the edge-labeled multigraph with those parameters. Semi-edges are represented by singleton edge lists. Loops are represented by edges `[i,i]`.
DeclareOperation("EdgeLabeledGraphFromEdges",[IsList, IsList,IsList]);
#! Here we build an edge-labeled cycle graph with 6 vertices and edge labels alternating `0,1`.
#! @BeginExampleSession
#! gap> V := [1..6];;
#! gap> Ed := [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]];;
#! gap> L := [0,1,0,1,0,1];;
#! gap> gamma := EdgeLabeledGraphFromEdges(V,Ed,L);;
#! gap> Verts(gamma);
#! [ 1 .. 6 ]
#! gap> Labels(gamma);
#! [ 0, 1, 0, 1, 0, 1 ]
#! @EndExampleSession

#! @Arguments list
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a list of labeled edges, this represents the edge-labeled multigraph with those parameters. Each labeled edge is a pair `[edge,label]`. Semi-edges are represented by singleton edge lists.
DeclareOperation("EdgeLabeledGraphFromLabeledEdges",[IsList]);
#! @BeginExampleSession
#! gap> L := [[[1],0],[[2],0],[[1,2],1]];;
#! gap> gamma := EdgeLabeledGraphFromLabeledEdges(L);;
#! gap> Verts(gamma);
#! [ 1, 2 ]
#! gap> Labels(gamma);
#! [ 0, 0, 1 ]
#! @EndExampleSession

#! @Arguments group
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a group, assumed to be a connection group, this outputs the labeled flag graph. The input can also be a premaniplex; in that case the connection group is calculated first.
DeclareOperation("FlagGraph",[IsGroup]);
#! Here we build the flag graph of the 3-simplex from its connection group.
#! @BeginExampleSession
#! gap> gamma := FlagGraph(ConnectionGroup(Simplex(3)));;
#! gap> Length(Verts(gamma));
#! 24
#! gap> Length(Edges(gamma));
#! 36
#! gap> Set(Labels(gamma));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments premaniplex
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a premaniplex, this outputs its labeled flag graph.
DeclareOperation("FlagGraph",[IsPremaniplex]);
#! @BeginExampleSession
#! gap> gamma := FlagGraph(Simplex(3));;
#! gap> Length(Verts(gamma));
#! 24
#! gap> Set(Labels(gamma));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments edge-labeled-graph
#! @Returns `IsGraph`.
#! @Description Given an edge-labeled multigraph, this returns the underlying simple graph, with semi-edges, loops, and multiple edges removed.
DeclareOperation("UnlabeledSimpleGraph",[IsEdgeLabeledGraph]);
#! Here we build the underlying simple graph for the flag graph of the cube.
#! @BeginExampleSession
#! gap> g := UnlabeledSimpleGraph(FlagGraph(Cube(3)));;
#! gap> Length(Vertices(g));
#! 48
#! gap> Length(UndirectedEdges(g));
#! 72
#! @EndExampleSession

#! @Arguments edge-labeled-graph
#! @Returns `IsGroup`.
#! @Description Given an edge-labeled multigraph, this returns its automorphism group preserving the edge labels. This tends to be slow for large graphs.
DeclareOperation("EdgeLabelPreservingAutomorphismGroup",[IsEdgeLabeledGraph]);
#! Here we compute the label-preserving automorphism group of the flag graph of the 3-simplex.
#! @BeginExampleSession
#! gap> g := EdgeLabelPreservingAutomorphismGroup(FlagGraph(Simplex(3)));;
#! gap> Size(g);
#! 31104
#! @EndExampleSession

#! @Arguments edge-labeled-graph
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given an edge-labeled multigraph, this returns another edge-labeled graph where semi-edges, loops, and multiple edges are removed. If there are multiple edges, only the first edge label is retained.
DeclareOperation("Simple",[IsEdgeLabeledGraph]);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromLabeledEdges([[[1],0],[[1,1],1],[[1,2],2],[[1,2],3],[[2,3],0]]);;
#! gap> s := Simple(gamma);;
#! gap> Edges(s);
#! [ [ 1 ], [ 1, 1 ], [ 1, 2 ], [ 2, 3 ] ]
#! gap> Labels(s);
#! [ 0, 1, 2, 0 ]
#! @EndExampleSession

#! @Arguments edge-labeled-graph, list
#! @Returns `IsList`.
#! @Description Given an edge-labeled multigraph and a list of labels, this returns the connected components of the graph after removing edges whose labels are in the list. If the second argument is omitted, the empty list is used, so the connected components of the original graph are returned.
DeclareOperation("ConnectedComponents",[IsEdgeLabeledGraph, IsList]);
#! Here we remove edges of label `1` from the flag graph of the cube.
#! @BeginExampleSession
#! gap> comps := ConnectedComponents(FlagGraph(Cube(3)),[1]);;
#! gap> Length(comps);
#! 12
#! gap> Set(List(comps,Length));
#! [ 4 ]
#! @EndExampleSession

#! @Arguments edge-labeled-graph
#! @Returns `IsList`.
#! @Description Given an edge-labeled multigraph, this returns the connected components of the graph.
DeclareOperation("ConnectedComponents",[IsEdgeLabeledGraph]);
#! @BeginExampleSession
#! gap> Length(ConnectedComponents(FlagGraph(Cube(3))));
#! 1
#! @EndExampleSession

#! @Arguments group
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a permutation group, this returns the permutation representation graph for that group. When the group is a string C-group this is also called a CPR graph. The labels of the edges are `0..r-1`, where `r` is the number of generators of the group.
DeclareOperation("PRGraph",[IsGroup]);
#! Here we build the CPR graph of the automorphism group of a cube, acting on its 8 vertices.
#! @BeginExampleSession
#! gap> G := AutomorphismGroup(Cube(3));;
#! gap> H := Group(G.2,G.3);;
#! gap> phi := FactorCosetAction(G,H);;
#! gap> gamma := PRGraph(Range(phi));;
#! gap> Length(Verts(gamma));
#! 8
#! gap> Set(Labels(gamma));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments group, subgroup
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a group and a subgroup, this returns the graph of the action of the first group on cosets of the subgroup.
DeclareOperation("CPRGraphFromGroups",[IsGroup,IsGroup]);
#! @BeginExampleSession
#! gap> G := AutomorphismGroup(Cube(3));;
#! gap> H := Group(G.2,G.3);;
#! gap> gamma := CPRGraphFromGroups(G,H);;
#! gap> Length(Verts(gamma));
#! 8
#! gap> Set(Labels(gamma));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments EdgeLabeledGraph, vertex
#! @Returns `IsList`.
#! @Description Takes in an edge-labeled graph and a vertex, and outputs a list of the adjacent vertices.
 DeclareOperation("AdjacentVertices",[IsEdgeLabeledGraph, IsObject]);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
#! gap> AdjacentVertices(gamma,2);
#! [ 1, 3 ]
#! @EndExampleSession

#! @Arguments EdgeLabeledGraph, vertex
#! @Returns `IsList`.
#! @Description Takes in an edge-labeled graph and a vertex, and outputs two lists: the list of adjacent vertices, and the labels of the corresponding edges.
 DeclareOperation("LabeledAdjacentVertices",[IsEdgeLabeledGraph, IsObject]);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
#! gap> LabeledAdjacentVertices(gamma,2);
#! [ [ 1, 3 ], [ 0, 1 ] ]
#! @EndExampleSession

#! @Arguments EdgeLabeledGraph
#! @Returns `IsList`.
#! @Description Takes in an edge-labeled graph and outputs a list of semi-edges.
DeclareAttribute("SemiEdges",IsEdgeLabeledGraph);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
#! gap> SemiEdges(gamma);
#! [ [ 3 ], [ 1 ] ]
#! @EndExampleSession

#! @Arguments EdgeLabeledGraph
#! @Returns `IsList`.
#! @Description Takes in an edge-labeled graph and outputs two lists: the semi-edges and their labels.
DeclareAttribute("LabeledSemiEdges",IsEdgeLabeledGraph);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
#! gap> LabeledSemiEdges(gamma);
#! [ [ [ 3 ], [ 1 ] ], [ 2, 1 ] ]
#! @EndExampleSession

#! @Arguments EdgeLabeledGraph
#! @Returns `IsList`.
#! @Description Takes in an edge-labeled graph and outputs the labeled darts. Ordinary edges contribute two darts, while semi-edges contribute one.
DeclareAttribute("LabeledDarts",IsEdgeLabeledGraph);
#! @BeginExampleSession
#! gap> gamma := EdgeLabeledGraphFromEdges([1,2,3],[[1,2],[2,3],[3],[1]],[0,1,2,1]);;
#! gap> Length(LabeledDarts(gamma));
#! 6
#! @EndExampleSession

#! @Arguments list, list, list
#! @Returns `IsEdgeLabeledGraph`.
#! @Description Given a premaniplex, entered as its vertices and labeled darts, and a list of voltages, this returns the connected derived graph.
#! Careful, the order of our automorphisms may matter here.
DeclareOperation("DerivedGraph",[IsList,IsList,IsList]);
#! Here we build the flag graph of a 3-orbit polyhedron.
#! @BeginExampleSession
#! gap> V := [1,2,3];;
#! gap> Ed := [[1],[1],[1,2],[2],[2,3],[3],[3]];;
#! gap> L := [1,2,0,2,1,0,2];;
#! gap> base := EdgeLabeledGraphFromEdges(V,Ed,L);;
#! gap> darts := LabeledDarts(base);;
#! gap> volt := [ (1,2), (3,4), (), (), (3,4), (), (), (4,5), (2,3) ];;
#! gap> D := DerivedGraph(V,darts,volt);;
#! gap> Length(Verts(D));
#! 360
#! gap> Set(Labels(D));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments G, software_name
#! @Returns nothing.
#! @Description Given a Graph or EdgeLabeledGraph <A>G</A>, prints code to view the graph in other software. Currently Mathematica and Sage are supported. If the software is not specified it will print Mathematica code.
DeclareOperation("ViewGraph",[IsObject, IsString]);

#! @Arguments F
#! @Returns `IsPermGroup`
#! @Description Constructs the connection group from an edge-labeled graph. Loops, semi-edges, and non-edges give fixed points. The graph is assumed to come from a maniplex; other inputs may behave unexpectedly.
DeclareAttribute("ConnectionGroup", IsEdgeLabeledGraph);
#! @BeginExampleSession
#! gap> gamma := FlagGraph(Simplex(3));;
#! gap> G := ConnectionGroup(gamma);;
#! gap> Size(G);
#! 24
#! gap> Length(GeneratorsOfGroup(G));
#! 3
#! @EndExampleSession

# #! @Arguments M
# #! @Returns edgelabeledgraph
# #! @Description Returns the flag graph of a premaniplex <A>M</A>.
# DeclareOperation("FlagGraph",[IsPremaniplex]);
# #! @BeginExampleSession
# #! gap> STG3(4,1);;
# #!  gap> FlagGraph(last);
# #! Edge labeled graph with 3 vertices, and edge labels [ 0, 1, 2, 3 ]
# #! @EndExampleSession

#! @Arguments M
#! @Returns list
#! @Description Given a Premaniplex <A>M</A>, returns the list of labeled darts from its flag graph.
DeclareAttribute("LabeledDarts",IsPremaniplex);
#! @BeginExampleSession
#! gap> P := STG2(5,[2,4]);;
#! gap> Length(LabeledDarts(P));
#! 10
#! gap> Set(List(LabeledDarts(P),x -> x[2]));
#! [ 0, 1, 2, 3, 4 ]
#! @EndExampleSession

#! @Arguments M, label, startvert
#! @Returns list or `fail`
#! @Description Given a premaniplex <A>M</A>, a label, and a start vertex, returns the labeled dart with that label and initial vertex when it exists, and `fail` otherwise.
DeclareOperation("LabeledDart",[IsPremaniplex, IsInt,IsInt]);
#! @BeginExampleSession
#! gap> P := STG2(5,[2,4]);;
#! gap> LabeledDart(P,1,1);
#! [ [ 1, 2 ], 1 ]
#! gap> LabeledDart(P,1,0);
#! fail
#! @EndExampleSession
