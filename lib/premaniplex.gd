

#! @Chapter Graphs for Premaniplexes
#! @Section Constructors of Premaniplexes

#! @Arguments group
#! @Returns `IsPremaniplex`. 
#! @Description Given a group we return the premaniplex with that group as its connection group.  
#! This function first checks whether <A>group</A> is an Sggi. Use `PremaniplexNC` to
#! bypass that check.
DeclareOperation("Premaniplex",[IsGroup]);
#! Here we build a premaniplex with 3 flags.
#! @BeginExampleSession
#! gap> g:=Group((1,2),(2,3),(1,2));;
#! gap> Premaniplex(g);
#! Premaniplex of rank 3 with 3 flags
#! @EndExampleSession

DeclareOperation("PremaniplexNC",[IsGroup]);



#! @Arguments edgelabeledgraph
#! @Returns `IsPremaniplex`. 
#! @Description Given an edge labeled graph we return the premaniplex with for that graph.  
#! Note: We will assume (but not check) that the graph is a premaniplex, that is to say, we are assumging each vertex is incident with one edge of each label.
DeclareOperation("Premaniplex",[IsEdgeLabeledGraph]);
#! Here we have a premaniplex with 2 flags.
#! @BeginExampleSession
#! gap> gap> L:=[[[1,2],0], [[1,2],1], [[1],2], [[2],2]];;
#! gap> F:=EdgeLabeledGraphFromLabeledEdges(L);;
#! gap> Premaniplex(F);
#! Premaniplex of rank 3 with 2 flags
#! @EndExampleSession

#! @Arguments int
#! @Returns premaniplex
#! @Description Builds the 1 flag premaniplex of rank n
#! Note See VOLTAGE OPERATIONS ON MANIPLEXES
DeclareOperation("STG1",[IsInt]);
#! @BeginExampleSession
#! gap> STG1(5);
#! Premaniplex of rank 5 with 1 flag
#! @EndExampleSession


#! @Arguments int, list
#! @Returns premaniplex
#! @Description Builds the 2 flag premaniplex of rank n with semi-edges in I
#! Note See VOLTAGE OPERATIONS ON MANIPLEXES
DeclareOperation("STG2",[IsInt,IsList]);
#! @BeginExampleSession
#! gap> STG2(5,[2,4]);
#! Premaniplex of rank 5 with 2 flags
#! @EndExampleSession


#! @Arguments int, int
#! @Returns premaniplex
#! @Description Builds the 3 flag premaniplex of rank n described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes.  There are edges of label i-1 and i+1 are parallel.
DeclareOperation("STG3",[IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(5,2);
#! Premaniplex of rank 5 with 3 flags
#! @EndExampleSession


#! @Arguments int, int, int
#! @Returns premaniplex
#! @Description Assumes j=i+1 and builds the 3 flag premaniplex of rank n described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes.  There are edges of label i and j.
DeclareOperation("STG3",[IsInt,IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(6,2,3);
#! Premaniplex of rank 6 with 3 flags
#! @EndExampleSession


# #! @Arguments premaniplex
# #! @Returns edgelabeledgraph
# #! @Description Returns the flag graph of a premaniplex
# DeclareOperation("FlagGraph",[IsPremaniplex]);
# #! @BeginExampleSession
# #! gap> STG3(4,1);;
# #!  gap> FlagGraph(last);
# #! Edge labeled graph with 3 vertices, and edge labels [ 0, 1, 2, 3 ]
# #! @EndExampleSession

