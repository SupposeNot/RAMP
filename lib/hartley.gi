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

BindGlobal("HARTLEY_EVAL_PERM_GROUP",
	function(line)
	return HARTLEY_EVAL_POLY(Concatenation("poly := Group(", line, ");;"));
	end);

BindGlobal("HARTLEY_FP_GROUP_FROM_RELS",
	function(line, rank)
	local code, i;
	code := "F:=FreeGroup(";
	for i in [0 .. rank - 1] do
		if i > 0 then
			Append(code, ",");
		fi;
		Append(code, Concatenation("\"s", String(i), "\""));
	od;
	Append(code, ");;");
	for i in [0 .. rank - 1] do
		Append(code, Concatenation("s", String(i), " := F.", String(i + 1), ";;"));
	od;
	Append(code, Concatenation("rels := ", line, ";;poly := F / rels;;"));
	return HARTLEY_EVAL_POLY(code);
	end);

BindGlobal("HARTLEY_RANK_FROM_HID",
	function(hid)
	local leftBrace, rightBrace, symbol, commas;
	leftBrace := Position(hid, '{');
	rightBrace := Position(hid, '}');
	if leftBrace = fail or rightBrace = fail or rightBrace <= leftBrace then
		Error("Could not determine rank from Hartley ID: ", hid);
	fi;
	if rightBrace = leftBrace + 1 then
		return 1;
	fi;
	symbol := hid{[leftBrace + 1 .. rightBrace - 1]};
	commas := Positions(symbol, ',');
	return Length(commas) + 2;
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
		maniplexes := fail,
		ranks := fail,
		compact := false,
		sourceFilename := fail
	));

BindGlobal("HARTLEY_LOAD_COMPACT_ATLAS",
	function(atlas, stream)
	local hidLine, permLine, fpLine, hid;

	while not IsEndOfStream(stream) do
		hidLine := ReadLine(stream);
		if hidLine = fail then
			break;
		fi;
		hidLine := Chomp(hidLine);
		if Length(hidLine) = 0 then
			continue;
		fi;

		permLine := ReadLine(stream);
		fpLine := ReadLine(stream);
		if permLine = fail or fpLine = fail then
			CloseStream(stream);
			Error("Hartley compact atlas file ended in the middle of a record.");
		fi;

		hid := hidLine;
		Add(atlas.ids, hid);
		AddDictionary(atlas.permutationGroupLines, hid, Chomp(permLine));
		AddDictionary(atlas.fpGroupLines, hid, Chomp(fpLine));
		AddDictionary(atlas.ranks, hid, HARTLEY_RANK_FROM_HID(hid));
	od;

	atlas.compact := true;
	end);

BindGlobal("HARTLEY_LOAD_OLD_ATLAS",
	function(atlas, stream)
	local hidLine, permLine, fpLine, hid;

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
		AddDictionary(atlas.ranks, hid, HARTLEY_RANK_FROM_HID(hid));
	od;

	atlas.compact := false;
	end);

InstallGlobalFunction(LoadHartleyAtlas,
	function()
	local atlas, filename, stream;
	atlas := HARTLEY_ATLAS_CACHE;
	if atlas.loaded then
		return atlas;
	fi;

	filename := Filename(RampDataPath, "HartleyInfoCompact.txt.gz");
	stream := InputTextFile(filename);
	if stream = fail then
		filename := Filename(RampDataPath, "HartleyInfo.txt");
		stream := InputTextFile(filename);
		if stream = fail then
			Error("Could not open Hartley atlas file: ", filename);
		fi;
	fi;

	atlas.ids := [];
	atlas.permutationGroupLines := NewDictionary("", true);
	atlas.fpGroupLines := NewDictionary("", true);
	atlas.permutationGroups := NewDictionary("", true);
	atlas.fpGroups := NewDictionary("", true);
	atlas.maniplexes := NewDictionary("", true);
	atlas.ranks := NewDictionary("", true);

	if EndsWith(filename, "HartleyInfoCompact.txt.gz") then
		HARTLEY_LOAD_COMPACT_ATLAS(atlas, stream);
	else
		HARTLEY_LOAD_OLD_ATLAS(atlas, stream);
	fi;

	CloseStream(stream);
	atlas.sourceFilename := filename;
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

	if atlas.compact then
		group := HARTLEY_EVAL_PERM_GROUP(line);
	else
		group := HARTLEY_EVAL_POLY(line);
	fi;
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

	if atlas.compact then
		group := HARTLEY_FP_GROUP_FROM_RELS(line, LookupDictionary(atlas.ranks, hid));
	else
		group := HARTLEY_EVAL_POLY(line);
	fi;
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

InstallGlobalFunction(FindHartleyName,
	function(M)
	local atlas, key, hid, candidate;
	atlas := LoadHartleyAtlas();
	key := HARTLEY_KEY_FOR_MANIPLEX(M);

	for hid in atlas.ids do
		if HARTLEY_ID_MATCHES_KEY(hid, key) then
			candidate := HartleyManiplex(hid);
			if candidate = M then
				return hid;
			fi;
		fi;
	od;

	return fail;
	end);
