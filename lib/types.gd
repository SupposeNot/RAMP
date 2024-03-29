DeclareCategory("IsManiplex", IsObject);

DeclareRepresentation("IsManiplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "fvec"]);
DeclareRepresentation("IsReflexibleManiplexAutGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["aut_gp", "fvec"]);
DeclareRepresentation("IsRotaryManiplexRotGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["rot_gp", "fvec"]);
DeclareRepresentation("IsManiplexQuotientRep", IsComponentObjectRep and IsAttributeStoringRep, ["parent", "subgroup"]);
DeclareRepresentation("IsManiplexInstructionsRep", IsComponentObjectRep and IsAttributeStoringRep, ["operation", "attr_computers"]);
DeclareRepresentation("IsManiplexPosetRep", IsComponentObjectRep and IsAttributeStoringRep, ["poset", "fvec"]);
DeclareRepresentation("IsManiplexFlagGraphRep", IsComponentObjectRep and IsAttributeStoringRep, ["flaggraph", "fvec"]);

DeclareGlobalFunction("AddAttrComputer");
DeclareGlobalFunction("ComputeAttr");


# These are defined for convenience. They don't define new categories; they just combine information
# from multiple filters.
DeclareProperty("IsReflexibleManiplex", IsManiplex);
DeclareProperty("IsRotaryManiplex", IsManiplex);




#Poset stuff
DeclareCategory("IsPoset", IsObject);
DeclareRepresentation("IsPosetOfFlags", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_by_rank"]);
DeclareRepresentation("IsPosetOfAtoms", IsComponentObjectRep and IsAttributeStoringRep,["faces_list_of_atoms"]);
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


#Edge Labeled Graph stuff
DeclareCategory("IsEdgeLabeledGraph", IsObject);
DeclareRepresentation("IsEdgeLabeledGraphListRep", IsComponentObjectRep and IsAttributeStoringRep,["vertices","edges","labels"]);

#Premaniplex stuff
DeclareCategory("IsPremaniplex", IsObject);
DeclareRepresentation("IsPremaniplexConnGpRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "flags", "rank"]);
DeclareRepresentation("IsPremaniplexGraphRep", IsComponentObjectRep and IsAttributeStoringRep, ["conn_gp", "flags", "rank"]);

#Maps on surfaces stuff
DeclareProperty("IsMapOnSurface", IsManiplex);

#VoltageGraph stuff
DeclareCategory("IsVoltageGraph", IsObject);
DeclareRepresentation("IsVoltageGraphListRep", IsComponentObjectRep and IsAttributeStoringRep, ["voltage_group", "labels", "darts", "premaniplex", "voltages"]);
DeclareRepresentation("IsVoltageGraphPremaniplexRep", IsComponentObjectRep and IsAttributeStoringRep, ["voltage_group", "premaniplex", "voltages"]);
