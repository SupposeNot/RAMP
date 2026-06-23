
#! @Chapter Voltage Graphs and Operations
#! @Section Voltage Operator

#! @Arguments etain, etaout, Xa
#! @Returns `IsManiplex`
#! @Description Returns the output of the voltage operator acting on <A>Xa</A>.
#! The list <A>etain</A> gives the labeled darts of the auxiliary premaniplex.
#! The string <A>etaout</A> gives a comma-separated list of words in the universal sggi of the same rank as <A>Xa</A>, with one word for each dart in <A>etain</A>.
#! If <A>Xa</A> is a maniplex, the operation is applied to its flag graph.
DeclareOperation("VoltageOperator", [IsList, IsString,IsEdgeLabeledGraph]);
DeclareOperation("VoltageOperator", [IsList, IsString,IsManiplex]);
#! The Petrial and the dual can be built using voltage operations. Similarly, other rank 3 operations can be built this way.
#! See "Voltage operations on maniplexes" by Hubard, Mochan, and Montero.
#! @BeginExampleSession
#! gap> etain1 := [[[1],0],[[1],1],[[1],2],[[1],3]];;
#! gap> etain2 := [[[1],0],[[2],0],[[1],1],[[2],1],[[1,2],2]];;
#! gap> etain3 := [[[1],0],[[2],0],[[3],0],[[1],1],[[3],2],[[1,2],2],[[2,3],1]];;
#! gap> etaoutPetrial := "r0, r1 r3, r2, r3";;
#! gap> etaoutDual := "r3, r2, r1, r0";;
#! gap> etaoutMedial := "r1, r1, r0, r2, Id";;
#! gap> etaoutLeapfrog := "r1,r1,r2,r0,r0, , ";;
#! gap> etaoutTruncation := "r1, r1, r0, r2, r2,Id, Id";;
#! gap> Petrial(Cube(4)) = VoltageOperator(etain1, etaoutPetrial, Cube(4));
#! true
#! gap> Dual(Cube(4)) = VoltageOperator(etain1, etaoutDual, Cube(4));
#! true
#! gap> Medial(Dodecahedron()) = VoltageOperator(etain2, etaoutMedial, Dodecahedron());
#! true
#! gap> Leapfrog(Simplex(3)) = VoltageOperator(etain3, etaoutLeapfrog, Simplex(3));
#! true
#! gap> Truncation(Prism(7)) = VoltageOperator(etain3, etaoutTruncation, Prism(7));
#! true
#! @EndExampleSession

#! @Arguments n, I
#! @Returns `IsList`
#! @Description Returns the admissible sequences corresponding to the flag orbits for a Wythoffian of a rank <A>n</A> maniplex.
#! The vertex in the fundamental region is moved by `r_i` for `i` in <A>I</A>.
DeclareOperation("AdmissiblePerms", [IsInt, IsList]);
#! There are three flag orbits in the truncation of a rank 3 maniplex, where truncation is the Wythoffian defined by `I = [0,1]`.
#! @BeginExampleSession
#! gap> AdmissiblePerms(3,[0,1]);
#! [ [ 0, 1, 2 ], [ 1, 0, 2 ], [ 1, 2, 0 ] ]
#! @EndExampleSession

#! @Arguments n, I
#! @Returns `IsEdgeLabeledGraph`
#! @Description Returns the symmetry type graph for a Wythoffian of rank <A>n</A> defined by a list of indices <A>I</A>.
#! See, for instance, "Voltage operations on maniplexes".
DeclareOperation("WythoffSTG", [IsInt, IsList]);
#! Here is the symmetry type graph of a medial operation.
#! @BeginExampleSession
#! gap> W := WythoffSTG(3,[1]);
#! Edge labeled graph with 2 vertices, and edge labels [ 0, 1, 2 ]
#! gap> LabeledEdges(W);
#! [ [ [ 1 ], 0 ], [ [ 1 ], 1 ], [ [ 1, 2 ], 2 ], [ [ 2 ], 0 ], [ [ 2 ], 1 ] ]
#! @EndExampleSession

