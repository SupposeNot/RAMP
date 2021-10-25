

DeclareGlobalVariable("UNIVERSAL_ROT_FREE_GROUPS");


#! @Arguments n
#! Returns the rotation subgroup of the universal Coxeter Group of rank n.
DeclareOperation("UniversalRotationGroup", [IsInt]);

#! @Arguments sym
#! Returns the rotation subgroup of the Coxeter Group with Schlafli symbol sym.
DeclareOperation("UniversalRotationGroup", [IsList]);

#! @Arguments g
#! @Description Given a group g (which should be a string rotation group),
#! returns the rotary maniplex with that rotation group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
DeclareOperation("RotaryManiplex", [IsGroup]);

#! @Arguments sym
#! Returns the universal rotary maniplex (in fact, regular polytope)
#! with Schlafli symbol <A>sym</A>.
DeclareOperation("RotaryManiplex", [IsList]);

#! @Arguments symbol, relations
#! @Description Returns the rotary maniplex with the given Schlafli
#! symbol and with the given relations.
#! The relations are given by a string that refers to the generators
#! s1, s2, etc. For example:
#! @BeginExampleSession
#! gap> M := RotaryManiplex([4,4], "(s2^-1 s1)^6");;
#! @EndExampleSession
#! If the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
DeclareOperation("RotaryManiplex", [IsList, IsList]);

#! @Arguments M
#! @Description The __enantiomorphic form__ of a rotary maniplex is
#! the same maniplex, but where we choose the new base flag to be
#! one of the flags that is adjacent to the original base flag.
#! If M is reflexible, then this choice has no effect.
#! Otherwise, if M is chiral, then the enantiomorphic form
#! gives us a different presentation for the rotation group.
DeclareOperation("EnantiomorphicForm", [IsRotaryManiplex]);