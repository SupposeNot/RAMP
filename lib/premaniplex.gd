

#! @Chapter Graphs for Premaniplexes
#! @Section Constructors of Premaniplexes

#! @Arguments group
#! @Returns `IsPremaniplex`. 
#! @Description Given a group we return the premaniplex with that group as its connection group.  
#! Note: We will assume (but not check) that the group is an sggi.    
DeclareOperation("Premaniplex",[IsGroup]);
#! Here we build a premaniplex with 3 flags.
#! @BeginExampleSession
#! gap> g:=Group((1,2),(2,3),(1,2));;
#! gap> Premaniplex(g);
#! Premaniplex of rank 3 with 3 flags
#! @EndExampleSession




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