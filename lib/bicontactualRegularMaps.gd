
#! @Chapter Maps On Surfaces
#! @Section Bicontactual regular maps
#! The names for the maps in this section are from S.E. Wilson's <Cite Key="Wil85"/>. 

#! @Arguments k
#! @Returns IsManiplex
#! @Description Given an integer <A>k</A>, gives the map $\epsilon_k$, which is $\{k,2\}_k$ when <A>k</A> is even, and $\{k,2\}_{2k}$ when <A>k</A> is odd.
DeclareOperation("Epsilonk",[IsInt]);
#! @BeginExampleSession
#! gap> Epsilonk(5);
#! AbstractRegularPolytope([ 5, 2 ])
#! gap> Epsilonk(6);
#! AbstractRegularPolytope([ 6, 2 ])
#! @EndExampleSession

#! @Arguments k
#! @Returns IsManiplex
#! @Description Given an integer <A>k</A>, gives the map $\delta_k$, which is $\{2k,2\}/2$ when <A>k</A> is even, and $\{2k,2\}_{k}$ when <A>k</A> is odd.
DeclareOperation("Deltak",[IsInt]);
#! @BeginExampleSession
#! gap> Deltak(5);
#! AbstractRegularPolytope([ 10, 2 ], "(r0 r1)^5 r2")
#! gap> Deltak(6);
#! AbstractRegularPolytope([ 12, 2 ], "(r0 r1)^6 r2")
#! @EndExampleSession


#! @Arguments k
#! @Returns IsManiplex
#! @Description Given an integer <A>k</A>, gives the map $M_k$, which is $\{2k,2k\}_{1,0}$ when <A>k</A> is even, and $\{2k,k\}_{2}$ when <A>k</A> is odd.
DeclareOperation("Mk",[IsInt]);
#! @BeginExampleSession
#! gap> Mk(5);Mk(6);
#! AbstractRegularPolytope([ 10, 5 ], "(r0 r1)^5 r0 = r2")
#! AbstractRegularPolytope([ 12, 12 ], "(r0 r1)^6 r0 = r2")
#! @EndExampleSession

#! @Arguments k
#! @Returns IsManiplex
#! @Description Given an integer <A>k</A>, gives the map $M'_k$, which is $\{k,k\}_2$ when <A>k</A> is even, and $\{k,2k\}_{2}$ when <A>k</A> is odd. 
#! `MkPrime(k,i)` gives the map $M'_{k,i}$.
DeclareOperation("MkPrime",[IsInt]);
#! @BeginExampleSession
#! gap> MkPrime(5);MkPrime(6);
#! ReflexibleManiplex([ 5, 10 ], "(r2*r1*(r0 r2))^5,z1^2")
#! ReflexibleManiplex([ 6, 6 ], "(r2*r1*(r0 r2))^6,z1^2")
#! @EndExampleSession

#! @Arguments k, l
#! @Returns IsManiplex
#! @Description Given integers <A>k,l</A>, gives the map $B(k,2l)$. 
DeclareOperation("Bk2l",[IsInt,IsInt]);
#! @BeginExampleSession
#! gap> Bk2l(4,5);
#! 3-maniplex with 80 flags
#! @EndExampleSession

#! @Arguments k, l
#! @Returns IsManiplex
#! @Description Given integers <A>k,l</A>, gives the map $B^*(k,2l)$. 
DeclareOperation("Bk2lStar",[IsInt,IsInt]);
#! @BeginExampleSession
#! gap> Bk2lStar(5,7);
#! 3-maniplex with 140 flags
#! @EndExampleSession

#! @Section Operations on reflexible maps

#! @Arguments map
#! @Returns IsManiplex
#! @Description Forms the opposite map of the maniplex <A>map</A>.
DeclareOperation("Opp", [IsMapOnSurface]);
#! @BeginExampleSession
#! gap> Opp(Bk2lStar(5,7));
#! Petrial(Dual(Petrial(3-maniplex with 140 flags)))
#! @EndExampleSession

#! @Arguments map, j
#! @Returns IsManiplex
#! @Description Given <A>map</A> and integer $j$, will form the map $H_j(map)$. Note that if the action of $[r_0,(r_1 r_2)^{j-1} r_1, r_2]$ on the flags forms multiple orbits, then the resulting map will be on just one of those orbits.
DeclareOperation("Hole", [IsMapOnSurface,IsInt]);
#! @BeginExampleSession
#! gap> Hole(Bk2lStar(5,7),2);
#! 3-maniplex with 140 flags
#! @EndExampleSession

