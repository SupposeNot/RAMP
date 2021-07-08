# Dealing with graphs from maniplexes
#! @Chapter Graphs for Maniplexes
#! @Section Graphs for maniplexes functions

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
