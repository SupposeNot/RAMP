
#! @Chapter Constructions
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

#! @Arguments M[, x]
#! @Description Returns whether this maniplex is "internally self-dual", as defined by Cunningham and Mixer in
#! <Cite Key="CunMix17"/> (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! That is, if <A>M</A> is self-dual, and the automorphism of AutomorphismGroup(M) that induces
#! the isomorphism between <A>M</A> and its dual is an inner automorphism.
#! If the optional group element <A>x</A> is given, then we first check whether <A>x</A> is a dualizing
#! automorphism of <A>M</A>, and if not, then we search the whole automorphism group of <A>M</A>.
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
DeclareProperty("IsInternallySelfDual", IsReflexibleManiplex);

#! @Arguments M
#! @Description Returns whether this maniplex is "externally self-dual", as defined by Cunningham and Mixer in
#! <Cite Key="CunMix17"/> (<URL> https://doi.org/10.11575/cdm.v12i2.62785</URL>). 
#! That is, if <A>M</A> is self-dual, and the automorphism of AutomorphismGroup(M) that induces
#! the isomorphism between <A>M</A> and its dual is an outer automorphism.
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
DeclareProperty("IsExternallySelfDual", IsReflexibleManiplex);


#! @Arguments M
#! @Returns The Petrial (Petrie dual) of <A>M</A>.
#! Note that this is not necessarily a polytope, even if <A>M</A> is.
#! When Rank(M) > 3, this is the "generalized Petrial" which essentially
#! replaces $r_{n-3}$ with $r_{n-3} r_{n-1}$ in the set of generators.
DeclareAttribute("Petrial", IsManiplex);

DeclareSynonymAttr("PetrieDual", Petrial);

#! @Arguments M
#! @Returns Whether this maniplex is isomorphic to its Petrial.
DeclareProperty("IsSelfPetrial", IsManiplex);

#! @Arguments M
#! Returns a list of the __direct derivates__ of <A>M</A>, which are
#! the images of M under duality and Petriality. A 3-maniplex has up to
#! 6 direct derivates, and an n-maniplex with $n \geq 4$ has up to 8.
#! If the option 'polytopal' is set, then only returns those direct
#! derivates that are polytopal.
DeclareOperation("DirectDerivates", [IsManiplex]);