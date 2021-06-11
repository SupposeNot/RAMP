AbstractRegularPolytope := function(args...)
	local p;
	p := CallFuncList(ReflexibleManiplex, args);
	SetIsPolytopal(p, true);
	return p;
	end;

AbstractPolytope := function(args...)
	local p;
	p := CallFuncList(Maniplex, args);
	SetIsPolytopal(p, true);
	return p;
	end;



# Modifies the permutation perm by adding k to each entry.
TranslatePerm := function(perm, k)
	local n, l, l2;
	l := ListPerm(perm);
	Apply(l, i -> i+k);
	l2 := [1..k];
	Append(l2, l);
	perm := PermList(l2);
	return perm;
	end;

# Multiplies together perm, TranslatePerm(perm, offset), TranslatePerm(perm, offset*2), ..., with multiplier terms.	
MultPerm := function(perm, multiplier, offset)
	local MultPermAux;

	# perm is the "seed" permutations, newperm is the accumulated result so far.
	MultPermAux := function(perm, newperm, multiplier, offset)
		if (multiplier = 1) then
			return newperm;
		else
			return MultPermAux(perm, newperm*TranslatePerm(perm, offset*(multiplier-1)), multiplier-1, offset);
		fi;
		end;
		
	return MultPermAux(perm, perm, multiplier, offset);
	end;
	
# Takes an abstract word in the generators of some free group and returns the corresponding
# abstract word in the generators of f.
TranslateWord := function(word, f)
	local tw;
	tw := TietzeWordAbstractWord(word);
	return AbstractWordTietzeWord(tw, GeneratorsOfGroup(f));
	end;
	
# This is a bit of a hack.
# GAP has a built-in way to parse group presentations, so that if you take the quotient of,
# say, <a, b, c> by the string "a^5 = b^3 = c^2 = 1", then it does what you expect.
# I want to use this to do something similar with sggis. But the built-in GAP method
# only allows single-letter generators. So I translate r0 -> a, r1 -> b, etc, and
# then back again.	
ParseStringCRels := function(rels, w)
	local n, f, old_names, new_names, i, parsed_rels, trans_rels, f2;
	n := Size(GeneratorsOfGroup(w));
	if n > 9 then Error("Only works for n < 10"); fi;
	f := FreeGroupOfFpGroup(w);

	old_names := List([0..n-1], i -> Concatenation("r", String(i)));
	new_names := ["a","b","c","d","e","f","g","h","i"]{[1..n]};
	for i in [1..n] do
		rels := ReplacedString(rels, old_names[i], new_names[i]);
	od;
	f2 := FreeGroup(new_names);
	parsed_rels := ParseRelators(GeneratorsOfGroup(f2), rels);
	trans_rels := List(parsed_rels, r -> TranslateWord(r, f));
	return trans_rels;
	end;
	
IsSameRank := function(f1, f2)
	return f1!.rank = f2!.rank;
	end;

