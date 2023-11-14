#! @Chapter Polytope Constructions and Operations
#! @Section Polytopes Associated with a Group

#! The tools in this section exist primarily to enable the classification and listing of regular polytopes associated with a given group, though it will likely be expanded to cover maniplexes as well.

#! The approach and treatment here follows closely that in <Cite Key="Har06"/>.

#! @Subsection String Group Construction Tools

#! @Arguments gamma
#! @Returns  elements
#! @Description Given a group <A>gamma</A>, gives a list of representatives of the conjugacy classes of involutions in the group.
DeclareOperation("ConjugacyClassesOfInvolutionsRepresentatives", [IsGroup]);
#! @BeginExampleSession
#! gap>
#! @EndExampleSession

#! @Arguments gamma
#! @Returns  elements
#! @Description Given a group <A>gamma</A>, gives a list of representatives of the automorphism classes of involutions in the group.
DeclareOperation("AutomorphismClassRepresentativeInvolutions", [IsGroup]);
#! @BeginExampleSession
#! <##>
#! @EndExampleSession
