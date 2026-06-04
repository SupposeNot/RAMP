#! @Chapter Hartley atlas

#! @Section Hartley atlas

#! @Arguments
#! @Returns IsRecord
#! @Description Loads the Hartley atlas data from `HartleyInfo.txt` in the
#! RAMP data directory. The data is cached after the first call.
DeclareGlobalFunction("LoadHartleyAtlas");
#! @BeginExampleSession
#! gap> atlas := LoadHartleyAtlas();;
#! gap> Length(atlas.ids);
#! 10209
#! @EndExampleSession

#! @Arguments
#! @Returns IsList
#! @Description Returns the Hartley IDs known to RAMP.
DeclareGlobalFunction("HartleyIds");
#! @BeginExampleSession
#! gap> ids := HartleyIds();;
#! gap> ids{[1..5]};
#! [ "{}*2", "{3}*6", "{4}*8", "{5}*10", "{6}*12" ]
#! @EndExampleSession

#! @Arguments hid
#! @Returns IsGroup
#! @Description Returns the permutation group stored for the Hartley ID
#! <A>hid</A>.
DeclareGlobalFunction("HartleyGroup");
#! @BeginExampleSession
#! gap> HartleyGroup("{3,3}*24");
#! Group([ (3,4), (2,3), (1,2) ])
#! gap> Size(last);
#! 24
#! @EndExampleSession

#! @Arguments hid
#! @Returns IsFpGroup
#! @Description Returns the finitely presented group stored for the Hartley ID
#! <A>hid</A>.
DeclareGlobalFunction("HartleyFpGroup");
#! @BeginExampleSession
#! gap> HartleyFpGroup("{3,3}*24");
#! <fp group on the generators [ s0, s1, s2 ]>
#! gap> Size(last);
#! 24
#! @EndExampleSession

#! @Arguments hid
#! @Returns IsReflexibleManiplex
#! @Description Returns the reflexible maniplex associated to the Hartley ID
#! <A>hid</A>, using the stored permutation group.
DeclareGlobalFunction("HartleyManiplex");
#! @BeginExampleSession
#! gap> M := HartleyManiplex("{3,3}*24");
#! HartleyManiplex("{3,3}*24")
#! gap> NumberOfFlags(M);
#! 24
#! gap> SchlafliSymbol(M);
#! [ 3, 3 ]
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns IsList
#! @Description Returns all Hartley IDs whose stored permutation group gives a
#! maniplex isomorphic to <A>maniplex</A>.
DeclareGlobalFunction("FindHartleyNames");
#! @BeginExampleSession
#! gap> FindHartleyNames(Simplex(3));
#! [ "{3,3}*24" ]
#! gap> FindHartleyNames(Cube(3));
#! [ "{4,3}*48" ]
#! @EndExampleSession

#! @Arguments maniplex
#! @Returns IsString
#! @Description Returns the first Hartley ID whose stored permutation group
#! gives a maniplex isomorphic to <A>maniplex</A>, or `fail` if none is found.
DeclareGlobalFunction("FindHartleyName");
#! @BeginExampleSession
#! gap> FindHartleyName(Simplex(3));
#! "{3,3}*24"
#! gap> FindHartleyName(Pgon(10));
#! "{10}*20"
#! @EndExampleSession
