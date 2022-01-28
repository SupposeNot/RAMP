
#! @Chapter Maps On Surfaces
#! @Section Map properties

#! @Arguments M
#! @Returns  IsBool
#! @Description Determines whether a given maniplex is a map on a surface
DeclareAttribute("IsMapOnSurface", IsManiplex);
#! @BeginExampleSession
#! gap> Filtered([HemiCube(3),Cube(4),Icosahedron()],IsMapOnSurface);
#! [ HemiCube(3), Icosahedron() ]
#! @EndExampleSession


#! @Section Operations on maps

#! @Arguments map
#! @Returns  trunc_map
#! @Description Given a <A>map</A> on a surface, this function will return the truncation of <A>map</A>.
DeclareOperation("MapTruncation", [IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(MapTruncation(Simplex(3)));
#! [ [ 3, 6 ], 3 ]
#! gap> TruncatedTetrahedron()=MapTruncation(Simplex(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  snub_map
#! @Description Returns the snub of a given map; we require that the map have triangles as vertex figures.
DeclareOperation("MapSnub", [IsManiplex]);
#! @BeginExampleSession
#! gap> MapSnub(Dodecahedron())=SnubDodecahedron();
#! true
#! gap> MapSnub(Cube(3))=SnubCube();
#! true
#! gap> MapSnub(Simplex(3))=Icosahedron();
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  chamfered_map
#! @Description Returns the map obtained from the chamfering operation described in <Cite Key="Rio14"/>
DeclareOperation("MapChamfer", [IsManiplex]);
#! @BeginExampleSession
#! gap> s0 := (4,5)(6,7)(8,9);;
#! gap> s1 := (2,6)(3,4)(5,7);;
#! gap> s2 := (1,2)(4,8)(5,9);;
#! gap> poly := Group([s0,s1,s2]);;
#! gap> p:=ARP(poly);;
#! gap> SchlafliSymbol(p);
#! [ 6, 3 ]
#! gap> ch:=MapChamfer(p);
#! 3-maniplex with 432 flags
#! gap> SchlafliSymbol(ch);
#! [ 6, 3 ]
#! @EndExampleSession


#! @Arguments M
#! @Returns  Su1
#! @Description Returns the One-dimensional subdivision of a map, which replaces each edge with two edges. For more information on the oriented version of this, see <Cite Key="BerPisWil17"/>.
DeclareOperation("MapSubdivision1", [IsManiplex]);
#! @BeginExampleSession
#! gap> m:=MapSubdivision1(Simplex(3));
#! 3-maniplex with 48 flags
#! gap> SchlafliSymbol(m);
#! [ 6, [ 2, 3 ] ]
#! @EndExampleSession


#! @Arguments M
#! @Returns  Su2
#! @Description Returns the two-dimensional subdivision of <A>M</A>.
DeclareOperation("MapSubdivision2", [IsManiplex]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(MapSubdivision2(Cube(3)));
#! [ 3, [ 4, 6 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  barycentric_subdivision
#! @Description Gives the barycentric subdivision of <A>M</A>.
DeclareOperation("MapBarycentricSubdivision", [IsManiplex]);
#! @BeginExampleSession
#! gap> m:=MapBarycentricSubdivision(Cube(3));;
#! gap> SchlafliSymbol(m);NumberOfFacets(m);
#! [ 3, [ 4, 6, 8 ] ]
#! 48
#! @EndExampleSession
