
#! @Chapter Maniplex Constructors
#! @Section Reflexible Maniplexes


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
#! bypass that check. Note, however, that this function does not check
#! whether the generators are all nontrivial and pairwise distinct, and so the
#! output could be a pre-maniplex that is incorrectly labeled as a maniplex.
#! For most purposes, this is relatively harmless, since most functions treat
#! maniplexes and pre-maniplexes in roughly the same way.
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
#! @BeginExampleSession
#! gap> L := List([1..5], k -> ReflexibleManiplex([4,4], ["r0 r1 r2 r1"], [k]));;
#! gap> List(L, IsPolytopal);
#! [ false, true, true, true, true ]
#! @EndExampleSession
#! 
DeclareOperation("ReflexibleManiplex", [IsList, IsList, IsList]);
#! In the second and third forms, if the option set_schlafli is set, then we set the Schlafli symbol
#! to the one given. This may not be the correct Schlafli symbol, since
#! the relations may cause a collapse, so this should only be used if
#! you know that the Schlafli symbol is correct.
#! 

#! @Arguments name
#! @Description The fourth form accepts common names for reflexible 3-maniplexes that
#! specify the lengths of holes and zigzags. That is, "{p, q | h2, \ldots, hk\}_z1, ..., zL"
#! is the quotient of $\{p,q\}$ by the relations that make the 2-holes have length h2, ...,
#! and the 1-zigzags have length z1, etc.
#! @BeginExampleSession
#! gap> ReflexibleManiplex("{4,4 | 6}") = ToroidalMap44([6,0]);
#! true
#! gap> ReflexibleManiplex("{4,4}_4") = ToroidalMap44([2,2]);
#! true
#! gap> M := ReflexibleManiplex("{6,6 | 6,2}_4");;
#! gap> HoleLength(M,2);
#! 6
#! gap> HoleLength(M,3);
#! 2
#! gap> ZigzagLength(M,1);
#! 4
#! @EndExampleSession
DeclareOperation("ReflexibleManiplex", [IsString]);
#! The abbreviations `RefMan` and `RefManNC` are also available for all of these usages.
#! @EndGroup


DeclareSynonym("RefMan", ReflexibleManiplex);
DeclareSynonym("RefManNC", ReflexibleManiplexNC);

DeclareOperation("ReflexibleManiplexFromName", [IsString]);


#! @Arguments g
#! @Returns `IsPremaniplex`
#! @Description In the first form, we are given an Sggi <A>g</A>
#! and we return the reflexible premaniplex with that automorphism group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
#! @BeginExampleSession
#! gap> g := Group([(1,2), (2,3), (3,4)]);
#! gap> M := ReflexiblePremaniplex(g);
#! gap> M = Simplex(3);
#! true
#! @EndExampleSession
#! This function first checks whether g is an Sggi. Use `ReflexiblePremaniplexNC` to
#! bypass that check.
#!
DeclareOperation("ReflexiblePremaniplex", [IsGroup]);

DeclareOperation("ReflexiblePremaniplexNC", [IsGroup]);




#! @Section Maniplexes


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


#! @Arguments g
#! @Returns `IsPremaniplex`. 
#! @Description Given a group <A>g</A> we return the premaniplex with connection group <A>g</A>.  
#! This function first checks whether <A>group</A> is an Sggi. Use `PremaniplexNC` to
#! bypass that check.
DeclareOperation("Premaniplex",[IsGroup]);
#! Here we build a premaniplex with 3 flags.
#! @BeginExampleSession
#! gap> g:=Group((1,2),(2,3),(1,2));;
#! gap> Premaniplex(g);
#! Premaniplex of rank 3 with 3 flags
#! @EndExampleSession

DeclareOperation("PremaniplexNC",[IsGroup]);



#! @Arguments G
#! @Returns `IsPremaniplex`. 
#! @Description Given an edge labeled graph <A>G</A> we return the premaniplex with that graph.  
#! Note: We will assume (but not check) that the graph is a premaniplex, that is to say, we are assumging each vertex is incident with one edge of each label.
DeclareOperation("Premaniplex",[IsEdgeLabeledGraph]);
#! Here we have a premaniplex with 2 flags.
#! @BeginExampleSession
#! gap> gap> L:=[[[1,2],0], [[1,2],1], [[1],2], [[2],2]];;
#! gap> F:=EdgeLabeledGraphFromLabeledEdges(L);;
#! gap> Premaniplex(F);
#! Premaniplex of rank 3 with 2 flags
#! @EndExampleSession
