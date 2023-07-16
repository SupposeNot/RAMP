

#! @Chapter Graphs for Maniplexes
#! @Section Graph constructors for maniplexes

#! Note that this functionality depends on the functionality of the GRAPE package.

#! @Arguments list, list
#! @Returns `IsGraph`. Note this returns a directed graph.
#! @Description Given a list of vertices and a list of directed-edges (represented as ordered pairs), this outputs the directed graph with the appropriate vertex and directed-edge set.
DeclareOperation("DirectedGraphFromListOfEdges",[IsList,IsList]);
#! Here we have a directed cycle on 3 vertices.
#! @BeginExampleSession
#! gap> g:= DirectedGraphFromListOfEdges([1,2,3],[[1,2],[2,3],[3,1]]);
#! rec( adjacencies := [ [ 2 ], [ 3 ], [ 1 ] ], group := Group(()), 
#!  isGraph := true, names := [ 1, 2, 3 ], order := 3, 
#!  representatives := [ 1, 2, 3 ], schreierVector := [ -1, -2, -3 ] )
#! @EndExampleSession




#! @Arguments list, list
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a list of vertices and a list of (directed) edges (represented as ordered pairs), this outputs the simple underlying graph with the appropriate vertex and directed-edge set.
DeclareOperation("GraphFromListOfEdges",[IsList,IsList]);
#! Here we have a simple complete graph on 4 vertices.
#! @BeginExampleSession
#! gap> g:= GraphFromListOfEdges([1,2,3,4],[[1,2],[2,3],[3,1], [1,4], [2,4], [3,4]]);
#! rec( 
#!  adjacencies := [ [ 2, 3, 4 ], [ 1, 3, 4 ], [ 1, 2, 4 ], [ 1, 2, 3 ] ],
#!  group := Group(()), isGraph := true, isSimple := true, 
#!  names := [ 1, 2, 3, 4 ], order := 4, representatives := [ 1, 2, 3, 4 ]
#!    , schreierVector := [ -1, -2, -3, -4 ] )
#! @EndExampleSession




#! @Arguments group
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a group (assumed to be the connection group of a maniplex), this outputs the simple underlying flag graph.
DeclareOperation("UnlabeledFlagGraph",[IsGroup]);
#! Here we build the flag graph for the cube from its connection group.
#! @BeginExampleSession
#! gap> g:= UnlabeledFlagGraph(ConnectionGroup(Cube(3)));
#! rec( 
#!  adjacencies := [ [ 3, 11, 20 ], [ 7, 13, 18 ], [ 1, 4, 10 ], 
#!      [ 3, 25, 34 ], [ 26, 28, 35 ], [ 7, 13, 41 ], [ 2, 6, 8 ], 
#!      [ 7, 27, 32 ], [ 28, 33, 35 ], [ 3, 20, 45 ], [ 1, 14, 23 ], 
#!      [ 15, 17, 24 ], [ 2, 6, 31 ], [ 11, 25, 44 ], [ 12, 45, 47 ], 
#!      [ 18, 28, 40 ], [ 12, 19, 27 ], [ 2, 16, 21 ], [ 17, 22, 24 ], 
#!      [ 1, 10, 38 ], [ 18, 32, 40 ], [ 19, 41, 48 ], [ 11, 35, 44 ], 
#!      [ 12, 19, 34 ], [ 4, 14, 37 ], [ 5, 38, 42 ], [ 8, 17, 30 ], 
#!      [ 5, 9, 16 ], [ 39, 41, 48 ], [ 27, 32, 47 ], [ 13, 33, 39 ], 
#!      [ 8, 21, 30 ], [ 9, 31, 46 ], [ 4, 24, 37 ], [ 5, 9, 23 ], 
#!      [ 43, 45, 47 ], [ 25, 34, 48 ], [ 20, 26, 43 ], [ 29, 31, 46 ], 
#!      [ 16, 21, 42 ], [ 6, 22, 29 ], [ 26, 40, 43 ], [ 36, 38, 42 ], 
#!      [ 14, 23, 46 ], [ 10, 15, 36 ], [ 33, 39, 44 ], [ 15, 30, 36 ], 
#!      [ 22, 29, 37 ] ], group := Group(()), isGraph := true, 
#!  isSimple := true, names := [ 1 .. 48 ], order := 48, 
#!  representatives := [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 
#!      15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 
#!      31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 
#!      47, 48 ], 
#!  schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, 
#!      -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, -24, 
#!      -25, -26, -27, -28, -29, -30, -31, -32, -33, -34, -35, -36, -37, 
#!      -38, -39, -40, -41, -42, -43, -44, -45, -46, -47, -48 ] )
#! @EndExampleSession



