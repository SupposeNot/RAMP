DeclareOperation("UniversalPolytope", [IsInt]);
DeclareOperation("FlatRegularPolyhedron", [IsInt, IsInt, IsInt, IsInt]);
DeclareOperation("QuotientPolytope", [IsAbstractPolytope, IsList]);
DeclareOperation("UniversalExtension", [IsAbstractPolytope]);
DeclareOperation("TrivialExtension", [IsAbstractPolytope]);
DeclareOperation("FlatExtension", [IsAbstractPolytope, IsInt]);
DeclareOperation("Amalgamate", [IsAbstractPolytope, IsAbstractPolytope]);
DeclareOperation("IDouble", [IsAbstractPolytope, IsList]);	
DeclareOperation("Medial", [IsAbstractPolytope]);
