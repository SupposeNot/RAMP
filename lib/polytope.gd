
#! @Chapter Maniplexes
#! @Section Constructors


#! @BeginGroup ReflexibleManiplex
#! @GroupTitle ReflexibleManiplex


#! @Arguments g
#! @Returns `IsReflexibleManiplex`
#! @Description In the first form, we are given an Sggi <A>g</A>
#! and we return the reflexible maniplex with that automorphism group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
#! @BeginExampleSession
#! gap> g := Group([(1,2), (2,3), (3,4)]);
#! gap> M := ReflexibleManiplex(g);
#! gap> M = Simplex(3);
#! true
#! @EndExampleSession
#! This function first checks whether g is an Sggi. Use `ReflexibleManiplexNC` to
#! bypass that check.
#!
DeclareOperation("ReflexibleManiplex", [IsGroup]);

DeclareOperation("ReflexibleManiplexNC", [IsGroup]);

#! @Arguments sym[, relations]
#! @Description The second form returns the universal reflexible maniplex
#! with Schlafli symbol <A>sym</A>. If the optional argument <A>relations</A> is given,
#! then we return the reflexible maniplex with the given defining relations.
#! The relations can be given by a list of Tietze words or as a string of relators 
#! or relations that involve r0 etc.
#! This method automatically calls `InterpolatedString` on the relations, so
#! you may use \$variable in the relations, and it will be replaced with
#! the value of `variable` (but for global variables only).
#! @BeginExampleSession
#! gap> q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");;
#! gap> q = ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
#! true
#! gap> p := ReflexibleManiplex([infinity], "r0 r1 r0 = r1 r0 r1");;
#! gap> n := 3;;
#! gap> Size(ReflexibleManiplex([4,4], "(r0 r1 r2 r1)^$n"));
#! 72
#! @EndExampleSession
DeclareOperation("ReflexibleManiplex", [IsList]);

DeclareOperation("ReflexibleManiplex", [IsList, IsList]);

#! @Arguments sym, words, orders
#! @Description The third form takes the Schlafli Symbol <A>sym</A>, a list
#! of <A>words</A> in the generators r0 etc, and a list of <A>orders</A>.
#! It returns the reflexible maniplex that is the quotient of the universal
#! maniplex with that Schlalfi Symbol by the relations obtained by setting each
#! <A>word[i]</A> to have order <A>order[i]</A>. This is primarily useful for
#! quickly constructing a family of related maniplexes.
DeclareOperation("ReflexibleManiplex", [IsList, IsList, IsList]);
#! @BeginExampleSession
#! gap> L := List([1..5], k -> ReflexibleManiplex([4,4], ["r0 r1 r2 r1"], [k]));;
#! gap> List(L, IsPolytopal);
#! [ false, true, true, true, true ]
#! @EndExampleSession
#! 
#! In the second and third forms, if the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
#! 
#! The abbreviations `RefMan` and `RefManNC` are also available for all of these usages.
#! @EndGroup


DeclareSynonym("RefMan", ReflexibleManiplex);
DeclareSynonym("RefManNC", ReflexibleManiplexNC);




#! @Arguments G
#! @Returns `IsManiplex`
#! @Description Given a permutation group <A>G</A> on the set [1..N],
#! returns a maniplex with N flags with connection group <A>G</A>.
#! This function first checks whether g is an Sggi. Use `ManiplexNC` to
#! bypass that check.
#! @BeginExampleSession
#! gap> G := Group([(1,2)(3,4)(5,6), (2,3)(4,5)(1,6)]);;
#! gap> M := Maniplex(G);
#! Pgon(3)
#! gap> c := ConnectionGroup(Cube(3));
#! <permutation group with 3 generators>
#! gap> Maniplex(c) = Cube(3);
#! true
#! @EndExampleSession
DeclareOperation("Maniplex", [IsPermGroup]);

DeclareOperation("ManiplexNC", [IsPermGroup]);


