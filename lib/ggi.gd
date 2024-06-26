
#! @Chapter Group Constructors
#! @Section Ggis

#! @BeginGroup UniversalGgi
#! @GroupTitle UniversalGgi

#! @Arguments n
#! @Returns `IsFpGroup`
#! @Description In the first form, returns the universal Coxeter Group of rank n.
DeclareOperation("UniversalGgi", [IsInt]);

#! @Arguments cox
#! In the second form, returns the Coxeter Group with the given Coxeter diagram.
#! The diagram is given as a list with the order of r0 r1, r0 r2, ..., r0 r_{n-1}, r_1 r_2, etc. 
DeclareOperation("UniversalGgi", [IsList]);
#! @BeginExampleSession
#! gap> g := UniversalGgi(3);
#! <fp group of size infinity on the generators [ r0, r1, r2 ]>
#! gap> RelatorsOfFpGroup(g);
#! [ r0^2, r1^2, r2^2 ]
#! gap> q := UniversalGgi([3,3,3]);
#! <fp group on the generators [ r0, r1, r2 ]>
#! gap> RelatorsOfFpGroup(q);
#! [ r0^2, r1^2, r2^2, (r0*r1)^3, (r0*r2)^3, (r1*r2)^3 ]
#! @EndExampleSession
#! @EndGroup


#! @BeginGroup Ggi
#! @GroupTitle Ggi

#! @Arguments cox[, relations]
#! @Returns `IsFpGroup`
#! @Description Returns the ggi defined by the given Coxeter
#! diagram and with the given relations. The relations can be given
#! by a list of Tietze words or as a string of relators or relations
#! that involve r0 etc. If no relations are given, then returns
#! the universal ggi with the given Coxeter diagram.
#! This method automatically calls `InterpolatedString` on the relations, so
#! you may use \$variable in the relations, and it will be replaced with
#! the value of `variable` (but for global variables only).
#! @BeginExampleSession
#! gap> g := Ggi([3,3,3], "(r0 r1 r2 r1)^3");;
#! gap> Size(g);
#! 54
#! gap> n := 5;;
#! gap> Size(Ggi([3,3,3], "(r0 r1 r2 r1)^$n"));
#! 150
#! @EndExampleSession
DeclareOperation("Ggi", [IsList, IsList]);

#! @Arguments cox, words, orders
#! @Returns `IsFpGroup`
#! @Description The second form takes the Coxeter diagram <A>cox</A>, a list
#! of <A>words</A> in the generators r0 etc, and a list of <A>orders</A>.
#! It returns the ggi that is the quotient of the universal
#! ggi with that Coxeter diagram by the relations obtained by setting each
#! <A>word[i]</A> to have order <A>order[i]</A>. This is primarily useful for
#! quickly constructing a family of related Ggis.
DeclareOperation("Ggi", [IsList, IsList, IsList]);
#! @BeginExampleSession
#! gap> L := List([1..5], k -> Ggi([3,3,3], ["r0 r1 r2 r1"], [k]));;
#! gap> List(L, Size);
#! [ 6, 24, 54, 96, 150 ]
#! @EndExampleSession
#! @EndGroup

#! @Arguments cox[, relations]
#! @Returns `IsFpGroup`
#! @Description Returns the ggi with a cyclic diagram defined by the given orders,
#! and subject to the given relations.
#! <A>cox</A> gives the orders of r0 r1, r1 r2, ..., r_{n-1} r_0.
DeclareOperation("CyclicGgi", [IsList, IsList]);
#! @BeginExampleSession
#! gap> g := CyclicGgi([3,4,5,6]);
#! <fp group on the generators [ r0, r1, r2, r3 ]>
#! gap> RelatorsOfFpGroup(g);
#! [ r0^2, r1^2, r2^2, r3^2, (r0*r1)^3, (r0*r2)^2, (r0*r3)^6, (r1*r2)^4, (r1*r3)^2, (r2*r3)^5 ]
#! gap> g2 := CyclicGgi([3,4,3,4], "(r0 r1 r2 r3)^4");
#! <fp group on the generators [ r0, r1, r2, r3 ]>
#! gap> Size(g2);
#! 1440
#! @EndExampleSession

#! @Arguments g, str
#! @Returns the element of <A>g</A> with underlying word <A>str</A>.
#! @Description
#! This method automatically calls `InterpolatedString` on the relations, so
#! you may use \$variable in the relations, and it will be replaced with
#! the value of `variable` (but for global variables only).
#! @BeginExampleSession
#! gap> gap> g := Group((1,2), (2,3), (3,4), (1,4));;
#! gap> GgiElement(g, "r0 r3");
#! (1,2,4)
#! @EndExampleSession
DeclareOperation("GgiElement", [IsGroup, IsString]);

#! @Arguments g, str
#! @Returns the element of <A>g</A> with underlying word <A>str</A>, in a reduced form.
#! @Description This acts like GgiElement, except that the word is in reduced form.
#! Note that this is accomplished by calling SetReducedMultiplication on g. As a result,
#! further computations with g may be substantially slower.
#! This method automatically calls `InterpolatedString` on the relations, so
#! you may use \$variable in the relations, and it will be replaced with
#! the value of `variable` (but for global variables only).
DeclareOperation("SimplifiedGgiElement", [IsGroup, IsString]);
#! @BeginExampleSession
#! gap> g := Ggi([3,3,3], "(r0 r1 r2 r1)^4");;
#! gap> SimplifiedGgiElement(g, "(r0 r1)^4");
#! r0*r1
#! @EndExampleSession

