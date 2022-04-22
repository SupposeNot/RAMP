

#! @Chapter Voltage Graphs and Operations
#! @Section Voltage Operator


#! @Arguments Y, etain, etaout, Xa
#! @Returns IsManiplex
#! @Description Returns the output of the voltage operator acting on Xa.
#! Xa is a n-premaniplex as an edge labeled graph, Y is a m-premaniplex.  eta is a voltage assignment on the darts of Y.
#! etain is a list of all darts of Y.  etaout is a string giving words in the universal sggi of rank n.
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
#! gap> etaoutPetrial:="[r0, r1 r3, r2, r3]";;
#! gap> etaoutDual:="[r3, r2, r1, r0]";;
#! gap> etaoutMedial:="[r1, r1, r0, r2, Id]";;
#! gap> etaoutLeapfrog:="[r1,r1,r2,r0,r0, , ]";;
#! gap> etaoutTruncation:="[r1, r1, r0, r2, r2,Id, Id]";;
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






