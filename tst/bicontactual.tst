gap> Epsilonk(5) = ARP([5,2]);
true
gap> Epsilonk(6) = ARP([6,2]);
true
gap> Deltak(5) = ReflexibleManiplex([ 10, 2 ], "(r0 r1)^5 r2");
true
gap> Deltak(6) = ReflexibleManiplex([ 12, 2 ], "(r0 r1)^6 r2");
true
gap> Mk(5) = ReflexibleManiplex([ 10, 5 ], "(r0 r1)^5 r0 = r2");
true
gap> Mk(6) = ReflexibleManiplex([ 12, 12 ], "(r0 r1)^6 r0 = r2");
true
gap> MkPrime(5) = ReflexibleManiplex([ 5, 10 ], "(r0 r1 r2)^2");
true
gap> MkPrime(6) = ReflexibleManiplex([ 6, 6 ], "(r0 r1 r2)^2");
true
gap> Size(Bk2l(4,10)) = 80;
true
gap> Size(Bk2lStar(5,14)) = 140;
true
gap> Opp(Bk2lStar(5,14)) = Petrial(Dual(Petrial(Bk2lStar(5,14))));
true
gap> Size(Hole(Bk2lStar(5,14),2)) = 140;
true
gap> IsSelfPetrial(Bk2lRhoSigma(4,16,3,0));
true
gap> Opp(Bk2lRhoSigma(4,16,3,0))=Bk2lRhoSigma(4,16,5,2);
true
gap> Bk2l(4,16)=Bk2lRhoSigma(4,16,1,2);
true
gap> Bk2lStar(4,16)=Bk2lRhoSigma(4,16,1,6);
true