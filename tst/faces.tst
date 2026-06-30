gap> IsSpherical(Simplex(3));
true
gap> IsSpherical(AbstractRegularPolytope([4,4],"h2^3"));
false
gap> IsSpherical(Pyramid(5));
true
gap> IsSpherical(CubicTiling(2));
false
gap> IsLocallySpherical(Simplex(4));
true
gap> IsLocallySpherical(AbstractRegularPolytope([4,4,4]));
false
gap> IsLocallySpherical(CubicTiling(3));
true
gap> IsLocallySpherical(Pyramid(Cube(3)));
true
gap> IsToroidal(Simplex(3));
false
gap> IsToroidal(AbstractRegularPolytope([4,4],"h2^3"));
true
gap> IsToroidal(Pyramid(5));
false
gap> IsLocallyToroidal(Simplex(4));
false
gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,3],"(r0 r1 r2 r1)^2"));
true
gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,4],"(r0 r1 r2 r1)^2, (r1 r2 r3 r2)^2"));
true
gap> NumberOfIFaces(Dodecahedron(),1);
30
gap> NumberOfVertices(HemiDodecahedron());
10
gap> NumberOfEdges(HemiIcosahedron());
15
gap> NumberOfFacets(Bk2l(4,6));
4
gap> NumberOfRidges(CrossPolytope(5));
80
gap> NumberOfChains(Pyramid(5), [0,2]);
20
gap> Fvector(HemiIcosahedron());
[ 6, 15, 10 ]
gap> Section(ToroidalMap44([2,2]),3,0);
Pgon(4)
gap> Section(Cuboctahedron(),2,-1,1);
Pgon(4)
gap> Section(Cuboctahedron(),2,-1,4);
Pgon(3)
gap> Sections(Cuboctahedron(),2,-1);
[ Pgon(4), Pgon(3) ]
gap> Facets(Cuboctahedron());
[ Pgon(4), Pgon(3) ]
gap> Facet(Cuboctahedron(),4);
Pgon(3)
gap> Facet(Cuboctahedron());
Pgon(4)
gap> p:=Dual(SmallRhombicosidodecahedron());;
gap> VertexFigures(p);
[ Pgon(5), Pgon(4), Pgon(3) ]
gap> VertexFigure(p,4);
Pgon(4)
gap> VertexFigure(p);
Pgon(5)
gap> VertDegrees(Pyramid(5));
[ [ 3, 5 ], [ 5, 1 ] ]
gap> VertDegrees(Kis(Cube(3)));
[ [ 4, 6 ], [ 6, 8 ] ]
gap> VertDegrees(Prism(5));
[ [ 3, 10 ] ]
gap> FaceSizes(Cube(3));
[ [ 4, 6 ] ]
gap> FaceSizes(Cube(4));
[ [ 4, 24 ] ]
gap> FaceSizes(Prism(Dodecahedron()));
[ [ 4, 30 ], [ 5, 24 ] ]
gap> m:=Cuboctahedron();;
gap> FacetList(m)[1];
[ 1, 2, 3, 5, 7, 10, 13, 18 ]
gap> VertexList(m)[1];
[ 1, 3, 4, 8, 9, 15, 17, 26 ]
gap> NFacesList(m,2)=FacetList(m);
true
gap> NFacesList(m,1)[1];
[ 1, 2, 4, 6 ]
gap> IsFlat(HemiCube(3));
true
gap> IsFlat(Simplex(3),0,2);
false
gap> SchlafliSymbol(SmallRhombicosidodecahedron());
[ [ 3, 4, 5 ], 4 ]
gap> M := ReflexibleManiplex([4,4], "(r0 r1)^2");;
gap> PseudoSchlafliSymbol(M);
[ 4, 4 ]
gap> SchlafliSymbol(M);
[ 2, 4 ]
gap> PseudoSchlafliSymbol(M);
[ 2, 4 ]
gap> IsEquivelar(Bk2l(6,18));
true
gap> IsDegenerate(ARP([5,2,4]));
true
gap> IsTight(ToroidalMap44([2,0]));
true
gap> EulerCharacteristic(Bk2lStar(3,10));
-10
gap> Genus(Bk2lStar(3,10));
6
