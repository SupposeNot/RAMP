
# Dealing with mixes of maniplexes
#! @Chapter Maniplexes
#! @Section Mixing of Maniplexes functions

#! @BeginGroup Mix
#! @GroupTitle Mix of maniplexes
#! @Arguments permgroup, permgroup
#! @Returns `IsGroup `. 
#! @Description Given two (permutation) groups returns the mix of those groups.  Note, also works with FPgroups.
DeclareOperation("Mix", [IsPermGroup, IsPermGroup]);

#! Here we build the mix of the connection groups of a 3-cube and an edge.
#! @BeginExampleSession
#! gap> g1:=ConnectionGroup(Cube(3));
#! <permutation group with 3 generators>
#! gap> g2:=ConnectionGroup(Edge());
#! Group([ (1,2) ])
#! gap> Mix(g1,g2);
#! <permutation group with 3 generators>
#! @EndExampleSession

#! @Arguments fpgroup, fpgroup
#! @Returns the Mix of two Finitely Presented groups gp and gq.
DeclareOperation("Mix", [IsFpGroup, IsFpGroup]);


#! @Arguments maniplex, maniplex
#! @Returns `IsManiplex `. 
#! @Description Given two maniplexes p, q this returns the maniplex of their  
#! "flag" mix 
DeclareOperation("FlagMix", [IsManiplex, IsManiplex]);




#! @Arguments maniplex,  maniplex
#! @Returns `IsReflexibleManiplex `. 
#! @Description Given two manpilexes, returns their mix. For two reflexible maniplexes returns the IsReflexibleManiplex from the mix of their connection groups.  In general, it returns the flag mix.

DeclareOperation("Mix", [IsManiplex, IsManiplex]);

#! @EndGroup

#! @BeginGroup 
#! @GroupTitle Comix

#! @Arguments fpgroup, fpgroup
#! Returns the comix of two Finitely Presented groups gp and gq.
DeclareOperation("Comix", [IsFpGroup, IsFpGroup]);


#! @Arguments maniplex, maniplex
#! @Returns `IsReflexibleManiplex `. 
#! @Description Given maniplexes returns the IsReflexibleManiplex from the comix of their connection groups
DeclareOperation("Comix", [IsReflexibleManiplex, IsReflexibleManiplex]);

#! @EndGroup

#! @BeginGroup
#! @GroupTitle Indexed array tools
#! @Arguments int, int, int, int
#! @Returns `IsInteger `. 
#! @Description CtoL Returns an integer between 1 and N*M associated with the pair [a,b].  
#! LtoC Returns an ordered pair [a,b] associated with the integer between 1 and N*M.
#! a should range between 1 and N, and b should range between 1 and M
#! N is how many columns (x coordinates), M is how many rows (y coordinates) in a matrix
#! Functions are inverses.
DeclareOperation("CtoL",[IsInt,IsInt,IsInt,IsInt]);


DeclareOperation("LtoC",[IsInt,IsInt,IsInt]);
#! @BeginExampleSession
#! gap> LtoC(5,4,14);
#! [ 1, 2 ]
#! gap> CtoL(3,2,5,4);
#! 8
#! gap> LtoC(8,5,4);
#! [ 3, 2 ]
#! @EndExampleSession
#! @EndGroup






