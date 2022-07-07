
#! @Chapter Polytope Constructions and Operations
#! @Section Duality

#! @Arguments M
#! @Returns The maniplex that is dual to <A>M</A>.
DeclareOperation("Dual", [IsManiplex]);
#! @BeginExampleSession
#! gap> Dual(CrossPolytope(3));
#! Cube(3)
#! @EndExampleSession


#! @Arguments M
#! @Returns Whether this maniplex is isomorphic to its dual.
#! @Description Also works for IsPoset objects.
DeclareProperty("IsSelfDual", IsManiplex);
# ! @BeginExampleSession
# ! gap> IsSelfDual(Cube(3));
# ! false
# ! gap> IsSelfDual(Simplex(5));
# ! true
# ! @EndExampleSession

#! @Arguments M[, x]
#! @Description Returns whether this maniplex is "internally self-dual", as defined by Cunningham and Mixer in
#! <Cite Key="CunMix17"/> (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! That is, if <A>M</A> is self-dual, and the automorphism of AutomorphismGroup(M) that induces
#! the isomorphism between <A>M</A> and its dual is an inner automorphism.
#! If the optional group element <A>x</A> is given, then we first check whether <A>x</A> is a dualizing
#! automorphism of <A>M</A>, and if not, then we search the whole automorphism group of <A>M</A>.
DeclareProperty("IsInternallySelfDual", IsManiplex);
#! @BeginExampleSession
#! gap> IsInternallySelfDual(Simplex(4));
#! true
#! gap> IsInternallySelfDual(ARP([4,4], "h2^6"));
#! false
#! gap> IsInternallySelfDual(ARP([4,4], "h2^5"));
#! true
#! gap> IsInternallySelfDual(Cube(3));
#! false
#! gap> M := InternallySelfDualPolyhedron2(10,1);;
#! gap> g := AutomorphismGroup(M);;
#! gap> IsInternallySelfDual(M, (g.1*g.3*g.2)^6);
#! true
#! @EndExampleSession


#! @Arguments M
#! @Description Returns whether this maniplex is "externally self-dual", as defined by Cunningham and Mixer in
#! <Cite Key="CunMix17"/> (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! That is, if <A>M</A> is self-dual, and the automorphism of AutomorphismGroup(M) that induces
#! the isomorphism between <A>M</A> and its dual is an outer automorphism.
DeclareProperty("IsExternallySelfDual", IsManiplex);
#! @BeginExampleSession
#! gap> IsExternallySelfDual(Simplex(4));
#! false
#! gap> IsExternallySelfDual(ARP([4,4], "h2^6"));
#! true
#! gap> IsExternallySelfDual(ARP([4,4], "h2^5"));
#! false
#! gap> IsExternallySelfDual(Cube(3));
#! false
#! @EndExampleSession

#! @Arguments M
#! @Description Returns whether this rooted maniplex is "properly self-dual", meaning that 
#! there is an isomorphism of <A>M</A> to its dual that preserves the flag-orbits.
#! Note that all reflexible self-dual maniplexes are properly self-dual.
DeclareProperty("IsProperlySelfDual", IsManiplex);
#! @BeginExampleSession
#! gap> IsProperlySelfDual(Cube(4));
#! false
#! gap> IsProperlySelfDual(Simplex(4));
#! true
#! gap> IsProperlySelfDual(ARP([4,5,4]));
#! true
#! gap> IsProperlySelfDual(ToroidalMap44([1,2]));
#! false
#! gap> IsProperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1) (s2 s1^-1)^3, (s2 s3^-1) (s2^-1 s3)^3"));
#! true
#! gap> IsProperlySelfDual(RotaryManiplex([4,4,4],"(s2^-1 s1)^3 (s2 s1^-1), (s2 s3^-1) (s2^-1 s3)^3"));
#! false
#! @EndExampleSession

#! @BeginGroup
#! @GroupTitle Petrie Dual
#! @Arguments M
#! @Returns The Petrial (Petrie dual) of <A>M</A>.
#! @Description Note that this is not necessarily a polytope, even if <A>M</A> is.
#! When Rank(M) > 3, this is the "generalized Petrial" which essentially
#! replaces $r_{n-3}$ with $r_{n-3} r_{n-1}$ in the set of generators. 
#! 
#! Synonym for the command is `PetrieDual`.
DeclareAttribute("Petrial", IsManiplex);


DeclareSynonymAttr("PetrieDual", Petrial);

#! @BeginExampleSession
#! gap> Petrial(HemiCube(3));
#! ReflexibleManiplex([ 3, 3 ], "((r0 r2)*r1*r2)^3,z1^4")
#! @EndExampleSession
#! @EndGroup

#! @Arguments M
#! @Returns Whether this maniplex is isomorphic to its Petrial.
DeclareProperty("IsSelfPetrial", IsManiplex);
#! @BeginExampleSession
#! gap> s0 := ( 2, 3)( 4, 6)( 7,10)( 9,12)(11,14)(13,15);;
#! gap> s1 := ( 1, 2)( 3, 5)( 4, 7)( 6, 9)( 8,11)(10,13)(12,15)(14,16);;
#! gap> s2 := ( 2, 4)( 3, 6)( 5, 8)( 9,12)(11,15)(13,14);;
#! gap> poly := Group([s0,s1,s2]);;
#! gap> p:=ARP(poly);
#! regular 3-polytope
#! gap> IsSelfPetrial(p);
#! true
#! @EndExampleSession

#! @Arguments M
#! Returns a list of the __direct derivates__ of <A>M</A>, which are
#! the images of M under duality and Petriality. A 3-maniplex has up to
#! 6 direct derivates, and an n-maniplex with $n \geq 4$ has up to 8.
#! If the option 'polytopal' is set, then only returns those direct
#! derivates that are polytopal.
DeclareOperation("DirectDerivates", [IsManiplex]);
#! @BeginExampleSession
#! gap> DirectDerivates(Cube(3));
#! [ Cube(3), CrossPolytope(3), ReflexibleManiplex([ 6, 3 ], "z1^4"), 
#!   ReflexibleManiplex([ 6, 4 ], "z1^3"), ReflexibleManiplex([ 3, 6 ], "(r2*r1*r0)^4"), 
#!   ReflexibleManiplex([ 4, 6 ], "(r2*r1*r0)^3") ]
#! @EndExampleSession