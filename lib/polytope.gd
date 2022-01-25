
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
DeclareOperation("ReflexibleManiplex", [IsGroup]);

DeclareOperation("ReflexibleManiplexNC", [IsGroup]);


#! @Arguments sym[, relations]
#! @Description The second form returns the universal reflexible maniplex
#! with Schlafli symbol <A>sym</A>. If the optional argument <A>relations</A> is given,
#! then we return the reflexible maniplex with the given defining relations.
#! The relations can be given by a list of Tietze words or as a string of relators 
#! or relations that involve r0 etc.
#! @BeginExampleSession
#! gap> q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");;
#! gap> q = ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
#! true
#! gap> p := ReflexibleManiplex([infinity], "r0 r1 r0 = r1 r0 r1");;
#! @EndExampleSession
#! If the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
DeclareOperation("ReflexibleManiplex", [IsList]);
#! @EndGroup

DeclareOperation("ReflexibleManiplex", [IsList, IsList]);




#! @Arguments G
#! @Returns `IsManiplex`
#! @Description Given a permutation group <A>G</A> on the set [1..N],
#! returns a maniplex with N flags with connection group <A>G</A>.
#! The output may not make sense if <A>G</A> is not an sggi.
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
DeclareProperty("IsVertexFaithful", IsReflexibleManiplex);
#! @BeginExampleSession
#! gap> IsVertexFaithful(HemiCube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Description Returns whether the reflexible maniplex <A>M</A> is
#! facet-faithful; i.e., whether the action of the automorphism
#! group on the facets is faithful.
DeclareProperty("IsFacetFaithful", IsReflexibleManiplex);
#! @BeginExampleSession
#! gap> IsFacetFaithful(HemiCube(3));
#! false
#! gap> IsFacetFaithful(Cube(3));
#! true
#! @EndExampleSession

#! @Arguments M
#! Returns the maximal vertex-faithful reflexible maniplex covered by <A>M</A>.
DeclareOperation("MaxVertexFaithfulQuotient", [IsReflexibleManiplex]);
#! @BeginExampleSession
#! gap> MaxVertexFaithfulQuotient(HemiCrossPolytope(3));
#! reflexible 3-maniplex
#! gap> SchlafliSymbol(last);
#! [ 3, 2 ]
#! @EndExampleSession


DeclareGlobalFunction("MANIPLEX_STRING");

DeclareProperty("SatisfiesWeakPathIntersectionProperty", IsManiplex);