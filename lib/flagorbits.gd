
#! @Chapter Maniplex Properties
#! @Section Flag orbits

#! @Arguments M
#! @Returns IsList
#! @Description The list of flags of the maniplex <A>M</A>.
DeclareAttribute("Flags", IsManiplex);
#! @BeginExampleSession
#! gap> Flags(Pgon(5));
#! [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
#! gap> M := Maniplex(Group((3,4)(5,6)(7,8)(9,10), (3,6)(4,5)(7,10)(8,9), (3,7)(4,8)(5,9)(6,10)));;
#! gap> Flags(M);
#! [ 3, 4, 5, 6, 7, 8, 9, 10 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns IsObject
#! @Description The base flag of the maniplex <A>M</A>. By default, when the set of flags is a set of positive integers,
#! the base flag is the minimum of the set of flags.
DeclareAttribute("BaseFlag", IsManiplex);
#! @BeginExampleSession
#! gap> BaseFlag(Cube(3));
#! 1
#! gap> M := Maniplex(Group((3,4)(5,6)(7,8)(9,10), (3,6)(4,5)(7,10)(8,9), (3,7)(4,8)(5,9)(6,10)));;
#! gap> BaseFlag(M);
#! 3
#! @EndExampleSession


#! @Arguments M
#! Returns the Symmetry Type Graph of the maniplex <A>M</A>, encoded as
#! a permutation group on Rank(<A>M</A>) generators.
DeclareAttribute("SymmetryTypeGraph", IsManiplex);
#! @BeginExampleSession
#! gap> SymmetryTypeGraph(Prism(Simplex(3)));
#! Edge labeled graph with 4 vertices, and edge labels [ 0, 1, 2, 3 ]
#! @EndExampleSession

#! @Arguments M
#! Returns the number of orbits of the automorphism group of <A>M</A>
#! on its flags.
DeclareAttribute("NumberOfFlagOrbits", IsManiplex);
#! @BeginExampleSession
#! gap> NumberOfFlagOrbits(Prism(Simplex(3)));
#! 4
#! @EndExampleSession

#! @Arguments M
#! Returns one flag from each orbit under the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("FlagOrbitRepresentatives", IsManiplex);
#! @BeginExampleSession
#! gap> FlagOrbitRepresentatives(Prism(Simplex(3)));
#! [ 1, 49, 97, 145 ]
#! @EndExampleSession

#! @Arguments M
#! @Returns g
#! @Description Returns the subgroup of the connection group that preserves the flag orbits under the action of the automorphism group.
DeclareAttribute("FlagOrbitsStabilizer", IsManiplex);

#! @BeginExampleSession
#! gap> m:=Prism(Dodecahedron());
#! Prism(Dodecahedron())
#! gap> s:=FlagOrbitsStabilizer(m);
#! <permutation group of size 207360000 with 12 generators>
#! gap> IsSubgroup(ConnectionGroup(m),s);
#! true
#! gap> AsSet(Orbit(AutomorphismGroupOnFlags(m),1))=AsSet(Orbit(s,1));
#! true
#! @EndExampleSession


#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is reflexible (has one flag orbit).
DeclareProperty("IsReflexible", IsManiplex);
#! @BeginExampleSession
#! gap> IsReflexible(Epsilonk(6));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is chrial.
DeclareProperty("IsChiral", IsManiplex);
#! @BeginExampleSession
#! gap> IsChiral(ToroidalMap44([2,3]));
#! true
#! @EndExampleSession

#! @Arguments M
#! @Returns Whether the maniplex <A>M</A> is rotary; i.e., whether it is 
#! either reflexible or chiral.
DeclareProperty("IsRotary", IsManiplex);
#! @BeginExampleSession
#! gap> IsRotary(ToroidalMap44([3,5]));
#! true
#! @EndExampleSession

#! @Arguments M
#! Returns a list of lists of flags, representing the orbits of flags under the action of AutomorphismGroup(<A>M</A>).
DeclareAttribute("FlagOrbits", IsManiplex);
#! @BeginExampleSession
#! gap> FlagOrbits(ToroidalMap44([3,2]));
#! [ [ 1, 9, 7, 33, 15, 63, 5, 65, 39, 23, 13, 71, 61, 101, 3, 89, 47, 37, 95, 21, 11, 79, 69, 29, 59, 77, 99, 51, 49, 55, 45, 35, 103, 93, 19, 83, 87, 67, 85, 27, 57, 75, 91, 97, 43, 81, 53, 31, 17, 25, 73, 41 ], 
#!   [ 2, 10, 8, 34, 16, 64, 6, 66, 40, 24, 14, 72, 62, 102, 4, 90, 48, 38, 96, 22, 12, 80, 70, 30, 60, 78, 100, 52, 50, 56, 46, 36, 104, 94, 20, 84, 88, 68, 86, 28, 58, 76, 92, 98, 44, 82, 54, 32, 18, 26, 74, 42 ] ]
#! @EndExampleSession
