

#! @Chapter Voltage Graphs and Operations
#! @Section Voltage Operator


#! @Arguments etain, etaout, Xa
#! @Returns IsManiplex
#! @Description Returns the output of the voltage operator acting on Xa.
#! Xa is a n-premaniplex as an edge labeled graph, Y is a m-premaniplex.  eta is a voltage assignment on the darts of Y.
#! etain is a list of all darts of Y.  etaout is a string giving words in the universal sggi of rank n, and the order
#! of the words corresponds to the order of the darts in etain.
#! If Xa is given as a maniplex, the operation is done to its flag graph.
DeclareOperation("VoltageOperator", [IsList, IsString,IsEdgeLabeledGraph]);
DeclareOperation("VoltageOperator", [IsList, IsString,IsManiplex]);
#! @BeginExampleSession
#! The Petrial and the dual can be built using voltage operations
#! Similarly for rank 3 other operations can be built this way.
#! See VOLTAGE OPERATIONS ON MANIPLEXES by HUBARD, MOCHÁN, MONTERO
#! gap> etain1:=[[[1],0],[[1],1],[[1],2],[[1],3]];;
#! gap> etain2:=[[[1],0],[[2],0],[[1],1],[[2],1],[[1,2],2]];;
#! gap> etain3:=[[[1],0],[[2],0],[[3],0],[[1],1],[[3],2],[[1,2],2],[[2,3],1]];;
#! gap> etaoutPetrial:="r0, r1 r3, r2, r3";;
#! gap> etaoutDual:="r3, r2, r1, r0";;
#! gap> etaoutMedial:="r1, r1, r0, r2, Id";;
#! gap> etaoutLeapfrog:="r1,r1,r2,r0,r0, , ";;
#! gap> etaoutTruncation:="r1, r1, r0, r2, r2,Id, Id";;
#! gap> Petrial(Cube(4)) =VoltageOperator(etain1, etaoutPetrial, Cube(4));
#! true
#! gap> Dual(Cube(4)) = VoltageOperator(etain1, etaoutDual, Cube(4));
#! true
#! gap> Medial(Dodecahedron()) = VoltageOperator(etain2, etaoutMedial, Dodecahedron());
#! true
#! gap> Leapfrog(Simplex(3)) =  VoltageOperator(etain3, etaoutLeapfrog, Simplex(3));
#! true
#! gap> Truncation(Prism(7)) = VoltageOperator(etain3, etaoutTruncation, Prism(7));
#! true
#! @EndExampleSession





#! @Arguments n, I
#! @Returns IsList
#! @Description Returns a list of the admissible sequences that correspond to the flag orbits for a Wythoffian of a rank n maniplex.
#! The vertex in the fundamental region is moved by ri for i in I.
DeclareOperation("AdmissiblePerms", [IsInt, IsList]);
#! @BeginExampleSession
#! There will be three flag orbits in the truncation of a rank 3 maniplex, where truncation is a Wythoffican defined by I = [0,1]
#! gap> AdmissiblePerms(3,[0,1]);
#!  [ [ 0, 1, 2 ], [ 1, 0, 2 ], [ 1, 2, 0 ] ]
#! @EndExampleSession



#! @Arguments n, I
#! @Returns IsList
#! @Description Returns the symmetry type graph for a Wythoffian of rank n defined by a list of indices.
#! See, for instance, VOLTAGE OPERATIONS ON MANIPLEXES.
DeclareOperation("WythoffSTG", [IsInt, IsList]);
#! @BeginExampleSession
#! Symmetry type graph of a medial operation
#! gap> W:=WythoffSTG(3,[1]);
#! Edge labeled graph with 2 vertices, and edge labels [ 0, 1, 2 ]
#! gap> LabeledEdges(W);
#! [ [ [ 1 ], 0 ], [ [ 1 ], 1 ], [ [ 1, 2 ], 2 ], [ [ 2 ], 0 ], [ [ 2 ], 1 ] ]
#! @EndExampleSession



#! @Arguments n, I
#! @Returns IsList
#! @Description Returns the labeled edges of a possible symmetry type graph for a Wythoffian of rank n defined by a list of indices.
#! The actual graph is not returned, as we require edge labeled graphs to have integer vertices in order to calculate their connection groups.
DeclareOperation("WythoffLabeledEdges", [IsInt, IsList]);
#! @BeginExampleSession
#! Labeled Edges of the Symmetry type graph of a medial operation
#! gap> WythoffLabeledEdges(3,[1]);
#! [ [ [ [ 1, 0, 2 ] ], 0 ], [ [ [ 1, 0, 2 ] ], 1 ], [ [ [ 1, 2, 0 ] ], 0 ], [ [ [ 1, 2, 0 ] ], 1 ], [ [ [ 1, 2, 0 ], [ 1, 0, 2 ] ], 2 ] ]
#! @EndExampleSession


#! @Arguments n, I, M
#! @Returns IsList
#! @Description Returns the maniplex built from a voltage operation given a Wythoffian
DeclareOperation("WythoffVoltageOperator", [IsInt, IsList, IsManiplex]);
#! @BeginExampleSession
#! Truncation built using voltages 
#! gap> W:=WythoffVoltageOperator(3,[0,1],Dodecahedron());
#! 3-maniplex with 360 flags
#! gap> W=Truncation(Dodecahedron());
#! true
#! @EndExampleSession



