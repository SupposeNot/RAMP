BindGlobal("HARTLEY_ID_FROM_LINE",
	function(line)
	local quotePositions;
	quotePositions := Positions(line, '"');
	if Length(quotePositions) < 2 then
		Error("Could not read Hartley ID from line: ", line);
	fi;
	return line{[quotePositions[1] + 1 .. quotePositions[2] - 1]};
	end);

BindGlobal("HARTLEY_EVAL_POLY",
	function(line)
	local stream;
	stream := InputTextString(line);
	Read(stream);
	CloseStream(stream);
	return ValueGlobal("poly");
	end);

BindGlobal("HARTLEY_KEY_FOR_MANIPLEX",
	function(M)
	local sym, key, i;
	sym := SchlafliSymbol(M);
	key := "{";
	for i in [1 .. Length(sym)] do
		if i > 1 then
			Append(key, ",");
		fi;
		Append(key, String(sym[i]));
	od;
	Append(key, "}*");
	Append(key, String(Size(M)));
	return key;
	end);

BindGlobal("HARTLEY_ID_MATCHES_KEY",
	function(hid, key)
	if not StartsWith(hid, key) then
		return false;
	fi;
	return Length(hid) = Length(key) or not hid[Length(key) + 1] in "0123456789";
	end);

BindGlobal("HARTLEY_ATLAS_CACHE",
	rec(
		loaded := false,
		ids := [],
		permutationGroupLines := fail,
		fpGroupLines := fail,
		permutationGroups := fail,
		fpGroups := fail,
		maniplexes := fail
	));

InstallGlobalFunction(LoadHartleyAtlas,
	function()
	local atlas, filename, stream, hidLine, permLine, fpLine, hid;
	atlas := HARTLEY_ATLAS_CACHE;
	if atlas.loaded then
		return atlas;
	fi;

	filename := Filename(RampDataPath, "HartleyInfo.txt");
	stream := InputTextFile(filename);
	if stream = fail then
		Error("Could not open Hartley atlas file: ", filename);
	fi;

	atlas.ids := [];
	atlas.permutationGroupLines := NewDictionary("", true);
	atlas.fpGroupLines := NewDictionary("", true);
	atlas.permutationGroups := NewDictionary("", true);
	atlas.fpGroups := NewDictionary("", true);
	atlas.maniplexes := NewDictionary("", true);

	while not IsEndOfStream(stream) do
		hidLine := ReadLine(stream);
		if hidLine = fail then
			break;
		fi;
		if Length(Chomp(hidLine)) = 0 then
			continue;
		fi;

		permLine := ReadLine(stream);
		fpLine := ReadLine(stream);
		if permLine = fail or fpLine = fail then
			CloseStream(stream);
			Error("Hartley atlas file ended in the middle of a record.");
		fi;

		hid := HARTLEY_ID_FROM_LINE(hidLine);
		Add(atlas.ids, hid);
		AddDictionary(atlas.permutationGroupLines, hid, permLine);
		AddDictionary(atlas.fpGroupLines, hid, fpLine);
	od;

	CloseStream(stream);
	atlas.loaded := true;
	return atlas;
	end);

InstallGlobalFunction(HartleyIds,
	function()
	return ShallowCopy(LoadHartleyAtlas().ids);
	end);

InstallGlobalFunction(HartleyGroup,
	function(hid)
	local atlas, line, group;
	atlas := LoadHartleyAtlas();
	group := LookupDictionary(atlas.permutationGroups, hid);
	if group <> fail then
		return group;
	fi;

	line := LookupDictionary(atlas.permutationGroupLines, hid);
	if line = fail then
		Error("Unknown Hartley ID: ", hid);
	fi;

	group := HARTLEY_EVAL_POLY(line);
	AddDictionary(atlas.permutationGroups, hid, group);
	return group;
	end);

InstallGlobalFunction(HartleyFpGroup,
	function(hid)
	local atlas, line, group;
	atlas := LoadHartleyAtlas();
	group := LookupDictionary(atlas.fpGroups, hid);
	if group <> fail then
		return group;
	fi;

	line := LookupDictionary(atlas.fpGroupLines, hid);
	if line = fail then
		Error("Unknown Hartley ID: ", hid);
	fi;

	group := HARTLEY_EVAL_POLY(line);
	AddDictionary(atlas.fpGroups, hid, group);
	return group;
	end);

InstallGlobalFunction(HartleyManiplex,
	function(hid)
	local atlas, M;
	atlas := LoadHartleyAtlas();
	M := LookupDictionary(atlas.maniplexes, hid);
	if M <> fail then
		return M;
	fi;

	M := ReflexibleManiplex(HartleyGroup(hid));
	SetString(M, Concatenation("HartleyManiplex(\"", hid, "\")"));
	AddDictionary(atlas.maniplexes, hid, M);
	return M;
	end);

InstallGlobalFunction(FindHartleyNames,
	function(M)
	local atlas, key, ans, hid, candidate;
	atlas := LoadHartleyAtlas();
	key := HARTLEY_KEY_FOR_MANIPLEX(M);
	ans := [];

	for hid in atlas.ids do
		if HARTLEY_ID_MATCHES_KEY(hid, key) then
			candidate := HartleyManiplex(hid);
			if candidate = M then
				Add(ans, hid);
			fi;
		fi;
	od;

	return ans;
	end);

InstallGlobalFunction(FindHartleyName,
	function(M)
	local names;
	names := FindHartleyNames(M);
	if IsEmpty(names) then
		return fail;
	fi;
	return names[1];
	end);
