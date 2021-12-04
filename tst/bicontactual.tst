gap> Epsilonk(5);
AbstractRegularPolytope([ 5, 2 ])
gap> Epsilonk(6);
AbstractRegularPolytope([ 6, 2 ])
gap> Deltak(5);
ReflexibleManiplex([ 10, 2 ], "(r0 r1)^5 r2")
gap> Deltak(6);
ReflexibleManiplex([ 12, 2 ], "(r0 r1)^6 r2")
gap> Mk(5);Mk(6);
ReflexibleManiplex([ 10, 5 ], "(r0 r1)^5 r0 = r2")
ReflexibleManiplex([ 12, 12 ], "(r0 r1)^6 r0 = r2")
gap> MkPrime(5);MkPrime(6);
ReflexibleManiplex([ 5, 10 ], "(r0 r1 r2)^2")
ReflexibleManiplex([ 6, 6 ], "(r0 r1 r2)^2")
gap> Bk2l(4,5);
3-maniplex with 80 flags
gap> Bk2lStar(5,7);
3-maniplex with 140 flags
gap> Opp(Bk2lStar(5,7));
Petrial(Dual(Petrial(3-maniplex with 140 flags)))
gap> Hole(Bk2lStar(5,7),2);
3-maniplex with 140 flags
