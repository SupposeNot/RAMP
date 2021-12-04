

#! @Chapter Families of Polytopes
#! @Section Toroids

#! @Arguments u [, v]
#! @Returns IsManiplex
#! @Description Returns the toroidal map $\{4,4\}_{\vec u, \vec v}$.
#! If only <A>u</A> is given, then <A>v</A> is taken to be <A>u</A> rotated 90 degrees,
#! in which case the resulting map is either reflexible or chiral.
DeclareGlobalFunction("ToroidalMap44");
#! @BeginExampleSession
#! gap> ToroidalMap44([3,0]) = ARP([4,4], "(r0 r1 r2 r1)^3");
#! true
#! gap> M := ToroidalMap44([1,2]);; IsChiral(M);
#! true
#! gap> ToroidalMap44([5,0]) = SmallestReflexibleCover(M);
#! true
#! gap> M := ToroidalMap44([2,0],[0,3]);; NumberOfFlagOrbits(M);
#! 2
#! gap> M = ARP([4,4]) / "(r0 r1 r2 r1)^2, (r1 r0 r1 r2)^3";
#! true
#! gap> SmallestReflexibleCover(M) = ToroidalMap44([6,0]);
#!true
#! gap> ToroidalMap44([2,3],[4,1]) = ToroidalMap44([-3,2],[-1,4]);
#! true
#! @EndExampleSession

#! @Arguments s, k, n
#! @Returns IsManiplex
#! @Description Given IsInt triple <A>s, k, n</A>, will return the regular toroid $\{4, 3^{n-2},4\}_{\vec s}$ where $\vec s=(s^k, 0^{n-k})$.
DeclareOperation("CubicalToroid",[IsInt,IsInt,IsInt]);
#! @BeginExampleSession
#! gap> m44:=CubicalToroid(3,2,2);;
#! gap> m44=ToroidalMap44([3,3]);
#! true
#! @EndExampleSession


#! @Arguments s, k
#! @Returns IsManiplex
#! @Description Given IsInt pair <A>s, k</A>, will return the regular toroid $\{3,3,4,3\}_{\vec s}$ where $\vec s=(s^k, 0^{n-k})$. Note that $k$ must be 0 or 1.
DeclareOperation("3343Toroid",[IsInt,IsInt]);

#! @Arguments s, k
#! @Returns IsManiplex
#! @Description Given IsInt pair <A>s, k</A>, will return the regular toroid $\{3,4,3,3\}_{\vec s}$ where $\vec s=(s^k, 0^{n-k})$. Note that $k$ must be 0 or 1.
DeclareOperation("24CellToroid",[IsInt,IsInt]);