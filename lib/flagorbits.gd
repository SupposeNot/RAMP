
#! @Chapter Actions
#! @Section Flag orbits

#! @Arguments M
#! Returns the Symmetry Type Graph of the maniplex <A>M</A>, encoded as
#! a permutation group on Rank(<A>M</A>) generators.
DeclareAttribute("SymmetryTypeGraph", IsManiplex);

#! @Arguments M
#! Returns the number of orbits of the automorphism group of <A>M</A>
#! on its flags.
DeclareAttribute("NumberOfFlagOrbits", IsManiplex);

#! @Arguments M
#! Returns one flag from each orbit under the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("FlagOrbitRepresentatives", IsManiplex);

#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is reflexible (has one flag orbit).
DeclareProperty("IsReflexible", IsManiplex);

#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is chrial.
DeclareProperty("IsChiral", IsManiplex);

#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is rotary; i.e., whether it is 
#! either reflexible or chiral.
DeclareProperty("IsRotary", IsManiplex);

#! @Arguments M
#! Returns a list of lists of flags, representing the orbits of flags under the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("FlagOrbits", IsManiplex);
