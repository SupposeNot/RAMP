
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


DeclareGlobalFunction("TranslatePerm");
DeclareGlobalFunction("MultPerm");

DeclareGlobalFunction("TranslateWord");
DeclareGlobalFunction("ParseStringCRels");
DeclareGlobalFunction("ParseRotGpRels");
DeclareGlobalFunction("StandardizeSggi");

DeclareGlobalFunction("IsSameRank");

#! @Arguments L, x
#! Given a list <A>L</A> and an object <A>x</A>, this calls
#! Append(L, x) if x is a list; otherwise it calls Add(L, x).
#! Note that since strings are internally represented as lists,
#! AddOrAppend(L, "foo") will append the characters 'f', 'o', 'o'.
DeclareGlobalFunction("AddOrAppend");
