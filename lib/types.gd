DeclareCategory("IsManiplex", IsObject);
DeclareCategory("IsRotaryManiplex", IsManiplex);
DeclareCategory("IsReflexibleManiplex", IsRotaryManiplex);

DeclareRepresentation("IsReflexibleManiplexWithRels", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "rels", "schlafli_symbol", "fvec"]);
DeclareRepresentation("IsReflexibleManiplexWithoutRels", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "schlafli_symbol", "fvec"]);
DeclareRepresentation("IsRotaryManiplexRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "rels", "size", "fvec"]);
DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
