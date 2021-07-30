

#! @Chapter Families of Polytopes
#! @Section Toroids


DeclareGlobalFunction("ToroidalMap44");

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