#! @Arguments n, I
#! @Returns `IsList`
#! @Description Returns the labeled edges of a possible symmetry type graph for a Wythoffian of rank <A>n</A> defined by a list of indices <A>I</A>.
#! This returns a list rather than an edge-labeled graph, since edge-labeled graphs are expected to have integer vertices when calculating their connection groups.
DeclareOperation("WythoffLabeledEdges", [IsInt, IsList]);
#! Here are the labeled edges of the symmetry type graph of a medial operation.
#! @BeginExampleSession
#! gap> WythoffLabeledEdges(3,[1]);
#! [ [ [ [ 1, 0, 2 ] ], 0 ], [ [ [ 1, 0, 2 ] ], 1 ], [ [ [ 1, 2, 0 ] ], 0 ], 
#!   [ [ [ 1, 2, 0 ] ], 1 ], [ [ [ 1, 2, 0 ], [ 1, 0, 2 ] ], 2 ] ]
#! @EndExampleSession

#! @Arguments I, M
#! @Returns `IsManiplex`
#! @Description Returns the Wythoffian of the maniplex <A>M</A> with set of ringed nodes <A>I</A>.
#! For example, if `I = [1]` then this is the rectification of <A>M</A>, and if `I = [0,1]` then this is the truncation of <A>M</A>.
#! Behind the scenes, this is accomplished using `VoltageOperator`.
DeclareOperation("Wythoffian", [IsList, IsManiplex]);
#! @BeginExampleSession
#! gap> W := Wythoffian([0,1],Dodecahedron());
#! 3-maniplex with 360 flags
#! gap> Fvector(W);
#! [ 60, 90, 32 ]
#! gap> W = Truncation(Dodecahedron());
#! true
#! gap> M := Wythoffian([1], Simplex(4));;
#! gap> Fvector(M);
#! [ 10, 30, 30, 10 ]
#! gap> VertexFigure(M) = Prism(3);
#! true
#! @EndExampleSession

