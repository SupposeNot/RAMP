



InstallMethod(TruncatedTetrahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([6,3]);
	return w/"(r0*r1)^3, r2*r1*r0*r1*r2*(r0*r1)^3*r2*r1*r0*r1*r2,   r0*r1*r2*r1*r0*r1*r2*(r0*r1)^3*r2*r1*r0*r1*r2*r1*r0";
	end);
	
InstallMethod(TruncatedOctahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([12,3]);
	return w/"(r0 r1)^6, r2 (r0 r1)^4 r2, r1 r2 (r0 r1)^6 r2 r1,r1 r0 r1 r0 r1 r2 (r0 r1)^6 r2 r1 r0 r1 r0 r1,r0 r1 r2 (r0 r1)^6 r2 r1 r0,r2 r1 r0 r1 r2 (r0 r1)^6 r2 r1 r0 r1 r2,r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r2 (r0 r1)^6 r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r2,r1 r0 r1 r2 (r0 r1)^4 r2 r1 r0 r1,r1 r0 r1 r2 r1 r0 r1 r2 (r0 r1)^6 r2 r1 r0 r1 r2 r1 r0 r1,r0 r1 r0 r1 r2 (r0 r1)^4 r2 r1 r0 r1 r0,r0 r1 r0 r1 r2 r1 r0 r1 r2 (r0 r1)^6 r2 r1 r0 r1 r2 r1 r0 r1 r0,r0 r2 r1 r0 r2 r1 r0 r2 r1 r2 (r0 r1)^4 r2 r1 r2 r0 r1 r2 r0 r1 r2 r0,r1 r0 r1 r0 r2 r1 r0 r1 r2 r1 r0 r1 r2 (r0 r1)^4 r2 r1 r0 r1 r2 r1 r0 r1 r2 r0 r1 r0 r1";
	end);	

InstallMethod(Cuboctahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([12,4]);
	return w/"(r0 r1)^4 ,r1 r2 r0 r1 r2 (r0 r1)^4 r2 r1 r0 r2 r1 ,((r0 r1)^4)^(r2 r1 r2 r0 r1 r0 r2 r1 r2) ,((r0 r1)^4)^(r2 r1 r0 r1 r2) ,((r0 r1)^4)^(r2 r1 r2 r0 r1 r0 r1) ,r1 r0 r1 r2 (r0 r1)^3 r2 r1 r0 r1 ,r2 ((r0 r1)^3) r2 ,r1 r2 ((r0 r1)^3) r2 r1 ,r0 r1 r2 ((r0 r1)^3) r2 r1 r0 ,((r0 r1)^3)^(r2 r1 r2 r0 r1 r2 r1 r0) ,((r0 r1)^3)^(r2 r1 r0 r1 r0 r2 r1 r2) ,((r0 r1)^3)^(r2 r1 r2 r0 r1 r2) ,((r0 r1)^3)^(r2 r1 r2 r0 r1 r2 r0 r1 r0 r1)";
	end);


InstallMethod(TruncatedCube,
	[],
	function()
	local w, g, n;
	w:=ARP([24,3]);
	return w/"((r0 r1)^3),((r0 r1)^8)^r2, ((r0 r1)^8)^(r2 (r0 r1)),((r0 r1)^8)^(r2 r1r0),     ((r0 r1)^3)^(r2 (r0 r1)^2 r2),((r0 r1)^3)^(r2 (r0 r1)^2 r2 (r0 r1)),((r0 r1)^3)^(r2 (r0 r1)^2 r2 r1r0),((r0 r1)^8)^(r2 (r0 r1)^3 r2),((r0 r1)^8)^(r2 (r0 r1)^3 r2 (r0 r1)),((r0 r1)^8)^(r2 (r0 r1)^3 r2 r1r0),((r0 r1)^3)^(r2 (r0 r1)^4 r2),((r0 r1)^3)^(r2 (r0 r1)^4 r2 (r0 r1)),((r0 r1)^3)^(r2 (r0 r1)^4 r2 r1r0)";
	end);
	
