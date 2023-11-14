

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
#! @Description Returns a list of the admissible sequences that correspond to the flag orbits for a Wythoffian of a rank <A>n</A> maniplex.
#! The vertex in the fundamental region is moved by ri for i in <A>I</A>.
DeclareOperation("AdmissiblePerms", [IsInt, IsList]);
#! @BeginExampleSession
#! There will be three flag orbits in the truncation of a rank 3 maniplex, where truncation is a Wythoffican defined by I = [0,1]
#! gap> AdmissiblePerms(3,[0,1]);
#!  [ [ 0, 1, 2 ], [ 1, 0, 2 ], [ 1, 2, 0 ] ]
#! @EndExampleSession



#! @Arguments n, I
#! @Returns IsList
#! @Description Returns the symmetry type graph for a Wythoffian of rank <A>n</A> defined by a list of indices <A>I</A>.
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
#! @Description Returns the labeled edges of a possible symmetry type graph for a Wythoffian of rank <A>n</A> defined by a list of indices <A>I</A>.
#! The actual graph is not returned, as we require edge labeled graphs to have integer vertices in order to calculate their connection groups.
DeclareOperation("WythoffLabeledEdges", [IsInt, IsList]);
#! @BeginExampleSession
#! Labeled Edges of the Symmetry type graph of a medial operation
#! gap> WythoffLabeledEdges(3,[1]);
#! [ [ [ [ 1, 0, 2 ] ], 0 ], [ [ [ 1, 0, 2 ] ], 1 ], [ [ [ 1, 2, 0 ] ], 0 ], [ [ [ 1, 2, 0 ] ], 1 ], [ [ [ 1, 2, 0 ], [ 1, 0, 2 ] ], 2 ] ]
#! @EndExampleSession


#! @Arguments I, M
#! @Returns IsList
#! @Description Returns the Wythoffian of the maniplex <A>M</A> with set of ringed nodes <A>I</A>. For example, if I = [1] then this is the rectification of <A>M</A> and if I = [0, 1] then this is truncation of <A>M</A>. Behind the scenes, this is accomplished using VoltageOperator. 
DeclareOperation("Wythoffian", [IsList, IsManiplex]);
#! @BeginExampleSession
#! gap> W:=Wythoffian([0,1],Dodecahedron());
#! 3-maniplex with 360 flags
#! gap> W=Truncation(Dodecahedron());
#! true
#! gap> M := Wythoffian([1], Simplex(4));;
#! gap> Fvector(M);
#! [10, 30, 30, 10]
#! gap> VertexFigure(M) = Prism(3);
#! true
#! gap> Wythoffian([3], M) = Dual(M);
#! true
#! @EndExampleSession





#! @Arguments G, L, V
#! @Returns IsVoltageGraph
#! @Description Given an IsGroup <A>G</A>, an IsList <A>L</A>, and an IsList  <A>V</A>, `VoltageGraph(G,L,V)` will construct the voltage graph with voltages from G, labeled darts from L, and voltages from V.
DeclareOperation("VoltageGraph", [IsGroup,IsList,IsList]);
#! @BeginExampleSession
#! gap> G:=ConnectionGroup(Cube(3));;
#! gap> L:=[ [[1],0], [[1],1], [[1,2],2], [[2],0], [[2],1]];;
#! gap> V:=[G.2, G.1, Identity(G), G.2, G.1];;
#! gap> VG:=VoltageGraph(G,L,V);
#! Voltage Graph with voltages from Group( [ (1,20)(2,13)(3,10)(4,45)(5,35)(6,7)(8,41)(9,28)(11,38)
#! (12,24)(14,43)(15,34)(16,33)(17,19)(18,31)(21,39)(22,27)(23,26)(25,36)(29,32)(30,48)(37,47)
#! (40,46)(42,44), (1,11)(2,32)(3,14)(4,25)(5,26)(6,27)(7,8)(9,43)(10,44)(12,29)(13,30)(15,39)(16,40)
#! (17,41)(18,21)(19,22)(20,23)(24,48)(28,42)(31,47)(33,36)(34,37)(35,38)(45,46), (1,3)(2,7)
#! (4,11)(5,12)(6,13)(8,18)(9,19)(10,20)(14,25)(15,26)(16,27)(17,28)(21,32)(22,33)(23,34)(24,35)
#! (29,39)(30,40)(31,41)(36,43)(37,44)(38,45)(42,47)(46,48) ] )
#! @EndExampleSession


