InstallMethod(VoltageOperator,
	[IsList, IsString,IsEdgeLabeledGraph],
	function(etain,etaout,Xa)
	local Y, eta2, V1, V2, Vnew, ranknew, CX, gensX, CY, gensY, images, i, out, j, newLabEdges, x, y, 
	ed, xnew, ynew, vxy, vnewxnewy;	
	Y:=EdgeLabeledGraphFromLabeledEdges(etain);
	eta2:=SplitString(etaout,",");
	V1:=Vertices(Xa);
	V2:=Vertices(Y);
	Vnew:=Cartesian(V1,V2);;
	ranknew:=Size(Set(Labels(Y)));
	CX:=ConnectionGroup(Xa);
	gensX:=GeneratorsOfGroup(CX);
	CY:=ConnectionGroup(Y);
	gensY:=GeneratorsOfGroup(CY);
	images:=[];
	for i in [1..Size(eta2)] do
	NormalizeWhitespace(eta2[i]);
	Add(images, SggiElement(CX, eta2[i]));
	#out:=CX.1^2;
	#for j in eta2[i] do
	#if IsDigitChar(j) then
 	#out:=out*gensX[SIntChar(j)+1-48];  ### Weird behavior of ints as characters.
	#fi;
	#od;
	#Add(images,out);
	od;
	newLabEdges:=[];
	for x in V1 do
	for y in V2 do
	for i in [1..Size(etain)] do 
	ed:=etain[i];
	if y = ed[1][1] then
	xnew:=x^images[i];
	ynew:=y^gensY[ed[2]+1];
	vxy:=CtoL(x,y,Size(V1), Size(V2));
	vnewxnewy:=CtoL(xnew,ynew,Size(V1), Size(V2));
	Add(newLabEdges, [[vxy,vnewxnewy],ed[2]]);
	fi;
	od;
	od;
	od;
	return Maniplex(EdgeLabeledGraphFromLabeledEdges(newLabEdges));
end);



InstallMethod(VoltageOperator,
	[IsList, IsString,IsManiplex],
	function(etain,etaout,Xa)
	return VoltageOperator(etain,etaout,FlagGraph(Xa));
	end);







InstallMethod(AdmissiblePerms,
	[IsInt, IsList],
	function(n,I)
	local P, Good, test, p, i, plessi;
	if n = 1 then
	return List(I, i-> [i]);
	fi;
	P:=PermutationsList([0..n-1]);
	Good:=[];
	test:=true;
	for p in P do
	test:=true;

	if (p[1] in I) then 
	
	for i in [2..n] do
		plessi := List([1..i-1], j-> p[j] ); 
		if not ((p[i] in I) or ((p[i]-1) in plessi) or  ((p[i]+1) in plessi)) then
		test:=false;
		fi;
	od;
	if test = true then
	Add(Good,p);
	fi;
	fi;
	od;

	return Good;
	end);




InstallMethod(WythoffSTG, 
	[IsInt, IsList],
	function(n,I)
	local V1, V2, LabEd2, k, v, i, moved, p;
	V1:=AdmissiblePerms(n,I);
	V2:=[1..Size(V1)];
	LabEd2:=[];
	for k in V2 do
	v:=V1[k];
	Add(LabEd2,[[k],0]);
	for i in [1..n-1] do
	moved:=ShallowCopy(v);
	moved[i]:=v[i+1];
	moved[i+1]:=v[i];
	if (moved in V1) then
	p:=Position(V1,moved);
	if p > k then
	Add(LabEd2, [[k, p],i]);
	fi;
	else
	Add(LabEd2, [[k],i]);
	fi;
	od;
	od;	
	return EdgeLabeledGraphFromLabeledEdges(LabEd2);
	end);







