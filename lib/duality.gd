
#! @Chapter Constructions
#! @Section Duality

#! @Arguments M
#! @Returns The maniplex that is dual to <A>M</A>.
DeclareAttribute("Dual", IsManiplex);

#! @Arguments P
#! @Returns Whether this polytope is isomorphic to its dual.
DeclareProperty("IsSelfDual", IsManiplex);

#! @Arguments P
#! @Returns The Petrial (Petrie dual) of <A>P</A>.
#! Note that this is not necessarily a polytope.
DeclareAttribute("Petrial", IsManiplex);

DeclareSynonymAttr("PetrieDual", Petrial);

#! @Arguments P
#! @Returns Whether this polytope is isomorphic to its Petrial.
DeclareProperty("IsSelfPetrial", IsManiplex);

