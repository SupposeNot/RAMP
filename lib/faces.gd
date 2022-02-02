
#! @Chapter Combinatorics and Structure
#! @Section Faces

#! @Arguments M, i
#! Returns The number of <A>i</A>-faces of <A>M</A>.
DeclareOperation("NumberOfIFaces", [IsManiplex, IsInt]);
#! @BeginExampleSession
#! gap> NumberOfIFaces(Dodecahedron(),1);
#! 30
#! @EndExampleSession

#! @Arguments M
#! Returns the number of vertices of <A>M</A>.
DeclareAttribute("NumberOfVertices", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfVertices(HemiDodecahedron());
#! 10
#! @EndExampleSession

#! @Arguments M
#! Returns the number of edges of <A>M</A>.
DeclareAttribute("NumberOfEdges", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfEdges(HemiIcosahedron());
#! 15
#! @EndExampleSession

#! @Arguments M
#! Returns the number of facets of <A>M</A>.
DeclareAttribute("NumberOfFacets", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfFacets(Bk2l(4,6));
#! 4
#! @EndExampleSession

#! @Arguments M
#! Returns the number of ridges ((n-2)-faces) of <A>M</A>.
DeclareAttribute("NumberOfRidges", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfRidges(CrossPolytope(5));
#! 80
#! @EndExampleSession

#! @Arguments M
#! Returns the f-vector of <A>M</A>.
DeclareAttribute("Fvector", IsManiplex);
#! @BeginExampleSession
#! gap> Fvector(HemiIcosahedron());
#! [ 6, 15, 10 ]
#! @EndExampleSession

#! @BeginGroup Sections
#! @GroupTitle Section(s)

#! @Arguments M, j, i
#! `Section(M,j,i)` returns the section `F_j / F_i`, where `F_j` is the $j$-face of the base flag of <A>M</A> and
#! `F_i` is the $i$-face of the base flag.
DeclareOperation("Section", [IsManiplex, IsInt, IsInt]);


#! @Arguments M, j, i, k
#! `Section(M,j,i,k)` returns the section `F_j / F_i`, where `F_j` is the $j$-face of flag number <A>k</A> of <A>M</A> and
#! `F_i` is the $i$-face of the same flag.
DeclareOperation("Section", [IsManiplex, IsInt, IsInt, IsInt]);


#! @Arguments M, j, i
#! `Sections(M,j,i)` returns all sections of type `F_j / F_i`, where `F_j` is a $j$-face and `F_i` is an incident $i$-face.
DeclareOperation("Sections", [IsManiplex, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> Section(ToroidalMap44([2,2]),3,0);
#! Pgon(4)
#! gap> Section(Cuboctahedron(),2,-1,1);
#! Pgon(4)
#! gap> Section(Cuboctahedron(),2,-1,4);
#! Pgon(3)
#! gap> Sections(Cuboctahedron(),2,-1);
#! [ Pgon(4), Pgon(3) ]
#! @EndExampleSession
#! @EndGroup


#! @BeginGroup Facet
#! @GroupTitle Facet(s)
#! @Arguments M
#! Returns the facet-types of <A>M</A> (i.e. the maniplexes corresponding to the facets).
DeclareAttribute("Facets", IsManiplex);


#! @Arguments M, k
#! Returns the facet of <A>M</A> that contains the flag number <A>k</A> (that is, the maniplex corresponding to the facet).
DeclareOperation("Facet", [IsManiplex, IsInt]);


#! @Arguments M
#! Returns the facet of <A>M</A> that contains flag number 1 (that is, the maniplex corresponding to the facet).
DeclareAttribute("Facet", IsManiplex);
#! @BeginExampleSession
#! gap> Facets(Cuboctahedron());
#! [ Pgon(4), Pgon(3) ]
#! gap> Facet(Cuboctahedron(),4);
#! Pgon(3)
#! gap> Facet(Cuboctahedron());
#! Pgon(4)
#! @EndExampleSession
#! @EndGroup


#! @BeginGroup VertexFigure
#! @GroupTitle Vertex Figure(s)
#! @Arguments M
#! Returns the types of vertex-figures of <A>M</A> (i.e. the maniplexes corresponding to the vertex-figures).
DeclareAttribute("VertexFigures", IsManiplex);


#! @Arguments M, k
#! Returns the vertex-figure of <A>M</A> that contains flag number <A>k</A>.
DeclareOperation("VertexFigure", [IsManiplex, IsInt]);


#! @Arguments M
#! Returns the vertex-figure of <A>M</A> that contains the base flag.
DeclareAttribute("VertexFigure", IsManiplex);
#! @BeginExampleSession
#! gap> p:=Dual(SmallRhombicosidodecahedron());
#! Dual(3-maniplex)
#! gap> VertexFigures(p);
#! [ Pgon(5), Pgon(4), Pgon(3) ]
#! gap> VertexFigure(p,4);
#! Pgon(4)
#! gap> VertexFigure(p);
#! Pgon(5)
#! @EndExampleSession
#! @EndGroup

#! @Chapter Combinatorics and Structure
#! @Section Flatness

#! @BeginGroup IsFlat
#! @GroupTitle Flatness

#! @Arguments M
#! In the first form, returns true if every vertex of the maniplex <A>M</A> is incident
#! to every facet.
DeclareProperty("IsFlat", IsManiplex);


#! @Arguments M, i, j
#! In the second form, returns true if every i-face of the maniplex <A>M</A> is
#! incident to every j-face.
DeclareOperation("IsFlat", [IsManiplex, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> IsFlat(HemiCube(3));
#! true
#! gap> IsFlat(Simplex(3),0,2);
#! false
#! @EndExampleSession

#! @EndGroup



#! @Chapter Combinatorics and Structure
#! @Section Schlafli symbol

#! @Arguments M
#! Returns the Schlafli symbol of the maniplex <A>M</A>.
#! Each entry is either an integer or a set of integers,
#! where entry number i shows the polygons that we obtain
#! as sections of (i+1)-faces over (i-2)-faces.
DeclareAttribute("SchlafliSymbol", IsManiplex);
#! @BeginExampleSession
#! gap> SchlafliSymbol(SmallRhombicosidodecahedron());
#! [ [ 3, 4, 5 ], 4 ]
#! @EndExampleSession

#! @Arguments M
#! Sometimes when we make a maniplex, we know that the
#! Schlafli symbol must be a quotient of some symbol.
#! This most frequently happens because we start with a
#! maniplex with a given Schlafli symbol and then take a
#! quotient of it. In this case, we store the given
#! Schlafli symbol and call it a __pseudo-Schlafli symbol__
#! of <A>M</A>. Note that whenever we compute the actual
#! Schlafli symbol of <A>M</A>, we update the pseudo-Schlafli
#! symbol to match.
DeclareAttribute("PseudoSchlafliSymbol", IsManiplex);


#! @Arguments M
#! @Returns the the maniplex <A>M</A> is equivelar; i.e.,
#! whether its Schlafli Symbol consists of integers at each
#! position (no lists).
DeclareProperty("IsEquivelar", IsManiplex);
#! @BeginExampleSession
#! gap> IsEquivelar(Bk2l(6,18));
#! true
#! @EndExampleSession

#! @Arguments M
#! Returns whether the maniplex <A>M</A> has any sections that
#! are digons. We may eventually want to include maniplexes with
#! even smaller sections.
DeclareProperty("IsDegenerate", IsManiplex);
#! @BeginExampleSession
#! gap> F := FreeGroup("s0","s1","s2","s3");;
#! gap> s0 := F.1;;  s1 := F.2;;  s2 := F.3;;  s3 := F.4;;  
#! gap> rels := [ s0*s0, s1*s1, s2*s2, s3*s3, s0*s2*s0*s2, 
#! > s1*s2*s1*s2, s0*s3*s0*s3, s1*s3*s1*s3, 
#! > s2*s3*s2*s3*s2*s3*s2*s3, s0*s1*s0*s1*s0*s1*s0*s1*s0*s1 ];;
#! gap> poly := F / rels;;
#! gap> IsDegenerate(ARP(poly));
#! true
#! @EndExampleSession

#! @Arguments P
#! Returns whether the polytope <A>P</A> is tight, meaning that
#! it has a Schlafli symbol {k_1, ..., k_{n-1}} and has
#! 2 k_1 ... k_{n-1} flags, which is the minimum possible.
#! This property doesn't make any sense for non-polytopal maniplexes, which
#! aren't constrained by this lower bound.
DeclareProperty("IsTight", IsManiplex);
#! @BeginExampleSession
#! gap> IsTight(ToroidalMap44([2,0]));
#! true
#! @EndExampleSession


#! @Arguments M
#! @Returns The Euler characteristic of the maniplex, given by
#! $f_0 - f_1 + f_2 - \cdots + (-1)^{n-1} f_{n-1}$.
DeclareAttribute("EulerCharacteristic", IsManiplex);
#! @BeginExampleSession
#! gap> EulerCharacteristic(Bk2lStar(3,5));
#! -10
#! @EndExampleSession

#! @Arguments M
#! @Returns The genus of the given 3-maniplex.
DeclareAttribute("Genus", IsMapOnSurface);
#! @BeginExampleSession
#! gap> Genus(Bk2lStar(3,5));
#! 6
#! @EndExampleSession

#! @Arguments M
#! @Returns Whether the 3-maniplex <A>M</A> is spherical, which is to say, whether the Euler characteristic is
#! equal to 2. 
#! @Description
#! @BeginExampleSession
#! gap> IsSpherical(Simplex(3));
#! true
#! gap> IsSpherical(AbstractRegularPolytope([4,4],"h2^3"));
#! false
#! gap> IsSpherical(Pyramid(5));
#! true
#! gap> IsSpherical(CubicTiling(2));
#! false
#! @EndExampleSession
DeclareProperty("IsSpherical", IsManiplex);


#! @Arguments M
#! @Returns Whether the 4-maniplex <A>M</A> is locally spherical, which is to say, whether its facets and vertex-figures
#! are both spherical.
#! @Description
#! @BeginExampleSession
#! gap> IsLocallySpherical(Simplex(4));
#! true
#! gap> IsLocallySpherical(AbstractRegularPolytope([4,4,4]));
#! false
#! gap> IsLocallySpherical(CubicTiling(3));
#! true
#! gap> IsLocallySpherical(Pyramid(Cube(3)));
#! true
#! @EndExampleSession
DeclareProperty("IsLocallySpherical", IsManiplex);


#! @Arguments M
#! @Returns Whether the 3-maniplex <A>M</A> is toroidal, which is to say, whether the Euler characteristic is
#! equal to 0. 
#! @Description
#! @BeginExampleSession
#! gap> IsToroidal(Simplex(3));
#! false
#! gap> IsToroidal(AbstractRegularPolytope([4,4],"h2^3"));
#! true
#! gap> IsToroidal(Pyramid(5));
#! false
#! @EndExampleSession
DeclareProperty("IsToroidal", IsManiplex);


#! @Arguments M
#! @Returns Whether the 4-maniplex <A>M</A> is locally toroidal, which is to say, whether it has at least one toroidal facet
#! or vertex-figure, and all of its facets and vertex-figures are either spherical or toroidal.
#! @Description
#! @BeginExampleSession
#! gap> IsLocallyToroidal(Simplex(4));
#! false
#! gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,3],"(r0 r1 r2 r1)^2"));
#! true
#! gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,4],"(r0 r1 r2 r1)^2, (r1 r2 r3 r2)^2"));
#! true
#! @EndExampleSession
DeclareProperty("IsLocallyToroidal", IsManiplex);


