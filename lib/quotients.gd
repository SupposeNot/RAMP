
#! @Chapter Comparing maniplexes
#! @Section Quotients and covers

#! Many of the quotient operations let you describe some relations in terms of a string.
#! We assume that Sggis have a generating set of $\{r0, r1, ..., r_{n-1}\}$, so
#! these relation strings will look something like "(r0 r1 r2)^5, r2 = (r0 r1)^3".
#! Notice that we can mix relations like "r2 = (r0 r1)^3" with relators like "(r0 r1 r2)^5";
#! the latter is treated as the relation "(r0 r1 r2)^5 = 1".
#! For convenience, we also allow relations to contain the following strings:
#! s1, s2, s3, etc, where si is expanded to r(i-1) ri. For example, s2 becomes r1 r2.
#! z1, z2, z3, etc, where zi is expanded to r0 (r1 r2)^i (the "i-zigzag" word).
#! h1, h2, h3, etc, where hi is expanded to r0 (r1 r2)^(j-1) r1 (the "i-hole" word).
#! We note that these strings are all restricted to have $i \leq 9$, **including ri**.
#! This restriction might be changed eventually, but it will require a rewrite of the
#! method ParseStringCRels that underlies many quotient operations.

DeclareGlobalFunction("CouldBeQuotient");

#! @BeginGroup
#! @GroupTitle IsQuotient
#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether <A>M2</A> is a quotient of <A>M1</A>.
DeclareOperation("IsQuotient", [IsManiplex, IsManiplex]);

#! @Arguments g, h
#! @Returns `IsBool`
#! @Description Returns whether <A>h</A> is a quotient of <A>g</A>.
#! That is, whether there is a homomorphism sending each generator of g
#! to the corresponding generator of h.
DeclareOperation("IsQuotient", [IsSggi, IsSggi]);
#! @BeginExampleSession
#! gap> IsQuotient(Cube(3),HemiCube(3));
#! true
#! gap> IsQuotient(UniversalSggi([4,3]),AutomorphismGroup(HemiCube(3)));
#! true
#! @EndExampleSession

#! @EndGroup

