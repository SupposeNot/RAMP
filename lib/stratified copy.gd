
#! @Chapter Stratified Operations
#! @Section Computational tools

#! I should say something more here.

#! @Arguments element1, element2
#! @Returns element
# Description Elements are ordered pairs of the form [perm, list], where the elements of list are members of a group. Operation performed is consistent with that in defined in <Cite Key="PelWil18">.
DeclareOperation("ChunkMultiply", [IsList,IsList]);

#! @Arguments element, integer
#! @Returns element
# Description Given an element compatible with the  ChunkMultiply operation, this function will compute the product of element with itself integer times.
DeclareOperation("ChunkPower", [IsList,IsInt]);

#! @Arguments list, group
#! @Returns newList
# Description Given a list of generators compatible with the ChunkMultiply operation, this function will construct the associated list of group elements in a form suitable for taking ChunkMultiply and ChunkPower.
DeclareOperation("ChunkGeneratedGroupElements", [IsList, IsGroup]);

#! @Arguments list, group
#! @Returns permGroup
#! Description Given a list of generators compatible with the ChunkMultiply operation, this function will construct a representation of the group as a permutation group. Note that generators are of the form [perm, list], and each list is a list of elements from group.
DeclareOperation("ChunkGeneratedGroup", [IsList, IsGroup]);

#! @BeginExampleSession
#! gap> p:=Simplex(2); a:=AutomorphismGroup(p);
#! Pgon(3)
#! <fp group of size 6 on the generators [ r0, r1 ]>
#! gap> e:=One(a);; AssignGeneratorVariables(a);
#I  Assigned the global variables [ r0, r1 ]
#! gap> s0:=[(3,4),[r0,r0,e,e,r0,r0]];
#! [ (3,4), [ r0, r0, <identity ...>, <identity ...>, r0, r0 ] ]
#! gap> s1:=[(2,3)(4,5),[r1,e,e,e,e,r1]];
#! [ (2,3)(4,5), [ r1, <identity ...>, <identity ...>, <identity ...>, <identity ...>, r1 ] ]
#! gap> s2:=[(1,2)(5,6),[e,e,r1,r1,e,e]];
#! [ (1,2)(5,6), [ <identity ...>, <identity ...>, r1, r1, <identity ...>, <identity ...> ] ]
#! gap>  gens:=[s0,s1,s2];;
#! gap> ChunkMultiply(s0,s1);
#! [ (2,3,5,4), [ r0*r1, <identity ...>, r0, r0, <identity ...>, r0*r1 ] ]
#! gap> ChunkMultiply(s0,s0);
#! [ (), [ r0^2, r0^2, <identity ...>, <identity ...>, r0^2, r0^2 ] ]
#! gap> SetReducedMultiplication(r1);
#! gap> ChunkMultiply(s0,s0);
#! [ (), [ <identity ...>, <identity ...>, <identity ...>, <identity ...>, <identity ...>,  <identity ...> ] ]
#! gap> ChunkGeneratedGroup(gens,a);
#! <permutation group with 3 generators>
#! gap> Size(last);
#! 1296
#! @EndExampleSession