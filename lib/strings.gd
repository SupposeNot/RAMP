#! @Chapter Databases
#! @Section System internal representations

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

#! @Arguments str
#! @Returns IsString
#! @Description Given a string, replaces each instance of "\$variable" with
#! String(EvalString(variable)). Any character which cannot be used in a
#! variable name (such as spaces, commas, etc.) marks the end of the variable name.
#!
#! Note that, due to limitations with EvalString, only global variables can be
#! interpolated this way.
DeclareOperation("InterpolatedString", [IsString]);
#! @BeginExampleSession
#! gap> n := 5;;
#! gap> InterpolatedString("2 + 3 = $n");
#! "2 + 3 = 5"
#! gap> InterpolatedString("2 + 3 = $n, right?");
#! "2 + 3 = 5, right?"
#! gap> nn := 17;;
#! gap> InterpolatedString("$n and $nn are different");
#! "5 and 17 are different"
#! @EndExampleSession