#! This also works with a maniplex input. 

DeclareOperation("UnlabeledFlagGraph",[IsManiplex]);

#! Here we build the flag graph for the cube.
#! @BeginExampleSession
#! gap> g:= UnlabeledFlagGraph(Cube(3));
#! @EndExampleSession



#! @Arguments group
#! @Returns a triple [`IsGraph`, `IsList`, `IsList`]. 
#! @Description Given a group (assumed to be the connection group of a maniplex), this outputs a triple [graph,list,list].
#! The graph is the unlabeled flag graph of the connection group.  
#! The first list gives the undirected edges in the flag graphs.  
#! The second list gives the labels for these edges.
DeclareOperation("FlagGraphWithLabels",[IsGroup]);
#! Here we again build the flag graph for the cube from its connection group, but this time keep track of labels of the edges.
#! @BeginExampleSession
#! gap> g:= FlagGraphWithLabels(ConnectionGroup(Cube(3)));
#! [ rec( 
#!      adjacencies := [ [ 3, 11, 20 ], [ 7, 13, 18 ], [ 1, 4, 10 ], 
#!          [ 3, 25, 34 ], [ 26, 28, 35 ], [ 7, 13, 41 ], [ 2, 6, 8 ], 
#!          [ 7, 27, 32 ], [ 28, 33, 35 ], [ 3, 20, 45 ], [ 1, 14, 23 ], 
#!          [ 15, 17, 24 ], [ 2, 6, 31 ], [ 11, 25, 44 ], [ 12, 45, 47 ], 
#!          [ 18, 28, 40 ], [ 12, 19, 27 ], [ 2, 16, 21 ], 
#!          [ 17, 22, 24 ], [ 1, 10, 38 ], [ 18, 32, 40 ], 
#!          [ 19, 41, 48 ], [ 11, 35, 44 ], [ 12, 19, 34 ], 
#!          [ 4, 14, 37 ], [ 5, 38, 42 ], [ 8, 17, 30 ], [ 5, 9, 16 ], 
#!          [ 39, 41, 48 ], [ 27, 32, 47 ], [ 13, 33, 39 ], 
#!          [ 8, 21, 30 ], [ 9, 31, 46 ], [ 4, 24, 37 ], [ 5, 9, 23 ], 
#!          [ 43, 45, 47 ], [ 25, 34, 48 ], [ 20, 26, 43 ], 
#!          [ 29, 31, 46 ], [ 16, 21, 42 ], [ 6, 22, 29 ], 
#!          [ 26, 40, 43 ], [ 36, 38, 42 ], [ 14, 23, 46 ], 
#!          [ 10, 15, 36 ], [ 33, 39, 44 ], [ 15, 30, 36 ], 
#!          [ 22, 29, 37 ] ], group := Group(()), isGraph := true, 
#!      isSimple := true, names := [ 1 .. 48 ], order := 48, 
#!      representatives := [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 
#!          14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 
#!          29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 
#!          44, 45, 46, 47, 48 ], 
#!      schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, 
#!          -12, -13, -14, -15, -16, -17, -18, -19, -20, -21, -22, -23, 
#!          -24, -25, -26, -27, -28, -29, -30, -31, -32, -33, -34, -35, 
#!          -36, -37, -38, -39, -40, -41, -42, -43, -44, -45, -46, -47, 
#!          -48 ] ), 
#!  [ [ 1, 3 ], [ 1, 11 ], [ 1, 20 ], [ 2, 7 ], [ 2, 13 ], [ 2, 18 ], 
#!      [ 3, 4 ], [ 3, 10 ], [ 4, 25 ], [ 4, 34 ], [ 5, 26 ], [ 5, 28 ], 
#!      [ 5, 35 ], [ 6, 7 ], [ 6, 13 ], [ 6, 41 ], [ 7, 8 ], [ 8, 27 ], 
#!      [ 8, 32 ], [ 9, 28 ], [ 9, 33 ], [ 9, 35 ], [ 10, 20 ], 
#!      [ 10, 45 ], [ 11, 14 ], [ 11, 23 ], [ 12, 15 ], [ 12, 17 ], 
#!      [ 12, 24 ], [ 13, 31 ], [ 14, 25 ], [ 14, 44 ], [ 15, 45 ], 
#!      [ 15, 47 ], [ 16, 18 ], [ 16, 28 ], [ 16, 40 ], [ 17, 19 ], 
#!      [ 17, 27 ], [ 18, 21 ], [ 19, 22 ], [ 19, 24 ], [ 20, 38 ], 
#!      [ 21, 32 ], [ 21, 40 ], [ 22, 41 ], [ 22, 48 ], [ 23, 35 ], 
#!      [ 23, 44 ], [ 24, 34 ], [ 25, 37 ], [ 26, 38 ], [ 26, 42 ], 
#!      [ 27, 30 ], [ 29, 39 ], [ 29, 41 ], [ 29, 48 ], [ 30, 32 ], 
#!      [ 30, 47 ], [ 31, 33 ], [ 31, 39 ], [ 33, 46 ], [ 34, 37 ], 
#!      [ 36, 43 ], [ 36, 45 ], [ 36, 47 ], [ 37, 48 ], [ 38, 43 ], 
#!      [ 39, 46 ], [ 40, 42 ], [ 42, 43 ], [ 44, 46 ] ], 
#!  [ 3, 2, 1, 3, 1, 2, 2, 1, 3, 1, 2, 3, 1, 1, 3, 2, 2, 1, 3, 1, 2, 3, 
#!      3, 2, 3, 1, 2, 3, 1, 2, 2, 1, 1, 3, 1, 2, 3, 1, 2, 3, 2, 3, 2, 2, 
#!      1, 1, 3, 2, 3, 2, 1, 1, 3, 3, 2, 3, 1, 1, 2, 1, 3, 3, 3, 2, 3, 1, 
#!      2, 3, 1, 2, 1, 2 ] ]
#! @EndExampleSession


