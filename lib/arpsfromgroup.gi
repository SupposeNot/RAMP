
ARP_SubgroupGeneratedByIndices := function(gamma, gens, inds)
	if Length(inds) = 0 then
		return Subgroup(gamma, []);
	fi;
	return Subgroup(gamma, gens{inds});
end;

ARP_IsStringCGroupTupleForGroup := function(gamma, gens)
	local rank, inds, pair, I, J, GI, GJ, GK;

	rank := Length(gens);
	inds := [1..rank];

	if ForAny(gens, g -> Order(g) <> 2) then
		return false;
	fi;

	if Subgroup(gamma, gens) <> gamma then
		return false;
	fi;

	for pair in Combinations(inds, 2) do
		if AbsInt(pair[1] - pair[2]) > 1 and
		   gens[pair[1]] * gens[pair[2]] <> gens[pair[2]] * gens[pair[1]] then
			return false;
		fi;
	od;

	for I in Combinations(inds) do
		for J in Combinations(inds) do
			GI := ARP_SubgroupGeneratedByIndices(gamma, gens, I);
			GJ := ARP_SubgroupGeneratedByIndices(gamma, gens, J);
			GK := ARP_SubgroupGeneratedByIndices(gamma, gens, Intersection(I, J));
			if Intersection(GI, GJ) <> GK then
				return false;
			fi;
		od;
	od;

	return true;
end;

ARP_CommutesWithRequiredEarlierGenerators := function(prefix, x)
	local k, i;

	k := Length(prefix) + 1;
	for i in [1..Length(prefix)] do
		if AbsInt(k - i) > 1 and prefix[i] * x <> x * prefix[i] then
			return false;
		fi;
	od;

	return true;
end;

ARP_IsStringCGroupTupleInOwnGroup := function(gens)
	return ARP_IsStringCGroupTupleForGroup(Group(gens), gens);
end;

ARP_AutomorphismActionOnInvolutions := function(gamma, involutions)
	local aut, autGens, perms, gen, images, i, pos;

	aut := AutomorphismGroup(gamma);
	autGens := GeneratorsOfGroup(aut);
	perms := [];

	for gen in autGens do
		images := [];
		for i in [1..Length(involutions)] do
			pos := Position(involutions, Image(gen, involutions[i]));
			if pos = fail then
				Error("Automorphism image of involution was not in involution list.\n");
			fi;
			images[i] := pos;
		od;
		Add(perms, PermList(images));
	od;

	if Length(perms) = 0 then
		return Group(());
	fi;

	return Group(perms);
end;

ARP_RepresentativeIndicesUpToDuality := function(searchResult)
	local reps, autPerm, kept, idxTuple;

	reps := searchResult.repsAsInvolutionIndices;
	autPerm := searchResult.automorphismActionOnInvolutions;
	kept := [];

	for idxTuple in reps do
		if not ForAny(kept,
			k -> RepresentativeAction(autPerm, k, idxTuple, OnTuples) <> fail or
			     RepresentativeAction(autPerm, Reversed(k), idxTuple, OnTuples) <> fail) then
			Add(kept, idxTuple);
		fi;
	od;

	return kept;
end;

InstallMethod(ARPsFromGroupSearch,
	[IsGroup, IsPosInt],
	function(gamma, rank)
	local involutions, autPerm, reps, repsIdx, candidatesAtDepth, extend,
		dualRepsIdx, dualReps;

	involutions := Filtered(Elements(gamma), g -> Order(g) = 2);
	autPerm := ARP_AutomorphismActionOnInvolutions(gamma, involutions);
	reps := [];
	repsIdx := [];
	candidatesAtDepth := List([1..rank], i -> 0);

	extend := function(prefixIdx, prefix, stabilizer)
		local k, candidates, orbitReps, idx, x, newPrefixIdx, newPrefix,
			newStabilizer, H;

		k := Length(prefix) + 1;

		if Length(prefix) = rank then
			if ARP_IsStringCGroupTupleForGroup(gamma, prefix) then
				Add(repsIdx, prefixIdx);
				Add(reps, prefix);
			fi;
			return;
		fi;

		candidates := Filtered([1..Length(involutions)],
			i -> ARP_CommutesWithRequiredEarlierGenerators(prefix, involutions[i]));
		orbitReps := List(Orbits(stabilizer, candidates), Representative);
		candidatesAtDepth[k] := candidatesAtDepth[k] + Length(orbitReps);

		for idx in orbitReps do
			x := involutions[idx];
			newPrefixIdx := Concatenation(prefixIdx, [idx]);
			newPrefix := Concatenation(prefix, [x]);

			if Length(newPrefix) = 3 and not ARP_IsStringCGroupTupleInOwnGroup(newPrefix) then
				continue;
			fi;

			if Length(newPrefix) = rank - 1 then
				H := Subgroup(gamma, newPrefix);
				if Size(H) = Size(gamma) then
					continue;
				fi;
			fi;

			newStabilizer := Stabilizer(stabilizer, idx);
			extend(newPrefixIdx, newPrefix, newStabilizer);
		od;
	end;

	extend([], [], autPerm);

	dualRepsIdx := ARP_RepresentativeIndicesUpToDuality(rec(
		repsAsInvolutionIndices := repsIdx,
		automorphismActionOnInvolutions := autPerm
	));
	dualReps := List(dualRepsIdx, idxTuple -> List(idxTuple, i -> involutions[i]));

	return rec(
		rank := rank,
		involutions := involutions,
		automorphismActionOnInvolutions := autPerm,
		candidatesAtDepth := candidatesAtDepth,
		reps := reps,
		repsAsInvolutionIndices := repsIdx,
		repsModDuality := dualReps,
		repsModDualityAsInvolutionIndices := dualRepsIdx
	);
	end);

InstallMethod(ARPsFromGroup,
	[IsGroup, IsPosInt],
	function(gamma, rank)
		return ARPsFromGroupSearch(gamma, rank).reps;
	end);

InstallMethod(ARPsFromGroup,
	[IsGroup, IsPosInt, IsBool],
	function(gamma, rank, identifyDuals)
		local search;

		search := ARPsFromGroupSearch(gamma, rank);
		if identifyDuals then
			return search.repsModDuality;
		fi;
		return search.reps;
	end);

InstallMethod(StringCGroupRepresentationSearch,
	[IsGroup, IsPosInt],
	function(gamma, rank)
		return ARPsFromGroupSearch(gamma, rank);
	end);

InstallMethod(StringCGroupRepresentations,
	[IsGroup, IsPosInt],
	function(gamma, rank)
		return ARPsFromGroup(gamma, rank);
	end);

InstallMethod(StringCGroupRepresentations,
	[IsGroup, IsPosInt, IsBool],
	function(gamma, rank, identifyDuals)
		return ARPsFromGroup(gamma, rank, identifyDuals);
	end);
