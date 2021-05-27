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
	
