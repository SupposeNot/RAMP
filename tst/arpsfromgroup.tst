gap> a5search := ARPsFromGroupSearch(AlternatingGroup(5), 3);;
gap> Length(a5search.reps);
3
gap> Length(a5search.repsModDuality);
2
gap> Set(List(a5search.reps, t -> List([1..2], i -> Order(t[i] * t[i+1]))));
[ [ 3, 5 ], [ 5, 3 ], [ 5, 5 ] ]
gap> ForAll(a5search.reps, t -> IsStringC(Group(t)));
true
gap> psl32search := ARPsFromGroupSearch(PSL(3,2), 3);;
gap> Length(psl32search.reps);
0
gap> psl211r3 := ARPsFromGroupSearch(PSL(2,11), 3);;
gap> Length(psl211r3.reps);
4
gap> Length(psl211r3.repsModDuality);
3
gap> Set(List(psl211r3.reps, t -> List([1..2], i -> Order(t[i] * t[i+1]))));
[ [ 5, 5 ], [ 5, 6 ], [ 6, 5 ], [ 6, 6 ] ]
gap> psl211r4 := ARPsFromGroupSearch(PSL(2,11), 4);;
gap> Length(psl211r4.reps);
1
gap> List(psl211r4.reps[1], Order);
[ 2, 2, 2, 2 ]
gap> List([1..3], i -> Order(psl211r4.reps[1][i] * psl211r4.reps[1][i+1]));
[ 3, 5, 3 ]
gap> ARPsFromGroup(PSL(3,2), 3);
[  ]
gap> StringCGroupRepresentations(PSL(3,2), 3);
[  ]