InstallMethod(Icosadodecahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([15,4]);
	return w/"((r0 r1)^5),((r0 r1)^3)^r2, ((r0 r1)^3)^(r2*(r0 r1)),((r0 r1)^3)^(r2*(r1 r0)), ((r0 r1)^3)^(r2*(r0 r1)^2),((r0 r1)^3)^(r2*(r1 r0)^2), ((r0 r1)^5)^(r2*(r0 r1)*r2), ((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)), ((r0 r1)^5)^(r2*(r0 r1)*r2*(r1 r0)), ((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)^2), ((r0 r1)^5)^(r2*(r0 r1)*r2*(r1 r0)^2),((r0 r1)^3)^(r2*(r0 r1)*r2*(r0 r1)*r2),((r0 r1)^3)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)),((r0 r1)^3)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)),((r0 r1)^3)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)^2),((r0 r1)^3)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)^2),((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2),((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)),((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)),((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)^2),((r0 r1)^5)^(r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)^2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r1 r0)),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)^2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r1 r0)^2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)^2),((r0 r1)^3)^(r2*(r0 r1)^2*r2*(r0 r1)*r2*(r0 r1)*r2*(r0 r1)*r2*(r1 r0)^2)";
	end);


InstallMethod(TruncatedIcosahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([30,3]);
	return w/"((r0 r1)^6), ((r0 r1)^6)^(r2), ((r0 r1)^5)^(r2 r1), ((r0 r1)^6)^(r2 r1 r0 r2 r1 r2),((r0 r1)^6)^(r2 r1 r0 r1 r0 r2 r1 r2), ((r0 r1)^6)^(r2 r1 r0 r1), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r1),((r0 r1)^6)^(r2 r1 r0 r1 r0), ((r0 r1)^5)^(r2 r1 r0), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r1 r0 r2 r1 r0 r1 r2 r0 r1 r0 r1 r2 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r0), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r1 r2), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r2), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r0), ((r0 r1)^5)^(r2 r1 r0 r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r0 r1 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r0 r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r0), ((r0 r1)^5)^(r2 r1 r0 r2 r1 r0 r1 r2 r1 r0 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r1 r0 r1 r0 r2 r1 r0 r1 r2 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r2), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r1 r0 r1 r2 r1 r0 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r0 r1 r2 r1 r0 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r0 r1), ((r0 r1)^5)^(r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r0 r1 r0 r1 r2 r1 r0 r1), ((r0 r1)^6)^(r2 r1 r0 r1 r2 r1 r0 r1 r0 r1 r2 r1 r0 r1 r0), ((r0 r1)^6)^(r2 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r2 r0 r1 r0), ((r0 r1)^6)^(r2 r1 r0 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r0 r1 r2 r1 r0 r1),((r0 r1)^5)^((r2 r1 r0)^7)";
	end);

InstallMethod(SmallRhombicuboctahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([12,4]);
	return w/"((r0 r1)^4),((r0 r1)^4)^r2,((r0 r1)^3)^(r2 r1 r2),((r0 r1)^4)^(r2 r1),((r0 r1)^3)^(r2 r1 r2 r0 r1),((r0 r1)^4)^(r2 r1 r0 r1),((r0 r1)^3)^(r2 r1 r2 r0 r1 r0),((r0 r1)^4)^(r2 r1 r0),((r0 r1)^3)^(r2 r1 r2 r0),((r0 r1)^4)^(r2 r1 r0 r1 r2),((r0 r1)^4)^(r2 r1 r2 r1 r0 r1 r2),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1),((r0 r1)^4)^(r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1),((r0 r1)^4)^(r2 r1 r0 r2 r1 r2 r0 r1 r0),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0),((r0 r1)^4)^(r2 r1 r0 r2 r1 r2 r0),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1 r2),((r0 r1)^3)^(r2 r1 r2 r1 r0 r1 r2 r1 r0 r1 r2),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1 r2 r1),((r0 r1)^3)^(r2 r1 r0 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1 r2 r1 r0 r1),((r0 r1)^3)^(r2 r1 r0 r1 r2 r1 r0 r2 r1 r2 r0 r1 r0),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1 r2 r1 r0),((r0 r1)^3)^(r2 r1 r0 r1 r2 r1 r0 r2 r1 r2 r0),((r0 r1)^4)^(r2 r1 r0 r1 r2 r1 r0 r1 r2 r1 r0 r1 r2)";
	end);
	
