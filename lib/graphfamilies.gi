InstallMethod(HeawoodGraph,
	[],
	function()
	return EdgeOrbitsGraph( Group( [ (1,2,3)(4,7,6)(9,12,14)(10,11,13), (1,8,2,12,5,14,6,10)(3,11,7,9)(4,13) ]), [[1,8]]);
	end);	

InstallMethod(PetersenGraph,
	[],
	function()
	return Graph( SymmetricGroup(5), [[1,2]], OnSets,
                   function(x,y) return Intersection(x,y)=[]; end );
	end);	

InstallMethod(CirculantGraph,
	[IsInt, IsList],
	function (n, L)
	local edges , i, g ;
	edges:=[];
	for i in L do
	Add(edges, [1,1+i]);
	Add(edges, [1+i,1]);
	od;
	g:=[2..n];
	Add(g,1);
	g:=PermList(g);
		return EdgeOrbitsGraph( Group(g), edges, n);

	end);	

InstallMethod(CompleteBipartiteGraph,
	[IsInt,IsInt],
	function (n, m)
	local edges , i,g  ;
	edges:=[];
	for i in [1..n] do
	Add(edges, [i,n+1]);
	Add(edges, [n+1,i]);
	od;
	if m = 1 then
	return EdgeOrbitsGraph( Group(), edges, n+m);
	fi;
	g:=[1..n];
	Append(g, [n+2..n+m]);
	Add(g,n+1);
	g:=PermList(g);
		return EdgeOrbitsGraph( Group(g), edges, n+m);
	end);	