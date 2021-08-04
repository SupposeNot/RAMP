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
	
InstallGlobalFunction(MANIPLEX_STRING,
	function(p)
	local str;
	str := "";
	if IsReflexibleManiplex(p) then
		if HasIsPolytopal(p) and IsPolytopal(p) then
			Append(str, "regular ");
		else
			Append(str, "reflexible ");
		fi;
	fi;
	
	if HasIsPolytopal(p) and not(IsPolytopal(p)) then
		Append(str, "nonpolytopal ");
	fi;
	
	Append(str, String(Rank(p)));
	if HasIsPolytopal(p) and IsPolytopal(p) then
		Append(str, "-polytope");
	else
		Append(str, "-maniplex");
	fi;
	if HasSchlafliSymbol(p) then 
		Append(str, Concatenation(" of type ", String(SchlafliSymbol(p))));
	fi;
	if HasSize(p) then 
		Append(str, Concatenation(" with ", String(Size(p)), " flags")); 
	fi;
	return str;
	end);
	
InstallMethod(DisplayString,
	[IsManiplex],
	function(p)
	return MANIPLEX_STRING(p);
	end);
	
	
InstallMethod(String,
	[IsManiplex],
	function(M)
	return MANIPLEX_STRING(M);
	end);
	

	