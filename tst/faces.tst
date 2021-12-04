gap> IsSpherical(Simplex(3));
true
gap> IsSpherical(AbstractRegularPolytope([4,4],"h2^3"));
false
gap> IsSpherical(Pyramid(5));
true
gap> IsSpherical(CubicTiling(2));
false
gap> IsLocallySpherical(Simplex(4));
true
gap> IsLocallySpherical(AbstractRegularPolytope([4,4,4]));
false
gap> IsLocallySpherical(CubicTiling(3));
true
gap> IsLocallySpherical(Pyramid(Cube(3)));
true
gap> IsToroidal(Simplex(3));
false
gap> IsToroidal(AbstractRegularPolytope([4,4],"h2^3"));
true
gap> IsToroidal(Pyramid(5));
false
gap> IsLocallyToroidal(Simplex(4));
false
gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,3],"(r0 r1 r2 r1)^2"));
true
gap> IsLocallyToroidal(AbstractRegularPolytope([4,4,4],"(r0 r1 r2 r1)^2, (r1 r2 r3 r2)^2"));
true