#! @Arguments M1, M2, i, j
#! @Returns `IsBool`
#! @Description Returns whether there is a maniplex homomorphism from <A>M1</A> to <A>M2</A>
#! that sends flag <A>i</A> of <A>M1</A> to flag <A>j</A> of <A>M2</A>.
DeclareOperation("IsRootedQuotient", [IsManiplex, IsManiplex, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> IsRootedQuotient(Pyramid(8), Pyramid(4), 1, 1);
#! true
#! gap> IsRootedQuotient(Pyramid(8), Pyramid(4), 1, 2);
#! false
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether there is a maniplex homomorphism from <A>M1</A> to <A>M2</A>
#! that sends `BaseFlag(M1)` to `BaseFlag(M2)`.
DeclareOperation("IsRootedQuotient", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> IsRootedQuotient(ToroidalMap44([4,4]), ToroidalMap44([4,0]));
#! true
#! gap> IsRootedQuotient(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
#! false
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether <A>M2</A> is a cover of <A>M1</A>.
DeclareOperation("IsCover", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> IsCover(HemiDodecahedron(),Dodecahedron());
#! true
#! @EndExampleSession

#! @Arguments M1, M2, i, j
#! @Returns `IsBool`
#! @Description Returns whether there is a maniplex homomorphism from <A>M2</A> to <A>M1</A>
#! that sends flag <A>j</A> of <A>M2</A> to flag <A>i</A> of <A>M1</A>.
DeclareOperation("IsRootedCover", [IsManiplex, IsManiplex, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> IsRootedCover(Pyramid(4), Pyramid(8), 1, 1);
#! true
#! gap> IsRootedCover(Pyramid(4), Pyramid(8), 1, 2);
#! false
#! @EndExampleSession


#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether there is a maniplex homomorphism from <A>M2</A> to <A>M1</A>
#! that sends `BaseFlag(M2)` to `BaseFlag(M1)`.
DeclareOperation("IsRootedCover", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> IsRootedCover(ToroidalMap44([4,0]), ToroidalMap44([4,4]));
#! true
#! gap> IsRootedCover(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
#! false
#! @EndExampleSession


#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether <A>M1</A> is isomorphic to <A>M2</A>.
DeclareOperation("IsIsomorphicManiplex", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> IsIsomorphicManiplex(HemiCube(3),Petrial(Simplex(3)));
#! true
#! @EndExampleSession

#! @Arguments M1, M2, i, j
#! @Returns `IsBool`
#! @Description Returns whether there is an isomorphism from <A>M1</A> to <A>M2</A>
#! that sends flag <A>j</A> of <A>M2</A> to flag <A>i</A> of <A>M1</A>.
DeclareOperation("IsIsomorphicRootedManiplex", [IsManiplex, IsManiplex, IsInt, IsInt]);
#! @BeginExampleSession
#! gap> IsIsomorphicManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
#! true
#! gap> FlagOrbitRepresentatives(ToroidalMap44([1,2]));
#! [1, 21]
#! gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), ToroidalMap44([1,2]), 1, 1);
#! true
#! gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), ToroidalMap44([1,2]), 1, 21);
#! false
#! gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]), 1, 1);
#! false
#! @EndExampleSession

#! @Arguments M1, M2
#! @Returns `IsBool`
#! @Description Returns whether there is an isomorphism from <A>M1</A> to <A>M2</A>
#! that sends `BaseFlag(M2)` to `BaseFlag(M1)`.
DeclareOperation("IsIsomorphicRootedManiplex", [IsManiplex, IsManiplex]);
#! @BeginExampleSession
#! gap> IsIsomorphicManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
#! true
#! gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), ToroidalMap44([2,1]));
#! false
#! gap> IsIsomorphicRootedManiplex(ToroidalMap44([1,2]), EnantiomorphicForm(ToroidalMap44([2,1])));
#! true
#! @EndExampleSession

#! @Arguments M
#! Returns the smallest regular cover of <A>M</A>, which is the
#! maniplex whose automorphism group is isomorphic to the connection group
#! of <A>M</A>.
DeclareAttribute("SmallestReflexibleCover", IsManiplex);
#! @BeginExampleSession
#! gap> SmallestReflexibleCover(ToroidalMap44([2,3],[3,2]));
#! reflexible 3-maniplex
#! gap> last=ToroidalMap44([5,0]);
#! true
#! @EndExampleSession

#! @Arguments M, relStr
#! Given a reflexible maniplex <A>M</A>, generates the subgroup S of
#! AutomorphismGroup(<A>M</A>) given by relStr, and returns the quotient
#! maniplex M / S.
#! For example, QuotientManiplex(CubicTiling(2), "(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2")
#! returns the toroidal map {4,4}_{(5,0),(0,2)}.
#! You can also input this as CubicTiling(2) / "(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2".
DeclareOperation("QuotientManiplex", [IsReflexibleManiplex, IsString]);
#! @BeginExampleSession
#! gap> q:=QuotientManiplex(CubicTiling(2),"(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2");
#! 3-maniplex
#! gap> SchlafliSymbol(q);
#! [ 4, 4 ]
#! @EndExampleSession

#! @Arguments M, rels
#! Given a reflexible maniplex <A>M</A>, generates the normal closure N of
#! the subgroup S of AutomorphismGroup(<A>M</A>) given by relStr, and returns 
#! the quotient maniplex M / N, which will be reflexible.
#! For example, QuotientManiplex(CubicTiling(2), "(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2")
#! returns the toroidal map {4,4}_{(1,0)}, because the normal closure of the group
#! generated by (r0 r1 r2 r1)^5 and (r1 r0 r1 r2)^2 is the group generated by r0 r1 r2 r1
#! and r1 r0 r1 r2.
DeclareOperation("ReflexibleQuotientManiplex", [IsManiplex, IsList]);
#! @BeginExampleSession
#! gap> q:=ReflexibleQuotientManiplex(CubicTiling(2),"(r0 r1 r2 r1)^5, (r1 r0 r1 r2)^2");
#! reflexible 3-maniplex with 8 flags
#! gap> last=ToroidalMap44([1,0]);
#! true
#! @EndExampleSession

#! @Arguments g, rels
#! @Returns the quotient of <A>g</A> by <A>rels</A>, which is either a list
#! of Tietze words or a string of relations that is parsed by ParseStringCRels.
#! @Description
#! @BeginExampleSession
#! gap> g := UniversalSggi(3);
#! <fp group of size infinity on the generators [ r0, r1, r2 ]>
#! gap> h := QuotientSggi(g, "(r0 r1)^5, (r1 r2)^3, (r0 r1 r2)^5");
#! <fp group on the generators [ r0, r1, r2 ]>
#! gap> Size(h);
#! 60
#! @EndExampleSession
DeclareOperation("QuotientSggi", [IsGroup, IsList]);

#! @Arguments g, n
#! @Returns g/n
#! @Description Given an sggi <A>g</A> and a normal subgroup <A>n</A> in <A>g</A>, this function will give you the quotient in a way that respects the generators (i.e., the generators of the quotient will be the images of the generators of the original group).
DeclareOperation("QuotientSggiByNormalSubgroup",[IsGroup,IsGroup]);
#! @BeginExampleSession
#! gap> g:=AutomorphismGroup(Cube(3));
#! <fp group of size 48 on the generators [ r0, r1, r2 ]>
#! gap> q:=QuotientSggiByNormalSubgroup(g,Group([(g.1*g.2*g.3)^3]));
#! Group([ (1,2)(3,7)(4,6)(5,10)(8,14)(9,16)(11,18)(12,20)(13,17)(15,23)(19,22)(21,24), (1,3)(2,5)(4,9)(6,12)(7,13)(8,15)(10,17)(11,19)(14,22)(16,24)(18,23)(20,21), (1,4)(2,6)(3,8)(5,11)(7,14)(9,15)(10,18)(12,19)(13,21)(16,23)(17,24)(20,22) ])
#! gap> Maniplex(q)=HemiCube(3);
#! true
#! @EndExampleSession

#! @Arguments m, h
#! @Returns m/h
#! @Description Given a maniplex <A>m</A>, and a subgroup <A>h</A> of the automorphism group on the flags, this function will give you the maniplex in which the orbits of flags under the action of <A>h</A> are identified.
#! Note that this function doesn't do any prechecks, and may break easily when `m/h` _isn't_ a maniplex or when `m/h` is of lower rank (sorry!).
DeclareOperation("QuotientManiplexByAutomorphismSubgroup",[IsManiplex,IsPermGroup]);
#! @BeginExampleSession
#! gap> m:=Cube(3);
#! Cube(3)
#! gap> a:=AutomorphismGroupOnFlags(m);
#! <permutation group with 3 generators>
#! gap> h:=Group((a.3*a.1*a.2)^3);
#! Group([ (1,7)(2,3)(4,18)(5,19)(6,20)(8,11)(9,12)(10,13)(14,32)(15,33)(16,34)(17,35)(21,25)(22,26)  (23,27)(24,28)(29,43)(30,44)(31,45)(36,39)(37,40)(38,41)(42,48)(46,47) ])
#! gap> q:=QuotientManiplexByAutomorphismSubgroup(m,h);
#! 3-maniplex with 24 flags
#! gap> last=HemiCube(3);
#! true
#! @EndExampleSession

# This function is used internally by the isomorphism-testing code,
# and is not intended to be used by end-users.
# When two maniplexes are found to be isomorphic, they sync the values
# of some certain attributes / properties.
DeclareGlobalFunction("SyncManiplexAttributes");
