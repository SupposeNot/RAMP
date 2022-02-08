


#! @Chapter Utility Functions
#! @Section System


#! @Description The InfoClass for the Ramp package.
DeclareInfoClass("InfoRamp");

#! @Section Polytopes
#! @Arguments args
#! @Description Calls `Maniplex(args)` and verifies whether the output is polytopal.
#! If not, this throws an error. Use `AbstractPolytopeNC` to assume that the output
#! is polytopal and mark it as such.
DeclareGlobalFunction("AbstractPolytope");
#! @BeginExampleSession
#! gap> AbstractPolytope(Group([ (1,2)(3,4)(5,6)(7,8)(9,10), (1,10)(2,3)(4,5)(6,7)(8,9) ]));
#! Pgon(5)
#! @EndExampleSession

DeclareGlobalFunction("AbstractPolytopeNC");

#! @Arguments args
#! @Description Calls `ReflexibleManiplex(args)` and verifies whether the output is polytopal.
#! If not, this throws an error. Use `AbstractRegularPolytopeNC` to assume that the output
#! is polytopal and mark it as such.
#! Also available as `ARP(args)` and `ARPNC(args)`.
DeclareGlobalFunction("AbstractRegularPolytope");

DeclareSynonym("ARP", AbstractRegularPolytope);
#! @BeginExampleSession
#! gap> Pgon(5)=AbstractRegularPolytope(Group([(2,3)(4,5),(1,2)(3,4)]));
#! true
#! @EndExampleSession

DeclareGlobalFunction("AbstractRegularPolytopeNC");
DeclareSynonym("ARPNC", AbstractRegularPolytopeNC);


#! @Arguments args
#! @Description Calls `RotaryManiplex(args)` and verifies whether the output is polytopal.
#! If not, this throws an error. Use `AbstractRotaryPolytopeNC` to assume that the output
#! is polytopal and mark it as such.
DeclareGlobalFunction("AbstractRotaryPolytope");

DeclareGlobalFunction("AbstractRotaryPolytopeNC");


#! @Section Permutations

#! @Arguments perm, k
#! Returns a new permutation obtained from <A>perm</A> by adding k
#! to each moved point.
DeclareGlobalFunction("TranslatePerm");


#! @Arguments perm, multiplier, offset
#! Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), 
#! ..., with <A>multiplier</A> terms, and returns the result.
DeclareGlobalFunction("MultPerm");

#! @Arguments perm1, perm2
#! @Returns Permutation
#! @Description This attempts to construct a permutation that we would
#! write as perm1 ... perm2. Probably it is clearest to look at some examples:
#! @BeginExampleSession
#! gap> PermFromRange((1,2), (9,10));
#! (1,2)(3,4)(5,6)(7,8)(9,10)
#! gap> PermFromRange((1,3), (13,15));
#! (1,3)(4,6)(7,9)(10,12)(13,15)
#! gap> PermFromRange((2,3,4), (8,9,10));
#! (2,3,4)(5,6,7)(8,9,10)
#! @EndExampleSession
DeclareGlobalFunction("PermFromRange");

#! @Section Words on relations

DeclareGlobalFunction("TranslateWord");

#! @Arguments rels, g
#! @Returns a list of relators
#! @Description This helper function is used in several maniplex constructors.
#! Given a string <A>rels</A> that represents relations in an sggi, and an sggi g,
#! returns a list of elements in the free group of g represented by <A>rels</A>.
#! These can then be used to form a quotient of g.
#! @BeginExampleSession
#! gap> g := AutomorphismGroup(CubicTiling(2));;
#! gap> rels := "(r0 r1 r2 r1)^6";;
#! gap> newrels := ParseStringCRels(rels, g);
#! [ (r0*r1*r2*r1)^6 ]
#! gap> newrels[1] in FreeGroupOfFpGroup(g);
#! true
#! gap> g2 := FactorGroupFpGroupByRels(g, newrels);
#! <fp group on the generators [ r0, r1, r2 ]>
#! @EndExampleSession
#! For convenience, you may use z1, z2, etc and h1, h2, etc in relations,
#! where zj means r0 (r1 r2)^j (the "j-zigzag" word) and hj means r0 (r1 r2)^j-1 r1
#! (the "j-hole" word).
DeclareGlobalFunction("ParseStringCRels");

#! @Arguments rels, g
#! @Description This helper function is used in several maniplex constructors.
#! It is analogous to ParseStringCRels, but for rotation groups instead.
DeclareGlobalFunction("ParseRotGpRels");

DeclareGlobalFunction("StandardizeSggi");

#! @Arguments L, x
#! @Description Given a list <A>L</A> and an object <A>x</A>, this calls
#! Append(L, x) if x is a list; otherwise it calls Add(L, x).
#! Note that since strings are internally represented as lists,
#! AddOrAppend(L, "foo") will append the characters 'f', 'o', 'o'.
#! @BeginExampleSession
#! gap> L := [1, 2, 3];;
#! gap> AddOrAppend(L, 4);
#! gap> L;
#! [1, 2, 3, 4]
#! gap> AddOrAppend(L, [5, 6]);
#! gap> L;
#! [1, 2, 3, 4, 5, 6];
#! @EndExampleSession
DeclareGlobalFunction("AddOrAppend");

#! @Arguments posetOp
#! @Description Given a poset operation, creates a bare-bones maniplex
#! operation that delegates to the poset operation.
#! @BeginExampleSession
#! gap> myjoin := WrappedPosetOperation(JoinProduct);
#! function( arg... ) ... end
#! gap> M := myjoin(Pgon(4), Vertex());
#! 3-maniplex
#! gap> M = Pyramid(4);
#! true
#! @EndExampleSession
#! Usually, you will want to eventually create a fuller-featured wrapper
#! of the poset operation -- one that can infer more information from its
#! arguments. But this method is a good way to quickly test whether a poset
#! operation works on maniplexes the way one expects.
DeclareGlobalFunction("WrappedPosetOperation");