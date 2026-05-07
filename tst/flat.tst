gap> FlatOrientablyRegularPolyhedron(4,4,-1,1) = ToroidalMap44([2,0]);
true
gap> FlatOrientablyRegularPolyhedron(3,8,-1,1);
#I  The given values of p, q, i, and j do not define a flat orientably regular polyhedron.
fail
gap> Size(FlatOrientablyRegularPolyhedraOfType([6,6]));
3
gap> Size(TightOrientablyRegularPolytopesOfType([12,6,12]));
7
