DeclareCategory("IsManiplex", IsObject);
DeclareCategory("IsRotaryManiplex", IsManiplex);
DeclareCategory("IsPoset", IsObject);

DeclareRepresentation("IsRotaryManiplexRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "rels", "size", "fvec"]);
DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
DeclareRepresentation("IsReflexibleManiplexAutGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "fvec"]);
DeclareRepresentation("IsManiplexQuotientRep", IsComponentObjectRep and IsAttributeStoringRep, ["parent", "subgroup"]);

# These are defined for convenience. They don't define new categories; they just combine information
# from multiple filters.
DeclareFilter("IsReflexibleManiplex");
DeclareFilter("IsRegularPolytope");
DeclareFilter("IsPolytope");

#Poset stuff
DeclareRepresentation("IsPosetOfFlags", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_by_rank"]);
DeclareRepresentation("IsPosetByElementsWParents", IsComponentObjectRep and IsAttributeStoringRep,["face_parent_pairs"]);
