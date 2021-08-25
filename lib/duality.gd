
#! @Chapter Constructions
#! @Section Duality

#! @Arguments M
#! @Returns The maniplex that is dual to <A>M</A>.
DeclareOperation("Dual", [IsManiplex]);

#! @Arguments M
#! @Returns Whether this maniplex is isomorphic to its dual.
#! @Description Also works for IsPoset objects.
DeclareProperty("IsSelfDual", IsManiplex);

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