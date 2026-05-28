
# Dealing with mixes of maniplexes
#! @Chapter Polytope Constructions and Operations
#! @Section Mixing of Maniplexes functions

#! @BeginGroup Mix
#! @GroupTitle Mix of groups

#! @Arguments g, h
#! @Returns `IsGroup`. 
#! @Description Given two groups, returns the mix of those groups.  
#! If g and h are permutation groups of degree m and n, respectively, then the mix is a permutation group of degree
#! m+n.
DeclareOperation("Mix", [IsGroup, IsGroup]);
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

#! @Arguments M, N
#! @Returns `IsPreManiplex`. 
#! @Description Given two (pre-)maniplexes M and N, returns their mix. For two reflexible maniplexes returns the reflexible maniplex from the mix of their connection groups.  In general, it returns the "flag mix" of the two maniplexes (see `FlagMix`).
DeclareOperation("Mix", [IsPremaniplex, IsPremaniplex]);


#! @Arguments M, N
#! @Returns `IsPreManiplex`. 
#! @Description Given two (pre-)maniplexes M and N, this returns the (pre-)maniplex of their  
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

#! @Arguments gp, gq
#! Given two finitely presented groups gp and gq, returns their comix, their largest common
#! quotient. 
DeclareOperation("Comix", [IsFpGroup, IsFpGroup]);


#! @Arguments M, N
#! @Returns `IsReflexibleManiplex `. 
#! @Description Given reflexible maniplexes M and N returns the reflexible maniplex from the comix 
#! of their automorphism groups.
DeclareOperation("Comix", [IsReflexibleManiplex, IsReflexibleManiplex]);
#! @BeginExampleSession
#! gap> M := Comix(ToroidalMap44([2,0]), ToroidalMap44([3,0]));;
#! gap> M = ToroidalMap44([1,0]);
#! true
#! @EndExampleSession

#! @EndGroup

