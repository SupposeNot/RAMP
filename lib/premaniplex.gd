

#! @Chapter Graphs for Premaniplexes
#! @Section Constructors of Premaniplexes

#! @Arguments g
#! @Returns `IsPremaniplex`. 
#! @Description Given a group <A>g</A> we return the premaniplex with connection group <A>g</A>.  
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



#! @Arguments G
#! @Returns `IsPremaniplex`. 
#! @Description Given an edge labeled graph <A>G</A> we return the premaniplex with that graph.  
#! Note: We will assume (but not check) that the graph is a premaniplex, that is to say, we are assumging each vertex is incident with one edge of each label.
DeclareOperation("Premaniplex",[IsEdgeLabeledGraph]);
#! Here we have a premaniplex with 2 flags.
#! @BeginExampleSession
#! gap> gap> L:=[[[1,2],0], [[1,2],1], [[1],2], [[2],2]];;
#! gap> F:=EdgeLabeledGraphFromLabeledEdges(L);;
#! gap> Premaniplex(F);
#! Premaniplex of rank 3 with 2 flags
#! @EndExampleSession

#! @Arguments n
#! @Returns premaniplex
#! @Description Builds the 1 flag premaniplex of rank <A>n</A>.
#! See VOLTAGE OPERATIONS ON MANIPLEXES (citation coming soon).
DeclareOperation("STG1",[IsInt]);
#! @BeginExampleSession
#! gap> STG1(5);
#! Premaniplex of rank 5 with 1 flag
#! @EndExampleSession


#! @Arguments n, I
#! @Returns premaniplex
#! @Description Builds the 2 flag premaniplex of rank <A>n</A> with semi-edges in <A>I</A>.
#! See VOLTAGE OPERATIONS ON MANIPLEXES (citation coming soon).
DeclareOperation("STG2",[IsInt,IsList]);
#! @BeginExampleSession
#! gap> STG2(5,[2,4]);
#! Premaniplex of rank 5 with 2 flags
#! @EndExampleSession


#! @Arguments n, i
#! @Returns premaniplex
#! @Description Builds the 3 flag premaniplex of rank <A>n</A> described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes <Cite Key="CDHT15"/> (<URL>https://doi.org/10.1007/s00026-015-0263-z</URL>). The edges of label i-1 and i+1 are parallel.
DeclareOperation("STG3",[IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(5,2);
#! Premaniplex of rank 5 with 3 flags
#! @EndExampleSession


#! @Arguments n, i, j
#! @Returns premaniplex
#! @Description Assumes `j=i+1` and builds the 3 flag premaniplex of rank <A>n</A> described on Page 11 of Symmetry Type Graphs of Polytopes and Maniplexes <Cite Key="CDHT15"/> (<URL>https://doi.org/10.1007/s00026-015-0263-z</URL>). There are edges of label <A>i</A> and <A>j</A>.
DeclareOperation("STG3",[IsInt,IsInt,IsInt]);
#! @BeginExampleSession
#! gap> STG3(6,2,3);
#! Premaniplex of rank 6 with 3 flags
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
#! gap> P:=STG2(5,[2,4]);;
#! gap> LabeledDarts(P);
#! [ [ [ 1, 2 ], 0 ], [ [ 2, 1 ], 0 ], [ [ 1, 2 ], 1 ], [ [ 2, 1 ], 1 ], [ [ 1 ], 2 ], [ [ 1, 2 ], 3 ], [ [ 2, 1 ], 3 ], [ [ 1 ], 4 ], [ [ 2 ], 2 ], [ [ 2 ], 4 ] ]
#! @EndExampleSession


DeclareOperation("LabeledDart",[IsPremaniplex, IsInt,IsInt]);

