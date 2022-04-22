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
	out:=CX.1^2;
	for j in eta2[i] do
	if IsDigitChar(j) then
 	out:=out*gensX[SIntChar(j)+1-48];  ### Weird behavior of ints as characters.
	fi;
	od;
	Add(images,out);
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
