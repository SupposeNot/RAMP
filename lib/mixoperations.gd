
# Dealing with mixes of maniplexes
#! @Chapter Polytope Constructions and Operations
#! @Section Mixing of Maniplexes functions

#! @BeginGroup Mix
#! @GroupTitle Mix of groups

#! @Arguments g, h
#! @Returns `IsGroup `. 
#! @Description Given two groups (either both permutation groups or both FpGroups), returns the mix of those groups.  
#! If g and h are permutation groups of degree m and n, respectively, then the mix is a permutation group of degree
#! m+n.
DeclareOperation("Mix", [IsPermGroup, IsPermGroup]);

DeclareOperation("Mix", [IsFpGroup, IsFpGroup]);
#! Here we build the mix of the connection groups of a 3-cube and an edge.
#! @BeginExampleSession
#! gap> g1:=ConnectionGroup(Cube(3));
#! <permutation group with 3 generators>
#! gap> g2:=ConnectionGroup(Edge());
#! Group([ (1,2) ])
#! gap> Mix(g1,g2);
#! <permutation group with 3 generators>
#! @EndExampleSession
#! @EndGroup

#! @Arguments maniplex,  maniplex
#! @Returns `IsReflexibleManiplex `. 
#! @Description Given two (pre-)maniplexes, returns their mix. For two reflexible maniplexes returns the IsReflexibleManiplex from the mix of their connection groups.  In general, it returns the "flag mix" of the two maniplexes (see `FlagMix`).
DeclareOperation("Mix", [IsPremaniplex, IsPremaniplex]);


#! @Arguments maniplex, maniplex
#! @Returns `IsManiplex `. 
#! @Description Given two (pre-)maniplexes p, q this returns the (pre-)maniplex of their  
#! "flag" mix. That is, it constructs the mix of their connection groups, keeps
#! the connected component with the base flags of p and q, and then builds a maniplex
#! from this.
DeclareOperation("FlagMix", [IsPremaniplex, IsPremaniplex]);
#! @BeginExampleSession
#! gap> M := ToroidalMap44([1,2]);;
#! gap> FlagMix(M,M) = M;
#! true
#! gap> R := FlagMix(M, EnantiomorphicForm(M));
#! 3-maniplex with 200 flags
#! gap> IsReflexible(R);
#! true
#! gap> R = ToroidalMap44([5,0]);
#! true
#! @EndExampleSession



#! @BeginGroup Comix
#! @GroupTitle Comix

#! @Arguments fpgroup, fpgroup
#! Returns the comix of two Finitely Presented groups gp and gq.
DeclareOperation("Comix", [IsFpGroup, IsFpGroup]);


#! @Arguments maniplex, maniplex
#! @Returns `IsReflexibleManiplex `. 
#! @Description Given maniplexes returns the IsReflexibleManiplex from the comix of their connection groups
DeclareOperation("Comix", [IsReflexibleManiplex, IsReflexibleManiplex]);

#! @EndGroup

#! @BeginGroup Tools
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






