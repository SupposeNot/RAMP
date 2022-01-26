
#! @Chapter Stratified Operations
#! @Section Computational tools
#! I should say something more here.

#! @Arguments element1, element2
#! @Returns element
#! @Description Elements are ordered pairs of the form [perm, list], where the elements of list are members of a group. Operation performed is consistent with that in defined in <Cite Key="PelWil18"/>.
#! 
DeclareOperation("ChunkMultiply", [IsList,IsList]);

#! @Arguments element, integer
#! @Returns element
#! @Description Given an element compatible with the  ChunkMultiply operation, this function will compute the product of element with itself integer times.
DeclareOperation("ChunkPower", [IsList,IsInt]);

#! @Arguments list, group
#! @Returns newList
#! @Description Given a list of generators compatible with the ChunkMultiply operation, this function will construct the associated list of group elements in a form suitable for taking ChunkMultiply and ChunkPower.
DeclareOperation("ChunkGeneratedGroupElements", [IsList, IsGroup]);
#! @BeginExampleSession
#! gap> g:=AutomorphismGroup(Simplex(2));
#! <fp group of size 6 on the generators [ r0, r1 ]>
#! gap> AssignGeneratorVariables(g);
#! #I  Assigned the global variables [ r0, r1 ]
#! gap> SetReducedMultiplication(r0);
#! gap> s0:=[(1,2),[r0,r0,r1]];;s1:=[(2,3),[r0,r1,r1]];;
#! gap> ChunkGeneratedGroupElements([s0,s1],g);
#! [ [ (1,2), [ r0, r0, r1 ] ], [ (2,3), [ r0, r1, r1 ] ], 
#!   [ (), [ <identity ...>, <identity ...>, <identity ...> ] ], 
#!   [ (1,3,2), [ <identity ...>, <identity ...>, r0*r1 ] ], 
#!   [ (1,2,3), [ r1*r0, <identity ...>, <identity ...> ] ], [ (1,3), [ r0, r0, r0 ] ], 
#!   [ (1,3), [ r1, r1, r1 ] ], [ (1,2,3), [ <identity ...>, r0*r1, r0*r1 ] ], 
#!   [ (1,3,2), [ r1*r0, r1*r0, <identity ...> ] ], [ (2,3), [ r0*r1*r0, r0, r0 ] ], 
#!   [ (1,2), [ r1, r1, r0*r1*r0 ] ], [ (), [ r0*r1, r0*r1, r0*r1 ] ], 
#!   [ (), [ r1*r0, r1*r0, r1*r0 ] ], [ (1,2), [ r0*r1*r0, r0*r1*r0, r0 ] ], 
#!   [ (2,3), [ r1, r0*r1*r0, r0*r1*r0 ] ], [ (1,3,2), [ r0*r1, r0*r1, r1*r0 ] ], 
#!   [ (1,2,3), [ r0*r1, r1*r0, r1*r0 ] ], [ (1,3), [ r0*r1*r0, r0*r1*r0, r0*r1*r0 ] ] ]
#! @EndExampleSession


#! @Arguments list, group
#! @Returns permGroup
#! @Description Given a list of generators compatible with the ChunkMultiply operation, this function will construct a representation of the group as a permutation group. Note that generators are of the form [perm, list], and each list is a list of elements from group.
DeclareOperation("ChunkGeneratedGroup", [IsList, IsPermGroup]);
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


#! @Arguments list, group
#! @Returns IsPermGroup
#! @Description Implements fully stratified operations on maniplexes from <Cite Key="CunPelWil22"/>. Given <A>list</A> of generators compatible with the `ChunkMultiply` operation, <A>group</A> is the underlying group in the representation (usually the connection group of the base), this will calculate the connection group of the resulting maniplex acting on the implicit flags of the construction. Function assumes that <A>list</A> are the generators of the connection group of the resulting maniplex in the order $\langle r_0, r_1, \ldots, r_{d-1}\rangle$.
#! It is possible that for some groups this function will behave poorly because GAP won't recognize equivalent representations of a group element. If so, try again with a permutation representation and let us know so we can modify the code to handle this problem better (didn't show up in our testing, but is a theoretical possibility).
DeclareOperation("FullyStratifiedGroup", [IsList, IsGroup]);
#! @BeginExampleSession
#! gap> p:=Simplex(2);; a:=AutomorphismGroup(p);
#! <fp group of size 6 on the generators [ r0, r1 ]>
#! gap> e:=One(a);
#! <identity ...>
#! gap> AssignGeneratorVariables(a);
#! #I  Assigned the global variables [ r0, r1 ]
#! gap> s0:=[(3,4),[r0,r0,e,e,r0,r0]];
#! [ (3,4), [ r0, r0, <identity ...>, <identity ...>, r0, r0 ] ]
#! gap> s1:=[(2,3)(4,5),[r1,e,e,e,e,r1]];
#! [ (2,3)(4,5), [ r1, <identity ...>, <identity ...>, <identity ...>, <identity ...>, r1 ] ]
#! gap> s2:=[(1,2)(5,6),[e,e,r1,r1,e,e]];
#! [ (1,2)(5,6), [ <identity ...>, <identity ...>, r1, r1, <identity ...>, <identity ...> ] ]
#! gap> gens:=[s0,s1,s2];
#! [ [ (3,4), [ r0, r0, <identity ...>, <identity ...>, r0, r0 ] ], 
#!   [ (2,3)(4,5), [ r1, <identity ...>, <identity ...>, <identity ...>, <identity ...>, r1 ] ], 
#!   [ (1,2)(5,6), [ <identity ...>, <identity ...>, r1, r1, <identity ...>, <identity ...> ] ] ]
#! gap> Maniplex(FullyStratifiedGroup(gens,a))=Prism(Simplex(2));
#! true
#! @EndExampleSession