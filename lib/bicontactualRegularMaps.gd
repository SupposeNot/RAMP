
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