#! This also works with a maniplex input. 

DeclareOperation("FlagGraphWithLabels",[IsManiplex]);

#! Here we build the flag graph for the cube.
#! @BeginExampleSession
#! gap> g:= FlagGraphWithLabels(Cube(3));
#! @EndExampleSession


DeclareOperation("Vertices",[IsEdgeLabeledGraph]);
#DeclareOperation("Edges",[IsEdgeLabeledGraph]);
#DeclareOperation("Labels",[IsEdgeLabeledGraph]);
DeclareAttribute("LabeledEdges",IsEdgeLabeledGraph);



#! @Arguments [group, int, int]
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a group (assumed to be the connection group of a maniplex), and two integers, this outputs the simple underlying graph given by incidences of faces of those ranks.
#! Note: There are no warnings yet to make sure that i,j are bounded by the rank.
DeclareOperation("LayerGraph",[IsGroup, IsInt, IsInt]);

#! Here we build the graph given by the 6 faces and 12 edges of a cube from its connection group.
#! @BeginExampleSession
#! gap> g:= LayerGraph(ConnectionGroup(Cube(3)),2,1);
#! rec( 
#!  adjacencies := [ [ 7, 10, 12, 17 ], [ 8, 10, 15, 18 ], 
#!      [ 7, 9, 13, 14 ], [ 8, 11, 13, 16 ], [ 9, 12, 16, 18 ], 
#!      [ 11, 14, 15, 17 ], [ 1, 3 ], [ 2, 4 ], [ 3, 5 ], [ 1, 2 ], 
#!      [ 4, 6 ], [ 1, 5 ], [ 3, 4 ], [ 3, 6 ], [ 2, 6 ], [ 4, 5 ], 
#!      [ 1, 6 ], [ 2, 5 ] ], group := Group(()), isGraph := true, 
#!  isSimple := true, names := [ 1 .. 18 ], order := 18, 
#!  representatives := [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 
#!      15, 16, 17, 18 ], 
#!  schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, 
#!      -12, -13, -14, -15, -16, -17, -18 ] )
#! @EndExampleSession



