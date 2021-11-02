gap> M := Cube(3);; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := Medial(Cube(3));; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := Pyramid(Cube(3));; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := Pyramid(5);; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := ARP([4,4], "z1^6");; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := ReflexibleManiplex([4,4], "z1^5");; M = ManiplexFromDatabaseString(DatabaseString(M));
true
gap> M := RotaryManiplex([4,4], "s2^-1*s1");; M = ManiplexFromDatabaseString(DatabaseString(M));
true