#! @Arguments M, H
#! @Returns `IsManiplex`
#! @Description Let <A>M</A> be a reflexible maniplex and let <A>H</A> be a subgroup
#! of AutomorphismGroup(<A>M</A>). This returns the maniplex <A>M/H</A>. This will be
#! reflexible if and only if <A>H</A> is normal.
#! For most purposes, it is probably easier to use QuotientManiplex, which takes a
#! string of relations as input instead of a subgroup.
#! The example below builds the map $\{4, 4\}_{(1,0), (0,2)}$.
#! @BeginExampleSession
#! gap> M := ReflexibleManiplex([4,4]);
#! CubicTiling(2)
#! gap> G := AutomorphismGroup(M);
#! <fp group of size infinity on the generators [ r0, r1, r2 ]>
#! gap> H := Subgroup(G, [G.1*G.2*G.3*G.2, (G.2*G.1*G.2*G.3)^2]);
#! Group([ r0*r1*r2*r1, (r1*r0*r1*r2)^2 ])
#! gap> M2 := Maniplex(M, H);
#! 3-maniplex
#! gap> Size(M2);
#! 16
#! @EndExampleSession
DeclareOperation("Maniplex", [IsReflexibleManiplex, IsGroup]);

#! @Arguments F, inputs
#! @Returns `IsManiplex`
#! @Description Constructs a formal maniplex, represented by an operation <A>F</A> and
#! a list of arguments <A>inputs</A>. By itself, this does not really _do_
#! anything -- it creates a maniplex object that only knows the operation <A>F</A> and 
#! the <A>inputs</A>. However, many polytope operations (such as Pyramid(M), Medial(M), etc)
#! use this construction as a base, and then add "attribute computers" that tell the formal
#! maniplex how to compute certain things in terms of properties of the base.
#! See AddAttrComputer for more information.
DeclareOperation("Maniplex", [IsFunction, IsList]);

#! @Arguments P
#! @Returns `IsManiplex`
#! @Description Constructs the maniplex from the given poset <A>P</A>.
#! This assumes that P actually defines a maniplex.
DeclareOperation("Maniplex", [IsPoset]);

#! @Arguments P
#! @Returns `IsManiplex`
#! @Description Constructs the maniplex from its flag graph <A>F</A>.
#! This assumes that F actually defines a maniplex.
DeclareOperation("Maniplex", [IsEdgeLabeledGraph]);


#! @Arguments M
#! @Description Returns whether the maniplex <A>M</A> is polytopal;
#! i.e., the flag graph of a polytope.
DeclareProperty("IsPolytopal", IsManiplex);



#! @Chapter Combinatorics and Structure
#! @Section Basics

#! @Arguments M
#! @Returns The number of flags of the maniplex <A>M</A>.
#! @Description Synonym: `NumberOfFlags`.
DeclareAttribute("Size", IsManiplex);

DeclareSynonymAttr("NumberOfFlags", Size);

#! @Arguments M
#! @Returns The rank of the maniplex <A>M</A>.
DeclareAttribute("RankManiplex", IsManiplex);


#! @Chapter Maniplex Properties
#! @Section Faithfulness

#! @Arguments M
#! @Description Returns whether the reflexible maniplex <A>M</A> is
#! vertex-faithful; i.e., whether the action of the automorphism
#! group on the vertices is faithful.
DeclareProperty("IsVertexFaithful", IsManiplex);
#! @BeginExampleSession
#! gap> IsVertexFaithful(HemiCube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Description Returns whether the reflexible maniplex <A>M</A> is
#! facet-faithful; i.e., whether the action of the automorphism
#! group on the facets is faithful.
DeclareProperty("IsFacetFaithful", IsManiplex);
#! @BeginExampleSession
#! gap> IsFacetFaithful(HemiCube(3));
#! false
#! gap> IsFacetFaithful(Cube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns Q
#! @Description Returns the maximal vertex-faithful reflexible maniplex covered by <A>M</A>.
DeclareOperation("MaxVertexFaithfulQuotient", [IsManiplex]);
#! @BeginExampleSession
#! gap> MaxVertexFaithfulQuotient(HemiCrossPolytope(3));
#! reflexible 3-maniplex
#! gap> SchlafliSymbol(last);
#! [ 3, 2 ]
#! @EndExampleSession


DeclareGlobalFunction("MANIPLEX_STRING");

#! @Arguments M
#! @Returns IsBool
#! @Description Tests for the weak path intersection property in a maniplex. Definitions and description available in <Cite Key="GleHub18"/>.
DeclareProperty("SatisfiesWeakPathIntersectionProperty", IsManiplex);


#! @Arguments m
#! @Description Returns whether the maniplex <A>m</A> is
#! faithful, as defined in "Polytopality of Maniplexes"; i.e., whether for each flag the intersection of all the i-faces containing that flag is just the flag itself.
DeclareOperation("IsFaithful", [IsManiplex]);
#! @BeginExampleSession
#! gap> IsFaithful(Cube(3));
#! true
#! gap> IsFaithful(ToroidalMap44([1,0]));
#! false
#! @EndExampleSession