#! @Arguments G, L, V
#! @Returns `IsVoltageGraph`
#! @Description Given a group <A>G</A>, a list <A>L</A> of labeled darts, and a list <A>V</A> of group elements, constructs the voltage graph with voltage group <A>G</A>, labeled darts <A>L</A>, and voltages <A>V</A>.
DeclareOperation("VoltageGraph", [IsGroup,IsList,IsList]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> L := LabeledDarts(P);;
#! gap> V := List(L, i -> Identity(G));;
#! gap> VG := VoltageGraph(G,L,V);
#! Voltage Graph with 2 vertices, and voltages from Sym( [ 1 .. 3 ] )
#! gap> Length(LabeledDarts(VG));
#! 6
#! gap> Set(Voltages(VG));
#! [ () ]
#! @EndExampleSession

#! @Arguments G, P, V
#! @Returns `IsVoltageGraph`
#! @Description Given a group <A>G</A>, a premaniplex <A>P</A>, and a list <A>V</A> of group elements, constructs the voltage graph with voltage group <A>G</A>, labeled darts from <A>P</A>, and voltages <A>V</A>.
DeclareOperation("VoltageGraph", [IsGroup,IsPremaniplex,IsList]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> V := List(LabeledDarts(P), i -> Identity(G));;
#! gap> VG := VoltageGraph(G,P,V);
#! Voltage Graph with 2 vertices, and voltages from Sym( [ 1 .. 3 ] )
#! gap> Rank(Premaniplex(VG));
#! 3
#! gap> Voltages(VG) = V;
#! true
#! @EndExampleSession

#! @Arguments G, P
#! @Returns `IsVoltageGraph`
#! @Description Given a group <A>G</A> and a premaniplex <A>P</A>, constructs the voltage graph with voltage group <A>G</A>, labeled darts from <A>P</A>, and trivial voltages.
DeclareOperation("VoltageGraph", [IsGroup,IsPremaniplex]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);
#! Voltage Graph with 2 vertices, and voltages from Sym( [ 1 .. 3 ] )
#! gap> Set(Voltages(VG));
#! [ () ]
#! @EndExampleSession

#! @Arguments VG, ld, g
#! @Description Given a voltage graph <A>VG</A>, a labeled dart <A>ld</A>, and a group element <A>g</A>, changes the voltage for the labeled dart <A>ld</A> to <A>g</A>.
DeclareOperation("ChangeVoltage", [IsVoltageGraph,IsList, IsObject]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> ChangeVoltage(VG,[[1],0],(1,2));;
#! gap> Voltages(VG)[1];
#! (1,2)
#! @EndExampleSession

#! @Arguments VG, lab, startvert, g
#! @Description Given a voltage graph <A>VG</A>, a label <A>lab</A>, a start vertex <A>startvert</A>, and a group element <A>g</A>, changes the voltage for the labeled dart of label <A>lab</A> with initial vertex <A>startvert</A> to <A>g</A>.
DeclareOperation("ChangeVoltage", [IsVoltageGraph,IsInt,IsInt, IsObject]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> ChangeVoltage(VG,1,1,(1,2,3));;
#! gap> Voltages(VG)[2];
#! (1,2,3)
#! @EndExampleSession

#! @Arguments VG
#! @Returns `IsEdgeLabeledGraph`
#! @Description Given a voltage graph <A>VG</A>, `DerivedGraph(VG)` constructs the derived graph of <A>VG</A>.
DeclareAttribute("DerivedGraph", IsVoltageGraph);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> D := DerivedGraph(VG);;
#! gap> Length(Verts(D));
#! 12
#! gap> Length(Edges(D));
#! 36
#! gap> Set(Labels(D));
#! [ 0, 1, 2 ]
#! @EndExampleSession

#! @Arguments VG, M
#! @Returns `IsManiplex`
#! @Description Given a voltage graph <A>VG</A> and a maniplex <A>M</A>, `VoltageOperator(VG,M)` returns the voltage operator <A>VG</A> acting on <A>M</A>.
DeclareOperation("VoltageOperator", [IsVoltageGraph, IsManiplex]);
#! @BeginExampleSession
#! gap> M := Dodecahedron();;
#! gap> S := STG2(3,[0,1]);;
#! gap> C := ConnectionGroup(M);;
#! gap> V := VoltageGraph(C,S);;
#! gap> ChangeVoltage(V,0,1,C.2);;
#! gap> ChangeVoltage(V,0,2,C.2);;
#! gap> ChangeVoltage(V,1,1,C.1);;
#! gap> ChangeVoltage(V,1,2,C.3);;
#! gap> Medial(M) = VoltageOperator(V,M);
#! true
#! @EndExampleSession

#! @Arguments VG, ELG
#! @Returns `IsManiplex`
#! @Description Given a voltage graph <A>VG</A> and an edge-labeled graph <A>ELG</A>, `VoltageOperator(VG,ELG)` returns the voltage operator <A>VG</A> acting on <A>ELG</A>.
DeclareOperation("VoltageOperator", [IsVoltageGraph,IsEdgeLabeledGraph]);
#! @BeginExampleSession
#! gap> M := Simplex(3);;
#! gap> S := STG2(3,[0,1]);;
#! gap> C := ConnectionGroup(M);;
#! gap> V := VoltageGraph(C,S);;
#! gap> ChangeVoltage(V,0,1,C.2);;
#! gap> ChangeVoltage(V,0,2,C.2);;
#! gap> ChangeVoltage(V,1,1,C.1);;
#! gap> ChangeVoltage(V,1,2,C.3);;
#! gap> Medial(M) = VoltageOperator(V,FlagGraph(M));
#! true
#! @EndExampleSession

#! @Arguments VG
#! @Returns `IsGroup`
#! @Description Returns the voltage group of the voltage graph <A>VG</A>.
DeclareAttribute("VoltageGroup", IsVoltageGraph);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> VoltageGroup(VG) = G;
#! true
#! @EndExampleSession

#! @Arguments VG
#! @Returns `IsList`
#! @Description Returns the labeled darts of the voltage graph <A>VG</A>.
DeclareAttribute("LabeledDarts", IsVoltageGraph);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> Length(LabeledDarts(VG));
#! 6
#! @EndExampleSession

#! @Arguments VG
#! @Returns `IsList`
#! @Description Returns the voltages of the voltage graph <A>VG</A>, in the same order as `LabeledDarts(VG)`.
DeclareAttribute("Voltages", IsVoltageGraph);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> Set(Voltages(VG));
#! [ () ]
#! @EndExampleSession

#! @Arguments VG
#! @Returns `IsPremaniplex`
#! @Description Returns the premaniplex underlying the voltage graph <A>VG</A>.
DeclareOperation("Premaniplex", [IsVoltageGraph]);
#! @BeginExampleSession
#! gap> G := SymmetricGroup(3);;
#! gap> P := STG2(3,[0,1]);;
#! gap> VG := VoltageGraph(G,P);;
#! gap> Rank(Premaniplex(VG));
#! 3
#! @EndExampleSession
