# When writing maniplexes to a database, we use the separator "#" as something safe that will not appear in String(M).
BindGlobal("ManiplexDatabaseStringSeparator", "#");

# Right now this assumes a particular database format.
# We'll probably want to revisit this as we define new databases.
InstallMethod(DatabaseString,
	[IsManiplex],
	function(M)

	return JoinStringsWithSeparator([ 	String(M), 
										String(PetrieLength(M)), 
										String(Size(M))],
									ManiplexDatabaseStringSeparator);
	end);
	
InstallMethod(ManiplexFromDatabaseString,
	[IsString],
	function(maniplexString)
	local parameters, maniplex;
	parameters := SplitString(maniplexString, ManiplexDatabaseStringSeparator);
	maniplex := EvalString(parameters[1]);
	SetPetrieLength(maniplex, EvalString(parameters[2]));
	SetSize(maniplex, EvalString(parameters[3]));
	return maniplex;
	end);
	