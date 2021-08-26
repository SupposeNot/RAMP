
#! @Chapter Regular maps
#! @Section Bicontactual regular maps
#! The names for the maps in this section are from S.E. Wilson's paper of the same title.

#! @Arguments k
#! @Returns maniplex
#! @Description Given an integer <A>k</A>, gives the map $\epsilon_k$, which is $\{k,2\}_k$ when <A>k</A> is even, and $\{k,2\}_{2k}$ when <A>k</A> is odd.
DeclareOperation("Epsilonk",[IsInt]);

#! @Arguments k
#! @Returns maniplex
#! @Description Given an integer <A>k</A>, gives the map $\delta_k$, which is $\{2k,2\}/2$ when <A>k</A> is even, and $\{2k,2\}_{k}$ when <A>k</A> is odd.
DeclareOperation("Deltak",[IsInt]);

#! @Arguments k
#! @Returns maniplex
#! @Description Given an integer <A>k</A>, gives the map $M_k$, which is $\{2k,2k\}_{1,0}$ when <A>k</A> is even, and $\{2k,k\}_{2}$ when <A>k</A> is odd.
DeclareOperation("Mk",[IsInt]);

#! @Arguments k
#! @Returns maniplex
#! @Description Given an integer <A>k</A>, gives the map $M'_k$, which is $\{k,k\}_2$ when <A>k</A> is even, and $\{k,2k\}_{2}$ when <A>k</A> is odd.
DeclareOperation("MkPrime",[IsInt]);

#! @Section Operators on reflexible maps

#! @Arguments map
#! @Returns oppositeMap
#! @Description Forms the opposite map of the maniplex <A>map</>.
DeclareOperation("Opp", [IsManiplex]);

#! @Arguments map, j
#! @Returns newMap
#! @Description Given <A>map</A> and integer $j$, will form the map $H_j(map)$. Note that if the action of $[r_0,(r_1 r_2)^{j-1} r_1, r_2]$ on the flags forms multiple orbits, then the resulting map will be on just one of those orbits.
DeclareOperation("Hole", [IsManiplex,IsInt]);