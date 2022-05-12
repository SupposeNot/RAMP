gap> IsQuotient(Cube(3),HemiCube(3));
true
gap> IsQuotient(UniversalSggi([4,3]),AutomorphismGroup(HemiCube(3)));
true
gap> IsRootedQuotient(ToroidalMap44([4,4]), ToroidalMap44([4,0]));
true
gap> IsRootedQuotient(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
false
gap> IsCover(HemiDodecahedron(),Dodecahedron());
true
gap> IsRootedCover(ToroidalMap44([4,0]), ToroidalMap44([4,4]));
true
gap> IsRootedCover(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
false
gap> IsIsomorphicManiplex(HemiCube(3),Petrial(Simplex(3)));
true
gap> IsIsomorphicManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
true
gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
false
gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), EnantiomorphicForm(ToroidalMap44([2,1])));
true
gap> SmallestReflexibleCover(ToroidalMap44([2,3],[3,2])) = ToroidalMap44([5,0]);
true
gap> ReflexibleQuotientManiplex(CubicTiling(2),"(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2") = ToroidalMap44([1,0]);
true
gap> g := UniversalSggi(3);;
gap> h := QuotientSggi(g, "(r0 r1)^5, (r1 r2)^3, (r0 r1 r2)^5");;
gap> Size(h);
60
gap> g:=AutomorphismGroup(Cube(3));;
gap> q:=QuotientSggiByNormalSubgroup(g,Group([(g.1*g.2*g.3)^3]));;
gap> Maniplex(q)=HemiCube(3);
true
gap> m:=Cube(3);;
gap> a:=AutomorphismGroupOnFlags(m);;
gap> h:=Group((a.3*a.1*a.2)^3);;
gap> q:=QuotientManiplexByAutomorphismSubgroup(m,h);;
gap> last=HemiCube(3);
true
