
# Basic constructors
DeclareGlobalVariable("UNIVERSAL_SGGI_FREE_GROUPS");

#! @Chapter Basics
#! @Section Sggis

DeclareGlobalFunction("COXETER_GROUP_SIZES");

#! @BeginGroup UniversalSggi
#! @GroupTitle UniversalSggi

#! @Arguments n
#! @Returns `IsFpGroup`
#! @Description In the first form, returns the universal Coxeter Group of rank n.
DeclareOperation("UniversalSggi", [IsInt]);

#! @Arguments sym
#! In the second form, returns the Coxeter Group with Schlafli symbol sym.
DeclareOperation("UniversalSggi", [IsList]);

#! @EndGroup

#! @Arguments symbol, relations
#! @Returns `IsFpGroup`
#! @Description Returns the sggi defined by the given Schlafli
#! symbol and with the given relations. The relations can be given
#! by a list of Tietze words or as a string of relators or relations
#! that involve r0 etc.
#! @BeginExampleSession
#! gap> g := Sggi([4,3,4], "(r0 r1 r2)^3, (r1 r2 r3)^3");;
#! gap> h := Sggi([4,4], "r0 = r2");;
#! gap> k := Sggi([infinity, infinity], [[1,2,1,2,1,2], [2,3,2,3,2,3]]);;
#! gap> k = Sggi([3,3]);
#! true
#! @EndExampleSession
DeclareOperation("Sggi", [IsList, IsList]);


#!
DeclareProperty("IsGgi", IsGroup);

#!
DeclareProperty("IsStringy", IsGroup);

#!
DeclareProperty("IsSggi", IsGroup);



#! @Arguments G
#! For an sggi <A>G</A>, returns whether the group is
#! a string C group. 
DeclareOperation("IsStringC", [IsGroup]);

#! @Arguments G
#! For a "string rotation group" <A>G</A>, returns whether the group is
#! a string C+ group. It does not check whether <A>G</A>
#! is a string rotation group.
DeclareOperation("IsStringCPlus", [IsGroup]);


#! @Arguments g, str
#! @Returns the element of <A>g</A> with underlying word <A>str</A>.
#! @Description
#! @BeginExampleSession
#! gap> g := Group((1,2),(2,3),(3,4));;
#! gap> SggiElement(g, "r0 r1");
#! (1,3,2)
#! @EndExampleSession
DeclareOperation("SggiElement", [IsGroup, IsString]);
