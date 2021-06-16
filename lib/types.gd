DeclareCategory("IsManiplex", IsObject);
DeclareCategory("IsRotaryManiplex", IsManiplex);
DeclareCategory("IsReflexibleManiplex", IsRotaryManiplex);
DeclareCategory("IsPoset", IsObject);

DeclareRepresentation("IsReflexibleManiplexWithRels", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "rels", "schlafli_symbol", "fvec"]);
DeclareRepresentation("IsRotaryManiplexRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "rels", "size", "fvec"]);
DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);

#Poset stuff
DeclareRepresentation("IsPosetOfFlags", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_by_rank"]);
DeclareRepresentation("IsPosetByElementsWParents", IsComponentObjectRep and IsAttributeStoringRep,["face_parent_pairs"]);