#! @Arguments G, P, V
#! @Returns IsVoltageGraph
#! @Description Given an IsGroup <A>G</A>, an IsPremaniplex <A>P</A>, and an IsList  <A>V</A>, `VoltageGraph(G,P,V)` will construct the voltage graph with voltages from G, labeled darts from the premaniplex P, and voltages from V.
DeclareOperation("VoltageGraph", [IsGroup,IsPremaniplex,IsList]);
#! @BeginExampleSession
#! gap> G:=ConnectionGroup(Cube(3));;
#! gap> P:=STG2(3,[0,1]);
#! Premaniplex of rank 3 with 2 flags
#! gap> L:=LabeledDarts(P);
#! [ [ [ 1 ], 0 ], [ [ 1 ], 1 ], [ [ 1, 2 ], 2 ], [ [ 2, 1 ], 2 ], [ [ 2 ], 0 ], [ [ 2 ], 1 ] ]
#! gap> V:=[G.2, G.1, Identity(G), Identity(G), G.2, G.1];;
#! gap> VG:=VoltageGraph(G,P,V);
#! Voltage Graph with voltages from Group( [ (1,20)(2,13)(3,10)(4,45)(5,35)(6,7)(8,41)(9,28)(11,38)(12,24)(14,43)
#! (15,34)(16,33)(17,19)(18,31)(21,39)(22,27)(23,26)(25,36)(29,32)(30,48)(37,47)(40,46)(42,44), 
#! (1,11)(2,32)(3,14)(4,25)(5,26)(6,27)(7,8)(9,43)(10,44)(12,29)(13,30)(15,39)(16,40)(17,41)(18,21)(19,22)(20,23)
#! (24,48)(28,42)(31,47)(33,36)(34,37)(35,38)(45,46), 
#! (1,3)(2,7)(4,11)(5,12)(6,13)(8,18)(9,19)(10,20)(14,25)(15,26)(16,27)(17,28)(21,32)(22,33)(23,34)(24,35)(29,39)
#! (30,40)(31,41)(36,43)(37,44)(38,45)(42,47)(46,48) ] )
#! @EndExampleSession




#! @Arguments G, P
#! @Returns IsVoltageGraph
#! @Description Given an IsGroup <A>G</A>, and an IsPremaniplex <A>P</A>, `VoltageGraph(G,P)` will construct the voltage graph with voltages from G, labeled darts from the premaniplex P, and trivial voltages.
DeclareOperation("VoltageGraph", [IsGroup,IsPremaniplex]);







#! @Arguments VG, ld, g
#! @Description Given an IsVoltageGraph <A>VG</A>, an IsList <A>ld</A>, and an IsObject <A>g</A>, `ChangeVoltage(VG,ld,g)` will change the voltage for the one labeled dart ld to the group element g.
DeclareOperation("ChangeVoltage", [IsVoltageGraph,IsList, IsObject]);


#! @Arguments VG, lab, startvert, g 
#! @Description Given an IsVoltageGraph <A>VG</A>, an IsInt <A>lab</A>, an IsInt <A>startvert</A>, and an IsObject <A>g</A>, `ChangeVoltage(VG,lab, startvert,g)` will change the voltage for the one labeled dart of label lab and start vertex startvert to the group element g.
DeclareOperation("ChangeVoltage", [IsVoltageGraph,IsInt,IsInt, IsObject]);



#! @Arguments VG
#! @Returns IsVoltageGraph
#! @Description Given an IsVoltageGraph <A>VG</A>, a `DerivedGraph(VG)` will construct the derived graph of the voltage graph VG.
DeclareAttribute("DerivedGraph", IsVoltageGraph);


#! @Arguments VG, M
#! @Description Given an IsVoltageGraph <A>VG</A>, and an IsManiplex <A>M</A>, `VoltageOperator(VG,M)` will return the voltage operator VG acting on M.
DeclareOperation("VoltageOperator", [IsVoltageGraph, IsManiplex]);
#! @BeginExampleSession
#! gap> M:=Dodecahedron();;
#! gap> S:=STG2(3,[0,1]);
#! Premaniplex of rank 3 with 2 flags
#! gap> C:=ConnectionGroup(M);;
#! gap> V:=VoltageGraph(C,S);;
#! gap> ChangeVoltage(V,0,1,C.2);;
#! gap> ChangeVoltage(V,0,2,C.2);;
#! gap> ChangeVoltage(V,1,1,C.1);;
#! gap> ChangeVoltage(V,1,2,C.3);;
#! gap> Medial(M) = VoltageOperator(V,M);
#! true
#! @EndExampleSession


#! @Arguments VG, ELG
#! @Description Given an IsVoltageGraph <A>VG</A>, and an IsEdgeLabeledGraph <A>ELM</A>, `VoltageOperator(VG,M)` will return the voltage operator VG acting on ELM.
DeclareOperation("VoltageOperator", [IsVoltageGraph,IsEdgeLabeledGraph]);


DeclareAttribute("VoltageGroup", IsVoltageGraph);
DeclareAttribute("LabeledDarts", IsVoltageGraph);
DeclareAttribute("Voltages", IsVoltageGraph);
DeclareOperation("Premaniplex", [IsVoltageGraph]);





