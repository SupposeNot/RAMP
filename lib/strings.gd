
#! @Arguments M
#! @Returns String
#! @Description Given a maniplex <A>M</A>, returns a string representation of
#! <A>M</A> suitable for saving in a database for later retrieval.
DeclareOperation("DatabaseString", [IsManiplex]);

#! @Arguments maniplexString
#! @Returns IsManiplex
#! @Description Given a string <A>maniplexString</A>, representing a maniplex stored
#! in a database, returns the maniplex that is represented.
DeclareOperation("ManiplexFromDatabaseString", [IsString]);