#! This also works with a maniplex  input. 

DeclareOperation("LayerGraph",[IsManiplex, IsInt, IsInt]);

#! Here we build the graph given by the 6 faces and 12 edges of a cube.
#! @BeginExampleSession
#! gap> g:= LayerGraph(Cube(3),2,1);;
#! @EndExampleSession



#! @Arguments maniplex 
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex, this outputs the 0-1 skeleton.   The vertices are the 0-faces, and the edges are the 1-faces.
DeclareOperation("Skeleton",[IsManiplex]);
#! Here we build the skeleton of the dodecahedron.
#! @BeginExampleSession
#! gap> g:= Skeleton(Dodecahedron());;
#! @EndExampleSession


#! @Arguments maniplex 
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a maniplex, this outputs the $(n-1)$-$(n-2)$ skeleton, i.e., the 0-1 skeleton of the dual.   The vertices are the $(n-1)$-faces, and the edges are the $(n-2)$-faces.
DeclareOperation("CoSkeleton",[IsManiplex]);
#! Here we build the co-skeleton of the dodecahedron and verify that it is the skeleton of the icosahedron.
#! @BeginExampleSession
#! gap> g:=CoSkeleton(Dodecahedron());;
#! gap> h:=Skeleton(Icosahedron());;
#! gap> g=h;
#! true
#! @EndExampleSession


#! @Arguments group
#! @Returns `IsGraph`. Note this returns a directed graph.
#! @Description Given a group, assumed to be the connection group of a maniplex, this outputs the Hasse Diagram as a directed graph.  
#! Note: The unique minimal and maximal face are assumed.
DeclareOperation("Hasse",[IsManiplex]);
#! Here we build the Hasse Diagram of a 3-simplex from its representation as a maniplex.
#! @BeginExampleSession
#! gap> Hasse(Simplex(3));
#! rec( 
#!  adjacencies := [ [  ], [ 1 ], [ 1 ], [ 1 ], [ 1 ], [ 2, 4 ], 
#!      [ 2, 3 ], [ 3, 5 ], [ 2, 5 ], [ 4, 5 ], [ 3, 4 ], [ 6, 9, 10 ], 
#!      [ 6, 7, 11 ], [ 8, 10, 11 ], [ 7, 8, 9 ], [ 12, 13, 14, 15 ] ], 
#!  group := Group(()), isGraph := true, names := [ 1 .. 16 ], 
#!  order := 16, 
#!  representatives := [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 
#!      15, 16 ], 
#!  schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, 
#!      -12, -13, -14, -15, -16 ] )
#! @EndExampleSession