InstallMethod(Pseudorhombicuboctahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([12,4]);
	return w/"((a b)^4),((a b)^4)^c,((a b)^3)^(c b c),((a b)^4)^(c b),((a b)^3)^(c b c a b),((a b)^4)^(c b a b),((a b)^3)^(c b c a b a),((a b)^4)^(c b a),((a b)^3)^(c b c a),((a b)^4)^(c b a b c),((a b)^4)^(c b c b a b c),((a b)^4)^(c b a b c b),((a b)^4)^(c b a c b c a b),((a b)^4)^(c b a b c b a b),((a b)^4)^(c b a c b c a b a),((a b)^4)^(c b a b c b a),((a b)^4)^(c b a c b c a),((a b)^3)^(c b a b c b a b c),((a b)^4)^(c b c b a b c b a b c),((a b)^3)^(c b a b c b a b c b),((a b)^4)^(c b a b c b a c b c a b),((a b)^3)^(c b a b c b a b c b a b),((a b)^4)^(c b a b c b a c b c a b a),((a b)^3)^(c b a b c b a b c b a),((a b)^4)^(c b a b c b a c b c a)";
	end);
	
InstallMethod(SnubCube,
	[],
	function()
	local w, g, n;
	w:=ARP([12,5]);
	return w/"((r0 r1)^4),((r0 r1)^3)^r2,((r0 r1)^3)^(r2 r1 r2),((r0 r1)^3)^(r2 r1 r2 r1 r2),((r0 r1)^3)^(r2 r0 r1),((r0 r1)^3)^(r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r1),((r0 r1)^3)^(r2 r1 r2 r1 r2 r0 r1 r0),((r0 r1)^3)^(r2 r1 r2 r0 r1 r0),((r0 r1)^3)^(r2 r1 r0),((r0 r1)^3)^(r2 r1 r2 r1 r0),((r0 r1)^3)^(r2 r1 r2 r0),((r0 r1)^4)^(r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2),((r0 r1)^4)^(r2 r1 r2 r1 r0 r2 r1 r2),((r0 r1)^3)^(r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^4)^(r2 r1 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r2 r0 r1),((r0 r1)^4)^(r2 r1 r0 r2 r1 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r2),((r0 r1)^3)^(r2 r1 r2 r1 r0 r2 r1 r0 r2 r1 r0 r2 r1 r2),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r2 r0),((r0 r1)^3)^(r2 r1 r0 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^4)^(r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1),((r0 r1)^3)^(r2 r1 r2 r1 r0 r2 r1 r2 r1 r0 r2 r1 r2 r0 r1)";
	end);


