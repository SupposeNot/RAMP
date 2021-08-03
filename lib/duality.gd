
#! @Chapter Constructions
#! @Section Duality

#! @Arguments M
#! @Returns The maniplex that is dual to <A>M</A>.
DeclareOperation("Dual", [IsManiplex]);

#! @Arguments P
#! @Returns Whether this polytope is isomorphic to its dual.
#! @Description Also works for IsPoset objects.
DeclareProperty("IsSelfDual", IsManiplex);

#! @Arguments P
#! @Returns The Petrial (Petrie dual) of <A>P</A>.
#! Note that this is not necessarily a polytope.
DeclareAttribute("Petrial", IsManiplex);

DeclareSynonymAttr("PetrieDual", Petrial);

#! @Arguments P
#! @Returns Whether this polytope is isomorphic to its Petrial.
DeclareProperty("IsSelfPetrial", IsManiplex);

#! @Arguments M
#! Returns a list of the __direct derivates__ of <A>M</A>, which are
#! the images of M under duality and Petriality.
#! If the option 'polytopal' is set, then only returns those direct
#! derivates that are polytopal.
DeclareOperation("DirectDerivates", [IsManiplex]);