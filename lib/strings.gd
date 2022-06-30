#! @Chapter Databases
#! @Section System internal representations

#! @Arguments M
#! @Returns String
#! @Description Given a maniplex <A>M</A>, returns a string representation of
#! <A>M</A> suitable for saving in a database for later retrieval.
#! This works for any maniplex such that String(<A>M</A>) contains defining
#! information for <A>M</A> - otherwise the output may not be so useful.
DeclareOperation("DatabaseString", [IsManiplex]);
#! @BeginExampleSession
#! gap> DatabaseString(Cube(3));
#! "Cube(3)#6#48"
#! gap> M := ReflexibleManiplex(Group((1,2),(2,3),(3,4)));;
#! gap> DatabaseString(M);
#! "<object>#4#24"
#! @EndExampleSession

#! @Arguments maniplexString
#! @Returns IsManiplex
#! @Description Given a string <A>maniplexString</A>, representing a maniplex stored
#! in a database, returns the maniplex that is represented. In particular,
#! ManiplexFromDatabaseString(DatabaseString(M)) is isomorphic to M if DatabaseString(M)
#! contains defining information for M.
DeclareOperation("ManiplexFromDatabaseString", [IsString]);
#! @BeginExampleSession
#! gap> ManiplexFromDatabaseString("Cube(3)#6#48") = Cube(3);
#! true
#! gap> M := ReflexibleManiplex(Group((1,2),(2,3),(3,4)));;
#! gap> ManiplexFromDatabaseString(DatabaseString(M));
#! Syntax error: expression expected in stream:1
#! _EVALSTRINGTMP:=<object>;
#! @EndExampleSession


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