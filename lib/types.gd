DeclareCategory("IsAbstractPolytope", IsObject);
DeclareCategory("IsAbstractRotaryPolytope", IsAbstractPolytope);
DeclareCategory("IsAbstractRegularPolytope", IsAbstractRotaryPolytope);

DeclareRepresentation("IsAbstractRegularPolytopeWithRels", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "rels", "schlafli_symbol", "fvec"]);
DeclareRepresentation("IsAbstractRegularPolytopeWithoutRels", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "rels", "schlafli_symbol", "fvec"]);
DeclareRepresentation("IsAbstractRotaryPolytopeRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "rels", "size", "fvec"]);
DeclareRepresentation("IsAbstractPolytopeConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
