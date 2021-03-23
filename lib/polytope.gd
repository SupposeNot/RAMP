# Basic constructors
DeclareGlobalVariable("UNIVERSAL_SGGI_FREE_GROUPS");
DeclareOperation("UniversalSggi", [IsInt]);
DeclareOperation("AbstractRegularPolytope", [IsGroup]);
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

# Orientability
DeclareProperty("IsOrientable", IsAbstractPolytope);
DeclareOperation("IsIOrientable", [IsAbstractPolytope, IsList]);
DeclareProperty("IsVertexBipartite", IsAbstractPolytope);
DeclareProperty("IsFacetBipartite", IsAbstractPolytope);

