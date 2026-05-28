
#! @Chapter Families of Polytopes
#! @Section The Tomotope

#! @Returns  maniplex
#! @Description Constructs the **Tomotope** from <Cite Key="MonPelWil12"/>. This is
#! the smallest known polytope whose smallest reflexible cover is not a polytope.
DeclareOperation("Tomotope", []);
#! @BeginExampleSession
#! gap> SchlafliSymbol(Tomotope());
#! [ 3, [ 3, 4 ], 4 ]
#! gap> IsPolytopal(SmallestReflexibleCover(Tomotope()));
#! false
#! @EndExampleSession