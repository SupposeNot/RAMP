gap> DegeneratePolyhedra([5..4]);
[  ]
gap> DegeneratePolyhedra(6);
[  ]
gap> Size(DegeneratePolyhedra(8));
1
gap> Size(DegeneratePolyhedra(50));
21
gap> Size(DegeneratePolyhedra([1..50]));
21
gap> Size(DegeneratePolyhedra([8..50]));
21
gap> Size(DegeneratePolyhedra([9..50]));
20
gap> Size(DegeneratePolyhedra([9..48]));
20
gap> Size(DegeneratePolyhedra([9..47]));
18
gap> ForAll(DegeneratePolyhedra(50), IsDegenerate);
true
gap> Size(FlatRegularPolyhedra(50));
32
gap> Size(FlatRegularPolyhedra(50 : nondegenerate));
11
gap> ForAll(FlatRegularPolyhedra(50), IsTight);
true
gap> ForAll(FlatRegularPolyhedra(50), IsFlat);
true
gap> ForAny(FlatRegularPolyhedra(50 : nondegenerate), IsDegenerate);
false
gap> ForAll(DegeneratePolyhedra(50), p -> p in FlatRegularPolyhedra(50));
true
gap> Size(RegularToroidalPolyhedra44(100));
3
gap> Size(RegularToroidalPolyhedra44(128));
4
gap> Size(RegularToroidalPolyhedra44(127));
3
gap> Size(RegularToroidalPolyhedra36(100));
2
gap> Size(RegularToroidalPolyhedra36(144));
4
gap> ForAny(SmallRegularPolyhedra(100 : nonflat), IsFlat);
false
gap> ForAny(SmallRegularPolyhedra(100 : nondegenerate), IsDegenerate);
false
gap> Size(Filtered(SmallRegularPolyhedra(200), p -> SchlafliSymbol(p) = [4,4])) = Size(RegularToroidalPolyhedra44(200));
true
gap> Size(Filtered(SmallRegularPolyhedra(200), p -> SchlafliSymbol(p) = [3,6])) = Size(RegularToroidalPolyhedra36(200));
true
gap> Size(Filtered(SmallRegularPolyhedra(200), IsDegenerate)) = Size(DegeneratePolyhedra(200));
true
gap> Size(Filtered(SmallRegularPolyhedra(200), IsTight)) = Size(FlatRegularPolyhedra(200));
true

# These take too long to be very useful
#gap> Size(SmallRegularPolyhedra(4000));
#22415
#gap> Size(SmallRegularPolyhedra(4000 : nonflat));
#15860
