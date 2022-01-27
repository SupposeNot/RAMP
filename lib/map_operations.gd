
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
