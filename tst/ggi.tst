gap> g := UniversalGgi(3);
<fp group of size infinity on the generators [ r0, r1, r2 ]>
gap> RelatorsOfFpGroup(g);
[ r0^2, r1^2, r2^2 ]
gap> q := UniversalGgi([3,3,3]);
<fp group on the generators [ r0, r1, r2 ]>
gap> RelatorsOfFpGroup(q);
[ r0^2, r1^2, r2^2, (r0*r1)^3, (r0*r2)^3, (r1*r2)^3 ]
gap> g := Ggi([3,3,3], "(r0 r1 r2 r1)^3");;
gap> Size(g);
54
gap> n := 5;;
gap> Size(Ggi([3,3,3], "(r0 r1 r2 r1)^$n"));
150
gap> L := List([1..5], k -> Ggi([3,3,3], ["r0 r1 r2 r1"], [k]));;
gap> List(L, Size);
[ 6, 24, 54, 96, 150 ]
gap> g := Group((1,2), (2,3), (3,4), (1,4));;
gap> GgiElement(g, "r0 r3");
(1,2,4)
gap> g := Ggi([3,3,3], "(r0 r1 r2 r1)^4");;
gap> SimplifiedGgiElement(g, "(r0 r1)^4");
r0*r1