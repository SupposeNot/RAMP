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

#Trying to make the database commands more tolerant of errors in objects passed to them. Need some helper functions for that.

InstallMethod(PremaniplexAttrStringOrEmpty,
	[IsPremaniplex,IsString],
	function(M,attr)
	local attrE;
	attrE:=ValueGlobal(attr);
    if ApplicableMethod(attrE, [M]) = fail then
        return "";
    elif Tester(attrE)(M) then
        return String(attrE(M));
    else
        return String(attrE(M));  # not yet known, but computable — this will trigger computation
    fi;
end);

	
InstallOtherMethod(DatabaseString,
	[IsPremaniplex, IsList],
	function(M, attrList)
	local attrStrings;
	attrStrings := [Chomp(ManiplexConstructorString(M))];
	Append(attrStrings, List(attrList, attr -> PremaniplexAttrStringOrEmpty(M,attr)));
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
	if HasIsReflexible(p) and IsReflexible(p) then
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
	elif IsManiplex(p) then
		Append(str, "-maniplex");
	else
		Append(str, "-premaniplex");	
	fi;
	if HasSchlafliSymbol(p) then 
		Append(str, Concatenation(" of type ", String(SchlafliSymbol(p))));
	fi;
	if HasSize(p) then 
		if IsFinite(p) then
			if Size(p) = 1 then
				Append(str, " with 1 flag");
			else
				Append(str, Concatenation(" with ", String(Size(p)), " flags")); 
			fi;
		else
			Append(str, " with infinitely many flags"); 
		fi;
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
	
InstallMethod(ViewObj,
	[IsPremaniplex],
	function(M)
	if HasString(M) then
		Print(String(M));
	else
		Print(MANIPLEX_STRING(M));
	fi;
	end);
	
# InstallMethod(String,
# 	[IsManiplex],
# 	function(M)
# 	return MANIPLEX_STRING(M);
# 	end);
# 
# InstallMethod(ViewObj, "for maniplexes in conn gp rep", [IsManiplexConnGpRep],
# function(M)
#     Print(RankManiplex(M),"-maniplex with ", Size(M), " flags");
# end);

InstallMethod(String, "for premaniplexes", [IsPremaniplex],
    M -> MANIPLEX_STRING(M));
	

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

InstallMethod(ManiplexConstructorString, "for quotient-rep maniplexes",
	[IsPremaniplex and IsManiplexQuotientRep and HasQuotientRelatorString],
	function(M)
	local relText;
	relText := String(QuotientRelatorString(M));
	relText := ReplacedString(relText, "^-1", "");
	relText := ReplacedString(relText, "*", "");
	relText := relText{[2..Length(relText)-1]};
	return Concatenation("QuotientManiplex(UniversalPolytope(",
	                     String(RankManiplex(M)), "), \"", relText, "\")");
	end);

RAMP_CONN_GP_CONSTRUCTOR_STRING := M ->
    Concatenation("Maniplex(Group(",
                  String(GeneratorsOfGroup(ConnectionGroup(M))), "))");

InstallMethod(ManiplexConstructorString, "for maniplexes in conn gp rep",
	[IsPremaniplex and IsManiplexConnGpRep],
	RAMP_CONN_GP_CONSTRUCTOR_STRING);

InstallMethod(ManiplexConstructorString, "for premaniplexes in conn gp rep",
	[IsPremaniplex and IsPremaniplexConnGpRep],
	RAMP_CONN_GP_CONSTRUCTOR_STRING);

InstallMethod(ManiplexConstructorString, "fallback via String",
    [IsPremaniplex],
    M -> String(M));