InstallMethod(SmallRhombicosidodecahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([60,4]);
	return w/"(r0 r1)^5, (r2 r1 r0 r1)^3 r2 r0 (r1 r2 r0 r1 r2)^2 (r0 r1)^4 r0 (r1 r2 r1 r0 r2)^2 r1 r0 (r2 r1 r0 r1)^3 r2, r2 (r0 r1)^4 r2, r2 r1 r2 (r0 r1)^3 r2 r1 r2, r2 r1 r0 r1 r2 (r0 r1)^5 r2 r1 r0 r1 r2, r2 r1 r0 (r1 r2)^2 (r0 r1)^4 (r2 r1)^2 r0 r1 r2, (r2 r1 r0 r1)^2 r2 (r0 r1)^4 (r2 r1 r0 r1)^2 r2, (r2 r1 r0 r1)^2 r2 r1 r2 (r0 r1)^3 r2 (r1 r2 r1 r0)^2 r1 r2, (r2 r1 r0 r1)^2 r2 r0 r1 r2 (r0 r1)^3 r2 r1 r0 (r2 r1 r0 r1)^2 r2, (r2 r1 r0 r1)^2 r2 r0 (r1 r2)^2 (r0 r1)^4 (r2 r1)^2 r0 (r2 r1 r0 r1)^2 r2, (r2 r1 r0 r1)^3 r2 (r0 r1)^3 r0 (r1 r0 r1 r2)^4, (r2 r1 r0 r1)^3 r2 r0 r1 r2 (r0 r1)^4 r2 r1 r0 (r2 r1 r0 r1)^3 r2, (r2 r1 r0 r1)^3 (r2 r0 r1)^2 r2 (r0 r1)^3 (r2 r1 r0)^2 (r2 r1 r0 r1)^3 r2, (r2 r1 r0 r1)^3 (r2 r0 r1)^2 r2 r1 r2 (r0 r1)^4 r2 r1 (r2 r1 r0)^2 (r2 r1 r0 r1)^3 r2, r0 r1 r2 (r0 r1)^4 r2 r1 r0, r0 (r1 r2)^2 (r0 r1)^3 (r2 r1)^2 r0, r0 r1 r2 r1 r0 r1 r2 (r0 r1)^5 r2 r1 r0 r1 r2 r1 r0, (r0 r1 r2 r1)^2 r2 (r0 r1)^4 r2 (r1 r2 r1 r0)^2, (r0 r1 r2 r1)^2 r0 r1 r2 (r0 r1)^4 (r2 r1 r0 r1)^2 r2 r1 r0, (r0 r1 r2 r1)^3 r2 (r0 r1)^3 r2 (r1 r2 r1 r0)^3, (r0 r1 r2 r1)^2 (r0 r1 r2)^2 (r0 r1)^3 r2 r1 r0 (r2 r1 r0 r1)^2 r2 r1 r0, (r0 r1 r2 r1)^2 (r0 r1 r2)^2 r1 r2 (r0 r1)^4 (r2 r1)^2 r0 (r2 r1 r0 r1)^2 r2 r1 r0, (r0 r1 r2 r1)^3 r0 r1 r2 (r0 r1)^3 r0 (r1 r0 r1 r2)^4 r1 r0, (r0 r1 r2 r1)^3 (r0 r1 r2)^2 (r0 r1)^4 r2 r1 r0 (r2 r1 r0 r1)^3 r2 r1 r0, (r0 r1 r2 r1)^3 (r0 r1 r2)^3 (r0 r1)^3 (r2 r1 r0)^2 (r2 r1 r0 r1)^3 r2 r1 r0, (r0 r1 r2 r1)^3 (r0 r1 r2)^3 r1 r2 (r0 r1)^4 r2 r1 (r2 r1 r0)^2 (r2 r1 r0 r1)^3 r2 r1 r0, (r0 r1)^2 r2 (r0 r1)^4 r2 (r1 r0)^2, (r0 r1)^2 r2 r1 r2 (r0 r1)^3 (r2 r1)^2 r0 r1 r0, r0 (r1 r0 r1 r2)^2 (r0 r1)^5 (r2 r1 r0 r1)^2 r0, r0 (r1 r0 r1 r2)^2 r1 r2 (r0 r1)^4 r2 (r1 r2 r1 r0)^2 r1 r0, r0 (r1 r0 r1 r2)^3 (r0 r1)^4 (r2 r1 r0 r1)^3 r0, r0 (r1 r0 r1 r2)^3 r1 r2 (r0 r1)^3 r2 (r1 r2 r1 r0)^3 r1 r0, r0 (r1 r0 r1 r2)^3 r0 r1 r2 (r0 r1)^3 r2 r1 r0 (r2 r1 r0 r1)^3 r0, r0 (r1 r0 r1 r2)^3 r0 (r1 r2)^2 (r0 r1)^4 (r2 r1)^2 r0 (r2 r1 r0 r1)^3 r0, r0 (r1 r0 r1 r2)^4 (r0 r1)^3 r0 (r1 r0 r1 r2)^4 (r1 r0)^2, r0 (r1 r0 r1 r2)^4 r0 r1 r2 (r0 r1)^4 r2 r1 r0 (r2 r1 r0 r1)^4 r0, r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 (r0 r1)^3 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 r0, r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 r1 r2 (r0 r1)^4 r2 r1 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 r0, (r0 r1)^3 r2 (r0 r1)^4 r2 (r1 r0)^3, (r0 r1)^3 r2 r1 r2 (r0 r1)^3 (r2 r1)^2 (r0 r1)^2 r0, r0 r1 r0 (r1 r0 r1 r2)^2 (r0 r1)^5 (r2 r1 r0 r1)^2 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^2 r1 r2 (r0 r1)^4 r2 (r1 r2 r1 r0)^2 (r1 r0)^2, r0 r1 r0 (r1 r0 r1 r2)^3 (r0 r1)^4 (r2 r1 r0 r1)^3 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^3 r1 r2 (r0 r1)^3 r2 (r1 r2 r1 r0)^3 (r1 r0)^2, r0 r1 r0 (r1 r0 r1 r2)^3 r0 r1 r2 (r0 r1)^3 r2 r1 r0 (r2 r1 r0 r1)^3 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^3 r0 (r1 r2)^2 (r0 r1)^4 (r2 r1)^2 r0 (r2 r1 r0 r1)^3 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^4 (r0 r1)^3 r0 (r1 r0 r1 r2)^4 (r1 r0)^3, r0 r1 r0 (r1 r0 r1 r2)^4 r0 r1 r2 (r0 r1)^4 r2 r1 r0 (r2 r1 r0 r1)^4 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 (r0 r1)^3 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 r0 r1 r0, r0 r1 r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 r1 r2 (r0 r1)^4 r2 r1 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 r0 r1 r0, (r0 r1)^4 r2 (r0 r1)^4 r2 (r1 r0)^4, (r0 r1)^4 r2 r1 r2 (r0 r1)^3 r2 r1 r2 (r1 r0)^4, (r0 r1)^4 r2 r1 r0 r1 r2 (r0 r1)^5 (r2 r1 r0 r1)^2 (r0 r1)^2 r0, (r0 r1)^4 r2 r1 r0 (r1 r2)^2 (r0 r1)^4 r2 (r1 r2 r1 r0)^2 (r1 r0)^3, (r0 r1)^4 (r2 r1 r0 r1)^2 r2 (r0 r1)^4 (r2 r1 r0 r1)^3 (r0 r1)^2 r0, (r0 r1)^4 (r2 r1 r0 r1)^2 r2 r1 r2 (r0 r1)^3 r2 (r1 r2 r1 r0)^3 (r1 r0)^3, (r0 r1)^4 (r2 r1 r0 r1)^2 r2 r0 r1 r2 (r0 r1)^3 r2 r1 r0 (r2 r1 r0 r1)^3 (r0 r1)^2 r0, (r0 r1)^4 (r2 r1 r0 r1)^2 r2 r0 (r1 r2)^2 (r0 r1)^4 (r2 r1)^2 r0 (r2 r1 r0 r1)^3 (r0 r1)^2 r0, (r0 r1)^2 r0 (r1 r0 r1 r2)^4 (r0 r1)^3 r0 (r1 r0 r1 r2)^4 (r1 r0)^4, (r0 r1)^2 r0 (r1 r0 r1 r2)^4 r0 r1 r2 (r0 r1)^4 r2 r1 r0 (r2 r1 r0 r1)^4 (r0 r1)^2 r0, (r0 r1)^2 r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 (r0 r1)^3 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 (r0 r1)^2 r0, (r0 r1)^2 r0 (r1 r0 r1 r2)^4 (r0 r1 r2)^2 r1 r2 (r0 r1)^4 r2 r1 (r2 r1 r0)^2 (r2 r1 r0 r1)^4 (r0 r1)^2 r0";
	end);

