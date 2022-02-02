
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
DeclareOperation("Truncation", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Truncation(Simplex(3)));
#! [ [ 3, 6 ], 3 ]
#! gap> TruncatedTetrahedron()=Truncation(Simplex(3));
#! true
#! gap> Truncation(CrossPolytope(3))=TruncatedOctahedron();
#! true
#! gap> Truncation(Cube(3))=TruncatedCube();
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  snub_map
#! @Description Returns the snub of a given map; we require that the map have triangles as vertex figures.
DeclareOperation("Snub", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Snub(Dodecahedron())=SnubDodecahedron();
#! true
#! gap> Snub(Cube(3))=SnubCube();
#! true
#! gap> Snub(Simplex(3))=Icosahedron();
#! true
#! gap> Snub(CrossPolytope(3))=SnubCube();
#! true
#! gap> Snub(Dual(Cube(3)))=Reflection(Snub(Reflection(Cube(3))));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  chamfered_map
#! @Description Returns the map obtained from the chamfering operation described in <Cite Key="Rio14"/>
DeclareOperation("Chamfer", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> s0 := (4,5)(6,7)(8,9);;
#! gap> s1 := (2,6)(3,4)(5,7);;
#! gap> s2 := (1,2)(4,8)(5,9);;
#! gap> poly := Group([s0,s1,s2]);;
#! gap> p:=ARP(poly);;
#! gap> SchlafliSymbol(p);
#! [ 6, 3 ]
#! gap> ch:=Chamfer(p);
#! 3-maniplex with 432 flags
#! gap> SchlafliSymbol(ch);
#! [ 6, 3 ]
#! @EndExampleSession


#! @Arguments M
#! @Returns  Su1
#! @Description Returns the One-dimensional subdivision of a map, which replaces each edge with two edges. For more information on the oriented version of this, see <Cite Key="BerPisWil17"/>.
DeclareOperation("Subdivision1", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> m:=Subdivision1(Simplex(3));
#! 3-maniplex with 48 flags
#! gap> SchlafliSymbol(m);
#! [ 6, [ 2, 3 ] ]
#! @EndExampleSession


#! @Arguments M
#! @Returns  Su2
#! @Description Returns the two-dimensional subdivision of <A>M</A>.
DeclareOperation("Subdivision2", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Subdivision2(Cube(3)));
#! [ 3, [ 4, 6 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  barycentric_subdivision
#! @Description Gives the barycentric subdivision of <A>M</A>.
DeclareOperation("BarycentricSubdivision", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> m:=BarycentricSubdivision(Cube(3));;
#! gap> SchlafliSymbol(m);NumberOfFacets(m);
#! [ 3, [ 4, 6, 8 ] ]
#! 48
#! @EndExampleSession


#! @Arguments M
#! @Returns  leapfrog
#! @Description Gives the result of performing the leapfrog operation on a map on a surface
DeclareOperation("Leapfrog", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Leapfrog(Dodecahedron());
#! 3-maniplex with 360 flags
#! gap> SchlafliSymbol(last);
#! [ [ 5, 6 ], 3 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  combinatorial_map
#! @Description Gives the result of combinatorial operation on a map; this is equivalent to taking the dual of the barycentric subdivision.
DeclareOperation("CombinatorialMap", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> NumberOfEdges(Cube(3));
#! 12
#! gap> NumberOfEdges(CombinatorialMap(Cube(3)));
#! 72
#! @EndExampleSession

#! @Arguments M
#! @Returns  angle_map
#! @Description Returns the angle map of a map. This is equivalent to taking the dual of the medial.
DeclareOperation("Angle", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> NumberOfEdges(ToroidalMap44([3,0]));
#! 18
#! gap> NumberOfEdges(Angle(ToroidalMap44([3,0])));
#! 36
#! @EndExampleSession

#! @Arguments M
#! @Returns  gothic
#! @Description Returns the result of performing the gothic operation to a map. This is the same as taking the dual of the medial of the truncation of the map.
DeclareOperation("Gothic", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> m:=AbstractRegularPolytope([ 3, 6 ], "(r0 r1 r2)^6");;
#! gap> NumberOfEdges(m); NumberOfEdges(Gothic(m));
#! 27
#! 162
#! @EndExampleSession

#! @Section Conway polyhedron operator notation
#! We include here operators from Wikipedia that are not included above.
#! * `MapJoin`: Creates quadrilateral faces by placing a node in each face, and then the set of edges are formed by the nodes corresponding to incident vertex-face pairs. This is another name for `Angle`.
#! * `Ambo`: This is another name for `Medial`.
#! Additional functions are described below.


DeclareSynonym("Ambo", Medial);
DeclareSynonym("MapJoin", Angle);

#! @Arguments M
#! @Returns  reflection
#! @Description Reverses the orientation of a maniplex.
DeclareOperation("Reflection", [IsManiplex]);
#! @BeginExampleSession
#! gap> Gyro(Dual(m))=Reflection(Gyro(Reflection(m)));
#! true
#! gap> Reflection(m)=EnantiomorphicForm(m);
#! true
#! gap> Reflection(Truncation(m))=Truncation(EnantiomorphicForm(m));
#! true
#! @EndExampleSession



#! @Arguments M
#! @Returns  kis
#! @Description Returns the Kis of the map, which erects a pyramid over each of the faces.
DeclareOperation("Kis", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Kis(Cube(3));
#! 3-maniplex with 144 flags
#! gap> SchlafliSymbol(last);
#! [ 3, [ 4, 6 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  needle
#! @Description Performs the needle operation to the map: edges connect adjacent face centers, and face centers to incident vertices.
DeclareOperation("Needle", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Needle(Cube(3)));
#! [ 3, [ 3, 8 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  zip
#! @Description Returns the zip of the map.
DeclareOperation("Zip", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Zip(Cube(3))=TruncatedOctahedron();
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  ortho
#! @Description Returns the ortho of the map (this is the same as applying the join twice.).
DeclareOperation("Ortho", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Ortho(Cube(3)));
#! [ 4, [ 3, 4 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  expand
#! @Description Returns the expand of the map (this is the same as applying the ambo operation twice.).
DeclareOperation("Expand", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Expand(Cube(3))=SmallRhombicuboctahedron();
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  gyro
#! @Description Returns the gyro of the map.
DeclareOperation("Gyro", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Gyro(Dual(Cube(3)))=Gyro(Cube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  meta
#! @Description Constructs the meta of the given map. (This is the same as applying first the join, and then the kis operation to the map).
DeclareOperation("Meta", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Size(Cube(3))=NumberOfFacets(Meta(Cube(3)));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  bevel
#! @Description Constructs the bevel of a given map. (This is the same as truncating the ambo of a map.)
DeclareOperation("Bevel", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> CombinatorialMap(Cube(3))=Bevel(Cube(3));
#! true
#! @EndExampleSession


#! @Section Extended operations
#! A number of these were introduced by George Hart.

#! @Arguments M
#! @Returns  u
#! @Description Returns the subdivide (u) of <A>M</A>.
DeclareOperation("Subdivide", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Chamfer(Dual(Cube(3)))=Dual(Subdivide(Cube(3)));
#! true
#! gap> SchlafliSymbol(Subdivide(Cube(3)));
#! [ [ 3, 4 ], [ 3, 6 ] ]
#! @EndExampleSession


#! @Arguments M
#! @Returns  propeller
#! @Description Constructs the propeller of the map.
DeclareOperation("Propeller", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Dual(Propeller(Cube(3)))=Propeller(Dual(Cube(3)));
#! true
#! gap> Dual(Propeller(Dual(Cube(3))))=Propeller(Cube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns  loft
#! @Description Constructs the loft of the map.
DeclareOperation("Loft", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> NumberOfFacets(Loft(Cube(3)));
#! 30
#! gap> SchlafliSymbol(Loft(Cube(3)));
#! [ 4, [ 3, 6 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  quinto
#! @Description Constructs the quinto of the map.
DeclareOperation("Quinto", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Quinto(Cube(3)));
#! [ [ 4, 5 ], [ 3, 4 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  join-lace
#! @Description Constructs the join-lace of the map.
DeclareOperation("JoinLace", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(JoinLace(Cube(3)));
#! [ [ 3, 4 ], [ 4, 6 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  lace
#! @Description Constructs the lace of the map.
DeclareOperation("Lace", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Lace(Cube(3)));
#! [ [ 3, 4 ], [ 4, 9 ] ]
#! @EndExampleSession

#! @Arguments M
#! @Returns  stake
#! @Description Constructs the stake of the map.
DeclareOperation("Stake", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Stake(Cube(3)));
#! [ [ 3, 4 ], [ 3, 4, 9 ] ]
#! @EndExampleSession

