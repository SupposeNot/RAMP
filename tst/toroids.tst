gap> ToroidalMap44([3,0]) = ARP([4,4], "(r0 r1 r2 r1)^3");
true
gap> ToroidalMap44([3,3]) = ARP([4,4], "(r0 r1 r2)^6");
true
gap> ToroidalMap44([3,-3]) = ToroidalMap44([3,3]);
true
gap> M := ToroidalMap44([1,2]);; IsChiral(M);
true
gap> M = RotaryManiplex([4,4], "s2^-1 s1 (s2 s1^-1)^2");
true
gap> ToroidalMap44([5,0]) = SmallestReflexibleCover(M);
true
gap> M := ToroidalMap44([2,0],[0,3]);; NumberOfFlagOrbits(M);
2
gap> M = ARP([4,4]) / "(r0 r1 r2 r1)^2, (r1 r0 r1 r2)^3";
true
gap> SmallestReflexibleCover(M) = ToroidalMap44([6,0]);
true
gap> ToroidalMap44([2,3],[4,1]) = ToroidalMap44([-3,2],[-1,4]);
true
gap> M := CubicToroid(4, [[1,0,1,0],[1,0,-1,0],[0,1,0,1],[0,1,0,-1]]);;
gap> NumberOfFlagOrbits(M);
3
gap> Size(ToroidalMap36([3,0])) = 108;
true
gap> IsReflexible(ToroidalMap36([2,3]));
false
gap> SmallestReflexibleCover(ToroidalMap36([2,3])) = ToroidalMap36([19,0]);
true
gap> ToroidalMap36([3,0]) = ToroidalMap36([3,0],[0,3]);
true
gap> ToroidalMap36([2,2]) = ToroidalMap36([2,2],[4,-2]);
true
gap> ToroidalMap36([2,3]) = ToroidalMap36([2,3],[-3,5]);
true
gap> NumberOfFlagOrbits(ToroidalMap36([3,0],[-2,4]));
3
gap> NumberOfFlagOrbits(ToroidalMap36([4,3],[5,0]));
6
gap> Size(ToroidalMap63([3,0])) = 108;
true
gap> IsReflexible(ToroidalMap63([2,3]));
false
gap> SmallestReflexibleCover(ToroidalMap63([2,3])) = ToroidalMap63([19,0]);
true
gap> ToroidalMap63([3,0]) = ToroidalMap63([3,0],[0,3]);
true
gap> ToroidalMap63([2,2]) = ToroidalMap63([2,2],[4,-2]);
true
gap> ToroidalMap63([2,3]) = ToroidalMap63([2,3],[-3,5]);
true
gap> NumberOfFlagOrbits(ToroidalMap63([3,0],[-2,4]));
3
gap> NumberOfFlagOrbits(ToroidalMap63([4,3],[5,0]));
6