DeclareCategory("IsManiplex", IsObject);
DeclareCategory("IsPoset", IsObject);

DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
DeclareRepresentation("IsReflexibleManiplexAutGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "fvec"]);
DeclareRepresentation("IsRotaryManiplexRotGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "fvec"]);
DeclareRepresentation("IsManiplexQuotientRep", IsComponentObjectRep and IsAttributeStoringRep, ["parent", "subgroup"]);

# These are defined for convenience. They don't define new categories; they just combine information
# from multiple filters.
DeclareFilter("IsReflexibleManiplex");
DeclareFilter("IsRotaryManiplex");
DeclareFilter("IsRegularPolytope");
DeclareFilter("IsPolytope");

#Poset stuff
DeclareRepresentation("IsPosetOfFlags", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_by_rank"]);
DeclareRepresentation("IsPosetByElementsWParents", IsComponentObjectRep and IsAttributeStoringRep,["face_parent_pairs"]);
