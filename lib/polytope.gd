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
DeclareOperation("AbstractRegularPolytope", [IsGroup]);

#! @Arguments symbol, relations
#! @Description Returns an abstract regular polytope with the given Schlafli
#! symbol and with the given relations.
#! The formatting of the relations is quite flexible. All of the following work:
#! @BeginExampleSession
#! q := AbstractRegularPolytope([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");
#! q := AbstractRegularPolytope([4,3,4], "(r0 r1 r2)^3 = (r1 r2 r3)^3 = 1");
#! p := AbstractRegularPolytope([infinity], "r0 r1 r0 = r1 r0 r1");
#! @EndExampleSession
DeclareOperation("AbstractRegularPolytope", [IsList, IsString]);

DeclareOperation("AbstractRotaryPolytope", [IsGroup]);
DeclareOperation("AbstractPolytope", [IsGroup]);


# Combinatorics
DeclareAttribute("Size", IsAbstractPolytope);
DeclareSynonymAttr("NumberOfFlags", Size);
DeclareAttribute("RankPolytope", IsAbstractPolytope);
DeclareAttribute("SchlafliSymbol", IsAbstractPolytope);
DeclareOperation("ComputeSchlafliSymbol", [IsAbstractPolytope]);
DeclareProperty("IsTight", IsAbstractPolytope);
DeclareOperation("NumberOfIFaces", [IsAbstractPolytope, IsInt]);
DeclareAttribute("Fvector", IsAbstractPolytope);
DeclareAttribute("PetrieLength", IsAbstractRegularPolytope);
DeclareAttribute("HoleLength", IsAbstractRegularPolytope);

# Groups
DeclareAttribute("AutomorphismGroup", IsAbstractPolytope);
DeclareAttribute("ConnectionGroup", IsAbstractPolytope);
DeclareAttribute("RotationGroup", IsAbstractRotaryPolytope);
DeclareOperation("FindRels", [IsAbstractRegularPolytope and IsAbstractRegularPolytopeWithoutRels]);
DeclareAttribute("ExtraRelators", IsAbstractRegularPolytope);
DeclareOperation("IsStringC", [IsGroup]);

# Faithfulness
DeclareProperty("IsVertexFaithful", IsAbstractRegularPolytope);
DeclareProperty("IsFacetFaithful", IsAbstractRegularPolytope);

# Covers / Quotients
DeclareOperation("MaxVertexFaithfulQuotient", [IsAbstractRegularPolytope]);
DeclareOperation("IsQuotientOf", [IsAbstractPolytope, IsAbstractPolytope]);
DeclareOperation("IsCoverOf", [IsAbstractPolytope, IsAbstractPolytope]);
DeclareOperation("IsIsomorphicTo", 	[IsAbstractPolytope, IsAbstractPolytope]);

# Dualities
DeclareAttribute("DualPolytope", IsAbstractPolytope);
DeclareAttribute("PetrialPolytope", IsAbstractPolytope);
DeclareProperty("IsSelfDual", IsAbstractPolytope);

# Substructure
DeclareAttribute("Facets", IsAbstractPolytope);
DeclareAttribute("VertexFigures", IsAbstractPolytope);

# Symmetry Type Graphs
DeclareAttribute("SymmetryTypeGraph", IsAbstractPolytope);
DeclareAttribute("NumberOfFlagOrbits", IsAbstractPolytope);