#! @Arguments object,list, list, list
#! @Returns `IsGraph`. Note this returns an undirected graph.
#! @Description Given a graph, its edges, and its edge labels, and a sublist of labels, this creates the underlying simple graph of the quotient identifying vertices connected by labels not in the sublist.
DeclareOperation("QuotientByLabel", [IsObject,IsList, IsList, IsList]);
#! Here we start with the flag graph of the 3-cube (with edge labels 1,2,3), and identify any vertices not connected by edge by edges of label 1.   We can then check that this new graph is bipartite. 
#! @BeginExampleSession
#! gap> P:=Cube(3);;
#! gap> f:=FlagGraphWithLabels(P);;
#! gap> g:=f[1];;
#! gap> ed:=f[2];;
#! gap> lab:=f[3];  #Note This triple is to be replace by a single object.
#! [ 3, 2, 1, 3, 1, 2, 1, 2, 3, 2, 1, 3, 2, 1, 1, 3, 2, 2, 3, 1, 3, 1, 2, 3, 2, 1, 1, 2, 2, 3, 1, 3, 1, 2, 
#!   3, 1, 2, 1, 3, 2, 2, 1, 2, 2, 3, 1, 1, 3, 1, 3, 3, 2, 1, 2, 1, 3, 3, 1, 3, 2, 2, 2, 2, 3, 3, 1, 3, 1, 1, 3, 2, 3 ]
#! gap> Q:=QuotientByLabel(g,ed,lab,[1]);
#!rec( adjacencies := [ [ 5, 6, 8 ], [ 3, 4, 7 ], [ 2, 6, 8 ], [ 2, 5, 8 ], [ 1, 4, 7 ], [ 1, 3, 7 ], [ 2, 5, 6 ], [ 1, 3, 4 ] ], group := Group(()), isGraph := true, 
#!  isSimple := true, names := [ 1 .. 8 ], order := 8, representatives := [ 1, 2, 3, 4, 5, 6, 7, 8 ], schreierVector := [ -1, -2, -3, -4, -5, -6, -7, -8 ] )
#! gap> IsBipartite(Q);
#! true
#! @EndExampleSession


DeclareAttribute("Verts", IsEdgeLabeledGraph);
DeclareAttribute("Edges", IsEdgeLabeledGraph);
DeclareAttribute("Labels", IsEdgeLabeledGraph);

#! @Arguments list, list, list
#! @Returns `IsEdgeLabeledGraph`. 
#! @Description Given a list of vertices, a list of edges, and a list of edge labels, this represents the edge labeled (multi)-graph with those parameters.   Semi-edges are represented by a singleton in the edge list.  Loops are represented by edges [i,i]
DeclareOperation("EdgeLabeledGraphFromEdges",[IsList, IsList,IsList]);
#! Here we have an edge labeled cycle graph with 6 vertices and edges alternating in labels 0,1.
#! @BeginExampleSession
#! V:=[1..6];;
#! Edges:=[[1,2],[2,3],[3,4],[4,5],[5,6],[6,1]];;
#! L:=[0,1,0,1,0,1];;
#! gamma:=EdgeLabeledGraphFromEdges(V,Edges,L);
#! @EndExampleSession





#! @Arguments list
#! @Returns `IsEdgeLabeledGraph`. 
#! @Description Given a list of labeled edges this represents the edge labeled (multi)-graph with those parameters.   Semi-edges are represented by a singleton in the edge list.  
DeclareOperation("EdgeLabeledGraphFromLabeledEdges",[IsList]);
#! @BeginExampleSession
#! L:=[[[1],0],[[2],0],  [ [1,2],1]];;
#! X2:=EdgeLabeledGraphFromLabeledEdges(L);
#! @EndExampleSession



#! @Arguments group
#! @Returns `IsEdgeLabeledGraph`. 
#! @Description Given group, assumed to be a connection group, output the labeled flag graph.  The input could also be a premaniplex, then the connection group is calculated.
DeclareOperation("FlagGraph",[IsGroup]);
#! Here we have the flag graph of the 3-simplex from its connection group.  
#! @BeginExampleSession
#! gap> C:=ConnectionGroup(Simplex(3));;
#! gap> gamma:=FlagGraph(C);
#! Edge labeled graph with 24 vertices, and edge labels [ 0, 1, 2 ]
#! gap> STG3(4,1);;
#! gap> FlagGraph(last);
#! Edge labeled graph with 3 vertices, and edge labels [ 0, 1, 2, 3 ]
#! @EndExampleSession

