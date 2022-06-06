
InstallMethod(Premaniplex,
	[IsGroup],
	function(g)
	local pm;
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexConnGpRep),  	    rec(conn_gp:=g, flags:=MovedPoints(g), rank:=Size(GeneratorsOfGroup(g))));
	return(pm);
	end);


InstallMethod(Premaniplex,
	[IsEdgeLabeledGraph],
	function(g)
	local pm, c;
	c:=ConnectionGroup(g);
	pm:=Objectify(NewType(PremaniplexFamily, IsPremaniplex and IsPremaniplexGraphRep),  	    rec(conn_gp:=c, flags:=Vertices(g), rank:=Size(Set(Labels(g)))));
	return(pm);
	end);



InstallMethod( ViewObj,
	[IsPremaniplex],
	function(pm)
	Print(Concatenation("Premaniplex of rank ", String(pm!.rank), " with ", String(Size(pm!.flags)), " flags"));
	end);