InstallMethod(GreatRhombicosidodecahedron,
	[],
	function()
	local w, g, n;
	w:=ARP([60,3]);
	return w/"(a*b)^10, (r0*r1*r2*r1*r0*r1)^2*r2*r1*(r0*r1*r2)^2*(r0*r1)^4*r2*r1*r0*r1*r2*(r0*r1)^10*(r2*r1*r0*r1)^2*r0*r1*r0*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2, r2*(r0*r1)^4*r2, r2*r1*r2*(r0*r1)^6*r2*r1*r2, r2*r1*r0*r1*r2*(r0*r1)^10*r2*r1*r0*r1*r2, (r2*r1*r0*r1)^2*r2*(r0*r1)^4*(r2*r1*r0*r1)^2*r2, (r2*r1*r0*r1)^2*r0*r1*r2*(r0*r1)^6*r2*r1*r0*(r1*r0*r1*r2)^2, (r2*r1*r0*r1)^2*(r0*r1)^2*r2*r0*((r1*r0)^3*r1*r2)^2*r1*r0*r1*r2, (r2*r1*r0*r1)^2*(r0*r1)^3*r2*r0*r1*r0*((r1*r0)^4*r1*r2)^2*r1*r0*r1*r2, r0*r1*r2*(r0*r1)^6*r2*r1*r0, r0*r1*r2*(r1*r0)^2*r1*r2*r0*r1*r0*((r1*r0)^2*r1*r2)^2*r1*r0, (r0*r1*r2*r1*r0*r1)^2*r2*(r0*r1)^6*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1*r2*r1*r0*r1)^2*r2*r1*r0*r1*r2*(r0*r1)^4*r2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1*r2*r1*r0*r1)^2*r2*r1*(r0*r1*r2)^2*(r0*r1)^10*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1*r2*r1*r0*r1)^2*r2*r1*(r0*r1*r2)^2*(r0*r1)^2*r2*(r0*r1)^4*r2*r1*r0*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1*r2*r1*r0*r1)^2*r2*r1*(r0*r1*r2)^2*(r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^2*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1*r2*r1*r0*r1)^2*r2*r1*(r0*r1*r2)^2*(r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2, (r0*r1)^2*r2*(r0*r1)^4*r2*(r1*r0)^2, (r0*r1)^2*r2*r1*r2*(r0*r1)^6*(r2*r1)^2*r0*r1*r0, r0*(r1*r0*r1*r2)^2*(r0*r1)^10*(r2*r1*r0*r1)^2*r0, r0*(r1*r0*r1*r2)^3*(r0*r1)^4*(r2*r1*r0*r1)^3*r0, r0*(r1*r0*r1*r2)^2*(r1*r0)^2*r1*r2*(r0*r1)^6*r2*r1*r0*(r1*r0*r1*r2)^2*(r1*r0)^2, r0*(r1*r0*r1*r2)^2*(r1*r0)^3*r1*r2*r0*((r1*r0)^3*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^2, r0*(r1*r0*r1*r2)^2*(r1*r0)^4*r1*r2*r0*r1*r0*((r1*r0)^4*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^2, (r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^3, r0*((r1*r0)^2*r1*r2)^2*r0*r1*r0*((r1*r0)^2*r1*r2)^2*(r1*r0)^3, r0*((r1*r0)^2*r1*r2)^2*r1*r0*r1*r2*(r0*r1)^6*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2, r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*(r0*r1)^4*r2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2 , r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^10*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2, r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^2*r2*(r0*r1)^4*r2*r1*r0*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2, r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^2*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2, r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^2, (r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4, (r0*r1)^4*r2*r1*r2*(r0*r1)^6*r2*r1*r2*(r1*r0)^4, (r0*r1)^4*r2*r1*r0*r1*r2*(r0*r1)^10*(r2*r1*r0*r1)^2*(r0*r1)^2*r0, (r0*r1)^4*(r2*r1*r0*r1)^2*r2*(r0*r1)^4*(r2*r1*r0*r1)^3*(r0*r1)^2*r0, (r0*r1)^4*(r2*r1*r0*r1)^2*r0*r1*r2*(r0*r1)^6*r2*r1*r0*(r1*r0*r1*r2)^2*(r1*r0)^4, (r0*r1)^4*(r2*r1*r0*r1)^2*(r0*r1)^2*r2*r0*((r1*r0)^3*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^4, (r0*r1)^4*(r2*r1*r0*r1)^2*(r0*r1)^3*r2*r0*r1*r0*((r1*r0)^4*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^4, (r0*r1)^5*r2*(r0*r1)^6*r2*(r1*r0)^5, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*r0*r1*r0*((r1*r0)^2*r1*r2)^2*(r1*r0)^5, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*r1*r0*r1*r2*(r0*r1)^6*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*(r0*r1)^4*r2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^10*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^2*r2*(r0*r1)^4*r2*r1*r0*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^2*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^2*r0*((r1*r0)^2*r1*r2)^2*(r1*r0*r1*r2)^2*r0*r1*r2*(r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^4, (r0*r1)^6*r2*(r0*r1)^4*r2*(r1*r0)^6 , (r0*r1)^6*r2*r1*r2*(r0*r1)^6*r2*r1*r2*(r1*r0)^6, (r0*r1)^6*r2*r1*r0*r1*r2*(r0*r1)^10*r2*r1*r0*r1*r2*(r1*r0)^6, (r0*r1)^6*(r2*r1*r0*r1)^2*r2*(r0*r1)^4*(r2*r1*r0*r1)^2*r2*(r1*r0)^6, (r0*r1)^6*(r2*r1*r0*r1)^2*r0*r1*r2*(r0*r1)^6*r2*r1*r0*(r1*r0*r1*r2)^2*(r1*r0)^6, (r0*r1)^6*(r2*r1*r0*r1)^2*(r0*r1)^2*r2*r0*((r1*r0)^3*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^6, (r0*r1)^6*(r2*r1*r0*r1)^2*(r0*r1)^3*r2*r0*r1*r0*((r1*r0)^4*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^6, (r0*r1)^7*r2*(r0*r1)^6*r2*(r1*r0)^7, (r0*r1)^7*r2*(r1*r0)^2*r1*r2*r0*r1*r0*((r1*r0)^2*r1*r2)^2*(r1*r0)^7, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^2*(r0*r1)^6*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^3*(r0*r1)^4*r2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^10*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^2*r2*(r0*r1)^4*r2*r1*r0*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^2*(r1*r0*r2)^2*r1*r0*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^7*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4*(r2*r1*r0)^2*r1*r2*(r1*r0*r1*r2*r1*r0)^2*(r1*r0)^6, (r0*r1)^8*r2*(r0*r1)^4*r2*(r1*r0)^8, (r0*r1)^8*r2*r1*r2*(r0*r1)^6*r2*r1*r2*(r1*r0)^8, (r0*r1)^8*r2*r1*r0*r1*r2*(r0*r1)^10*r2*r1*r0*r1*r2*(r1*r0)^8, (r0*r1)^8*(r2*r1*r0*r1)^2*r2*(r0*r1)^4*(r2*r1*r0*r1)^2*r2*(r1*r0)^8, (r0*r1)^8*(r2*r1*r0*r1)^2*r0*r1*r2*(r0*r1)^6*r2*r1*r0*(r1*r0*r1*r2)^2*(r1*r0)^8, (r0*r1)^8*(r2*r1*r0*r1)^2*(r0*r1)^2*r2*r0*((r1*r0)^3*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^8, (r0*r1)^8*(r2*r1*r0*r1)^2*(r0*r1)^3*r2*r0*r1*r0*((r1*r0)^4*r1*r2)^2*r1*r0*r1*r2*(r1*r0)^8, (r0*r1)^9*r2*(r0*r1)^6*r2*(r1*r0)^9, (r0*r1)^9*r2*(r1*r0)^2*r1*r2*r0*r1*r0*((r1*r0)^2*r1*r2)^2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^2*(r0*r1)^6*(r2*r1*r0*r1)^2*r0*r1*r2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^3*(r0*r1)^4*(r2*r1*r0*r1)^3*r0*r1*r2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^10*r2*r1*r0*(r2*r1*r0*r1)^3*r0*r1*r2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^2*r2*(r0*r1)^4*r2*(r1*r0)^2*r2*r1*r0*(r2*r1*r0*r1)^3*r0*r1*r2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^3*r2*(r0*r1)^6*r2*(r1*r0)^3*r2*r1*r0*(r2*r1*r0*r1)^3*r0*r1*r2*(r1*r0)^9, (r0*r1)^9*r2*r1*r0*(r1*r0*r1*r2)^3*r0*r1*r2*(r0*r1)^4*r2*(r0*r1)^4*r2*(r1*r0)^4*r2*r1*r0*(r2*r1*r0*r1)^3*r0*r1*r2*(r1*r0)^9";
	end);
	
	
	
