gap> g:=UniversalSggi(3);
<fp group of size infinity on the generators [ r0, r1, r2 ]>
gap> q:=UniversalSggi([3,4]);
<fp group of size 48 on the generators [ r0, r1, r2 ]>
gap> IsQuotient(g,q);
true
gap> g := Sggi([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");;
gap> h := Sggi([4,4], "r0 = r2");;
gap> k := Sggi([infinity, infinity], [[1,2,1,2,1,2], [2,3,2,3,2,3]]);;
gap> SchlafliSymbol(k);
[ 3, 3 ]
gap> n := 3;;
gap> Size(Sggi([4,4], "(r0 r1 r2 r1)^$n"));
72
gap> L := List([1..5], k -> Sggi([4,4], ["r0 r1 r2"], [2*k]));;
gap> List(L, Size);
[ 16, 64, 144, 256, 400 ]
gap> IsGgi(SymmetricGroup(4));
false
gap> IsGgi(Group([(1,2),(2,3)]));
true
gap> IsStringy(Group((1,2),(2,3),(3,4)));
true
gap> IsStringy(Group((1,2),(3,4),(2,3)));
false
gap> IsSggi(SymmetricGroup(4));
false
gap> IsSggi(Group((1,2),(3,4),(2,3)));
false
gap> IsSggi(Group((1,2),(2,3),(3,4)));
true
gap> IsFixedPointFreeSggi(Group((1,2)(3,4), (1,3)(2,4) ,(1,4)(2,3)));
true
gap> IsFixedPointFreeSggi(Group((1,2)(3,4), (1,2)(3,4), (1,4)(2,3)));
false
gap> IsStringRotationGroup(Group((1,2)(3,4), (2,3,4)));
false
gap> IsStringRotationGroup(Group((1,3,2), (2,4,3)));
true
gap> IsStringC(Sggi([4,4], "r0 r1 r2"));
false
gap> IsStringC(Sggi([4,4], "(r0 r1 r2)^4"));
true
gap> IsStringCPlus(Group((1,2)(3,4), (2,3,4)));
false
gap> IsStringCPlus(Group((1,3,2), (2,4,3)));
true
gap> IsStringCPlus(RotationGroup(ToroidalMap44([1,0])));
false
gap> g := Group((1,2),(2,3),(3,4));;
gap> SggiElement(g, "r0 r1");
(1,3,2)
gap> n := 2;;
gap> SggiElement(g, "(r0 r1)^$n");
(1,2,3)
gap> g := AutomorphismGroup(Cube(3));;
gap> SimplifiedSggiElement(g, "(r0 r1)^5");
r0*r1
gap> M := ReflexibleManiplex([8,6],"(r0 r1)^4 (r1 r2)^3");;
gap> IsRelationOfReflexibleManiplex(M, "(r0 r1 r2)^3");
false
gap> IsRelationOfReflexibleManiplex(M, "(r0 r1 r2)^12");
true
gap> Order(RotGpElement(Cube(3), "s1"));
4
gap> Order(RotGpElement(ToroidalMap44([1,2]), "s2^-1 s1"));
5
gap> SimplifiedRotGpElement(ToroidalMap44([1,2]), "s1^6");
s1^2
gap> f := SggiFamily(Sggi([4,4]), ["r0 r1 r2 r1"]);
function( orders ) ... end
gap> g := f([3]);
<fp group on the generators [ r0, r1, r2 ]>
gap> Size(g);
72
gap> h := f([6]);
<fp group on the generators [ r0, r1, r2 ]>
gap> IsQuotient(h,g);
true
gap> IsCConnected(ToroidalMap44([1,0]));
false
gap> IsCConnected(Prism(ToroidalMap44([1,0])));
true
gap> g := AutomorphismGroup(Cube(5));;
gap> SectionSubgroup(g, [0, 2, 3]);
Group([ r0, r2, r3 ])
gap> Size(last);
12
gap> VertexFigureSubgroup(AutomorphismGroup(Cube(3)));
Group([ r1, r2 ])
gap> Size(last);
6
gap> FacetSubgroup(AutomorphismGroup(Cube(3)));
Group([ r0, r1 ])
gap> Size(last);
8
gap> UniversalRotationGroup(3);
<fp group of size infinity on the generators [ s1, s2 ]>
gap> UniversalRotationGroup([4,4]);
<fp group of size infinity on the generators [ s1, s2 ]>
gap> UniversalRotationGroup([3,3,3]);
<fp group of size 60 on the generators [ s1, s2, s3 ]>
gap> IsStringC(Group((1,2)));
true
gap> IsStringC(Group((1,2)(3,4)(5,6), (2,3)(4,5)(1,6)));
true
gap> IsStringC(Sggi([6,8], "(r0 r1)^3 = (r1 r2)^4"));
false
gap> IsStringC(Sggi([4,4,4], "r2"));
false
gap> IsStringCPlus(RotationGroup(RotaryManiplex([6,8], "s1^3 = s2^4")));
false
