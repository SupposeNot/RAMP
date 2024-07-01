gap> Size(ARP([3,2])) = 12;
true
gap> Size(RotaryManiplex([4,4], "(s1^-1 s2) (s1 s2^-1)^2")) = 40;
true
gap> Size(STG3(4,0,1)) = 3;
true
gap> IsPolytopal(ToroidalMap44([1,0])) or IsPolytopal(ToroidalMap44([1,1]));
false
gap> IsFaithful(ToroidalMap44([1,0]));
false
gap> IsFaithful(ToroidalMap44([1,1]));
true
gap> IsPolytopal(Pyramid(UniversalPolytope(3)));
true
gap> IsPolytopal(IOrientableCover(ReflexibleManiplex([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3"), [0,1,2,3]));
false
gap> IsPolytopal(SmallestReflexibleCover(RotaryManiplex([6,9,6], "s2 s1^2 = s1^2 s2^4, s3^2 s2 = s2^4 s3^2")));
false
gap> IsFaithful(RotaryManiplex([6,6], "s1 = s2"));
false
gap> IsFaithful(RotaryManiplex([6,6], "s1^2 = s2^-2"));
true
gap> IsPolytopal(RotaryManiplex([6,6], "s1^2 = s2^-2"));
false
gap> IsPolytopal(RotaryManiplex([4,3,6], "s2 = s3^2"));
false
gap> IsPolytopal(RotaryManiplex([6,3,4], "s2 = s1^2"));
false