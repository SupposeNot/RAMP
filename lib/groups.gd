
#! @Chapter Groups
#! @Section Groups

#! @Arguments M
#! Returns the automorphism group of <A>M</A>.
#! This group is not guaranteed to be in any particular form.
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
#! Returns the connection group of <A>M</A> as a
#! permutation group. We may eventually allow other types
#! of connection groups.
DeclareAttribute("ConnectionGroup", IsManiplex);

#! @Arguments M
#! Returns the even-word subgroup of the connection group of <A>M</A> as a
#! permutation group. 
DeclareAttribute("EvenConnectionGroup", IsManiplex);

#! @Arguments M
#! Returns the rotation group of <A>M</A>.
#! This group is not guaranteed to be in any particular form.
DeclareAttribute("RotationGroup", IsManiplex);

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

#! @Arguments G
#! For an sggi <A>G</A>, returns whether the group is
#! a string C group. It does not check whether <A>G</A>
#! is an sggi.
DeclareOperation("IsStringC", [IsGroup]);