InstallMethod(WythoffLabeledEdges, 
	[IsInt, IsList],
	function(n,I)
	local V1, V2, LabEd1, k, v, i, moved;
	V1:=AdmissiblePerms(n,I);
	V2:=[1..Size(V1)];
	LabEd1:=[];
	for k in V2 do
	v:=V1[k];
	Add(LabEd1,[[v],0]);
	for i in [1..n-1] do
	moved:=ShallowCopy(v);
	moved[i]:=v[i+1];
	moved[i+1]:=v[i];
	if (moved in V1) then
	if (Position(V1,v) > Position(V1,moved)) then
	Add(LabEd1, [[v, moved],i]);
	fi;
	else 
	Add(LabEd1, [[v],i]);
	fi;
	od;
	od;	
	return LabEd1;
	end);






InstallMethod(WythoffVoltageOperator, 
	[IsInt, IsList, IsManiplex],
	function(n,I,M)
	local V1, V2 , LabEd1, LabEd2, k, v, i, p, W, etain1, etain2, etaout,s, ed,lab, moved;
	if I = [] then
	return M;
	fi;	
	V1:=AdmissiblePerms(n,I);
	V2:=[1..Size(V1)];
	LabEd1:=[];
	LabEd2:=[];
	for k in V2 do
	v:=V1[k];
	Add(LabEd1,[[v],0]);
	Add(LabEd2,[[k],0]);
	for i in [1..n-1] do
	moved:=ShallowCopy(v);
	moved[i]:=v[i+1];
	moved[i+1]:=v[i];
	if (moved in V1) then
	p:=Position(V1,moved);
	if p > k then
	Add(LabEd1, [[v, moved],i]);
	Add(LabEd2, [[k, p],i]);
	fi;
	else
	Add(LabEd1, [[v],i]);
	Add(LabEd2, [[k],i]);
	fi;
	od;
	od;	
	etain1:=LabEd1;
	etain2:=LabEd2;
	etaout:="";

	for i in [1..Size(etain1)-1] do
	ed:=etain1[i][1];
	lab:=etain1[i][2];
	if Size(ed) = 2 then
	etaout:= Concatenation(etaout, "Id,");
	elif Size(ed) =1 then
	s:=String(ed[1][lab+1]);
	etaout:= Concatenation(etaout, "r");
	etaout:= Concatenation(etaout, s);
	etaout:= Concatenation(etaout, ",");
	fi;
	od;
	i:=Size(etain1);
	ed:=etain1[i][1];
	lab:=etain1[i][2];
	if Size(ed) = 2 then
	etaout:= Concatenation(etaout, "Id]");
	elif Size(ed) =1 then
	s:=String(ed[1][lab+1]);
	etaout:= Concatenation(etaout, "r");
	etaout:= Concatenation(etaout, s);
	fi;
	return VoltageOperator(etain2,etaout,M);
	end);





InstallMethod( ViewObj,
	[IsVoltageGraph],
	function(vg)
	Print(Concatenation("Voltage Graph with ", String(Size(Flags(vg!.premaniplex))), " vertices, and voltages from ", ViewString(vg!.voltage_group)));
	end);




InstallMethod(VoltageGraph,
	[IsGroup,IsList,IsList],
	function(G, LDarts, Voltages)
	local fam, pm, vg;
        pm:=Premaniplex(EdgeLabeledGraphFromLabeledEdges(LDarts));
	fam := NewFamily("Voltage Graph", IsVoltageGraph);
	vg:=Objectify(NewType(VoltageGraphFamily, IsVoltageGraph and IsVoltageGraphListRep),  rec( voltage_group := G, labeled_darts:=LDarts, voltages:=Voltages, premaniplex:=pm ));
	return(vg);
	end);


InstallMethod(VoltageGraph,
	[IsGroup,IsPremaniplex,IsList],
	function(G, P, Voltages)
	local fam, LD, vg;
	LD:=LabeledDarts(P);
	fam := NewFamily("Voltage Graph", IsVoltageGraph);
	vg:=Objectify(NewType(VoltageGraphFamily, IsVoltageGraph and IsVoltageGraphPremaniplexRep),  rec( voltage_group := G, labeled_darts:=LD ,premaniplex:=P, voltages:=Voltages ));
	return(vg);
	end);


