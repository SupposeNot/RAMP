gap> M := Maniplex(ConnectionGroup(Cube(3)));;
gap> SetNumberOfFlagOrbits(M, 3);
gap> VerifyProperties(M);
Value mismatch in NumberOfFlagOrbits: stored value is 3 and real value is 1
false
gap> P := AbstractPolytope(Group([ (1,2)(3,4)(5,6)(7,8)(9,10), (1,10)(2,3)(4,5)(6,7)(8,9) ]));;
gap> P = Pgon(5);
true
gap> Pgon(5)=AbstractRegularPolytope(Group([(2,3)(4,5),(1,2)(3,4)]));
true
gap> TranslatePerm((1,2,3,4),5);
(6,7,8,9)
gap> MultPerm((1,2,3)(4,5,6),3,7);
(1,2,3)(4,5,6)(8,9,10)(11,12,13)(15,16,17)(18,19,20)
gap> MultPerm((1,2,3,4),2,4);
(1,2,3,4)(5,6,7,8)
gap> InvolutionListList([3,4,5],[6,7,8]);
(3,6)(4,7)(5,8)
gap> PermFromRange((1,2), (9,10));
(1,2)(3,4)(5,6)(7,8)(9,10)
gap> PermFromRange((1,3), (13,15));
(1,3)(4,6)(7,9)(10,12)(13,15)
gap> PermFromRange((2,3,4), (8,9,10));
(2,3,4)(5,6,7)(8,9,10)
gap> PermFromRange((1,2), (101,102), (601,602));
(1,2)(101,102)(201,202)(301,302)(401,402)(501,502)(601,602)
gap> g := AutomorphismGroup(CubicTiling(2));;
gap> rels := "(r0 r1 r2 r1)^6";;
gap> newrels := ParseGgiRels(rels, g);
[ (r0*r1*r2*r1)^6 ]
gap> newrels[1] in FreeGroupOfFpGroup(g);
true
gap> g2 := FactorGroupFpGroupByRels(g, newrels);
<fp group on the generators [ r0, r1, r2 ]>
gap> g := UniversalRotationGroup([4,4]);
<fp group of size infinity on the generators [ s1, s2 ]>
gap> rels := "(s1 s2^-1)^6";;
gap> newrels := ParseRotGpRels(rels, g);
[ (s1*s2^-1)^6 ]
gap> g2 := FactorGroupFpGroupByRels(g, newrels);
<fp group on the generators [ s1, s2 ]>
gap> M := RotaryManiplex(g2);
3-maniplex with 288 flags
gap> M = ToroidalMap44([6,0]);
true
gap> f := FreeGroup("x","y","z");
<free group on the generators [ x, y, z ]>
gap> x := f.1;; y := f.2;; z := f.3;;
gap> g := f / [x^2, y^2, z^2, (x*z)^2, (x*y)^4, (y*z)^4, (x*y*z)^6];
<fp group on the generators [ x, y, z ]>
gap> IsSggi(g);
true
gap> g2 := StandardizeSggi(g);
<fp group on the generators [ r0, r1, r2 ]>
gap> ReflexibleManiplex(g) = ReflexibleManiplex(g2);
true
gap> L := [1, 2, 3];;
gap> AddOrAppend(L, 4);
gap> L;
[ 1, 2, 3, 4 ]
gap> AddOrAppend(L, [5, 6]);
gap> L;
[ 1, 2, 3, 4, 5, 6 ]
gap> myjoin := WrappedPosetOperation(JoinProduct);
function( arg... ) ... end
gap> M := myjoin(Pgon(4), Vertex());
3-maniplex
gap> M = Pyramid(4);
true
gap> g := Group([ (1,2)(3,4)(5,6)(7,8), (2,3)(6,7), (3,5)(4,6) ]);;
gap> ActionByGenerators(g, [[1,8],[2,7],[3,6],[4,5]], OnSets);
Group([ (1,2)(3,4), (2,3), (3,4) ])
gap> g := Group([ (1,2)(3,4)(5,6)(7,8), (2,3)(6,7), (3,5)(4,6) ]);;
gap> ActionOnBlocks(g, [1..8], [1,8]);
Group([ (1,2)(3,4), (2,3), (3,4) ])
gap> XORLists([1,0,1,1,0,0,1], [0,1,1,1,0,0,1]);
[ 1, 1, 0, 0, 0, 0, 0 ]
gap> ConvertToBinaryList(12,8);
[ 0, 0, 0, 0, 1, 1, 0, 0 ]
gap> BinaryListToInteger([0,0,1,1,0,0,1]);
25
gap> LtoC(5,4,14);
[ 1, 2 ]
gap> CtoL(3,2,5,4);
8
gap> LtoC(8,5,4);
[ 3, 2 ]
