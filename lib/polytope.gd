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

#! @Arguments g
#! @Description Given a group g (which should be a string C-group),
#! returns the abstract regular polytope with that automorphism group,
#! where the privileged generators are those returned by GeneratorsOfGroup(g).
DeclareOperation("ReflexibleManiplex", [IsGroup]);

DeclareOperation("ReflexibleManiplex", [IsList]);


#! @Arguments symbol, relations
#! @Description Returns an abstract regular polytope with the given Schlafli
#! symbol and with the given relations.
#! The formatting of the relations is quite flexible. All of the following work:
#! @BeginExampleSession
#! q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");
#! q := ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
#! p := ReflexibleManiplex([infinity], "r0 r1 r0 = r1 r0 r1");
#! @EndExampleSession
DeclareOperation("ReflexibleManiplex", [IsList, IsList]);

#! @Arguments name
#! @Description Returns the regular polytope with the given symbolic name.
#! Examples:
#! ReflexibleManiplex("{3,3,3}");
#! ReflexibleManiplex("{4,3}_3");
DeclareOperation("ReflexibleManiplex", [IsString]);

DeclareOperation("RotaryManiplex", [IsGroup]);
DeclareOperation("Maniplex", [IsGroup]);


DeclareProperty("IsPolytopal", IsManiplex);

# Combinatorics
DeclareAttribute("Size", IsManiplex);
DeclareSynonymAttr("NumberOfFlags", Size);
DeclareAttribute("RankManiplex", IsManiplex);
DeclareAttribute("SchlafliSymbol", IsManiplex);
DeclareOperation("ComputeSchlafliSymbol", [IsManiplex]);
DeclareProperty("IsTight", IsManiplex and IsPolytopal);
DeclareOperation("PetrieRelation", [IsInt, IsInt]);
DeclareAttribute("PetrieLength", IsReflexibleManiplex);
DeclareAttribute("HoleLength", IsReflexibleManiplex);
DeclareProperty("IsDegenerate", IsManiplex);

# Groups
DeclareAttribute("AutomorphismGroup", IsManiplex);
DeclareAttribute("ConnectionGroup", IsManiplex);
DeclareAttribute("RotationGroup", IsManiplex);
DeclareOperation("FindRels", [IsReflexibleManiplex and IsReflexibleManiplexWithoutRels]);
DeclareAttribute("ExtraRelators", IsReflexibleManiplex);
DeclareOperation("IsStringC", [IsGroup]);

# Faithfulness
DeclareProperty("IsVertexFaithful", IsReflexibleManiplex);
DeclareProperty("IsFacetFaithful", IsReflexibleManiplex);

# Covers / Quotients
DeclareOperation("MaxVertexFaithfulQuotient", [IsReflexibleManiplex]);
DeclareOperation("IsQuotientOf", [IsManiplex, IsManiplex]);
DeclareOperation("IsCoverOf", [IsManiplex, IsManiplex]);
DeclareOperation("IsIsomorphicTo", 	[IsManiplex, IsManiplex]);

# Symmetry Type Graphs
DeclareAttribute("SymmetryTypeGraph", IsManiplex);
DeclareAttribute("NumberOfFlagOrbits", IsManiplex);