DeclareOperation("FlagGraph",[IsPremaniplex]);


#! @Arguments edge-labeled-graph
#! @Returns `IsGraph`. 
#! @Description Given an edge labeled (multi) graph, it returns the underlying simple graph, with semi-edges, loops, and muliple-edges removed.
DeclareOperation("UnlabeledSimpleGraph",[IsEdgeLabeledGraph]);
#! Here we have underlying simple graph for the flag graph of the cube. 
#! @BeginExampleSession
#! gamma:=UnlabeledSimpleGraph(FlagGraph(Cube(3)));
#! @EndExampleSession


#! @Arguments edge-labeled-graph
#! @Returns `IsGroup`. 
#! @Description Given an edge labeled (multi) graph, it returns automorphism group (preserving the labels).  Note, for now the labels are assumed to be [1..n].
#! Note This tends to be very slow.  I would like to look for a way to go back and forth between flag automorphisms and poset automorphisms, as the latter are much faster to compute.
DeclareOperation("EdgeLabelPreservingAutomorphismGroup",[IsEdgeLabeledGraph]);
#! Here we have the automorphism group of the flag graph of the cube.
#! @BeginExampleSession
#! g:=EdgeLabelPreservingAutomorphismGroup(FlagGraph(Cube(3)));;
#! Size(g);
#! @EndExampleSession



#! @Arguments edge-labeled-graph
#! @Returns `IsEdgeLabeledGraph `. 
#! @Description Given an edge labeled (multi) graph, it returns another edge labeled graph where semi-edges, loops, and multiple edges are removed.  Note only the "first" edge label is retained if there are multiple edges.
DeclareOperation("Simple",[IsEdgeLabeledGraph]);






#! @Arguments edge-labeled-graph
#! @Returns `IsGraph`. 
#! @Description Given an edge labeled (multi) graph and a list of labels, it returns connected components of the graph not using edges in the list of labels. Note if the second argument is not used, it is assumed to be an empty list, and the connected components of the original graph are returned.
DeclareOperation("ConnectedComponents",[IsEdgeLabeledGraph, IsList]);
#! Here we see that each connected component of the flag graph of the cube (which has labels 1,2,3) where edges of label 2 are removed, is a 4 cycle.
#! @BeginExampleSession
#! gamma:=ConnectedComponents(FlagGraph(Cube(3)),[2]);
#! @EndExampleSession

DeclareOperation("ConnectedComponents",[IsEdgeLabeledGraph]);


#! @Arguments group
#! @Returns `IsEdgeLabeledGraph `. 
#! @Description Given a group, it returns the permutation representation graph for that group.  When the group is a string C-group this is also called a CPR graph.  The labels of the edges are [1...r] where r is the number of generators of the group.
DeclareOperation("PRGraph",[IsGroup]);
#! Here we see the CPR graph of the automorphism group of a cube (acting on its 8 vertices).
#! @BeginExampleSession
#! G:=AutomorphismGroup(Cube(3));
#! H:=Group(G.2,G.3);
#! phi:=FactorCosetAction(G,H);
#! G2:=Range(phi);
#! gamma:=PRGraph(G2);
#! @EndExampleSession


#! @Arguments group, subgroup
#! @Returns `IsEdgeLabeledGraph`. 
#! @Description Given a group and a subgroup.  Returns the graph of the action of the first group on cosets of the subgroup.
DeclareOperation("CPRGraphFromGroups",[IsGroup,IsGroup]);




