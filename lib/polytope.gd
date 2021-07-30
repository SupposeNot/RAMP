# Basic constructors
DeclareGlobalVariable("UNIVERSAL_SGGI_FREE_GROUPS");

#! @Chapter Basics
#! @Section Constructors

#! @BeginGroup UniversalSggi
#! @GroupTitle UniversalSggi

#! @Arguments n
#! In the first form, returns the universal Coxeter Group of rank n.
DeclareOperation("UniversalSggi", [IsInt]);

#! @Arguments sym
#! In the second form, returns the Coxeter Group with Schlafli symbol sym.
DeclareOperation("UniversalSggi", [IsList]);

#! @EndGroup

#! @Arguments symbol, relations
#! @Description Returns the sggi defined by the given Schlafli
#! symbol and with the given relations. The relations can be given
#! by a list of Tietze words or as a string of relators or relations
#! that involve r0 etc.
DeclareOperation("Sggi", [IsList, IsList]);

#! @Arguments g
#! @Description Given a group g (which should be a string C-group),
#! returns the reflexible maniplex with that automorphism group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
DeclareOperation("ReflexibleManiplex", [IsGroup]);

#! @Arguments sym
#! Returns the universal reflexible maniplex (in fact, regular polytope)
#! with Schlafli symbol <A>sym</A>.
DeclareOperation("ReflexibleManiplex", [IsList]);

#! @Arguments symbol, relations
#! @Description Returns the reflexible maniplex with the given Schlafli
#! symbol and with the given relations.
#! The formatting of the relations is quite flexible. All of the following work:
#! @BeginExampleSession
#! q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");
#! q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
#! p := ReflexibleManiplex([infinity], "r0 r1 r0 = r1 r0 r1");
#! @EndExampleSession
#! If the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
DeclareOperation("ReflexibleManiplex", [IsList, IsList]);

#! @Arguments name
#! @Description Returns the regular polytope with the given symbolic name.
#! Examples:
#! ReflexibleManiplex("{3,3,3}");
#! ReflexibleManiplex("{4,3}_3");
#! If the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
DeclareOperation("ReflexibleManiplex", [IsString]);

#! @Arguments G
#! Returns a maniplex with connection group <A>G</A>, where <A>G</A>
#! is assumed to be a permutation group on the flags.
DeclareOperation("Maniplex", [IsGroup]);

#! @Arguments M, G
#! Given a reflexible maniplex <A>M</A> and a subgroup <A>G</A> of the flag-stabilizer
#! of the base flag of <A>M</A>, returns the maniplex <A>M/G</A>.
DeclareOperation("Maniplex", [IsReflexibleManiplex, IsGroup]);

#! @Arguments F, inputs
#! Constructs a formal polytope, represented by an operation <A>F</A> and
#! a list of arguments <A>inputs</A>.
DeclareOperation("Maniplex", [IsFunction, IsList]);

#! @Arguments P
#! Returns a maniplex with poset <A>P</A>.
DeclareOperation("Maniplex", [IsPoset]);

#! @Arguments M
#! Returns whether the maniplex <A>M</A> is a polytope.
#! Currently only implemented for reflexible maniplexes.
DeclareProperty("IsPolytopal", IsManiplex);



#! @Chapter Combinatorics and Structure
#! @Section Basics

#! @Arguments M
#! Returns the number of flags of the maniplex <A>M</A>.
#! Synonym: `NumberOfFlags`.
DeclareAttribute("Size", IsManiplex);

DeclareSynonymAttr("NumberOfFlags", Size);

#! @Arguments M
#! Returns the rank of the maniplex <A>M</A>.
DeclareAttribute("RankManiplex", IsManiplex);


#! @Chapter Actions
#! @Section Faithfulness

#! @Arguments M
#! Returns whether the reflexible maniplex <A>M</A> is
#! vertex-faithful; i.e., whether the action of the automorphism
#! group on the vertices is faithful.
DeclareProperty("IsVertexFaithful", IsReflexibleManiplex);

#! @Arguments M
#! Returns whether the reflexible maniplex <A>M</A> is
#! facet-faithful; i.e., whether the action of the automorphism
#! group on the facets is faithful.
DeclareProperty("IsFacetFaithful", IsReflexibleManiplex);

#! @Arguments M
#! Returns the maximal vertex-faithful reflexible maniplex covered by <A>M</A>.
DeclareOperation("MaxVertexFaithfulQuotient", [IsReflexibleManiplex]);



DeclareGlobalFunction("MANIPLEX_STRING");