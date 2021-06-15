#! @Chapter Comparing maniplexes
#! @Section Quotients and covers

#! @Arguments M1, M2
#! Returns whether <A>M1</A> is a quotient of <A>M2</A>.
DeclareOperation("IsQuotientOf", [IsManiplex, IsManiplex]);

#! @Arguments M1, M2
#! Returns whether <A>M1</A> is a cover of <A>M2</A>.
DeclareOperation("IsCoverOf", [IsManiplex, IsManiplex]);

#! @Arguments M1, M2
#! Returns whether <A>M1</A> is isomorphic to <A>M2</A>.
DeclareOperation("IsIsomorphicTo", 	[IsManiplex, IsManiplex]);

#! @Arguments M
#! Returns the smallest regular cover of <A>M</A>, which is the
#! maniplex whose automorphism group is the connection group
#! of <A>M</A>.
DeclareAttribute("SmallestRegularCover", IsManiplex);