#! @Arguments EdgeLabeledGraph, vertex
#! @Returns `IsList`. 
#! @Description Takes in an edge labeled graph and a vertex, and outputs a list of the adjacent vertices.
 DeclareOperation("AdjacentVertices",[IsEdgeLabeledGraph, IsObject]);




#! @Arguments EdgeLabeledGraph, vertex
#! @Returns `IsList, IsList`. 
#! @Description Takes in an edge labeled graph and a vertex, and outputs two lists: the list of adjacent vertices, and the labels of the corresponding edges.
 DeclareOperation("LabeledAdjacentVertices",[IsEdgeLabeledGraph, IsObject]);

#! @Arguments EdgeLabeledGraph
#! @Returns `IsList`. 
#! @Description Takes in an edge labeled graph and a vertex, and outputs a list of semiedges
DeclareAttribute("SemiEdges",IsEdgeLabeledGraph);


#! @Arguments EdgeLabeledGraph
#! @Returns `IsList, IsList`. 
#! @Description Takes in an edge labeled graph and a vertex, and outputs two lists: SemiEdges and their labels
DeclareAttribute("LabeledSemiEdges",IsEdgeLabeledGraph);


#! @Arguments EdgeLabeledGraph
#! @Returns `IsList`. 
#! @Description Takes in an edge labeled graph and outputs the labeled darts.
DeclareAttribute("LabeledDarts",IsEdgeLabeledGraph);

#! @Arguments list, list, list
#! @Returns `IsEdgeLabeledGraph`. 
#! @Description Given a a pre-maniplex 
#! (entered as its vertices and labeled darts) and voltages
#! Return the connected derived graph from a pre-maniplex 
#! Careful, the order of our automorphisms.  Do we want them on left or right? Does it matter?
#! Can make another version with non-connected results, where the group is also an input
DeclareOperation("DerivedGraph",[IsList,IsList,IsList]);
#! Here we can build the flag graph of a 3-orbit polyhedron.
#! @BeginExampleSession
#! gap> V:=[1,2,3];;
#! gap> Ed:=[[1],[1],[1,2],[2],[2,3],[3],[3]];;
#! gap> L:=[1,2,0,2,1,0,2];;
#! gap> g:=EdgeLabeledGraphFromEdges(V,Ed,L);;
#! gap> L:=LabeledDarts(g);;
#! gap> volt:=[ (1,2), (3,4), (), (), (3,4), (), (), (4,5), (2,3) ];;
#! gap> D:=DerivedGraph(V,L,volt);
#! Edge labeled graph with 360 vertices, and edge labels [ 0, 1, 2 ]
#! @EndExampleSession



#! @Arguments G, software_name
#! @Returns `IsString`. 
#! @Description Given a Graph or EdgeLabeledGraph <A>G</A>, outputs code to view the graph in other software.
#! Currently Mathematica and Sage are supported. If the software is not specified it will return the code for Mathematica.
DeclareOperation("ViewGraph",[IsObject, IsString]);



#! @Arguments F
#! @Returns `IsPermGroup`
#! @Description Constructs the connection group from an edge labeled graph.
#! Loops, semi-edges, and non-edges give fixed points.
#! Graph is assumed to be coming from a maniplex.  Some weird things could happen if it is not
DeclareAttribute("ConnectionGroup", IsEdgeLabeledGraph);

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
#! gap> P:=STG2(5,[2,4]);;
#! gap> LabeledDarts(P);
#! [ [ [ 1, 2 ], 0 ], [ [ 2, 1 ], 0 ], [ [ 1, 2 ], 1 ], [ [ 2, 1 ], 1 ], [ [ 1 ], 2 ], [ [ 1, 2 ], 3 ], [ [ 2, 1 ], 3 ], [ [ 1 ], 4 ], [ [ 2 ], 2 ], [ [ 2 ], 4 ] ]
#! @EndExampleSession


DeclareOperation("LabeledDart",[IsPremaniplex, IsInt,IsInt]);