InstallMethod(VoltageGraph,
	[IsGroup,IsPremaniplex],
	function(G, P)
	local fam, LD, pm;
	LD:=LabeledDarts(P);
	fam := NewFamily("Voltage Graph", IsVoltageGraph);
	pm:=Objectify(NewType(VoltageGraphFamily, IsVoltageGraph and IsVoltageGraphPremaniplexRep),  rec( voltage_group := G, labeled_darts:=LD ,premaniplex:=P, voltages:=List([1..Size(LD)], i -> Identity(G))
));
	return(pm);
	end);



InstallMethod(ChangeVoltage,
	[IsVoltageGraph,IsList, IsObject],
	function(VG, labdart,g)
	local pos;
	pos:=Position(VG!.labeled_darts,labdart);
	VG!.voltages[pos]:=g;
	return;
	end);



InstallMethod(ChangeVoltage,
	[IsVoltageGraph,IsInt,IsInt, IsObject],
	function(VG, lab, startvert,g)
	local P, dart, pos;
	P:=VG!.premaniplex;
	dart:=LabeledDart(P,lab,startvert);
	pos:=Position(VG!.labeled_darts,dart);
	VG!.voltages[pos]:=g;
	return;
	end);



InstallMethod(DerivedGraph,
	[IsVoltageGraph],
	function(VG)
	local verts;
	verts:=Flags(Premaniplex(VG));
	return DerivedGraph(verts, VG!.labeled_darts,VG!.voltages);
	end);



InstallMethod(VoltageOperator,
	[IsVoltageGraph,IsManiplex],
	function(VG,Xa)
	return VoltageOperator(VG,FlagGraph(Xa));
	end);


InstallMethod(VoltageOperator,
	[IsVoltageGraph,IsEdgeLabeledGraph],
	function(VG,Xa)
	local pm, etain, Y, eta2, V1, V2, Vnew, ranknew, CX, gensX, CY, gensY, images, i, out, j, newLabEdges, x, y, 
	ed, xnew, ynew, vxy, vnewxnewy;	
	pm:=VG!.premaniplex;
	Y:=FlagGraph(pm);
	etain:=LabeledDarts(pm);
	eta2:=VG!.voltages;
	V1:=Vertices(Xa);
	V2:=Flags(pm);
	Vnew:=Cartesian(V1,V2);;
	ranknew:=Rank(pm);
	CX:=VG!.voltage_group;
	gensX:=GeneratorsOfGroup(CX);
	CY:=ConnectionGroup(Y);
	gensY:=GeneratorsOfGroup(CY);
	images:=eta2;
	newLabEdges:=[];
	for x in V1 do
	for y in V2 do
	for i in [1..Size(etain)] do 
	ed:=etain[i];
	if y = ed[1][1] then
	xnew:=x^images[i];
	ynew:=y^gensY[ed[2]+1];
	vxy:=CtoL(x,y,Size(V1), Size(V2));
	vnewxnewy:=CtoL(xnew,ynew,Size(V1), Size(V2));
	Add(newLabEdges, [[vxy,vnewxnewy],ed[2]]);
	fi;
	od;
	od;
	od;
	return Maniplex(EdgeLabeledGraphFromLabeledEdges(newLabEdges));
end);


InstallMethod(VoltageGroup,
	[IsVoltageGraph],
	function(vg)
	return vg!.voltage_group;
	end);

InstallMethod(LabeledDarts,
	[IsVoltageGraph],
	function(vg)
	return vg!.labeled_darts;
	end);

InstallMethod(Voltages,
	[IsVoltageGraph],
	function(vg)
	return vg!.voltages;
	end);

InstallMethod(Premaniplex,
	[IsVoltageGraph],
	function(vg)
	return vg!.premaniplex;
	end);

