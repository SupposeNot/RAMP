


#! @Chapter Utility functions
#! @Section Utility functions


#! @Arguments args
#! @Description Calls 
DeclareInfoClass("InfoRamp");

#! @Arguments args
#! @Description Calls `Maniplex(args)` and marks the output as polytopal.
DeclareGlobalFunction("AbstractPolytope");

#! @Arguments args
#! @Description Calls `ReflexibleManiplex(args)` and marks the output as polytopal.
#! Also available as `ARP(args)`.
DeclareGlobalFunction("AbstractRegularPolytope");

DeclareSynonym("ARP", AbstractRegularPolytope);

#! @Arguments args
#! @Description Calls `RotaryManiplex(args)` and marks the output as polytopal.
DeclareGlobalFunction("AbstractRotaryPolytope");

#! @Arguments perm, k
#! Returns a new permutation obtained from <A>perm</A> by adding k
#! to each moved point.
DeclareGlobalFunction("TranslatePerm");


#! @Arguments perm, multiplier, offset
#! Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), 
#! ..., with <A>multiplier</A> terms, and returns the result.
DeclareGlobalFunction("MultPerm");

DeclareGlobalFunction("TranslateWord");

#! @Arguments rels, g
#! This helper function is used in several maniplex constructors.
#! Given a string <A>rels</A> that represents relations in an sggi, and an sggi g,
#! returns a list of elements of g represented by <A>rels</A>. 
#! @BeginExampleSession
#! g := AutomorphismGroup(CubicTiling(2));;
#! rels := "(r0 r1 r2 r1)^6";;
#! newrels := ParseStringCRels(rels, g);
#! [ (r0*r1*r2*r1)^6 ]
#! @EndExampleSession
#! For convenience, you may use z1, z2, etc and h1, h2, etc in relations,
#! where zj means r0 (r1 r2)^j and hj means r0 (r1 r2)^j-1 r1.
#! (That is, the former is the word corresponding to j-zigzags of a polyhedron,
#! and the latter corresponds to j-holes.)
DeclareGlobalFunction("ParseStringCRels");

#! @Arguments rels, g
#! This helper function is used in several maniplex constructors.
#! It is analogous to ParseStringCRels, but for rotation groups instead.
DeclareGlobalFunction("ParseRotGpRels");

DeclareGlobalFunction("StandardizeSggi");

#! @Arguments L, x
#! Given a list <A>L</A> and an object <A>x</A>, this calls
#! Append(L, x) if x is a list; otherwise it calls Add(L, x).
#! Note that since strings are internally represented as lists,
#! AddOrAppend(L, "foo") will append the characters 'f', 'o', 'o'.
DeclareGlobalFunction("AddOrAppend");
