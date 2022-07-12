
#! @Chapter Groups for Maps, Polytopes, and Maniplexes
#! @Section Groups of Maps, Polytopes, and Maniplexes

#! @BeginGroup Automorphism Group
#! @GroupTitle Automorphism Groups
#! @Arguments M
#! Returns the automorphism group of <A>M</A>.
#! This group is not guaranteed to be in any particular form. For particular permutation representations you should consider the various AutomorphismGroupOn... functions, or AutomorphismGroupFpGroup.
DeclareAttribute("AutomorphismGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! finitely presented group. If <A>M</A> is reflexible, then this is guaranteed to be the standard presentation.
DeclareAttribute("AutomorphismGroupFpGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! permutation group. This group is not guaranteed to be in any particular form. For particular permutation representations you should consider the various AutomorphismGroupOn... functions.
DeclareAttribute("AutomorphismGroupPermGroup", IsManiplex);

#! @Arguments M
#! Returns the automorphism group of <A>M</A> as a
#! permutation group action on the flags of <A>M</A>.
DeclareAttribute("AutomorphismGroupOnFlags", IsManiplex);
#! @BeginExampleSession
#! gap> s0 := (3,7)(4,8)(5,6);;
#! gap> s1 := (2,3)(4,6)(5,7);;
#! gap> s2 := (1,2)(3,6)(4,8)(5,7);;
#! gap> poly := Group([s0,s1,s2]);;
#! gap> p:=ARP(poly);
#! regular 3-polytope
#! gap> AutomorphismGroup(p);
#! Group([ (3,7)(4,8)(5,6), (2,3)(4,6)(5,7), (1,2)(3,6)(4,8)(5,7) ])
#! gap> AutomorphismGroupFpGroup(p);
#! <fp group on the generators [ r0, r1, r2 ]>
#! gap> AutomorphismGroupPermGroup(Cube(3));
#! Group([ (3,4), (2,3)(4,5), (1,2)(5,6) ])
#! gap> AutomorphismGroupOnFlags(Cube(3));
#! <permutation group with 3 generators>
#! gap> GeneratorsOfGroup(last);
#! [ (1,20)(2,13)(3,10)(4,34)(5,35)(6,7)(8,27)(9,28)(11,23)(12,24)(14,44)(15,45)(16,18)(17,19)(21,40)(22,41)(25,37)(26,38)(29,48)(30,32)(31,33)(36,47)(39,46)(42,43), 
#!   (1,11)(2,18)(3,4)(5,26)(6,41)(7,8)(9,33)(10,45)(12,15)(13,31)(14,25)(16,28)(17,27)(19,22)(20,38)(21,32)(23,35)(24,34)(29,39)(30,47)(36,43)(37,48)(40,42)(44,46), 
#!   (1,3)(2,7)(4,25)(5,28)(6,13)(8,32)(9,35)(10,20)(11,14)(12,17)(15,47)(16,40)(18,21)(19,24)(22,48)(23,44)(26,42)(27,30)(29,41)(31,39)(33,46)(34,37)(36,45)(38,43) ]
#! @EndExampleSession
#! @EndGroup

#! @Arguments M
#! Returns the connection group of the premaniplex <A>M</A> as a
#! permutation group. We may eventually allow other types
#! of connection groups.
#! Synonym: MonodromyGroup
DeclareAttribute("ConnectionGroup", IsPremaniplex);

DeclareSynonymAttr("MonodromyGroup", ConnectionGroup);
#! @BeginExampleSession
#! gap> ConnectionGroup(HemiCube(3));
#! Group([ (1,8)(2,7)(3,14)(4,13)(5,20)(6,19)(9,16)(10,15)(11,22)(12,21)(17,24)(18,23), (1,3)(2,5)
#!   (4,6)(7,9)(8,11)(10,12)(13,15)(14,17)(16,18)(19,21)(20,23)(22,24), (1,2)(3,4)(5,6)(7,8)(9,10)
#!   (11,12)(13,14)(15,16)(17,18)(19,20)(21,22)(23,24) ])
#! @EndExampleSession

#! @Arguments M
#! Returns the even-word subgroup of the connection group of <A>M</A> as a
#! permutation group. 
DeclareAttribute("EvenConnectionGroup", IsManiplex);
#! @BeginExampleSession
#! gap> EvenConnectionGroup(HemiCube(3));
#! Group([ (1,11,24,14)(2,9,18,20)(3,17,22,8)(4,15,12,19)(5,23,16,7)(6,21,10,13), (1,4,5)(2,6,3)
#!   (7,10,11)(8,12,9)(13,16,17)(14,18,15)(19,22,23)(20,24,21) ])
#! @EndExampleSession

#! @Arguments M
#! Returns the rotation group of <A>M</A>.
#! This group is not guaranteed to be in any particular form.
DeclareAttribute("RotationGroup", IsManiplex);
#! @BeginExampleSession
#! gap> RotationGroup(HemiCube(3));
#! Group([ r0*r1, r1*r2 ])
#! @EndExampleSession

#! @Arguments M
#! Returns the rotation group of <A>M</A>, as a finitely presented group
#! on the standard generators.
DeclareAttribute("RotationGroupFpGroup", IsManiplex);
#! @BeginExampleSession
#! gap> RotationGroupFpGroup(ToroidalMap44([1,2]));
#! <fp group on the generators [ s1, s2 ]>
#! gap> RelatorsOfFpGroup(last);
#! [ (s1*s2)^2, s1^4, s2^4, s2^-1*s1*(s2*s1^-1)^2 ]
#! @EndExampleSession

#! @Arguments M
#! Returns the chirality group of the rotary maniplex <A>M</A>.
#! This is the kernel of the group epimorphism from the
#! rotation group of <A>M</A> to the rotation group of its maximal
#! reflexible quotient. In particular, the chirality group
#! is trivial if and only if <A>M</A> is reflexible.
DeclareAttribute("ChiralityGroup", IsRotaryManiplex);
#! @BeginExampleSession
#! gap> M := ToroidalMap44([1,2]);
#! ToroidalMap44([ 1, 2 ])
#! gap> G := ChiralityGroup(M);
#! Group([ s2^-1*s1^-1*s2*s1^3*s2*s1 ])
#! gap> Size(G);
#! 5
#! @EndExampleSession


#! @Arguments M
#! For a reflexible maniplex <A>M</A>, returns the relators
#! needed to define its automorphism group as a quotient of
#! the string Coxeter group given by its Schlafli symbol.
#! Not particularly robust at the moment.
DeclareAttribute("ExtraRelators", IsReflexibleManiplex);
#! @BeginExampleSession
#! gap> ExtraRelators(HemiCube(3));
#! [ (r0*r1*r2)^3 ]
#! @EndExampleSession

#! @Arguments M
#! For a reflexible maniplex <A>M</A>, returns the relators
#! needed to define its rotation group as a quotient of
#! the rotation group of a string Coxeter group given by its Schlafli symbol.
#! Not particularly robust at the moment.
DeclareAttribute("ExtraRotRelators", IsRotaryManiplex);
#! @BeginExampleSession
#! gap> ExtraRotRelators(HemiCube(3));
#! [ (F2^-1*F1^-1)^2, (F2*F1^2*F2^-1*F1^-1)^2 ]
#! @EndExampleSession

#! @Arguments permgroup
#! @Returns `Boolean`. 
#! @Description Given a permutation group, it asks if the generators could be the connection group of a maniplex.
#! That is to say, are each of the generators and their products fixed point free.
DeclareOperation("IsManiplexable",[IsPermGroup]);
