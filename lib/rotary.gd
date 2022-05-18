
#! @Chapter Maniplexes
#! @Section Rotary maniplexes and rotation groups

DeclareGlobalVariable("UNIVERSAL_ROT_FREE_GROUPS");


#! @Arguments n
#! Returns the rotation subgroup of the universal Coxeter Group of rank n.
DeclareOperation("UniversalRotationGroup", [IsInt]);

#! @Arguments sym
#! Returns the rotation subgroup of the Coxeter Group with Schlafli symbol sym.
DeclareOperation("UniversalRotationGroup", [IsList]);


#! @BeginGroup RotaryManiplex
#! @GroupTitle RotaryManiplex

#! @Arguments g
#! @Description In the first form, given a group g (which should be a string rotation group),
#! returns the rotary maniplex with that rotation group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
#! This function first checks whether g is a StringRotationGroup. Use `RotaryManiplexNC` to
#! bypass that check.
DeclareOperation("RotaryManiplex", [IsGroup]);

DeclareOperation("RotaryManiplexNC", [IsGroup]);

#! @Arguments sym
#! 
#! The second form returns the universal rotary maniplex (in fact, regular polytope)
#! with Schlafli symbol <A>sym</A>.
#!
DeclareOperation("RotaryManiplex", [IsList]);

#! @Arguments sym, relations
#! @Description The third form returns the rotary maniplex with the given Schlafli
#! symbol and with the given relations.
#! The relations are given by a string that refers to the generators
#! s1, s2, etc. This method automatically calls `InterpolatedString` on the relations, so
#! you may use \$variable in the relations, and it will be replaced with
#! the value of `variable` (but for global variables only).
#! @BeginExampleSession
#! gap> M := RotaryManiplex([4,4], "(s2^-1 s1)^6");;
#! @EndExampleSession
#! 
DeclareOperation("RotaryManiplex", [IsList, IsList]);


#! @Arguments sym, words, orders
#! @Description The fourth form takes the Schlafli Symbol <A>sym</A>, a list
#! of <A>words</A> in the generators r0 etc, and a list of <A>orders</A>.
#! It returns the rotary maniplex that is the quotient of the universal
#! maniplex with that Schlalfi Symbol by the relations obtained by setting each
#! <A>word[i]</A> to have order <A>order[i]</A>. This is primarily useful for
#! quickly constructing a family of related maniplexes.
DeclareOperation("RotaryManiplex", [IsList, IsList, IsList]);
#! @BeginExampleSession
#! gap> L := List([1..5], k -> RotaryManiplex([4,4], ["s1 s2^-1"], [k]));;
#! gap> List(L, IsPolytopal);
#! [ false, true, true, true, true ]
#! @EndExampleSession
#! 
#! In the last two forms, if the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
#! @EndGroup

#! @Arguments M
#! @Description The __enantiomorphic form__ of a rotary maniplex is
#! the same maniplex, but where we choose the new base flag to be
#! one of the flags that is adjacent to the original base flag.
#! If M is reflexible, then this choice has no effect.
#! Otherwise, if M is chiral, then the enantiomorphic form
#! gives us a different presentation for the rotation group.
DeclareOperation("EnantiomorphicForm", [IsManiplex]);