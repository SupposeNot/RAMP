
#! @Chapter Groups
#! @Section Groups

#! @Arguments M
#! Returns the automorphism group of <A>M</A>.
#! This group is not guaranteed to be in any particular form. For particular permutation representations you should consider the various AutomorphismGroupOn... functions.
DeclareAttribute("AutomorphismGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! finitely presented group.
DeclareAttribute("AutomorphismGroupFpGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! permutation group.
DeclareAttribute("AutomorphismGroupPermGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! permutation group action on the flags of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnFlags", IsManiplex);

#! @Arguments M
#! Returns the connection group of <A>M</A> as a
#! permutation group. We may eventually allow other types
#! of connection groups.
#! Synonym: MonodromyGroup
DeclareAttribute("ConnectionGroup", IsManiplex);

DeclareSynonymAttr("MonodromyGroup", ConnectionGroup);

#! @Arguments M
#! Returns the even-word subgroup of the connection group of <A>M</A> as a
#! permutation group. 
DeclareAttribute("EvenConnectionGroup", IsManiplex);

#! @Arguments M
#! Returns the rotation group of <A>M</A>.
#! This group is not guaranteed to be in any particular form.
DeclareAttribute("RotationGroup", IsManiplex);

#! @Arguments M
#! Returns the chirality group of the rotary maniplex <A>M</A>.
#! This is the kernel of the group epimorphism from the
#! rotation group of <A>M</A> to the rotation group of its maximal
#! reflexible quotient. In particular, the chirality group
#! is trivial if and only if <A>M</A> is reflexible.
DeclareAttribute("ChiralityGroup", IsRotaryManiplex);


#! @Arguments M
#! For a reflexible maniplex <A>M</A>, returns the relators
#! needed to define its automorphism group as a quotient of
#! the string Coxeter group given by its Schlafli symbol.
#! Not particularly robust at the moment.
DeclareAttribute("ExtraRelators", IsReflexibleManiplex);

#! @Arguments M
#! For a reflexible maniplex <A>M</A>, returns the relators
#! needed to define its rotation group as a quotient of
#! the rotation group of a string Coxeter group given by its Schlafli symbol.
#! Not particularly robust at the moment.
DeclareAttribute("ExtraRotRelators", IsRotaryManiplex);
