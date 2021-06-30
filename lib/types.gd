DeclareCategory("IsManiplex", IsObject);

DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
DeclareRepresentation("IsReflexibleManiplexAutGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "fvec"]);
DeclareRepresentation("IsRotaryManiplexRotGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "fvec"]);
DeclareRepresentation("IsManiplexQuotientRep", IsComponentObjectRep and IsAttributeStoringRep, ["parent", "subgroup"]);
DeclareRepresentation("IsManiplexInstructionsRep", IsComponentObjectRep and IsAttributeStoringRep, ["operation", "attr_computers"]);

DeclareGlobalFunction("AddAttrComputer", [IsManiplex and IsManiplexInstructionsRep, IsAttribute, IsFunction]);
DeclareGlobalFunction("ComputeAttr", [IsManiplex and IsManiplexInstructionsRep, IsAttribute]);



# These are defined for convenience. They don't define new categories; they just combine information
# from multiple filters.
DeclareFilter("IsReflexibleManiplex");
DeclareFilter("IsRotaryManiplex");
DeclareFilter("IsRegularPolytope");
DeclareFilter("IsPolytope");




#Poset stuff
DeclareCategory("IsPoset", IsObject);
DeclareRepresentation("IsPosetOfFlags", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_by_rank"]);
DeclareRepresentation("IsPosetOfIndices", IsComponentObjectRep and IsAttributeStoringRep, ["domain"]); 
#Note... need to specify PartialOrder here
#DeclareRepresentation("IsPosetByElementsWParents", IsComponentObjectRep and IsAttributeStoringRep,["face_parent_pairs"]);
DeclareRepresentation("IsPosetOfElements", IsComponentObjectRep and IsAttributeStoringRep, ["elements_list"]); 
#Note... for this type also (usually) want to specify the partial order


#Face/Poset Element stuff
DeclareCategory("IsPosetElement",IsObject);
DeclareSynonym("IsFace",IsPosetElement);
DeclareRepresentation("IsElementOfPoset",IsAttributeStoringRep,[]);
DeclareSynonym("IsFaceOfPoset",IsElementOfPoset);
