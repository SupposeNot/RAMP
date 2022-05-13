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
	
InstallOtherMethod(DatabaseString,
	[IsManiplex, IsList],
	function(M, attrList)
	local attrStrings;
	attrStrings := [Chomp(String(M))];
	Append(attrStrings, List(attrList, attr -> String(attr(M))));
	return JoinStringsWithSeparator(attrStrings, ManiplexDatabaseStringSeparator);
	end);
	
InstallMethod(ManiplexFromDatabaseString,
	[IsString],
	function(maniplexString)
	local parameters, maniplex;
	parameters := SplitString(maniplexString, ManiplexDatabaseStringSeparator);
	
	# The next line tells later constructors not to bother checking whether the output is well-defined.
	# e.g. a call to AbstractRegularPolytope(stuff) acts like AbstractRegularPolytopeNC(stuff)
	PushOptions(rec(no_check := true));
	
	maniplex := EvalString(parameters[1]);
	SetPetrieLength(maniplex, EvalString(parameters[2]));
	SetSize(maniplex, EvalString(parameters[3]));

	PopOptions();

	return maniplex;
	
	end);
	
InstallOtherMethod(ManiplexFromDatabaseString,
	[IsString, IsList],
	function(maniplexString, attrList)
	local parameters, maniplex, attr, i;
	parameters := SplitString(maniplexString, ManiplexDatabaseStringSeparator);

	# The next line tells later constructors not to bother checking whether the output is well-defined.
	# e.g. a call to AbstractRegularPolytope(stuff) acts like AbstractRegularPolytopeNC(stuff)
	PushOptions(rec(no_check := true));

	maniplex := EvalString(parameters[1]);
	i := 2;
	for attr in attrList do
		Setter(attr)(maniplex, EvalString(parameters[i]));
		i := i + 1;
	od;

	PopOptions();

	return maniplex;
	end);
	
InstallGlobalFunction(MANIPLEX_STRING,
	function(p)
	local str;
	str := "";
	if HasIsReflexibleManiplex(p) and IsReflexibleManiplex(p) then
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
	local str, prop, att;
	str := MANIPLEX_STRING(p);
	Append(str, "\n");
	for prop in KnownPropertiesOfObject(p) do
		Append(str, prop);
		Append(str, ": ");
		Append(str, String(EvalString(prop)(p)));
		Append(str, "\n");
	od;
	
	# This stuff below gives an output that is too verbose
	#for att in KnownAttributesOfObject(p) do
	#	Append(str, att);
	#	Append(str, ": ");
	#	Append(str, String(EvalString(att)(p)));
	#	Append(str, "\n");
	#od;
	return str;
	end);
	
	
InstallMethod(String,
	[IsManiplex],
	function(M)
	return MANIPLEX_STRING(M);
	end);
	

InstallMethod(InterpolatedString,
	[IsString],
	function(str)
	local L, L2, i, j, id, newid;
	
	L := SplitString(str, '$');
	for i in [2..Size(L)] do
		id := [L[i][1]];
		j := 2;
		for j in [2..Size(L[i])] do
			newid := Concatenation(id, [L[i][j]]);
			if not(IsValidIdentifier(newid)) then
				break;
			else
				id := newid;
				j := j + 1;
			fi;		
		od;
		
		L[i] := Concatenation(String(EvalString(id)), L[i]{[j..Size(L[i])]});
		
	#	L2 := SplitString(L[i], ' ');
	#	L2[1] := String(EvalString(L2[1]));
	#	L[i] := JoinStringsWithSeparator(L2, " ");
	od;
	
	return JoinStringsWithSeparator(L, "");
	
	end);